//Flowstate 1v1 gamemode
//made by __makimakima__
globalize_all_functions

global bool IS_CHINESE_SERVER = false

global struct soloLocStruct
{
	LocPair &Loc1 //player1 respawn location
	LocPair &Loc2 //player2 respawn location
	array<LocPair> respawnLocations
	vector Center //center of Loc1 and Loc2

	entity Panel //keep current opponent panel

}
global struct soloGroupStruct
{
	entity player1
	entity player2

	entity ring//ring boundaries

	int slotIndex
	bool IsFinished = false //player1 or player2 is died, set this to true and soloModeThread() will handle this
	bool IsKeep = false //player may want to play with current opponent,so we will keep this group
}
global struct soloPlayerStruct
{
	entity player
	float waitingTime //players may want to play with random opponent(or a matched opponent), so adding a waiting time after they died can allow server to match proper opponent
	float kd //stored this player's kd to help server match proper opponent
	entity lastOpponent //opponent of last round
	bool IsTimeOut = false
}
global array <soloLocStruct> soloLocations //all respawn location stored here
global array <soloPlayerStruct> soloPlayersWaiting = [] //waiting player stored here
global array <soloGroupStruct> soloPlayersInProgress = [] //playing player stored here
global array <entity> soloPlayersResting = []


int function getTimeOutPlayerAmount()
{
	int timeOutPlayerAmount = 0
	foreach (eachPlayerStruct in soloPlayersWaiting )
	{
		if(eachPlayerStruct.IsTimeOut)
			timeOutPlayerAmount++
	}
	return timeOutPlayerAmount
}
entity function getTimeOutPlayer()
{
	foreach (eachPlayerStruct in soloPlayersWaiting )
	{
		if(eachPlayerStruct.IsTimeOut)
			return eachPlayerStruct.player
	}
	entity p
	return p
}
void function soloModeWaitingPrompt(entity player)
{
	wait 0.2
	if(!IsValid(player)) return
	foreach (eachplayerStruct in soloPlayersWaiting)
	{
		if(eachplayerStruct.player == player) //this player is in waiting list
		{
			if(IS_CHINESE_SERVER)
				Message(player,"您已处于等待列队","请在控制台输入'rest'开始休息",1)
			else
				Message(player,"You're in waiting room.","Type rest in console to start resting.",1)
		}
	}

}

LocPair function getWaitingRoomLocation(string mapName)
{
	LocPair WaitingRoom
	if(mapName == "mp_rr_arena_composite")
	{
		WaitingRoom.origin = <-7.62,200,184.57>
		WaitingRoom.angles = <0,90,0>
	}
	else if (mapName == "mp_rr_aqueduct")
	{
		WaitingRoom.origin = <719.94,-5805.13,494.03>
		WaitingRoom.angles = <0,90,0>
	}
	else if (mapName == "mp_rr_canyonlands_64k_x_64k")
	{
		WaitingRoom.origin = <-762.59,20485.05,4626.03>
		WaitingRoom.angles = <0,45,0>
	}
	return WaitingRoom
}

int function getAvailableSlotIndex()
{
	array<int> soloLocationInProgressIndexs //所有正在游玩的地区编号
	foreach (eachGroup in soloPlayersInProgress)
	{
		soloLocationInProgressIndexs.append(eachGroup.slotIndex)
	}
	array<int> availableSoloLocationIndex
	for (int i = 0; i < soloLocations.len(); ++i)
	{
		if(!soloLocationInProgressIndexs.contains(i))
			availableSoloLocationIndex.append(i)
	}
	//printt("available slot :" + availableSoloLocationIndex.len())
	if(availableSoloLocationIndex.len()==0)
		return -1 //no available slot
	return availableSoloLocationIndex[RandomInt(availableSoloLocationIndex.len())]
}

soloGroupStruct function returnSoloGroupOfPlayer(entity player)
{
	foreach (eachGroup in soloPlayersInProgress)
	{
		if (player == eachGroup.player1 || player == eachGroup.player2)
			return eachGroup
	}
	soloGroupStruct group
	return group
}

void function endSpectate(entity player)
{
	player.SetSpecReplayDelay( 0 )
	player.SetObserverTarget( null )
	player.StopObserverMode()
    Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Deactivate")
    player.MakeVisible()
    player.ClearInvulnerable()
	player.SetTakeDamageType( DAMAGE_YES )
	try
	{
		player.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_suicide } )
	}
	catch (error)
	{}
    RemoveButtonPressedPlayerInputCallback(player, IN_JUMP,endSpectate)
}

bool function isPlayerInSoloMode(entity player)
{
	foreach (eachGroup in soloPlayersInProgress)
	{
	   	if (eachGroup.player1 == player || eachGroup.player2 == player) //找到当前玩家的group
	   		return true
	}
	return false
}

bool function isPlayerInWaitingList(entity player)
{
	foreach (eachPlayerStruct in soloPlayersWaiting)
	{
	   	if (eachPlayerStruct.player == player) //找到当前玩家的group
	   		return true
	}
	return false
}

bool function isPlayerInRestingList(entity player)
{
	foreach (eachPlayer in soloPlayersResting)
	{
	   	if (eachPlayer == player) //找到当前玩家的group
	   		return true
	}
	return false
}

void function deleteWaitingPlayer(entity player)
{
	if(!IsValid(player)) return
	foreach (eachPlayerStruct in soloPlayersWaiting )
	{
		if(eachPlayerStruct.player == player)
		{
			soloPlayersWaiting.removebyvalue(eachPlayerStruct) //delete this PlayerStruct
			//printt("deleted the PlayerStruct")
		}
	}
}

bool function ClientCommand_Maki_SoloModeRest(entity player, array<string> args)
{
	if( !IsValid(player) ) //|| !IsAlive(player) )
		return false

	if( Time() < player.p.lastRestUsedTime + 3 )
	{
		Message(player, "REST COOLDOWN")
		return false
	}

	if(soloPlayersResting.contains(player))
	{
		if( player.IsObserver() || IsValid( player.GetObserverTarget() ) )
		{
			player.SetSpecReplayDelay( 0 )
			player.SetObserverTarget( null )
			player.StopObserverMode()
			Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Deactivate")
			player.MakeVisible()
			player.ClearInvulnerable()
			player.SetTakeDamageType( DAMAGE_YES )
		}

		if(IS_CHINESE_SERVER)
			Message(player,"匹配中")
		else
			Message(player,"Matching!")
		
		soloModePlayerToWaitingList(player)
		try
		{
			player.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_suicide } )
		}
		catch (error)
		{}
	}
	else
	{
		if(IS_CHINESE_SERVER)
			Message(player,"您已处于休息室", "在控制台中输入'rest'重新开始匹配")
		else
			Message(player,"You are resting now", "Type rest in console to pew pew again.")
		
		soloModePlayerToRestingList(player)
		try
		{
			player.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_suicide } )
		}
		catch (error)
		{

		}

		thread respawnInSoloMode(player)
		TakeAllWeapons( player )
	}
	
	player.p.lastRestUsedTime = Time()

	return true
}

