//Flowstate 1v1 gamemode
//made by makimakima#5561
globalize_all_functions

global struct soloLocStruct
{
	LocPair &Loc1 //player1 respawn location
	LocPair &Loc2 //player2 respawn location
}
global struct soloGroupStruct
{
	entity player1
	entity player2
	int slotIndex
	bool IsFinished = false //player1 or player2 is died, set this to true and soloModeThread() will handle this
	bool IsKeep = false //not implement, player may want to play with current opponent,so we will keep this group
}
global array<soloLocStruct> soloLocations //all respawn location stored here
global array <entity> soloPlayersWaiting = [] //waiting player stored here
global array <soloGroupStruct> soloPlayersInProgress = [] //playing player stored here

void function soloModeWaitingPrompt(entity player, vector waitingRoom)
{
	wait 2
	if(!IsValid(player)) return
	if(soloPlayersWaiting.contains(player)) //该玩家仍然处于等待队列
		Message(player,"Flowstate 1v1", "You are in waiting room!")
}
void function soloModeThread()
{
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

		if(soloPlayersWaiting.len()>1) //检测到等待玩家大于2人,开始游戏
		{			
			//printt("more than 2 player in solo waiting array,start game")
			soloGroupStruct newGroup //创建一个soloGroup

			newGroup.player1 = soloPlayersWaiting[RandomInt(soloPlayersWaiting.len())]
			soloPlayersWaiting.removebyvalue(newGroup.player1)
			newGroup.player2 = soloPlayersWaiting[RandomInt(soloPlayersWaiting.len())]
			soloPlayersWaiting.removebyvalue(newGroup.player2)


			int slotIndex = getAvailableSlotIndex()
   			if (slotIndex > -1) //available slot exist
			{
				//printt("solo slot exist")
				newGroup.slotIndex = slotIndex

				//printt("add player1&player2 to InProgress list!")
				soloPlayersInProgress.append(newGroup) //加入游玩队列

				//printt("respawn and tp player1")
				thread respawnInSoloMode(newGroup.player1)

				//printt("respawn and tp player2")
				thread respawnInSoloMode(newGroup.player2)
			}
			else //available slot not exist
			{
				//printt("no available slot exist, back to waiting list")
				addPlayerToSoloMode(newGroup.player1)
				addPlayerToSoloMode(newGroup.player2)
			}
		}

		foreach (playerInWating in soloPlayersWaiting )
		{
			if(!IsValid(playerInWating)) continue 
			
			LocPair WaitingRoom
			WaitingRoom.origin = <-7.62,200,184.57>
			WaitingRoom.angles = <0,90,0>
			thread soloModeWaitingPrompt(playerInWating,WaitingRoom.origin)
			if(Distance(playerInWating.GetOrigin(),WaitingRoom.origin)>800) //waiting player should be in waiting room,not battle area
			{
				maki_tp_player(playerInWating,WaitingRoom) //waiting player should be in waiting room,not battle area
			}

			TakeAllWeapons(playerInWating)//waiting player shouldnt have guns
		}

		foreach (eachGroup in soloPlayersInProgress)//
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
				addPlayerToSoloMode(eachGroup.player1)
				addPlayerToSoloMode(eachGroup.player2)
				deleteGroup(eachGroup)
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
					addPlayerToSoloMode(eachGroup.player1) //back to wating list
					Message(eachGroup.player1,"Your opponent has quit the game!")
				}

				if(IsValid(eachGroup.player2))
				{
					addPlayerToSoloMode(eachGroup.player2) //back to wating list
					Message(eachGroup.player2,"Your opponent has quit the game!")
				}

				deleteGroup(eachGroup)
			}

		}
	}	
}
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
			print("soloLocationInProgressIndexs: " + i.tostring())
			return i
		}
	}
	print("soloLocationInProgressIndexs: " + "-1")
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

   	if(isPlayerInSoloMode(player))
   	{
   		soloGroupStruct group = returnSoloGroupOfPlayer(player)
   		if(!IsValid(group.player1)) return //Is this group is available

   		try
   		{
   			DecideRespawnPlayer(group.player1, true)
   			DecideRespawnPlayer(group.player2, true)
   		}
   		catch (error)
   		{}

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

		
		try
		{
			TakeAllWeapons(group.player1)
		    GiveRandomPrimaryWeaponMetagame(group.player1)
			GiveRandomSecondaryWeaponMetagame(group.player1)	
			group.player1.GiveWeapon( "mp_weapon_bolo_sword_primary", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
		    group.player1.GiveOffhandWeapon( "melee_bolo_sword", OFFHAND_MELEE, [] )
		}
		catch (ee)
		{}

		if (IsValid(group.player1) && !(group.player1.GetPlayerName() in weaponlist))
		{
			WpnPulloutOnRespawn(group.player1,0)
			wait 0.3
			if(IsValid(group.player1))
				WpnAutoReload(group.player1)
		}

		
		try
		{
			TakeAllWeapons(group.player2)
		    GiveRandomPrimaryWeaponMetagame(group.player2)
			GiveRandomSecondaryWeaponMetagame(group.player2)	
			group.player2.GiveWeapon( "mp_weapon_bolo_sword_primary", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
		    group.player2.GiveOffhandWeapon( "melee_bolo_sword", OFFHAND_MELEE, [] )
		}
		catch (eeee)
		{}

		if (IsValid(group.player2) && !(group.player2.GetPlayerName() in weaponlist))
		{
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
}


void function _soloModeInit(string mapName)
{
	array<LocPair> allSoloLocations 
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

		NewLocPair( <-2064.36401, 994.309998, 180.571426>, <0, -1.96184182, 0>), //9
		NewLocPair( <-1554.99084, 1230.74365, 192.03125>, <0, -133.656342, 0>),

		NewLocPair( <1649.15588, 1135.37439, 192.03125>, <0, 137.991577, 0>), //10
		NewLocPair( <1122.84058, 1418.50452, 190.821075>, <0, -27.6340904, 0>),

		NewLocPair( <-2862.42407, 1511.31921, 140.03125>, <0, -100.470222, 0>), //11
		NewLocPair( <-2633.31348, 833.701477, 128.03125>, <0, 130.051575, 0>),

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
	array<LocPair> panelLocations = [
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
	]
	foreach (eahclocation in panelLocations)
	{
		entity panel = CreateFRButton(eahclocation.origin, eahclocation.angles, "%&use% Never change enemy")
		panel.SetSkin(1)//red
		AddCallback_OnUseEntity( panel, void function(entity panel, entity user, int input)
		{
			soloGroupStruct group = returnSoloGroupOfPlayer(user)
			if (!IsValid(group.player1)) return
			if( group.IsKeep == false)
			{
				group.IsKeep = true
				panel.SetSkin(0) //green
			}
			else
			{
				group.IsKeep = false
				panel.SetSkin(1) //red
			}
			
		})
	}
	
	thread soloModeThread()

}
void function addPlayerToSoloMode(entity player)
{
	if (!IsValid(player)) return
	if (!player.IsPlayer()) return

	foreach (eachplayer in soloPlayersWaiting)
	{
		if(player == eachplayer)
		{
			printt("This play is exist in waiting list")
			return
		}
	}
	soloPlayersWaiting.append(player) 
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
	foreach (eachplayer in soloPlayersWaiting)
	{
		if(!IsValid(eachplayer)) return false
		
	   	if (eachplayer == player) //找到当前玩家的group
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
			Message(eachGroup.player1,"Your opponent has quit the game!")
			Message(eachGroup.player2,"Your opponent has quit the game!")
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