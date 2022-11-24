//Flowstate 1v1 gamemode
//made by makimakima#5561
globalize_all_functions

global struct soloLocStruct
{
	LocPair &Loc1 //player1 respawn location
	LocPair &Loc2 //player2 respawn location
	entity Panel //keep current opponent panel
}
global struct soloGroupStruct
{
	entity player1
	entity player2
	int slotIndex
	bool IsFinished = false //player1 or player2 is died, set this to true and soloModeThread() will handle this
	bool IsKeep = false //not implement, player may want to play with current opponent,so we will keep this group
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
global bool IsInSoloMode = true


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
void function soloModeWaitingPrompt(entity player, vector waitingRoom)
{
	wait 1
	if(!IsValid(player)) return
	foreach (eachplayerStruct in soloPlayersWaiting)
	{
		if(eachplayerStruct.player == player) //this player is in waiting list
			Message(player,"You're in waiting room.","Type rest in console to start resting (literally).",1)
	}

}
void function soloModeThread()
{
	OnThreadEnd(
			function() : (  )
			{
				//Warning(Time() + "Solo thread is down!!!!!!!!!!!!!!!")
				GameRules_ChangeMap( GetMapName(), GameRules_GetGameMode() )
			}
		)
		
	LocPair WaitingRoom
	WaitingRoom.origin = <-7.62,200,184.57>
	WaitingRoom.angles = <0,90,0>
	IsInSoloMode = true

	wait 8
	while(true)
	{
		WaitFrame()

		//遍历等待队列
		foreach (playerInWatingSctruct in soloPlayersWaiting )
		{
			if(!IsValid(playerInWatingSctruct.player)) 
			{
				//Warning("PLAYER QUIT")
				soloPlayersWaiting.removebyvalue(playerInWatingSctruct)
				continue
			}
			
			if(Distance(playerInWatingSctruct.player.GetOrigin(),WaitingRoom.origin)>800) //waiting player should be in waiting room,not battle area
			{
				thread soloModeWaitingPrompt(playerInWatingSctruct.player,WaitingRoom.origin)
				maki_tp_player(playerInWatingSctruct.player,WaitingRoom) //waiting player should be in waiting room,not battle area
				HolsterAndDisableWeapons(playerInWatingSctruct.player)
			}

			//TakeAllWeapons(playerInWatingSctruct.player)//waiting player shouldnt have guns

			//标记超时玩家
			if(playerInWatingSctruct.waitingTime < Time() && !playerInWatingSctruct.IsTimeOut && IsValid(playerInWatingSctruct.player))
			{
				printt("mark time out player: " + playerInWatingSctruct.player.GetPlayerName() + " waitingTime: " + playerInWatingSctruct.waitingTime)
				playerInWatingSctruct.IsTimeOut = true
			}

		}



		//遍历游玩队列
		foreach (eachGroup in soloPlayersInProgress)
		{
			if(IsValid(eachGroup.player1)) //avoid player regen health
			{
				eachGroup.player1.p.lastDamageTime = Time()
			}

			if(IsValid(eachGroup.player2)) //avoid player regen health
			{
				eachGroup.player2.p.lastDamageTime = Time()
			}
			
			if(eachGroup.IsFinished)//this round has been finished
			{
				printt("this round has been finished")
				soloModePlayerToWaitingList(eachGroup.player1)
				soloModePlayerToWaitingList(eachGroup.player2)
				continue
			}
			if(eachGroup.IsKeep) //player in this group dont want to change opponent
			{
				if(IsValid(eachGroup.player1) && IsValid(eachGroup.player2) && (!IsAlive(eachGroup.player1) || !IsAlive(eachGroup.player2) ))
				{
					printt("respawn and tp player1")
					thread respawnInSoloMode(eachGroup.player1)

					printt("respawn and tp player2")
					thread respawnInSoloMode(eachGroup.player2)
				}//player in keeped group is died, respawn them
			}
			
			if(!IsValid(eachGroup.player1) || !IsValid(eachGroup.player2)) //Is player in this group quit the game
			{
				printt("solo player quit!!!!!")
				if(IsValid(eachGroup.player1))
				{
					soloModePlayerToWaitingList(eachGroup.player1) //back to wating list
					Message(eachGroup.player1,"Your opponent has quit the game!")
				}

				if(IsValid(eachGroup.player2))
				{
					soloModePlayerToWaitingList(eachGroup.player2) //back to wating list
					Message(eachGroup.player2,"Your opponent has quit the game!")
				}

			}

		}
		//遍历休息队列
		foreach (restingPlayer in soloPlayersResting )
		{
			if(!IsValid(restingPlayer)) continue
			if(!IsAlive(restingPlayer))
				respawnInSoloMode(restingPlayer)
			// if(Distance(restingPlayer.GetOrigin(),WaitingRoom.origin)>2500)
				// maki_tp_player(restingPlayer,WaitingRoom)
		}
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
			newGroup.player1 = getTimeOutPlayer() //获取超时的玩家
			if(IsValid(newGroup.player1))//存在超时等待玩家
			{
				printt("Time out player found: " + newGroup.player1.GetPlayerName())
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

					if(fabs(selfKd - opponentKd) > 1.5) //过滤kd差值
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
					//Warning("Best opponent, kd gap: " + lowestKd)
					newGroup.player1 = playerSelf
					newGroup.player2 = bestOpponent
					break
				}
				else if (IsValid(scondBestOpponent))
				{
					//Warning("Secondary opponent, kd gap: " + lowestKd)
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

		//已经成功找到player1 和player2
		soloModePlayerToInProgressList(newGroup)

		EnableOffhandWeapons( newGroup.player1 )
		DeployAndEnableWeapons( newGroup.player1 )

		EnableOffhandWeapons( newGroup.player2 )
		DeployAndEnableWeapons( newGroup.player2 )

		thread respawnInSoloMode(newGroup.player1)

		thread respawnInSoloMode(newGroup.player2)



	}//while(true)
}//thread
int function getAvailableSlotIndex()
{
	array<int> soloLocationInProgressIndexs //所有正在游玩的地区编号
	foreach (eachGroup in soloPlayersInProgress)
	{
		soloLocationInProgressIndexs.append(eachGroup.slotIndex) 
	}

	for (int i = 0; i < soloLocations.len(); ++i)
	{
		if (!soloLocationInProgressIndexs.contains(i)) //当前i的编号没有被占用
		{
			//printt("soloLocationInProgressIndexs: " + i.tostring())
			return i
		}
	}
	//printt("soloLocationInProgressIndexs: " + "-1")
	return -1
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
void function respawnInSoloMode(entity player) //复活死亡玩家和同一个sologroup的玩家
{
	if (!IsValid(player)) return
   	LocPair respawnLoc1 
   	LocPair respawnLoc2 

   	if( player.p.isSpectating )
    {
		player.SetSpecReplayDelay( 0 )
		player.SetObserverTarget( null )
		player.StopObserverMode()
        Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Deactivate")
    }//disable replay mode


   	if( soloPlayersResting.contains(player) )
	{
		// Warning("resting respawn")
		try
		{
			DecideRespawnPlayer(player, true)
			TakeAllWeapons(player)
			player.GiveWeapon( "mp_weapon_bolo_sword_primary", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
		    player.GiveOffhandWeapon( "melee_bolo_sword", OFFHAND_MELEE, [] )
		    GiveRandomPrimaryWeaponMetagame(player)
			GiveRandomSecondaryWeaponMetagame(player)	
		}
		catch (erroree)
		{
			// printt("fail to respawn")
		}
		HolsterAndDisableWeapons(player)
		LocPair WaitingRoom
		WaitingRoom.origin = <-7.62,200,184.57>
		WaitingRoom.angles = <0,90,0>
		maki_tp_player(player, WaitingRoom)
		return
	}//玩家在休息模式

	soloGroupStruct group = returnSoloGroupOfPlayer(player)
	if(!IsValid(group.player1)) return //Is this group is available

	try
	{
		DecideRespawnPlayer(group.player1, true)
		DecideRespawnPlayer(group.player2, true)
	}
	catch (error)
	{
		//Warning("fail to respawn")
	}


   		respawnLoc1 = soloLocations[group.slotIndex].Loc1
		respawnLoc2 = soloLocations[group.slotIndex].Loc2

		// PlayerRestoreHP_1v1(group.player1, 100, Equipment_GetDefaultShieldHP())
		// PlayerRestoreHP_1v1(group.player2, 100, Equipment_GetDefaultShieldHP())

		if(IsValid(group.player1) )
			PlayerRestoreHP_1v1(group.player1, 100, group.player1.GetShieldHealthMax().tofloat())
		if(IsValid(group.player2) )
			PlayerRestoreHP_1v1(group.player2, 100, group.player2.GetShieldHealthMax().tofloat())

		maki_tp_player(group.player1,respawnLoc1)
		maki_tp_player(group.player2,respawnLoc2)

		//限制武器
		//
		if(IsValid(group.player1))
		{
			group.player1.TakeOffhandWeapon(OFFHAND_TACTICAL)
			group.player1.TakeOffhandWeapon(OFFHAND_ULTIMATE)
		}//player dont need any skills in solo mode
		if(IsValid(group.player2))
		{
			group.player2.TakeOffhandWeapon(OFFHAND_TACTICAL)
			group.player2.TakeOffhandWeapon(OFFHAND_ULTIMATE)
		}//player dont need any skills in solo mode

		
		

	if (IsValid(group.player1) && !(group.player1.GetPlayerName() in weaponlist))
	{
		try
		{
			TakeAllWeapons(group.player1)
			group.player1.GiveWeapon( "mp_weapon_bolo_sword_primary", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
		    group.player1.GiveOffhandWeapon( "melee_bolo_sword", OFFHAND_MELEE, [] )
		    GiveRandomPrimaryWeaponMetagame(group.player1)
			GiveRandomSecondaryWeaponMetagame(group.player1)	
			group.player1.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
		}
		catch (ee)
		{}
		WpnPulloutOnRespawn(group.player1,0)
		wait 0.3
		if(IsValid(group.player1))
			WpnAutoReload(group.player1)
	}

		
		

	if (IsValid(group.player2) && !(group.player2.GetPlayerName() in weaponlist))
	{
		try
		{
			TakeAllWeapons(group.player2)
			group.player2.GiveWeapon( "mp_weapon_bolo_sword_primary", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
		    group.player2.GiveOffhandWeapon( "melee_bolo_sword", OFFHAND_MELEE, [] )
		    GiveRandomPrimaryWeaponMetagame(group.player2)
			GiveRandomSecondaryWeaponMetagame(group.player2)
			group.player2.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
		}
		catch (eeee)
		{}
		WpnPulloutOnRespawn(group.player2,0)
		wait 0.3
		if(IsValid(group.player2))
			WpnAutoReload(group.player2)
	}


		thread LoadCustomWeapon(group.player1)
		thread LoadCustomWeapon(group.player2)

	thread ReCheckGodMode(group.player1)
	thread ReCheckGodMode(group.player2)
	// group.player1.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
	// group.player2.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
	
		
}


void function _soloModeInit(string mapName)
{
	array<LocPair> allSoloLocations 
	array<LocPair> panelLocations
	if (mapName == "mp_rr_arena_composite")
	{
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

	// NewLocPair( <-2064.36401, 994.309998, 180.571426>, <0, -1.96184182, 0>), //9
	// NewLocPair( <-1554.99084, 1230.74365, 192.03125>, <0, -133.656342, 0>),
	NewLocPair( <-1441.08, 1675.66, 280.08>, <0, -110, 0>),//9
	NewLocPair( <-1787.21, 1008.08, 254.03>, <0, 50, 0>),//9

		NewLocPair( <1649.15588, 1135.37439, 192.03125>, <0, 137.991577, 0>), //10
		NewLocPair( <1122.84058, 1418.50452, 190.821075>, <0, -27.6340904, 0>),

		NewLocPair( <-2862.42407, 1511.31921, 140.03125>, <0, -100.470222, 0>), //11
		NewLocPair( <-2633.31348, 833.701477, 128.03125>, <0, 130.051575, 0>),

	NewLocPair( <-836.684998, 2751.19849, 192.03125>, <0, -150.722626, 0>),//12
	NewLocPair( <-1405.85583, 2548.43164, 192.03125>, <0, 12.0755987, 0>),
	// NewLocPair( <-1463.13, 2888.77, -50.29>, <0, 114, 0>),//12
	// NewLocPair( <-1640.11, 3390.12, -49.97>, <0, -90, 0>),

	// NewLocPair( <1533.10, 2961.55, -49.97>, <0, 60, 0>),//13
	// NewLocPair( <1606.03, 3532.19, -49.97>, <0, -90, 0>),
	
	]
	}
	else
	{
		return
	}
	
	for (int i = 0; i < allSoloLocations.len(); i=i+2)
	{
		soloLocStruct p
		p.Loc1 = allSoloLocations[i]
		p.Loc2 = allSoloLocations[i+1]
		soloLocations.append(p)
	}

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

		// NewLocPair( <-1543.08, 3213.69, -110.97>, <0, -100, 0>),//12
		// NewLocPair( <-1555.59, 3234.19, -110.97>, <0, 68, 0>),//13
	]
	foreach (index,eahclocation in panelLocations)
	{
		entity panel = CreateFRButton(eahclocation.origin, eahclocation.angles, "%&use% Never change oponent.")
		panel.SetSkin(1)//red
		AddCallback_OnUseEntity( panel, void function(entity panel, entity user, int input)
		{
			soloGroupStruct group = returnSoloGroupOfPlayer(user)
			if (!IsValid(group.player1) || !IsValid(group.player2)) return
			if( group.IsKeep == false)
			{
				group.IsKeep = true
				panel.SetSkin(0) //green

				try
				{
					Message(group.player1,"Your opponent won't change")
					Message(group.player2,"Your opponent won't change")
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
					Message(group.player1,"Your opponent will change now")
					Message(group.player2,"Your opponent will change now")
				}
				catch (error)
				{}
			}
			
		})

		soloLocations[index].Panel = panel
	}
	
	thread soloModeThread()

}

bool function isPlayerInSoloMode(entity player)
{
	if(!IsValid(player)) return false
	
	foreach (eachGroup in soloPlayersInProgress)
	{
	   	if(IsValid(eachGroup.player1) && player == eachGroup.player1 || IsValid(eachGroup.player2) && player == eachGroup.player2) //找到当前玩家的group
	   		return true
	}
	return false
}

bool function isPlayerInWatingList(entity player)
{
	if(!IsValid(player)) return false
	foreach (eachPlayerStruct in soloPlayersWaiting)
	{
		if(!IsValid(eachPlayerStruct.player)) return false
		
	   	if (eachPlayerStruct.player == player) //找到当前玩家的group
	   		return true
	}
	return false
}

void function soloModePlayerQuit(entity player)
{
	if(!IsValid(player)) return
	
	foreach (eachGroup in soloPlayersInProgress)
	{
		if(IsValid(eachGroup.player1) && player == eachGroup.player1 || IsValid(eachGroup.player2) && player == eachGroup.player2)
		{
			Message(eachGroup.player1,"Your opponent has disconnected!")
			Message(eachGroup.player2,"Your opponent has disconnected!")
		}
	}
}

void function deleteGroup(soloGroupStruct group)
{
	if(!IsValid(group)) return
	
	try
	{
		soloPlayersInProgress.removebyvalue(group) //delete this group
	}
	catch (error)
	{}
}

void function maki_tp_player(entity player,LocPair data)
{
	if(!IsValid(player)) return
	
	player.SetOrigin(data.origin)
	player.SetAngles(data.angles)
	
}

void function deleteWaitingPlayer(entity player)
{
	if(!IsValid(player)) return
	foreach (eachPlayerStruct in soloPlayersWaiting )
	{
		if(eachPlayerStruct.player == player)
		{

			soloPlayersWaiting.removebyvalue(eachPlayerStruct) //delete this PlayerStruct
			printt("deleted the PlayerStruct")

		}
	}
}

bool function ClientCommand_Maki_SoloModeRest(entity player, array<string> args)
{
	if(soloPlayersResting.contains(player))
	{
		Message(player,"Matching")
		soloModePlayerToWaitingList(player)
		
		player.MakeVisible()
		ClearInvincible(player)
		//EnableOffhandWeapons( player )
		DeployAndEnableWeapons(player)
	}
	else
	{
		Message(player,"You are resting now", "Type rest in console to pew pew again.")
		soloModePlayerToRestingList(player)
		try
		{
			player.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_suicide } )
		}
		catch (error)
		{
			
		}
		
		respawnInSoloMode(player)	
		
		player.MakeInvisible()
		MakeInvincible(player)
		HolsterAndDisableWeapons(player)
	}
	
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

entity function returnOpponentOfPlayer(entity player, soloGroupStruct group)
{
	entity p
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
		playerStruct.kd = getkd(player.GetPlayerGameStat( PGS_KILLS ),player.GetPlayerGameStat( PGS_DEATHS ))
	else
		playerStruct.kd = 0
	playerStruct.lastOpponent = player.p.lastKiller

	if(!IsAlreadyExist) //如果waiting list里没有这个玩家
	{
		soloPlayersWaiting.append(playerStruct)
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
			entity opponent = returnOpponentOfPlayer(player,group)

			if(IsValid(soloLocations[group.slotIndex].Panel)) //Panel in current Location
				soloLocations[group.slotIndex].Panel.SetSkin(1) //set panel to red(default color)

			soloPlayersInProgress.removebyvalue(eachGroup) //销毁这个group

			soloModePlayerToWaitingList(player) //将自己放回waiting list
			if(!IsValid(opponent)) continue //找不到对手
			soloModePlayerToWaitingList(opponent) //将对手放回waiting list
			
			
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
		return result
	}

	//检查InProgress是否存在该玩家
	bool IsAlreadyExist = false
	foreach (eachGroup in soloPlayersInProgress)
	{
		if(player == eachGroup.player1 || player == eachGroup.player2 || opponent == eachGroup.player1 || opponent == eachGroup.player2)
		{
			IsAlreadyExist = true
			soloPlayersInProgress.removebyvalue(eachGroup) //销毁这个group

			//Warning("[ERROR]Try to add a exist player of InProgress list to InProgress list") //不应该出现这种情况
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
		//Warning("[ERROR]Try to add a exist player of InProgress list to InProgress list") //不应该出现这种情况
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
		printt("solo slot exist")
		newGroup.slotIndex = slotIndex

		printt("add player1&player2 to InProgress list!")
		soloPlayersInProgress.append(newGroup) //加入游玩队列

		result = true
	}
	else
	{
		//Warning("No avaliable slot")
		result = false
	}

	return result
}


void function soloModePlayerToRestingList(entity player)
{
	if(!IsValid(player)) return

	deleteWaitingPlayer(player)

	
	soloGroupStruct group = returnSoloGroupOfPlayer(player)
	if(IsValid(group))
	{
		entity opponent = returnOpponentOfPlayer(player,group)

		if(IsValid(soloLocations[group.slotIndex].Panel)) //Panel in current Location
			soloLocations[group.slotIndex].Panel.SetSkin(1) //set panel to red(default color)
		
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
	Message(player,"Flowstate 1V1", "Made by makimakima#5561, v1.1")
	HolsterAndDisableWeapons(player)

	wait 8
	if(!IsValid(player)) return
	
	if(!soloPlayersResting.contains(player))
	{
		EnableOffhandWeapons( player )
		DeployAndEnableWeapons(player)
		soloModePlayerToWaitingList(player)
	}

	try
	{
		player.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_suicide } )
	}
	catch (error)
	{}
}

void function PlayerRestoreHP_1v1(entity player, float health, float shields)
{
	if(!IsValid(player)) return
	if(!IsAlive( player)) return

	player.SetHealth( health )
	Inventory_SetPlayerEquipment(player, "helmet_pickup_lv3", "helmet")
	if(shields == 0) return
	else if(shields <= 50)
		Inventory_SetPlayerEquipment(player, "armor_pickup_lv1", "armor")
	else if(shields <= 75)
		Inventory_SetPlayerEquipment(player, "armor_pickup_lv2", "armor")
	else if(shields <= 100)
		Inventory_SetPlayerEquipment(player, "armor_pickup_lv3", "armor")
	player.SetShieldHealth( shields )
}
	