entity function getRandomOpponentOfPlayer(entity player)
{
	entity p
	if(!IsValid(player)) return p
	foreach (eachPlayerStruct in soloPlayersWaiting)
	{
		if(IsValid(eachPlayerStruct.player) && player != eachPlayerStruct.player)
			return eachPlayerStruct.player
	}

	return p
}

entity function returnOpponentOfPlayer(entity player )
{
	entity p
	soloGroupStruct group = returnSoloGroupOfPlayer(player)
	if(!IsValid(group) || !IsValid(player)) return p
	entity player1 = group.player1
	entity player2 = group.player2

	if(player == group.player1)
	{
		return player2
	}
	else if (player == group.player2)
	{
		return player1
	}

	return p
}

void function soloModePlayerToWaitingList(entity player)
{
	if(!IsValid(player)) return
	// Warning("Try to add a player to wating list: " + player.GetPlayerName())
	player.SetPlayerNetEnt( "FSDM_1v1_Enemy", null )

	//检查waiting list是否有该玩家
	bool IsAlreadyExist = false
	foreach (eachPlayerStruct in soloPlayersWaiting)
	{
		if(player == eachPlayerStruct.player)
		{
			IsAlreadyExist = true
			return //waiting list里已存在该玩家,返回
		}
	}

	soloPlayerStruct playerStruct
	playerStruct.player = player
	playerStruct.waitingTime = Time() + 2
	if(IsValid(player))
		playerStruct.kd = getkd( player.GetPlayerNetInt( "kills" ), player.GetPlayerNetInt( "deaths" ))
	else
		playerStruct.kd = 0
	playerStruct.lastOpponent = player.p.lastKiller

	if(!IsAlreadyExist) //如果waiting list里没有这个玩家
	{
		soloPlayersWaiting.append(playerStruct)
		TakeAllWeapons( player )

		//set realms for resting player
		setRealms_1v1(player,64)//more than 63 means AddToAllRealms
		
		Remote_CallFunction_NonReplay( player, "ForceScoreboardFocus" )
	}
	else //如果waiting list里有这个玩家
	{
		return //waiting list里已存在该玩家,返回
	}

	//检查InProgress是否存在该玩家
	foreach (eachGroup in soloPlayersInProgress)
	{
		if(player == eachGroup.player1 || player == eachGroup.player2)
		{

			soloGroupStruct group = returnSoloGroupOfPlayer(player)
			entity opponent = returnOpponentOfPlayer(player)

			if(IsValid(soloLocations[group.slotIndex].Panel)) //Panel in current Location
				soloLocations[group.slotIndex].Panel.SetSkin(1) //set panel to red(default color)

			destroyRingsForGroup(eachGroup) //delete rings
			soloPlayersInProgress.removebyvalue(eachGroup) //delete this group

			soloModePlayerToWaitingList(player) //force put this player to waiting list
			if(!IsValid(opponent)) continue //opponent is not vaild
			soloModePlayerToWaitingList(opponent) //force put opponent to waiting list
		}
	}

	//检查resting list 是否有该玩家
	soloPlayersResting.removebyvalue(player)
}

bool function soloModePlayerToInProgressList(soloGroupStruct newGroup) //不能重复添加玩家,否则会导致现有的group被销毁
{

	entity player = newGroup.player1
	entity opponent = newGroup.player2
	bool result = false
	if(!IsValid(player) || !IsValid(opponent)) return result
	if(player == opponent)
	{
		// Warning("Try to add same players to InProgress list:" + player.GetPlayerName())
		player.SetPlayerNetEnt( "FSDM_1v1_Enemy", null )
		return result
	}
	
	player.SetPlayerNetEnt( "FSDM_1v1_Enemy", opponent )
	opponent.SetPlayerNetEnt( "FSDM_1v1_Enemy", player )

	//检查InProgress是否存在该玩家
	bool IsAlreadyExist = false
	foreach (eachGroup in soloPlayersInProgress)
	{
		if(player == eachGroup.player1 || player == eachGroup.player2 || opponent == eachGroup.player1 || opponent == eachGroup.player2)
		{
			IsAlreadyExist = true
			destroyRingsForGroup(eachGroup)
			soloPlayersInProgress.removebyvalue(eachGroup) //销毁这个group

			// Warning("[ERROR]Try to add a exist player of InProgress list to InProgress list") //不应该出现这种情况
			return result
		}
	}

	if(!IsAlreadyExist)
	{
		newGroup.player1 = player
		newGroup.player2 = opponent
		result = true
	}
	else
	{
		// Warning("[ERROR]Try to add a exist player of InProgress list to InProgress list") //不应该出现这种情况
		return result//unreached
	}

	//检查waiting list是否有该玩家
	deleteWaitingPlayer(player)
	deleteWaitingPlayer(opponent)

	//检查resting list 是否有该玩家
	soloPlayersResting.removebyvalue(player)//将两个玩家移出resting list
	soloPlayersResting.removebyvalue(opponent)//将两个玩家移出resting list

	int slotIndex = getAvailableSlotIndex()
	if (slotIndex > -1) //available slot exist
	{
		//printt("solo slot exist")
		newGroup.slotIndex = slotIndex

		//printt("add player1&player2 to InProgress list!")
		soloPlayersInProgress.append(newGroup) //加入游玩队列

		result = true
	}
	else
	{
		// Warning("No avaliable slot")
		result = false
	}

	return result
}

void function soloModePlayerToRestingList(entity player)
{
	if(!IsValid(player)) return
	
	player.SetPlayerNetEnt( "FSDM_1v1_Enemy", null )
	deleteWaitingPlayer(player)


	soloGroupStruct group = returnSoloGroupOfPlayer(player)
	if(IsValid(group))
	{
		entity opponent = returnOpponentOfPlayer(player)

		if(IsValid(soloLocations[group.slotIndex].Panel)) //Panel in current Location
			soloLocations[group.slotIndex].Panel.SetSkin(1) //set panel to red(default color)

		destroyRingsForGroup(group)
		soloPlayersInProgress.removebyvalue(group) //销毁这个group

		if(IsValid(opponent)) //找不到对手
			soloModePlayerToWaitingList(opponent) //将对手放回waiting list
	}



	foreach (eachPlayer in soloPlayersResting )
	{
		if(player == eachPlayer)//玩家重复进入resting list
		{
			soloPlayersResting.removebyvalue(player) //可以清空在resting list里的重复玩家
		}
	}

	soloPlayersResting.append(player)
}

void function soloModefixDelayStart(entity player)
{
	if(IS_CHINESE_SERVER)
		Message(player,"加载中 FS 1v1")
	else
		Message(player,"Loading Flowstate 1v1")
	
	HolsterAndDisableWeapons(player)

	wait 8
	if(!isPlayerInRestingList(player))
	{
		soloModePlayerToWaitingList(player)
	}

	try
	{
		player.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_suicide } )
	}
	catch (error)
	{}
}

void function setRealms_1v1(entity ent,int realmIndex)
{
	if(!IsValid(ent)) return
	if(realmIndex>63)
	{
		ent.AddToAllRealms()
		return
	}//add to all realms for players in resting mode

	array<int> realms = ent.GetRealms()
	ent.AddToRealm(realmIndex)
	realms.removebyvalue(realmIndex)
	if(realms.len()>0)
	{
		foreach (eachRealm in realms )
		{
			ent.RemoveFromRealm(eachRealm)
		}
	}
}

void function destroyRingsForGroup(soloGroupStruct group)
{
	if(!IsValid(group)) return
	if(!IsValid(group.ring)) return
	group.ring.Destroy()
}//delete rings

entity function CreateSmallRingBoundary(vector Center)
{
    vector smallRingCenter = Center
	float smallRingRadius = 2000
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
	smallcircle.RemoveFromAllRealms()

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

entity function createForbiddenZone(vector zoneOrigin, float radius,float AboveHeight = 50,float BelowHeight = 15)
{
	entity trigger = CreateEntity( "trigger_cylinder" )
	trigger.SetRadius( radius )
	trigger.SetAboveHeight( AboveHeight )
	trigger.SetBelowHeight( BelowHeight )
	trigger.SetOrigin( zoneOrigin )
	trigger.SetEnterCallback(  forbiddenZone_enter )
	trigger.SetLeaveCallback(  forbiddenZone_leave )
	trigger.SearchForNewTouchingEntity()
	// DebugDrawCylinder( trigger.GetOrigin() , < -90, 0, 0 >, radius, trigger.GetAboveHeight(), 0, 165, 255, true, 9999.9 )
	// DebugDrawCylinder( trigger.GetOrigin() , < -90, 0, 0 >, radius, -trigger.GetBelowHeight(), 255, 90, 0, true, 9999.9 )
	DispatchSpawn( trigger )
	return trigger
}

void function forbiddenZoneInit(string mapName)
{
	array<vector> triggerList
	if(mapName == "mp_rr_aqueduct")
		triggerList = [
						<8693.24,-1103.93,571.29>,
						<-4805,-2543.85,553.75>,
					]
	else
	{
		return
	}
	foreach(origin in triggerList)
	{
		createForbiddenZone(origin,600)
	}
}

void function forbiddenZone_enter(entity trigger , entity ent)
{
	if(!IsValid( ent )) return
	HolsterAndDisableWeapons( ent )
	EntityOutOfBounds( trigger, ent, null, null )
}

void function forbiddenZone_leave(entity trigger , entity ent)
{
	if(!IsValid(ent)) return
	EnableOffhandWeapons(ent)
	DeployAndEnableWeapons( ent )
	EntityBackInBounds( trigger, ent, null, null )
}

void function maki_tp_player(entity player,LocPair data)
{
	if(!IsValid(player)) return
	player.SetVelocity( Vector( 0,0,0 ) )
	player.SetAngles(data.angles)
	player.SetOrigin(data.origin)
}

void function PlayerRestoreHP_1v1(entity player, float health, float shields)
{
	if(!IsValid( player )) return
	if(!IsAlive( player )) return

	player.SetHealth( health )
	Inventory_SetPlayerEquipment(player, "helmet_pickup_lv3", "helmet")
	if(shields == 0) return
	else if(shields <= 50)
		Inventory_SetPlayerEquipment(player, "armor_pickup_lv1", "armor")
	else if(shields <= 75)
		Inventory_SetPlayerEquipment(player, "armor_pickup_lv2", "armor")
	else if(shields <= 100)
		Inventory_SetPlayerEquipment(player, "armor_pickup_lv3", "armor")
	else if(shields <= 125)
		Inventory_SetPlayerEquipment(player, "armor_pickup_lv5", "armor")

	player.SetShieldHealth( shields )
}

void function giveWeaponInRandomWeaponPool(entity player)
{
	if(!IsValid(player)) return
	try
	{
		EnableOffhandWeapons( player )
		DeployAndEnableWeapons( player )

		TakeAllWeapons(player)

	    GiveRandomPrimaryWeaponMetagame(player)
		GiveRandomSecondaryWeaponMetagame(player)
		player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
		if(!isPlayerInRestingList(player))
	    	player.GiveOffhandWeapon( "melee_pilot_emptyhanded", OFFHAND_MELEE, [] )
		
		//hack to fix first reload
		player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_1)
		player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
		player.ClearFirstDeployForAllWeapons()
	}
	catch (e)
	{}
}

bool function isGroupVaild(soloGroupStruct group)
{
	if(!IsValid(group)) return false
	if(!IsValid(group.player1) || !IsValid(group.player2)) return false
	return true
}

void function respawnInSoloMode(entity player, int respawnSlotIndex = -1) //复活死亡玩家和同一个sologroup的玩家
{
	if (!IsValid(player)) return
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
		// Warning("resting respawn")
		try
		{
			DecideRespawnPlayer(player, true)
		}
		catch (erroree)
		{
			// printt("fail to respawn")
		}
		LocPair waitingRoomLocation = getWaitingRoomLocation(GetMapName())
		if (!IsValid(waitingRoomLocation)) return
		
		GivePlayerCustomPlayerModel( player )
		maki_tp_player(player, waitingRoomLocation)
		player.MakeVisible()
		player.ClearInvulnerable()
		player.SetTakeDamageType( DAMAGE_YES )

		//set realms for resting player
		setRealms_1v1(player,64)//more than 63 means AddToAllRealms

		return
	}//玩家在休息模式

	soloGroupStruct group = returnSoloGroupOfPlayer(player)

	if(!isGroupVaild(group)) return //Is this group is available
	if (respawnSlotIndex == -1) return

	try
	{
		DecideRespawnPlayer(player, true)
	}
	catch (error)
	{
		// Warning("fail to respawn")
	}
	GivePlayerCustomPlayerModel( player )
	maki_tp_player(player,soloLocations[group.slotIndex].respawnLocations[respawnSlotIndex])

	wait 0.2 //防攻击的伤害传递止上一条命被到下一条命的玩家上

	if(!IsValid(player)) return

	Inventory_SetPlayerEquipment(player, "armor_pickup_lv3", "armor")
	PlayerRestoreHP_1v1(player, 100, 125 )

	Survival_SetInventoryEnabled( player, false )
	//SetPlayerInventory( player, [] )
	thread ReCheckGodMode(player)

	//set realms for two players
	setRealms_1v1(player,group.slotIndex+1)
}

void function GivePlayerCustomPlayerModel( entity ent )
{
	if( FlowState_ChosenCharacter() > 10 )
	{
		switch( FlowState_ChosenCharacter() )
		{			
			case 11:
			ent.SetBodyModelOverride( $"mdl/Humans/pilots/w_blisk.rmdl" )
			ent.SetArmsModelOverride( $"mdl/Humans/pilots/pov_blisk.rmdl" )
			break
			
			case 12:
			ent.SetBodyModelOverride( $"mdl/Humans/pilots/w_phantom.rmdl" )
			ent.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_phantom.rmdl" )
			break
			
			case 13:
			ent.SetBodyModelOverride( $"mdl/Humans/pilots/w_amogino.rmdl" )
			ent.SetArmsModelOverride( $"mdl/Humans/pilots/ptpov_amogino.rmdl" )
			break
		}
	}
}

void function _soloModeInit(string mapName)
{
	array<LocPair> allSoloLocations
	array<LocPair> panelLocations
	LocPair waitingRoomPanelLocation
	// LocPair waitingRoomLocation
	if (mapName == "mp_rr_arena_composite")
	{
		// waitingRoomLocation = NewLocPair( <-7.62,200,184.57>, <0,90,0>)
		waitingRoomPanelLocation = NewLocPair( <7.74,595.19,125>, <0,0,0>)//休息区观战面板

		allSoloLocations= [
		NewLocPair( <344.814117, 1279.00415, 188.561081>, <0, 178.998779, 0>), //1
		NewLocPair( <-301.836731, 1278.16309, 188.60759>, <0, -2.78833318, 0>),

		NewLocPair( <-2934.02246, 3094.91431, 192.048279>, <0, 45.9642601, 0>), //2
		NewLocPair( <-2282.98853, 3810.25732, 192.046173>, <0, -120.085022, 0>),

		NewLocPair( <-1037.84583, 2280.85938, -130.952026>, <0, -6.83472872, 0>), //3
		NewLocPair( <-143.20752, 2239.93433, -114.43261>, <0, -178.196396, 0>),

		NewLocPair( <2983.75, 3072.01416, 192.054321>, <0, 138.60434, 0>), //4
		NewLocPair( <2251.52686, 3821.51807, 192.045395>, <0, -59.6830139, 0>),

		NewLocPair( <-694.934387, 4686.71777, 128.03125>, <0, -159.394516, 0>), //5
		NewLocPair( <-1257.71802, 4618.77295, 128.017029>, <0, 7.97793579, 0>),

		NewLocPair( <-851.90686, 5469.09717, -32.0257645>, <0, -3.02725101, 0>), //6
		NewLocPair( <-209.819092, 5462.67139, -30.802206>, <0, -178.949997, 0>),

		NewLocPair( <621.688782, 3920.86963, -31.9940014>, <0, -84.1400604, 0>), //7
		NewLocPair( <709.123413, 3262.09692, -31.96875>, <0, 94.3908463, 0>),

		NewLocPair( <2933.51343, 1449.6571, 140.03125>, <0, -100.364799, 0>), //8
		NewLocPair( <2455.15234, 1004.09894, 128.03125>, <0, 7.74315786, 0>),

		NewLocPair( <-1441.08, 1675.66, 280.08>, <0, -110, 0>),//9
		NewLocPair( <-1787.21, 1008.08, 254.03>, <0, 50, 0>),//9

		NewLocPair( <1649.15588, 1135.37439, 192.03125>, <0, 137.991577, 0>), //10
		NewLocPair( <1122.84058, 1418.50452, 190.821075>, <0, -27.6340904, 0>),

		NewLocPair( <-2862.42407, 1511.31921, 140.03125>, <0, -100.470222, 0>), //11
		NewLocPair( <-2633.31348, 833.701477, 128.03125>, <0, 130.051575, 0>),

		NewLocPair( <-836.684998, 2751.19849, 192.03125>, <0, -150.722626, 0>),//12
		NewLocPair( <-1405.85583, 2548.43164, 192.03125>, <0, 12.0755987, 0>),
		]

		//panel
		panelLocations = [
			NewLocPair( <-4.90188408, 1580.82349, 188.526581>, <0, 0, 0>),//1
			NewLocPair( <-2513.19702, 3376.53174, 192.048309>, <0, 50, 0>),//2
			NewLocPair( <-517.093201, 2170.28882, -143.956406>, <0, 0, 0>),//3
			NewLocPair( <2622.61, 3294.64, 190.05>, <0, -40, 0>),//4
			NewLocPair( <-894.18, 4539.96, 130.03>, <0, 30, 0>),//5
			NewLocPair( <-582.68, 5138.91, -30.02>, <0, 180, 0>),//6
			NewLocPair( <609.73, 3556.99, -30.03>, <0, -80, 0>),//7
			NewLocPair( <2998.07, 840.03, 140>, <0, -115, 0>),//8
			NewLocPair( <-1627.84, 1568.45, 190>, <0, 0, 0>),//9
			NewLocPair( <1268.07, 1527.68, 190>, <0, 0, 0>),//10
			NewLocPair( <-2969.78, 810.96, 140>, <0, 120, 0>),//11
			NewLocPair( <-1073.46, 2685.75, 190>, <0, -43, 0>),//12
		]
		}
		else if (mapName == "mp_rr_aqueduct")
		{
			// waitingRoomLocation = NewLocPair( <719.94,-5805.13,494.03>, <0,90,0>)
			waitingRoomPanelLocation = NewLocPair( <718.29,-5496.74,430>, <0,0,0>) //休息区观战面板

			allSoloLocations= [

			NewLocPair( <-6775.57568, -204.993729, 106.120445>, <0, -32.8351936, 0>),//1
			NewLocPair( <-6230.72607, -527.870239, 107.595337>, <0, 144.085541, 0>),

			NewLocPair( <3263.02002, -3556.06055, 273.576324>, <0, 8.61375999, 0>),//2
			NewLocPair( <3784.31885, -3452.91772, 272.03125>, <0, -171.17247, 0>),

			NewLocPair( <8502.62109, -615.898987, 315.014832>, <0, -60.9690781, 0>),//3
			NewLocPair( <9021.84863, -1498.87195, 310.646271>, <0, 117.371147, 0>),

			NewLocPair( <167.032883, -6722.06787, 336.03125>, <0, -1.60793841, 0>),//4
			NewLocPair( <1296.91602, -6719.25293, 336.03125>, <0, 178.672043, 0>),

			// NewLocPair( <3654.57104, -4299.94629, 251.554062>, <0, -131.212936, 0>), //remove
			// NewLocPair( <3087.35205, -4413.77637, 256.14917>, <0, -22.8175545, 0>),

			NewLocPair( <-761.57,-4554.79,311.46>, <0, -144.43, 0>),//5
			NewLocPair( <-1436.52,-5086.34,299.21>, <0, 40.96, 0>),

			NewLocPair( <2809.94946, -4459.84961, 361.746124>, <0, -88.6163712, 0>),//6
			NewLocPair( <2738.16772, -5504.04443, 388.564209>, <0, 82.8682785, 0>),

			NewLocPair( <-444.894531, -2472.0481, -313.453186>, <0, -6.28803873, 0>),//7
			NewLocPair( <34.082859, -2517.09546, -311.32724>, <0, 170.668167, 0>),

			NewLocPair( <2050.9939, -3850.13452, 432.03125>, <0, -174.60405, 0>),//8
			NewLocPair( <1504.50134, -3880.59595, 432.03125>, <0, 0.203577876, 0>),

			NewLocPair( <234.719513, -4128.62842, 273.224884>, <0, -94.9567108, 0>),//9
			NewLocPair( <214.551025, -4557.26904, 272.03125>, <0, 87.0343704, 0>),

			NewLocPair( <-5046.05176, -2948.47144, 314.250671>, <0, 63.9120026, 0>),//10
			NewLocPair( <-4553.3623, -2102.83643, 313.807098>, <0, -119.961533, 0>),

			NewLocPair( <-2457.16333, -5476.83203, 400.03125>, <0, -12.8816891, 0>),//11
			NewLocPair( <-1929.41846, -5594.64307, 400.03125>, <0, 165.039886, 0>),

			NewLocPair( <-81.694252, -3906.92749, 432.03125>, <0, 171.290192, 0>),//12
			NewLocPair( <-640.369202, -3834.13794, 432.03125>, <0, -13.2758875, 0>),

			NewLocPair( <-3015.57031, -3553.14819, 272.03125>, <0, -140.035995, 0>),//13
			NewLocPair( <-3493.69263, -4762.4126, 272.032166>, <0, 84.9091492, 0>),
			]
			panelLocations = [
				NewLocPair( <-6357.56, -110.40, -95.07>, <0, -30, 0>),//1
				NewLocPair( <3551.47, -3581.74, 270.03>, <0, 0, 0>),//2
				NewLocPair( <9136.70, -797.05, 310.17>, <0, -60, 0>),//3
				NewLocPair( <718.50, -7027.66, 330.03>, <0, 170, 0>),//4
				// NewLocPair( <3453.87, -4724.95, 170.89>, <0, -170, 0>),//remove
				NewLocPair( <-962.44, -4706.85, 190.77>, <0, -10, 0>),//5
				NewLocPair( <3035.04, -4838.01, 400.16>, <0, -80, 0>),//6
				NewLocPair( <-179.10, -2264.64, -390.97>, <0, 0, 0>),//7
				NewLocPair( <1810.83, -3773.77, 430.03>, <0, -179, 0>),//8
				NewLocPair( <451.17, -4365.68, 270.03>, <0, -90, 0>),//9
				NewLocPair( <-4515.57, -2811.07, 310.31>, <0, -120, 0>),//10
				NewLocPair( <-2278.44, -5838.17, 400.03>, <0, 160, 0>),//11
				NewLocPair( <-301.65, -4238.32, 430.03>, <0, 160, 0>),//12
				NewLocPair( <-3079.95, -4274.58, 290.03>, <0, -120, 0>),//13
			]
		}
		else if (mapName == "mp_rr_canyonlands_64k_x_64k")
		{
			// waitingRoomLocation = NewLocPair( <-795.58,20362.78,4570.03>, <0,90,0>)   //休息区出生点
			waitingRoomPanelLocation = NewLocPair( <-607.59,20647.05,4570.03>, <0,-45,0>) //休息区观战面板

			allSoloLocations= [

			NewLocPair( <-4896.12, 9610.98, 3528.03>, <0, -90, 0>),//1
			NewLocPair( <-4882.72607, 8705.870239, 3528.595337>, <0, 90.085541, 0>),

			NewLocPair( <8464,8373,5304>, <0, 90, 0>),//2
			NewLocPair( <8349,9969,5304>, <0, -90, 0>),

			NewLocPair( <8760.62109, 27974.898987, 4824.014832>, <0, -177, 0>),//3
			NewLocPair( <6854.84863, 27977.87195, 4824.646271>, <0, 0, 0>),

			NewLocPair( <21030, 7791.06787, 4150.03125>, <0, -173.60793841, 0>),//4
			NewLocPair( <20122.91602, 7161.25293, 4170.03125>, <0, 24.672043, 0>),

			NewLocPair( <-28277.57104, -4377.94629, 2536.554062>, <0, 18.212936, 0>),//5
			NewLocPair( <-27472.52,-3851.34,2536.21>, <0, -146, 0>),

			NewLocPair( <23742.94946, -8292.84961, 4342.746124>, <0, -88.6163712, 0>),//6
			NewLocPair( <24182.16772, -9669.04443, 4535.564209>, <0,94.8682785, 0>),

			NewLocPair( <4168.894531, -9882.0481, 3384.453186>, <0, -155.28803873, 0>),//7
			NewLocPair( <2824.082859, -10359.09546, 3323.32724>, <0, 23.668167, 0>),

			NewLocPair( <3590.9939, -10722.13452, 2816.03125>, <0, 178.60405, 0>),//8
			NewLocPair( <2692.50134, -10735.59595, 2816.03125>, <0, 0, 0>),

			NewLocPair( <-23428.719513, -472.62842, 3752.224884>, <0, 93.9567108, 0>),//9
			NewLocPair( <-23432.551025, 499.26904, 3752.03125>, <0, -89.0343704, 0>),

			NewLocPair( <10801.05176, 1195.47144, 4738.250671>, <0, -15.9120026, 0>),//10
			NewLocPair( <13043.3623, 1027.83643, 4790.807098>, <0, -178.961533, 0>),

			NewLocPair( <13030.16333, 16995.83203, 4763.03125>, <0, 90.8816891, 0>),//11
			NewLocPair( <12933.41846, 18315.64307, 4760.03125>, <0, -92.039886, 0>),

			NewLocPair( <13282.694252, 10734.92749, 4760.03125>, <0, -141.290192, 0>),//12
			NewLocPair( <11905.369202, 9689.13794, 4752.03125>, <0, 37.2758875, 0>),

			NewLocPair( <4519.57031, -7908.14819, 3147.03125>, <0, 161.035995, 0>),//13
			NewLocPair( <2328.69263, -7650.4126, 3352.032166>, <0, 7.9091492, 0>),

			NewLocPair( <4016.10693, -3406.61035, 2652.67822>, <0,-22,0> ),//14
			NewLocPair( <4875,-3494,2738>, <0,144,0> ),

			NewLocPair( <26629,-17691,5424>, <0,-179,0> ),//15
			NewLocPair( <24074,-17726,5424>, <0,-1,0> ),

			NewLocPair( <-7434,5519,2470>, <0,-178,0> ),//16
			NewLocPair( <-8115,5539,2470>, <0,-88,0> ),

			NewLocPair( <2007,23375,4190>, <0,45,0> ),//17
			NewLocPair( <3112,24544,4190>, <0,-135,0> ),

			NewLocPair( <28023,-5219,4248>, <0,179,0> ),//18
			NewLocPair( <26505,-5219,4248>, <0,0,0> ),

			NewLocPair( <-24643,11027,3090>,<0,0,0> ),//19zzt
			NewLocPair( <-23808,11104,3028>,<0,170,0> ),

			NewLocPair( <-16131,-18339,3583>,<0,-36,0> ),//20zzt
			NewLocPair( <-15046,-19175,3527>,<0,150,0> ),

			NewLocPair( <-9830,-25727,2579>,<0,-115,0> ),//21zzt
			NewLocPair( <-10110,-27197,2576>,<0,72,0> ),

			NewLocPair( <20278,11876,5078>,<0,-176,0> ),//22 zzt
			NewLocPair( <19507,11682,4936>,<0,0,0> ),

			NewLocPair( <10617,11637,5306>,<0,39,0> ),//23zzt
			NewLocPair( <10836,13212,5396>,<0,-82,0> ),

			]
			panelLocations = [
				NewLocPair( <-5206.56, 9206.40, 3472.07>, <0, 90, 0>),//1
				NewLocPair( <8604,9305,5384>, <0, -90, 0>),//2
				NewLocPair( <7944.70, 28174.05, 4676.17>, <0, 0, 0>),//3
				NewLocPair( <20406.50, 7791.66, 4120.03>, <0, -1, 0>),//4
				// // NewLocPair( <3453.87, -4724.95, 170.89>, <0, -170, 0>),//remove
				NewLocPair( <-27970.44, -3613.85, 2480.77>, <0, 21, 0>),//5
				NewLocPair( <23731.04, -9124.01, 4415.16>, <0, 87, 0>),//6
				NewLocPair( <3411.10, -9996.64, 3263.97>, <0, 7, 0>),//7
				NewLocPair( <3165.83, -10423.77, 2760.03>, <0, 0, 0>),//8
				NewLocPair( <-23762.17, 78.68, 3799.03>, <0, 90, 0>),//9
				NewLocPair( <12661, 614.07, 4566.31>, <0, -172, 0>),//10
				NewLocPair( <12924.44, 17652.17, 4717.03>, <0, -90, 0>),//11
				NewLocPair( <12291.65, 10387.32, 4693.03>, <0, 35, 0>),//12
				NewLocPair( <3086.95, -7750.58, 3260.03>, <0, -153, 0>),//13
				NewLocPair( <4281,-3634,2635>, <0,157,0> ),//14
				NewLocPair( <25331,-17565,4664>, <0,0,0> ),//15
				NewLocPair( <-7841,5328,2401>, <0,175,0> ),//16
				NewLocPair( <2457,23766,4128>, <0,-135,0> ),//17
				NewLocPair( <27360,-4862,4380>, <0,1,0> ),//18
				NewLocPair( <-24242,10927,3028>,<0,-178,0> ),//19
				NewLocPair( <-15584,-18774,3563>,<0,-36,0> ),//20
				NewLocPair( <-10287,-26430,2514>,<0,16,0> ),//21
				NewLocPair( <19599,11681,5018>,<0,94,0> ),//22
				NewLocPair( <10916,12579,5312>,<0,85,0> ),//23

			]
		}
		else
		{
			return
		}

	//resting room init
	
	string buttonText
	
	if(IS_CHINESE_SERVER)
		buttonText = "%&use% 开始观战"
	else
		buttonText = "%&use% Start spectating"

	string buttonText3
	
	if(IS_CHINESE_SERVER)
		buttonText3 = "%&use% 开始休息"
	else
		buttonText3 = "%&use% Toggle Rest"
	
	entity restingRoomPanel = CreateFRButton( waitingRoomPanelLocation.origin + AnglesToForward( waitingRoomPanelLocation.angles ) * 40, waitingRoomPanelLocation.angles, buttonText )
	entity restingRoomPanel_RestButton = CreateFRButton( waitingRoomPanelLocation.origin - AnglesToForward( waitingRoomPanelLocation.angles ) * 40, waitingRoomPanelLocation.angles, buttonText3 )

	AddCallback_OnUseEntity( restingRoomPanel, void function(entity panel, entity user, int input)
	{
		if(!IsValid(user)) return
		if(!isPlayerInRestingList(user))
		{
			if(IS_CHINESE_SERVER)
				Message(user,"您必须在休息模式中才能使用观战功能您","请在控制台中输入'rest'进入休息模式")
			else
				Message(user,"Your must be in resting mode to spectate others!","Input 'rest' in console to enter resting mode ")
			
			return //不在休息队列中不能使用观战功能
		}


	    try
	    {
	    	array<entity> enemiesArray = GetPlayerArray_Alive()
			enemiesArray.fastremovebyvalue( user )
		    entity specTarget = enemiesArray.getrandom()

	    	user.p.isSpectating = true
			user.SetPlayerNetInt( "spectatorTargetCount", GetPlayerArray().len() )
			user.SetObserverTarget( specTarget )
			user.SetSpecReplayDelay( 0.5 )
			user.StartObserverMode( OBS_MODE_IN_EYE )
			thread CheckForObservedTarget(user)
			user.p.lastTimeSpectateUsed = Time()

			if(IS_CHINESE_SERVER)
				Message(user,"按一下空格后结束观战")
			else
				Message(user,"Press 'SPACE' to stop spectating")
			
			user.MakeInvisible()

	    }
	    catch (error333)
	    {}
	    AddButtonPressedPlayerInputCallback( user, IN_JUMP,endSpectate  )
	})

	AddCallback_OnUseEntity( restingRoomPanel_RestButton, void function(entity panel, entity user, int input)
	{
		if(!IsValid(user)) return
		
		ClientCommand_Maki_SoloModeRest( user, [] )
	})


	for (int i = 0; i < allSoloLocations.len(); i=i+2)
	{
		soloLocStruct p

		p.respawnLocations.append(allSoloLocations[i])
		p.respawnLocations.append(allSoloLocations[i+1])

		p.Center = (allSoloLocations[i].origin + allSoloLocations[i+1].origin)/2

		soloLocations.append(p)
	}
	
	string buttonText2
	
	if(IS_CHINESE_SERVER)
	{
		buttonText2 = "%&use% 不再更换对手"
	}
	else
	{
		buttonText2 = "%&use% Never change your opponent"
	}
	
	foreach (index,eahclocation in panelLocations)
	{
		//Panels for save opponents
		entity panel = CreateFRButton(eahclocation.origin, eahclocation.angles, buttonText2)
		panel.SetSkin(1)//red
		soloLocations[index].Panel = panel
		AddCallback_OnUseEntity( panel, void function(entity panel, entity user, int input)
		{
			string Text3
			string Text4
			if(IS_CHINESE_SERVER)
			{
				Text3 = "您已取消绑定"
				Text4 = "您已绑定您的对手"
			}
			else
			{
				Text3 = "Your opponent will change now"
				Text4 = "Your opponent won't change"
			}
			soloGroupStruct group = returnSoloGroupOfPlayer(user)
			// if (!IsValid(group.player1) || !IsValid(group.player2)) return
			if(!isGroupVaild(group)) return //Is this group is available
			if (soloLocations[group.slotIndex].Panel != panel) return //有傻逼捣乱

			if( group.IsKeep == false)
			{
				group.IsKeep = true
				panel.SetSkin(0) //green

				try
				{
					Message(group.player1, Text4)
					Message(group.player2, Text4)
				}
				catch (error)
				{}


			}
			else
			{
				group.IsKeep = false
				panel.SetSkin(1) //red

				try
				{
					Message(group.player1, Text3)
					Message(group.player2, Text3)
				}
				catch (error)
				{}
			}
		})//AddCallback_OnUseEntity
	}//foreach


	forbiddenZoneInit(GetMapName())
	thread soloModeThread(getWaitingRoomLocation(GetMapName()))

}

void function soloModeThread(LocPair waitingRoomLocation)
{
	printt("solo mode thread start!")

	string Text5

	if(IS_CHINESE_SERVER)
	{
		Text5 = "您的对手已断开连接"
	}
	else
	{
		Text5 = "Your opponent has disconnected!"
	}
	wait 8
	while(true)
	{
		WaitFrame()
		
		if( GetScoreboardShowingState() )
			continue
		
		//遍历等待队列
		foreach (playerInWatingSctruct in soloPlayersWaiting )
		{
			if(!IsValid(playerInWatingSctruct.player))
			{
				// Warning("PLAYER QUIT")
				soloPlayersWaiting.removebyvalue(playerInWatingSctruct)
				continue
			}

			//标记超时玩家
			if(playerInWatingSctruct.waitingTime < Time() && !playerInWatingSctruct.IsTimeOut && IsValid(playerInWatingSctruct.player))
			{
				//printt("mark time out player: " + playerInWatingSctruct.player.GetPlayerName() + " waitingTime: " + playerInWatingSctruct.waitingTime)
				playerInWatingSctruct.IsTimeOut = true
			}
		}//foreach

		//遍历游玩队列
		foreach (eachGroup in soloPlayersInProgress)
		{
			if(eachGroup.IsFinished)//this round has been finished
			{
				//printt("this round has been finished")
				soloModePlayerToWaitingList(eachGroup.player1)
				soloModePlayerToWaitingList(eachGroup.player2)
				destroyRingsForGroup(eachGroup)
				continue
			}

			if(eachGroup.IsKeep) //player in this group dont want to change opponent
			{
				if(IsValid(eachGroup.player1) && IsValid(eachGroup.player2) && (!IsAlive(eachGroup.player1) || !IsAlive(eachGroup.player2) ))
				{
					//printt("respawn and tp player1")
					thread respawnInSoloMode(eachGroup.player1, 0)

					//printt("respawn and tp player2")
					thread respawnInSoloMode(eachGroup.player2, 1)
					
					GiveWeaponsToGroup( [eachGroup.player1, eachGroup.player2] )
				}//player in keeped group is died, respawn them
			}

			if(!IsValid(eachGroup.player1) || !IsValid(eachGroup.player2)) //Is player in this group quit the game
			{
				//printt("solo player quit!!!!!")
				if(IsValid(eachGroup.player1))
				{
					soloModePlayerToWaitingList(eachGroup.player1) //back to wating list
					Message(eachGroup.player1, Text5)
				}

				if(IsValid(eachGroup.player2))
				{
					soloModePlayerToWaitingList(eachGroup.player2) //back to wating list
					Message(eachGroup.player2, Text5)
				}
				continue
			}

			//检测乱跑的脑残
			int eachSlotIndex = eachGroup.slotIndex
			vector Center =  soloLocations[eachSlotIndex].Center
			array<entity> players = [eachGroup.player1,eachGroup.player2]
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
		}//foreach


		//遍历休息队列
		foreach (restingPlayer in soloPlayersResting )
		{
			if(!IsValid(restingPlayer)) continue

			TakeAllWeapons( restingPlayer )

			if(!IsAlive(restingPlayer)  )
			{
				thread respawnInSoloMode(restingPlayer)
			}
		}

		foreach ( player in GetPlayerArray() )
		{
			if( !IsValid( player ) ) 
				continue
			
			if( isPlayerInSoloMode( player ) )
				continue

			if( Distance2D( player.GetOrigin(), waitingRoomLocation.origin) > 450 ) //waiting player should be in waiting room,not battle area
			{
				maki_tp_player( player, waitingRoomLocation ) //waiting player should be in waiting room,not battle area
				HolsterAndDisableWeapons( player )
			}
		}

		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//开始匹配
		if(soloPlayersWaiting.len()<2) //等待队列人数不足,无法开始匹配
		{
			continue
		}

		// printt("------------------more than 2 player in solo waiting array,matching------------------")
		soloGroupStruct newGroup
		entity opponent
		//优先处理超时玩家
		//player1:超时的玩家,player2:随机从等待队列里找一个玩家

		if(getTimeOutPlayerAmount() > 0)//存在已经超时的玩家
		{
			// Warning("Time out matching")
			newGroup.player1 = getTimeOutPlayer()  //获取超时的玩家
			if(IsValid(newGroup.player1))//存在超时等待玩家
			{
				// printt("Time out player found: " + newGroup.player1.GetPlayerName())
				opponent = getRandomOpponentOfPlayer(newGroup.player1)
				if(IsValid(opponent))
					newGroup.player2 = opponent
			}
		}//超时玩家处理结束
		else//不存在已超时玩家,正常按照kd匹配
		{
			// Warning("Normal matching")
			foreach (eachPlayerStruct in soloPlayersWaiting ) //找player1
			{
				entity playerSelf = eachPlayerStruct.player
				float selfKd = eachPlayerStruct.kd
				table <entity,float> properOpponentTable
				foreach (eachOpponentPlayerStruct in soloPlayersWaiting ) //找player2
				{
					entity eachOpponent = eachOpponentPlayerStruct.player
					float opponentKd = eachOpponentPlayerStruct.kd
					if(playerSelf == eachOpponent || !IsValid(eachOpponent))//过滤非法对手
						continue

					if(fabs(selfKd - opponentKd) > 3.0) //过滤kd差值
						continue
					properOpponentTable[eachOpponent] <- fabs(selfKd - opponentKd)
				}

				float lowestKd = 999
				entity bestOpponent
				entity scondBestOpponent//防止bestOpponent是上一局的对手
				foreach (opponentt,kd in properOpponentTable)
				{

					if(kd < lowestKd)
					{
						scondBestOpponent = bestOpponent
						bestOpponent = opponentt
						lowestKd = kd
					}
				}

				entity lastOpponent = eachPlayerStruct.lastOpponent

				if(!IsValid(bestOpponent)) continue//没找到最合适玩家,为下一位玩家匹配
				if(bestOpponent != lastOpponent) //最合适玩家是上局对手,用第二合适玩家代替
				{
					// Warning("Best opponent, kd gap: " + lowestKd)
					newGroup.player1 = playerSelf
					newGroup.player2 = bestOpponent
					break
				}
				else if (IsValid(scondBestOpponent))
				{
					// Warning("Secondary opponent, kd gap: " + lowestKd)
					newGroup.player1 = playerSelf
					newGroup.player2 = scondBestOpponent
					break
				}
				else
				{
					// Warning("Only last opponent found, waiting for time out")
					continue //上局对手是最合适玩家,且没有第二合适对手,开始为下一位玩家匹配
				}
			}//foreach
		}//else

		if(! (IsValid(newGroup.player1) && IsValid(newGroup.player2))     ) //确保两个玩家都是合法玩家
		{
			// Warning("player Invalid, back to waiting list")
			soloModePlayerToWaitingList(newGroup.player1)
			soloModePlayerToWaitingList(newGroup.player2)
			continue
		}

		//already matched two players
		array<entity> players = [newGroup.player1,newGroup.player2]

		soloModePlayerToInProgressList(newGroup)

		foreach (index,eachPlayer in players )
		{
			EnableOffhandWeapons( eachPlayer )
			DeployAndEnableWeapons( eachPlayer )

			thread respawnInSoloMode(eachPlayer, index)
		}
		
		GiveWeaponsToGroup( players )
		// try{
			// newGroup.ring = CreateSmallRingBoundary(soloLocations[newGroup.slotIndex].Center)
			
			// if(IsValid(GetMainRingBoundary()))
				// newGroup.ring.SetParent(GetMainRingBoundary())
		// }catch(e420){}
		
		// setRealms_1v1(newGroup.ring,newGroup.slotIndex+1)
		//realms = 0 means visible for everyone,so it should be more than 1
		setRealms_1v1(newGroup.player1,newGroup.slotIndex+1) //to ensure realms is more than 0
		setRealms_1v1(newGroup.player2,newGroup.slotIndex+1) //to ensure realms is more than 0

	}//while(true)

	OnThreadEnd(
		function() : (  )
		{
			// Warning(Time() + "Solo thread is down!!!!!!!!!!!!!!!")
			GameRules_ChangeMap( GetMapName(), GameRules_GetGameMode() )
		}
	)

}//thread

void function GiveWeaponsToGroup( array<entity> players )
{
	thread function () : ( players )
	{
		foreach( player in players )
		{
			if( !IsValid( player ) )
				continue

			TakeAllWeapons(player)
		}

		wait 0.2

		string primaryWeaponWithAttachments = ReturnRandomPrimaryMetagame_1v1()
		string secondaryWeaponWithAttachments = ReturnRandomSecondaryMetagame_1v1()

		foreach( player in players )
		{
			if( !IsValid( player ) )
				continue
			
			DeployAndEnableWeapons( player )

			if ( !(player.GetPlayerName() in weaponlist))//avoid give weapon twice if player saved his guns
			{
				TakeAllWeapons(player)

				GivePrimaryWeapon_1v1( player, primaryWeaponWithAttachments, WEAPON_INVENTORY_SLOT_PRIMARY_0 )
				GivePrimaryWeapon_1v1( player, secondaryWeaponWithAttachments, WEAPON_INVENTORY_SLOT_PRIMARY_1 )
			} else
			{
				thread LoadCustomWeapon(player)
			}

			player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
			player.TakeOffhandWeapon( OFFHAND_MELEE )
			player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
			player.GiveOffhandWeapon( "melee_pilot_emptyhanded", OFFHAND_MELEE, [] )
		}
	}()
}

void function GivePrimaryWeapon_1v1(entity player, string weapon, int slot )
{
	array<string> Data = split(weapon, " ")
	string weaponclass = Data[0]
	
	if(weaponclass == "tgive") return
	
	array<string> Mods
	foreach(string mod in Data)
	{
		if(strip(mod) != "" && strip(mod) != weaponclass)
		    Mods.append( strip(mod) )
	}

	entity weaponNew = player.GiveWeapon( weaponclass , slot, Mods, false )

	SetupInfiniteAmmoForWeapon( player, weaponNew )
	player.ClearFirstDeployForAllWeapons()
	player.DeployWeapon()

	if( weaponNew.UsesClipsForAmmo() )
		weaponNew.SetWeaponPrimaryClipCount( weaponNew.GetWeaponPrimaryClipCountMax())

	if( weaponNew.LookupAttachment( "CHARM" ) != 0 )
		weaponNew.SetWeaponCharm( $"mdl/props/charm/charm_nessy.rmdl", "CHARM")
}

string function ReturnRandomPrimaryMetagame_1v1()
{
    array<string> Weapons = [
		"mp_weapon_alternator_smg optic_cq_threat bullets_mag_l2 stock_tactical_l2 laser_sight_l2"
		"mp_weapon_r97 laser_sight_l2 optic_cq_hcog_classic stock_tactical_l2 bullets_mag_l2",
		"mp_weapon_r97 laser_sight_l2 optic_cq_hcog_classic stock_tactical_l2 bullets_mag_l2",
		"mp_weapon_volt_smg laser_sight_l2 optic_cq_hcog_classic energy_mag_l2 stock_tactical_l2",
		"mp_weapon_energy_shotgun optic_cq_threat shotgun_bolt_l2 stock_tactical_l2",
		"mp_weapon_mastiff optic_cq_threat shotgun_bolt_l2 stock_tactical_l2",
		"mp_weapon_shotgun optic_cq_threat shotgun_bolt_l2 stock_tactical_l2"
	]

	foreach(weapon in Weapons)
	{
		array<string> weaponfullstring = split( weapon , " ")
		string weaponName = weaponfullstring[0]
		if(GetBlackListedWeapons().find(weaponName) != -1)
				Weapons.removebyvalue(weapon)
	}
	
	return Weapons.getrandom()
}

string function ReturnRandomSecondaryMetagame_1v1()
{
    array<string> Weapons = [
		"mp_weapon_wingman optic_cq_hcog_classic sniper_mag_l2 hopup_headshot_dmg",
		"mp_weapon_rspn101 barrel_stabilizer_l2 optic_cq_hcog_classic stock_tactical_l2 bullets_mag_l2",
		"mp_weapon_rspn101 barrel_stabilizer_l2 optic_cq_hcog_bruiser stock_tactical_l2 bullets_mag_l2",
		"mp_weapon_vinson optic_cq_hcog_bruiser stock_tactical_l2 highcal_mag_l2",
		"mp_weapon_vinson optic_cq_hcog_classic stock_tactical_l2 highcal_mag_l2",
		"mp_weapon_energy_ar optic_cq_hcog_classic energy_mag_l2 stock_tactical_l2 hopup_turbocharger",
		"mp_weapon_energy_ar optic_cq_hcog_bruiser energy_mag_l2 stock_tactical_l2 hopup_turbocharger"
	]

	foreach(weapon in Weapons)
	{
		array<string> weaponfullstring = split( weapon , " ")
		string weaponName = weaponfullstring[0]
		if(GetBlackListedWeapons().find(weaponName) != -1)
				Weapons.removebyvalue(weapon)
	}
	
	return Weapons.getrandom()
}

void function ForceAllRoundsToFinish_solomode()
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
			return

		soloGroupStruct group = returnSoloGroupOfPlayer(player) 
		destroyRingsForGroup(group)
		
		if(!group.IsKeep)
			group.IsFinished = true //tell solo thread this round has finished
		
		soloModePlayerToWaitingList( player )
		setRealms_1v1(player,64)
	}
	
	soloPlayersInProgress.clear()
}