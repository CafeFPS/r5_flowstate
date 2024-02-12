//Flowstate 1v1 gamemode
//made by __makimakima__
globalize_all_functions

global bool IS_CHINESE_SERVER = false
global bool APlayerHasMessage = false

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
	entity ring

	soloLocStruct &groupLocStruct

	int slotIndex
	bool GROUP_INPUT_LOCKED = false //lock group to their input - mkos
	bool IsFinished = false //player1 or player2 is died, set this to true and soloModeThread() will handle this
	bool IsKeep = false //player may want to play with current opponent,so we will keep this group
}
global struct soloPlayerStruct
{
	entity player
	float queue_time //marks the time when they queued, to allow checking for same input
	bool IBMM_Timeout_Reached = false //input based match making timeout 
	bool waitingmsg = true
	float waitingTime //players may want to play with random opponent(or a matched opponent), so adding a waiting time after they died can allow server to match proper opponent
	float kd //stored this player's kd to help server match proper opponent
	entity lastOpponent //opponent of last round
	bool IsTimeOut = false
}

array< bool > realmSlots
global array <soloLocStruct> soloLocations //all respawn location stored here
global array <soloPlayerStruct> soloPlayersWaiting = [] //waiting player stored here
global array <soloGroupStruct> soloPlayersInProgress = [] //playing player stored here
global array <entity> soloPlayersResting = []

// arrays to store loaded custom weapons from playlist once in init -- mkos //########
global array <string> custom_weapons_primary = [] 
global array <string> custom_weapons_secondary = [] 

// SBMM vars
global float lifetime_kd_weight
global float current_kd_weight 
global float SBMM_kd_difference


bool function Fetch_IBMM_Timeout_For_Player( entity player ) {

if ( !IsValid( player ) ) return false
if ( soloPlayersWaiting.len() <= 0 ) return false

    for (int i = 0; i < soloPlayersWaiting.len(); i++) {
        if ( soloPlayersWaiting[i].player == player ) {
            return soloPlayersWaiting[i].IBMM_Timeout_Reached;
        }
    }
	return false;
}

void function ResetIBMM( entity player ) {
	
	if ( !IsValid( player ) ) return
	if ( soloPlayersWaiting.len() <= 0 ) return

    for (int i = 0; i < soloPlayersWaiting.len(); i++) {
        if (soloPlayersWaiting[i].player == player ) {
            soloPlayersWaiting[i].IBMM_Timeout_Reached = false;
            return;
        }
    }
}


void function SetMsg( entity player, bool value ) {
	
	if ( !IsValid( player ) ) return
	if ( soloPlayersWaiting.len() <= 0 ) return

    for (int i = 0; i < soloPlayersWaiting.len(); i++) {
        if (soloPlayersWaiting[i].player == player ) {
            soloPlayersWaiting[i].waitingmsg = value;
            return;
        }
    }
}

string function FetchInputName( entity player ){

	string input = player.p.input == 0 ? "MnK" : "Controller";
	return input;

}

string function GetScore( entity player )
{	
	if ( !IsValid( player ) ) 
	{
		return "INVALID_PLAYER";
	}
	
	float lt_kd = getkd( (player.GetPlayerNetInt( "kills" ) + player.p.lifetime_kills) , (player.GetPlayerNetInt( "deaths" ) + player.p.lifetime_deaths) )
	float cur_kd = getkd( player.GetPlayerNetInt( "kills" ) , player.GetPlayerNetInt( "deaths" )  )
	float score = (  ( lt_kd * lifetime_kd_weight ) + ( cur_kd * current_kd_weight ) )
	string name = player.GetPlayerName()	
	
	return format("Player: %s, Lifetime KD: %.2f, Current KD: %.2f, Score: %.2f ", name, lt_kd, cur_kd, score )
	
}

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
	switch( mapName )
	{
		case "mp_rr_arena_phase_runner":
		WaitingRoom.origin = <30498.4766, 18053.9453, -897.115784>
		WaitingRoom.angles = <0, 105.206207, 0>
		break

		case "mp_rr_arena_composite":
		WaitingRoom.origin = <-7.62,200,184.57>
		WaitingRoom.angles = <0,90,0>
		break

		case "mp_rr_aqueduct":
		WaitingRoom.origin = <719.94,-5805.13,494.03>
		WaitingRoom.angles = <0,90,0>
		break

		case "mp_rr_canyonlands_64k_x_64k":
		WaitingRoom.origin = <-762.59,20485.05,4626.03>
		WaitingRoom.angles = <0,45,0>
		break

		case "mp_rr_canyonlands_staging":
		if( GetCurrentPlaylistName() == "fs_lgduels_1v1" )
		{
			WaitingRoom.origin = < 3477.69, -8364.02, -10252 >
			WaitingRoom.angles = <356.203, 269.459, 0>
		}
		break
		
		case "mp_rr_olympus_mu1":
		{
			// switch( RandomIntRangeInclusive(0,4) )
			// {
				// case 0:
				// WaitingRoom.origin = <1693.82263, -11303.1875, -5381.50537>
				// WaitingRoom.angles = <0, -147.762939, 0>
				// break
				
				// case 1:
				// WaitingRoom.origin = <-3884.95532, -2075.82471, -6327.96875>
				// WaitingRoom.angles = <0, -152.580872, 0>
				// break
				
				// case 2:
				// WaitingRoom.origin = <-4997.26904, -20453.6172, -4272.75342>
				// WaitingRoom.angles = <0, 177.826843, 0>
				// break
				
				// case 3:
				// WaitingRoom.origin = <-33551.1094, -4007.87256, -4234.25781>
				// WaitingRoom.angles = <0, -16.5702744, 0>
				// break
				
				// case 4:
				WaitingRoom.origin = <-34740.3789, 9108.625, -5563.96875>
				WaitingRoom.angles = <0, 0.366868019, 0>
				break
			// }
			// break
		}
	}
	return WaitingRoom
}

void function SetIsUsedBoolForRealmSlot( int realmID, bool usedState )
{
	realmSlots[ realmID ] = usedState
}

int function getAvailableRealmSlotIndex()
{
	for( int slot = 1; slot < realmSlots.len(); slot++ )
	{
		if( !realmSlots[slot] )
		{
			SetIsUsedBoolForRealmSlot( slot, true )
			return slot
		}
	}

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


// lg_duel mkos
bool function return_rest_state( entity player )
{
	if ( !IsValid( player )) return false
	if ( GetCurrentPlaylistName() != "fs_1v1" || GetCurrentPlaylistName() != "fs_lgduels_1v1" ) return false
	
	if (isPlayerInRestingList( player ))
	{
		return true;
	}
	return false;
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


bool function mkos_Force_Rest(entity player, array<string> args)
{
	if( !IsValid(player) ) //|| !IsAlive(player) )
		return false

	if(soloPlayersResting.contains(player))
	{
		return false
	} 
	
	if(isPlayerInWaitingList(player))
		return false

	soloModePlayerToRestingList(player)
	try
	{
		player.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_suicide } )
	}
	catch (error)
	{

	}

	TakeAllWeapons( player )	
	player.p.lastRestUsedTime = Time()

	return true
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
			if (eachPlayerStruct.player.p.input == player.p.input || ( eachPlayerStruct.IBMM_Timeout_Reached == true && Fetch_IBMM_Timeout_For_Player( player ) == true ) )
			{
				return eachPlayerStruct.player
			}
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
	if(!IsValid(player) || isPlayerInWaitingList(player) ) 
		return

	player.SetPlayerNetEnt( "FSDM_1v1_Enemy", null )

	soloPlayerStruct playerStruct
	playerStruct.player = player
	playerStruct.waitingTime = Time() + 2
	
	//mkos
	//playerStruct.queue_time = Time()
	//ResetIBMM( player )
	//player.p.inputmode = "OPEN";
	//sqprint(format("Queue time set for %s AT: %f ", playerStruct.player.GetPlayerName(), playerStruct.queue_time ))
	//sqprint(format("Setting player %s inputmode to: %s", player.GetPlayerName(), player.p.inputmode ))
	
	float lifetime_kd;
	float current_kd;
	
	if(IsValid(player))
	{// weighted scoring
		lifetime_kd = getkd( (player.GetPlayerNetInt( "kills" ) + player.p.lifetime_kills) , (player.GetPlayerNetInt( "deaths" ) + player.p.lifetime_deaths) )
		current_kd = getkd( player.GetPlayerNetInt( "kills" ) , player.GetPlayerNetInt( "deaths" )  )	
		playerStruct.kd = (  ( lifetime_kd * lifetime_kd_weight ) + ( current_kd * current_kd_weight ) )
	}
	else
	{
		playerStruct.kd = 0
	}
	playerStruct.lastOpponent = player.p.lastKiller

	playerStruct.queue_time = Time()
	ResetIBMM( player )
	soloPlayersWaiting.append(playerStruct)
	TakeAllWeapons( player )

	//set realms for resting player
	FS_ClearRealmsAndAddPlayerToAllRealms( player )
	
	Remote_CallFunction_NonReplay( player, "ForceScoreboardFocus" )

	//检查InProgress是否存在该玩家
	foreach (eachGroup in soloPlayersInProgress)
	{
		if(player == eachGroup.player1 || player == eachGroup.player2)
		{

			soloGroupStruct group = returnSoloGroupOfPlayer(player)
			entity opponent = returnOpponentOfPlayer(player)

			// if(IsValid(soloLocations[group.slotIndex].Panel)) //Panel in current Location
				// soloLocations[group.slotIndex].Panel.SetSkin(1) //set panel to red(default color)

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
		//oldspot
		
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

	int slotIndex = getAvailableRealmSlotIndex()
	if (slotIndex > -1) //available slot exist
	{
		//printt("solo slot exist")
		newGroup.slotIndex = slotIndex
		newGroup.groupLocStruct = soloLocations.getrandom()
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
	
	ResetIBMM( player )
	player.p.destroynotify = true
	player.p.notify = false
	
	player.SetPlayerNetEnt( "FSDM_1v1_Enemy", null )
	deleteWaitingPlayer(player)


	soloGroupStruct group = returnSoloGroupOfPlayer(player)
	if(IsValid(group))
	{
		entity opponent = returnOpponentOfPlayer(player)

		// if(IsValid(soloLocations[group.slotIndex].Panel)) //Panel in current Location
			// soloLocations[group.slotIndex].Panel.SetSkin(1) //set panel to red(default color)

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

const int MAX_REALM = 63

void function FS_SetRealmForPlayer( entity player, int realmIndex )
{
	if( !IsValid( player ) || realmIndex > MAX_REALM ) 
		return 

	player.RemoveFromAllRealms()
	player.AddToRealm( realmIndex )
}

void function FS_ClearRealmsAndAddPlayerToAllRealms( entity player )
{
	if( !IsValid( player ) )
		return

	player.AddToAllRealms()
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

		if(!isPlayerInRestingList(player))

		if( GetCurrentPlaylistName() != "fs_lgduels_1v1" && !GetCurrentPlaylistVarBool("lg_duel_mode_60p", false) )
		{
	    	player.GiveOffhandWeapon( "melee_pilot_emptyhanded", OFFHAND_MELEE, [] )
	    	player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
	    }
		
		//hack to fix first reload
		player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_1)
		player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
		player.ClearFirstDeployForAllWeapons()
	}
	catch (e)
	{}
}

bool function isGroupValid(soloGroupStruct group)
{
	if(!IsValid(group)) return false
	if(!IsValid(group.player1) || !IsValid(group.player2)) return false
	return true
}

void function respawnInSoloMode(entity player, int respawnSlotIndex = -1) //复活死亡玩家和同一个sologroup的玩家
{
	if ( !IsValid(player) ) return

	if ( !player.p.isConnected ) return //crash fix mkos

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

		maki_tp_player(player, waitingRoomLocation)
		player.MakeVisible()
		player.ClearInvulnerable()
		player.SetTakeDamageType( DAMAGE_YES )

		//set realms for resting player
		FS_ClearRealmsAndAddPlayerToAllRealms( player )

		return
	}//玩家在休息模式

	soloGroupStruct group = returnSoloGroupOfPlayer(player)

	if( !isGroupValid( group) ) 
		return //Is this group is available

	if ( respawnSlotIndex == -1 ) 
		return

	try
	{
		DecideRespawnPlayer(player, true)
	}
	catch (error)
	{
		// Warning("fail to respawn")
	}
	
	//mkosDEBUG
	/* array<ItemFlavor> characters = GetAllCharacters()
			int random_character_index = RandomIntRangeInclusive(0,characterslist.len()-1)
			ItemFlavor random_character = characters[characterslist[random_character_index]]
			CharacterSelect_AssignCharacter( ToEHI( player ), random_character )
	*/
	
	soloLocStruct groupLocStruct = group.groupLocStruct
	maki_tp_player(player, groupLocStruct.respawnLocations[ respawnSlotIndex ] )

	wait 0.2 //防攻击的伤害传递止上一条命被到下一条命的玩家上

	if(!IsValid(player)) return

	if( GetCurrentPlaylistName() == "fs_lgduels_1v1" )
	{
		Inventory_SetPlayerEquipment(player, "", "armor")
		PlayerRestoreHP_1v1(player, 100, 0 )
	}
	else
	{
		Inventory_SetPlayerEquipment(player, "armor_pickup_lv3", "armor")
		PlayerRestoreHP_1v1(player, 100, player.GetShieldHealthMax().tofloat() )
	}

	Survival_SetInventoryEnabled( player, false )
	//SetPlayerInventory( player, [] )
	thread ReCheckGodMode(player)
}

void function _soloModeInit(string mapName)
{	
	
	//convert strings from playlist into array and add to array memory structure -- mkos
	if ( Playlist_1v1_Primary_Array() != "" )
	{	
		
		string concatenate = Concatenate( Playlist_1v1_Primary_Array(), Playlist_1v1_Primary_Array_continue() )
	
		try {
		
			custom_weapons_primary = StringToArray( concatenate );
			
		} catch ( error ) 
		{
			sqprint( "" + error )
		}
	
	}
		
	if ( Playlist_1v1_Secondary_Array() != "" )
	{
		string concatenate = Concatenate( Playlist_1v1_Secondary_Array(), Playlist_1v1_Secondary_Array_continue() )
	
		try {
		
			custom_weapons_secondary = StringToArray( concatenate );
			
		} catch ( error ) 
		{
			sqprint( "" + error )
		}
	
	}
	
	//initialize defaults for SBMM
	
	lifetime_kd_weight = GetCurrentPlaylistVarFloat( "lifetime_kd_weight", 0.70 )
	current_kd_weight = GetCurrentPlaylistVarFloat( "current_kd_weight", 1.0 )
	SBMM_kd_difference = GetCurrentPlaylistVarFloat( "kd_difference", 2.2 )

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
			
			
			// //drop off patch mkos
			// array<LocPair> dropoff_patch
			// array<LocPair> dropoff_panel_patch
			
			// dropoff_patch = [
				
				// //removed skyroom
				// //NewLocPair( <-1378.05, 559.458, 1026.54 >, < 359.695, 307.314, 0 >),//13
				// //NewLocPair( <-1469.03, -117.677, 1026.54 >, < 1.34318, 60.0746, 0 >),
				
				// NewLocPair( < -2824.9, 2868.1, -111.969 >, < 0.354577, 31.8209, 0 >), //13
				// NewLocPair( < -2541.81, 3919.45, -111.969 >, < 358.65, 315.899, 0 >),

				
				// NewLocPair( < -2958.52, 183.899, 190.063 >, < 0.905181, 353.701, 0 >),//14
				// NewLocPair( < -1693.05, -663.034, 190.063 >, < 0.514909, 140.627, 0 >),
				
				
				// NewLocPair( <2544.54, 3934.15, -111.969 >, < 3.3168, 218.85, 0>), //15
				// NewLocPair( <3196.49, 3010.24, -111.969 >, < 1.33276, 134.094, 0>),
				
				// NewLocPair( < 2551.65, 515.938, 193.337 >, < 0.894581, 215.161, 0>), //16
				// NewLocPair( <1637.37, -808.877, 193.67 >, < 0.0671947, 36.8544, 0>)
			
			// ]
		
			// dropoff_panel_patch = [
			
					// NewLocPair( < -3047.298, 3813.393, -151.6514 >, < 0, 36.8985, 0 >),//13
					// NewLocPair( < -2178.562, 481.2845, 189.9998 >, < 0, -38.7379, 0 >),//14
					// //NewLocPair( <-1008.24, 147.977, 687.264 >, < 53.1792, 2.4232, 0>),//14
					// NewLocPair( < 3077.486, 3859.245, -151.6514 >, < 0, -39.3852, 0 >), //15
					// NewLocPair( < 1868.973, 211.2266, 191.9968 >, < 0, 36.8535, 0 >) //16
			
			// ]
			
			// if ( GetCurrentPlaylistVarBool( "patch_for_dropoff", false ) ){
			
					// foreach ( loc in dropoff_patch ) {
						// allSoloLocations.append(loc);
					// }

					// foreach ( loc in dropoff_panel_patch ) {
						// panelLocations.append(loc);
					// }
				
			// }
			
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
		waitingRoomPanelLocation = NewLocPair( <-607.59,20640.05,4570.03>, <0,-45,0>) //休息区观战面板

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
	else if (mapName == "mp_rr_canyonlands_staging") //_LG_duels
	{
		//waitingRoomLocation = NewLocPair( < 3477.74, -8544.55, -10252 >, < 356.203, 269.459, 0 >)  
		waitingRoomPanelLocation = NewLocPair( < 3486.38, -9283.15, -10252 >, < 0, 180, 0 >) //休息区观战面板

		allSoloLocations= [

		NewLocPair( < 1317.27, 10573.3, 136.275 >, < 358.367, 0.169666, 0 > ),//1
		NewLocPair( < 1912.15, 10630.3, 136.275 >, < 358.431, 180.377, 0 > ),
		
		
		NewLocPair( < 1314.7, 11484.3, 136.275 >, < 359.433, 359.118, 0 > ),//2
		NewLocPair( < 1920.17, 11083.7, 136.275 >, < 358.616, 179.015, 0 > ),
		
		
		NewLocPair( < 1342.6, 12083.1, 136.275 >, < 359.021, 359.681, 0 > ),//3
		NewLocPair( < 1928.12, 12062, 136.275 >, < 358.46, 179.056, 0 > ),
		
		
		NewLocPair( < 1334.54, 12767, 135.001 >, < 359.376, 359.648, 0 > ),//4
		NewLocPair( < 1929.33, 12617.3, 136.275 >, < 358.646, 179.52, 0 > ),
		
		
		NewLocPair( < 1314.61, 13608.2, 136.275 >, < 359.413, 359.458, 0 > ),//5
		NewLocPair( < 1932.81, 13588.9, 136.275 >, < 358.417, 179.147, 0 > ),
		
		
		NewLocPair( < 1327.13, 14445.1, 136.275 >, < 359.142, 359.982, 0 > ),//6
		NewLocPair( < 1895.99, 14101.3, 136.275 >, < 359.454, 179.149, 0 > ),
		
		
		NewLocPair( < 2027.17, 14255.7, 136.275 >, < 359.44, 0.900257, 0 > ),//7
		NewLocPair( < 2705.93, 14519.9, 136.275 >, < 358.557, 179.749, 0 > ),
					
		
		NewLocPair( < 2022.17, 13587.2, 136.275 >, < 358.804, 1.26951, 0 > ),//8
		NewLocPair( < 2649.07, 13569.1, 136.275 >, < 358.587, 177.486, 0 > ),
		
		
		NewLocPair( < 2012.83, 12907, 136.275 >, < 358.71, 358.894, 0 > ),//9
		NewLocPair( < 2705.93, 12639.9, 136.275 >, < 358.306, 179.909, 0 > ),
		
		
		NewLocPair( < 2007.38, 12065.2, 136.275 >, < 358.02, 1.20616, 0 > ),//10
		NewLocPair( < 2705.93, 12187.1, 136.275 >, < 358.205, 179.637, 0 > ),
					
		
		NewLocPair( < 2010.97, 11294.1, 136.275 >, < 358.677, 1.92442, 0 > ),//11
		NewLocPair( < 2684.01, 11274.2, 136.275 >, < 358.706, 181.528, 0 > ),
		
		
		NewLocPair( < 2018.2, 10553.4, 136.275 >, < 358.365, 0.918914, 0 > ),//12
		NewLocPair( < 2695.21, 10658.3, 136.275 >, < 358.73, 180.507, 0 > ),
		
		
		NewLocPair( < 3454.38, 10463.6, 136.275 >, < 358.461, 179.844, 0 >),//13
		NewLocPair( < 2774.57, 10563.2, 136.275 >, < 358.25, 359.569, 0 > ),
					
		
		NewLocPair( < 2789.48, 11318, 136.275 >, < 358.431, 359.476, 0 > ),//14
		NewLocPair( < 3419.66, 11296.9, 136.275 >, < 358.114, 178.214, 0 > ),
		
		
		NewLocPair( < 2851.9, 12073.4, 136.275 >, < 359.097, 0.0967312, 0 > ),//15
		NewLocPair( < 3410.55, 11985.1, 136.275 >, < 358.553, 178.984, 0 > ),
		
		
		NewLocPair( < 3434.33, 12949.8, 136.275 >, < 358.217, 180.349, 0 > ),//16
		NewLocPair( < 2789.41, 12696.9, 136.275 >, < 358.063, 0.618432, 0 > ),
					
		
		NewLocPair( < 2821.61, 13592.5, 136.275 >, < 358.434, 0.300493, 0 > ),//17
		NewLocPair( < 3445.45, 13501.6, 136.275 >, < 358.302, 178.999, 0 > ),
		
		
		NewLocPair( < 2785.1, 14336.5, 136.275 >, < 357.755, 1.08752, 0 > ),//18
		NewLocPair( < 3418.27, 14335, 136.275 >, < 358.706, 178.716, 0 > ),
		
		
		NewLocPair( < 3556.97, 14536.3, 136.275 >, < 358.44, 359.719, 0 > ),//19
		NewLocPair( < 4190.3, 14080.3, 136.275 >, < 358.096, 178.87, 0 > ),
					
		
		NewLocPair( < 3567.85, 13604.9, 136.275 >, < 358.768, 359.636, 0 > ),//20
		NewLocPair( < 4201.19, 13668.7, 136.275 >, < 358.71, 180.051, 0 > ),
		
		
		NewLocPair( < 3551.94, 13015.2, 136.275 >, < 358.056, 359.814, 0 > ),//21
		NewLocPair( < 4194.56, 12673.9, 136.275 >, < 358.854, 180.855, 0 > ),
		
		
		NewLocPair( < 3542.06, 11949.6, 136.275 >, < 358.863, 0.431551, 0 > ),//22
		NewLocPair( < 4212.53, 12181.8, 136.275 >, < 358.223, 179.777, 0 > ),
					
		
		NewLocPair( < 3535.76, 11498.9, 136.275 >, < 358.982, 359.36, 0 > ),//23
		NewLocPair( < 4155.54, 11130.5, 136.275 >, < 358.654, 179.863, 0 > ),
		
		
		NewLocPair( < 3542.66, 10485.4, 136.275 >, < 358.779, 359.757, 0 > ),//24
		NewLocPair( < 4216.37, 10769.5, 136.275 >, < 358.249, 180.085, 0 > ),
		
		
		NewLocPair( < 4312.77, 10552.7, 136.275 >, < 358.922, 0.222934, 0 > ),//25
		NewLocPair( < 4934.16, 10569.1, 136.275 >, < 358.363, 179.387, 0 > ),
					
		
		NewLocPair( < 4934.63, 11044.4, 136.275 >, < 358.444, 179.237, 0 > ),//26
		NewLocPair( < 4293.06, 11584.1, 136.275 >, < 359.283, 358.251, 0 > ),
		
		
		NewLocPair( < 4939.28, 12050.6, 136.275 >, < 358.252, 178.744, 0 > ),//27
		NewLocPair( < 4317.15, 12075.5, 136.275 >, < 357.813, 359.825, 0 > ),
		
		
		NewLocPair( < 4953.12, 12665.2, 136.275 >, < 358.416, 179.383, 0 > ),//28
		NewLocPair( < 4288.89, 12679.3, 136.275 >, < 358.572, 359.256, 0 > ),
					
		
		NewLocPair( < 4949.51, 13535, 136.275 >, < 358.109, 179.168, 0 > ),//29
		NewLocPair( < 4334.56, 13790.7, 136.275 >, < 358.745, 359.199, 0 > ),
		
		
		NewLocPair( < 4854.76, 14333.8, 136.275 >, < 358.84, 179.242, 0 > ),//30
		NewLocPair( < 4449.29, 14355.9, 136.275 >, < 358.114, 359.415, 0 > ),
		
		]
		
		
		panelLocations = [

		]
	}
	else if(mapName == "mp_rr_olympus_mu1" )
	{
		//waitingRoomLocation = NewLocPair( < 3477.74, -8544.55, -10252 >, < 356.203, 269.459, 0 >)  
		waitingRoomPanelLocation = NewLocPair( <757.977661, -19179.2988, -4947.88916> , <0, -59.8670502, 0> ) //休息区观战面板

		allSoloLocations= [

		NewLocPair( <-1201.59253, -16890.8047, -5855.96875> , <0, 31.9761848, 0> ),//1
		NewLocPair( <113.526039, -16029.5938, -5855.96875> , <0, -149.722336, 0> ),
		
		
		NewLocPair( <-512.127747, -15591.7178, -5855.96875> , <0, 94.5153809, 0> ),//2
		NewLocPair( <-667.869751, -14505.1709, -5855.96875> , <0, -83.5864868, 0> ),
		
		
		NewLocPair( <-714.33667, -12988.3916, -5599.96875> , <0, 34.2161255, 0> ),//3
		NewLocPair( <594.093018, -12082.2148, -5599.96875> , <0, -149.091339, 0> ),
		
		
		NewLocPair( <2100.16699, -18551.3066, -5161.96875> , <0, 22.290987, 0> ),//4
		NewLocPair( <3943.45288, -17322.4727, -5154.92383> , <0, -145.848755, 0> ),
		
		
		NewLocPair( <5843.12305, -20389.2637, -5336.85889> , <0, -147.011337, 0> ),//5
		NewLocPair( <3934.88306, -21301.6602, -5336.43604> , <0, 37.337265, 0> ),
		
		
		NewLocPair( <5705.55859, -23269.3281, -5424.20508> , <0, -16.8778439, 0> ),//6
		NewLocPair( <7590.79297, -23612.457, -5423.95166> , <0, 174.21315, 0> ),
		
		
		NewLocPair( <1632.04712, -2370.35645, -4298.61182> , <0, 57.0976982, 0> ),//7
		NewLocPair( <2745.64502, -1038.06262, -4299.8667> , <0, -130.497162, 0> ),
					
		
		NewLocPair( <2124.43579, 2414.39185, -5037.00586> , <0, 89.1222687, 0> ),//8
		NewLocPair( <2191.55835, 3534.9751, -5037.00586> , <0, -99.974762, 0> ),
		
		
		NewLocPair( <-7675.92139, 2044.28552, -6151.95654> , <0, -172.329117, 0>),//9
		NewLocPair( <-8938.15527, 1777.57361, -6151.14941> , <0, 15.8113909, 0> ),
		
		
		NewLocPair( <-22923.2324, 20.4092407, -5345.02686> , <0, 83.7902145, 0> ),//10
		NewLocPair( <-23319.9531, 883.936646, -5129.96875> , <0, -94.1073761, 0> ),
					
		
		NewLocPair( <-23755.168, 260.056152, -5567.94971> , <0, 2.46514034, 0> ),//11
		NewLocPair( <-22584.1582, 513.171265, -5129.96875> , <0, -157.329651, 0> ),
		
		
		NewLocPair( <-12356.9678, 11545.5654, -6143.65039> , <0, -13.025506, 0> ),//12
		NewLocPair( <-11321.626, 10563.5547, -6143.65039> , <0, 81.9014664, 0> ),
		
		
		]
		
		
		panelLocations = [

		]
	} else if( mapName == "mp_rr_arena_phase_runner" ) 
	{
		waitingRoomPanelLocation = NewLocPair( <30381.043, 18302.0391, -895.965271> , <0, -45.1068459, 0> ) //休息区观战面板

		allSoloLocations= [

		NewLocPair( <31332.9219, 18132.3281, -895.989746> , <0, -89.8043671, 0> ),//1
		NewLocPair( <31326.9941, 16906.6992, -895.96875> , <0, 88.9986115, 0> ),
		
		
		NewLocPair( <29699.1406, 15975.9023, -1176.46021> , <0, -144.70787, 0> ),//2
		NewLocPair( <28888.0137, 15340.0684, -1185.5896> , <0, 35.3883133, 0> ),
		
		
		NewLocPair( <27601.7637, 15353.7227, -1027.36304> , <0, -139.578262, 0> ),//3
		NewLocPair( <26812.2441, 14709.79, -1023.96875> , <0, 36.5818863, 0> ),
		
		
		NewLocPair( <26448.7891, 14013.6768, -1023.41461> , <0, 178.994629, 0> ),//4
		NewLocPair( <25798.9414, 14021.2881, -1023.41461> , <0, 1.59152949, 0> ),
		
		
		NewLocPair( <24593.4941, 14618.6934, -1181.36694> , <0, 49.9644318, 0> ),//5
		NewLocPair( <25242.8535, 15376.0488, -1239.50073> , <0, -130.276611, 0> ),
		
		
		NewLocPair( <22680.7012, 16862.7539, -1089.91553> , <0, 72.8533478, 0> ),//6
		NewLocPair( <23261.6563, 17945.1348, -1090.00647> , <0, -112.675751, 0> ),
		
		
		NewLocPair( <24485.2207, 22081.2246, -927.96875> , <0, -4.63035727, 0> ),//7
		NewLocPair( <27289.457, 21985.8887, -927.96875> , <0, 178.731415, 0> ),
					
		
		NewLocPair( <25919.8516, 22590.4727, -1119.96875> , <0, -92.2881927, 0> ),//8
		NewLocPair( <25880.9844, 21646.2461, -1119.96875> , <0, 84.3532867, 0> ),
		
		
		NewLocPair( <28079.623, 18537.6484, -1206.02881> , <0, -137.359543, 0>),//9
		NewLocPair( <27227.0176, 17741.9941, -1235.49365> , <0, 36.6373024, 0> ),
		
		
		NewLocPair( <26987.0469, 16268.4287, -1313.37378> , <0, 178.09613, 0> ),//10
		NewLocPair( <25173.748, 16264.2344, -1326.32593> , <0, 0.496456444, 0> )
		
		
		]
		
		
		panelLocations = [

		]
	} else
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
				Message(user,"Press jump to stop spectating")
			
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

	if( GetMapName() == "mp_rr_canyonlands_staging" )
	{
		foreach( loc in allSoloLocations )
		 loc.origin += <33184.4023, -11875.7686, -24047.4277>
	}
	
	for (int i = 0; i < allSoloLocations.len(); i=i+2)
	{
		soloLocStruct p

		p.respawnLocations.append(allSoloLocations[i])
		p.respawnLocations.append(allSoloLocations[i+1])

		p.Center = (allSoloLocations[i].origin + allSoloLocations[i+1].origin)/2

		soloLocations.append(p)
	}

	realmSlots.resize( MAX_REALM + 1 )
	realmSlots[ 0 ] = true
	for (int i = 1; i < realmSlots.len(); i++)
	{
		realmSlots[ i ] = false
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
	
	// foreach (index,eahclocation in panelLocations)
	// {
		// //Panels for save opponents
		// entity panel = CreateFRButton(eahclocation.origin, eahclocation.angles, buttonText2)
		// panel.SetSkin(1)//red
		// soloLocations[index].Panel = panel
		// AddCallback_OnUseEntity( panel, void function(entity panel, entity user, int input)
		// {
			// string Text3
			// string Text4
			// if(IS_CHINESE_SERVER)
			// {
				// Text3 = "您已取消绑定"
				// Text4 = "您已绑定您的对手"
			// }
			// else
			// {
				// Text3 = "Your opponent will change now"
				// Text4 = "Your opponent won't change"
			// }
			// soloGroupStruct group = returnSoloGroupOfPlayer(user)
			// // if (!IsValid(group.player1) || !IsValid(group.player2)) return
			// if(!isGroupValid(group)) return //Is this group is available
			// if (soloLocations[group.slotIndex].Panel != panel) return //有傻逼捣乱

			// if( group.IsKeep == false)
			// {
				// group.IsKeep = true
				// panel.SetSkin(0) //green

				// try
				// {
					// Message(group.player1, Text4)
					// Message(group.player2, Text4)
				// }
				// catch (error)
				// {}


			// }
			// else
			// {
				// group.IsKeep = false
				// panel.SetSkin(1) //red

				// try
				// {
					// Message(group.player1, Text3)
					// Message(group.player2, Text3)
				// }
				// catch (error)
				// {}
			// }
		// })//AddCallback_OnUseEntity
	// }//foreach


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
			
			
			//mkos
			if ( Time() - playerInWatingSctruct.queue_time > playerInWatingSctruct.player.p.IBMM_grace_period ){
			
				playerInWatingSctruct.IBMM_Timeout_Reached = true;
			
			} else {
			
				playerInWatingSctruct.IBMM_Timeout_Reached = false;
			
			}

			//标记超时玩家
			if(playerInWatingSctruct.waitingTime < Time() && !playerInWatingSctruct.IsTimeOut && IsValid(playerInWatingSctruct.player )) // && playerInWatingSctruct.IBMM_Timeout_Reached == true ))
			{	
				
				//if ( playerInWatingSctruct.IBMM_Timeout_Reached == true ) {
				//sqprint("mark time out player: " + playerInWatingSctruct.player.GetPlayerName() + " waitingTime: " + playerInWatingSctruct.waitingTime)
					playerInWatingSctruct.IsTimeOut = true
				//}
			}
		}//foreach

		//遍历游玩队列
		foreach (eachGroup in soloPlayersInProgress)
		{
			if( eachGroup.IsFinished )//this round has been finished
			{
				// printt("this round has been finished")
				SetIsUsedBoolForRealmSlot( eachGroup.slotIndex, false )

				soloModePlayerToWaitingList(eachGroup.player1)
				soloModePlayerToWaitingList(eachGroup.player2)
				destroyRingsForGroup(eachGroup)
				continue
			}

			if( eachGroup.IsKeep ) //player in this group dont want to change opponent
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

			if( !IsValid(eachGroup.player1) || !IsValid(eachGroup.player2) )
			{
				//printt("solo player quit!!!!!")
				if(IsValid(eachGroup.player1))
				{
					soloModePlayerToWaitingList(eachGroup.player1) //back to waiting list
					Message(eachGroup.player1, Text5)
				}

				if(IsValid(eachGroup.player2))
				{
					soloModePlayerToWaitingList(eachGroup.player2) //back to waiting list
					Message(eachGroup.player2, Text5)
				}
				
				SetIsUsedBoolForRealmSlot( eachGroup.slotIndex, false )
				continue
			}

			//检测乱跑的脑残
			soloLocStruct groupLocStruct = eachGroup.groupLocStruct
			vector Center = groupLocStruct.Center
			array<entity> players = [ eachGroup.player1, eachGroup.player2 ]
			foreach ( player in players )
			{
				if(!IsValid( player )) continue
				player.p.lastDamageTime = Time() //avoid player regen health

				if(Distance2D( player.GetOrigin(),Center ) > 2000) //检测乱跑的脑残
				{
					Remote_CallFunction_Replay( player, "ServerCallback_PlayerTookDamage", 0, 0, 0, 0, DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, eDamageSourceId.deathField, null )
					player.TakeDamage( 1, null, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )
				}
			}
		}//foreach


		//遍历休息队列
		foreach ( restingPlayer in soloPlayersResting )
		{
			if( !IsValid(restingPlayer)) continue

			TakeAllWeapons( restingPlayer )

			if( !IsAlive(restingPlayer)  )
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
			
			//mkos LG_Duel
			float t_radius = 600;
			if (GetMapName() == "mp_rr_canyonlands_staging" && GetCurrentPlaylistName() == "fs_lgduels_1v1" )
			{ 
				//sqprint("map set radius 2400");
				t_radius = 2400 
			} 
			
			if( Distance2D( player.GetOrigin(), waitingRoomLocation.origin) > t_radius ) //waiting player should be in waiting room,not battle area
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
			
			//mkos
			foreach ( solostruct in soloPlayersWaiting )
			{
				entity player = solostruct.player;	
				bool notify = solostruct.waitingmsg
				
				if ( notify == true ){
				
					int id = player.GetEncodedEHandle()
					Remote_CallFunction_NonReplay( player, "ForceScoreboardLoseFocus" );
					CreatePanelText(player, "", "Waiting for\n   players...",IBMM_WFP_Coordinates(),IBMM_WFP_Angles(), false, 2.5, id)
					//Message( player, "\n\n\n\n Waiting for players...", "", 120 )
					SetMsg( player, false )
					APlayerHasMessage = true;
					
				}
			}

			continue
			
		}  else if (APlayerHasMessage) {
		
			foreach ( player in GetPlayerArray() ){
				
				int id = player.GetEncodedEHandle()
				RemovePanelText( player, id)
			
			}
			
			APlayerHasMessage = false;
		}

		// printt("------------------more than 2 player in solo waiting array,matching------------------")
		soloGroupStruct newGroup
		entity opponent
		//优先处理超时玩家
		//player1:超时的玩家,player2:随机从等待队列里找一个玩家

		if(getTimeOutPlayerAmount() > 0 )//存在已经超时的玩家
		{
			// Warning("Time out matching")
			newGroup.player1 = getTimeOutPlayer()  //获取超时的玩家
			if(IsValid(newGroup.player1))//存在超时等待玩家
			{
				// printt("Time out player found: " + newGroup.player1.GetPlayerName())
				opponent = getRandomOpponentOfPlayer(newGroup.player1)
				if(IsValid(opponent)){
					newGroup.player1.p.notify = false;
					newGroup.player1.p.destroynotify = true;
					newGroup.player2 = opponent
				} else {
					newGroup.player1.p.notify = true;
					newGroup.player1.p.destroynotify = false;
				}
					
				
			}
		}//超时玩家处理结束
		else//不存在已超时玩家,正常按照kd匹配
		{
			// Warning("Normal matching")
			foreach (eachPlayerStruct in soloPlayersWaiting ) //找player1
			{
				entity playerSelf = eachPlayerStruct.player
				bool player_IBMM_timeout = eachPlayerStruct.IBMM_Timeout_Reached
				float selfKd = eachPlayerStruct.kd
				table <entity,float> properOpponentTable
				foreach (eachOpponentPlayerStruct in soloPlayersWaiting ) //找player2
				{
					entity eachOpponent = eachOpponentPlayerStruct.player
					float opponentKd = eachOpponentPlayerStruct.kd
					bool opponent_IBMM_timeout = eachOpponentPlayerStruct.IBMM_Timeout_Reached
					
					//this makes sure we don't compare same player as opponent during MM -- mkos clarification
					if(playerSelf == eachOpponent || !IsValid(eachOpponent))//过滤非法对手
						continue
						
					if(fabs(selfKd - opponentKd) > SBMM_kd_difference ) //过滤kd差值
						continue
						
					properOpponentTable[eachOpponent] <- fabs(selfKd - opponentKd)
					
					//mkos - keep building a list of candidates who are not timed out with same input
					if( playerSelf.p.input != eachOpponent.p.input && player_IBMM_timeout == false && opponent_IBMM_timeout == false )
					{
						//sqprint("Waiting for input match...");
						continue		
					} 
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
				if( (bestOpponent != lastOpponent && Fetch_IBMM_Timeout_For_Player( bestOpponent ) == true && Fetch_IBMM_Timeout_For_Player( playerSelf ) == true ) 
					|| ( bestOpponent != lastOpponent && Fetch_IBMM_Timeout_For_Player( playerSelf ) == false && Fetch_IBMM_Timeout_For_Player( bestOpponent ) == false && playerSelf.p.input == bestOpponent.p.input ) ) //最合适玩家是上局对手,用第二合适玩家代替
				{		
						
						bool inputresult = playerSelf.p.input == bestOpponent.p.input ? true : false;
						
						//sqprint(format("Player found: ibmm timeout: %s, INputs are same?: ", Fetch_IBMM_Timeout_For_Player(bestOpponent), inputresult  ));
					
						// Warning("Best opponent, kd gap: " + lowestKd)
						newGroup.player1 = playerSelf
						newGroup.player2 = bestOpponent			
					
						break
					
				}
				else if ( IsValid(scondBestOpponent) && scondBestOpponent != lastOpponent && Fetch_IBMM_Timeout_For_Player( playerSelf ) == true && Fetch_IBMM_Timeout_For_Player( scondBestOpponent ) == true 
				|| IsValid(scondBestOpponent) && scondBestOpponent != lastOpponent && Fetch_IBMM_Timeout_For_Player( playerSelf ) == false && Fetch_IBMM_Timeout_For_Player( scondBestOpponent ) == false && playerSelf.p.input == scondBestOpponent.p.input )
				{	
						
						//bool inputresult = playerSelf.p.input == scondBestOpponent.p.input ? true : false;
						//sqprint(format("Player found: ibmm timeout: %s, INputs are same?: ", Fetch_IBMM_Timeout_For_Player(scondBestOpponent), inputresult  ));
					
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

		if(! ( IsValid( newGroup.player1 ) && IsValid( newGroup.player2 ) ) ) //确保两个玩家都是合法玩家
		{
			SetIsUsedBoolForRealmSlot( newGroup.slotIndex, false )
			// Warning("player Invalid, back to waiting list")
			soloModePlayerToWaitingList( newGroup.player1 )
			soloModePlayerToWaitingList( newGroup.player2 )
			continue
		}

		//already matched two players
		array<entity> players = [newGroup.player1,newGroup.player2]
	
		//mkos
		if ( Fetch_IBMM_Timeout_For_Player( newGroup.player1 ) == false || Fetch_IBMM_Timeout_For_Player( newGroup.player2 ) == false && newGroup.player1.p.input == newGroup.player2.p.input )
		{
						
			newGroup.GROUP_INPUT_LOCKED = true;
			
		} else {
		
			newGroup.GROUP_INPUT_LOCKED = false;
		
		}
		
		soloModePlayerToInProgressList(newGroup)

		foreach ( index, player in players )
		{
			EnableOffhandWeapons( player )
			DeployAndEnableWeapons( player )

			thread respawnInSoloMode( player, index )
		}
		
		GiveWeaponsToGroup( players )

		FS_SetRealmForPlayer( newGroup.player1, newGroup.slotIndex )
		FS_SetRealmForPlayer( newGroup.player2, newGroup.slotIndex )

		//mkos
		string e_str = "";
		
		if ( newGroup.GROUP_INPUT_LOCKED == true )
		{	
			newGroup.player1.p.inputmode = "LOCK_INPUT";
			newGroup.player2.p.inputmode = "LOCK_INPUT";
			//sqprint(format("Starting watch thread for: %s", newGroup.player1.GetPlayerName() ))
			thread InputWatchdog( newGroup.player1, newGroup.player2, newGroup ); 
			e_str = " INPUT LOCKED " 
		}
		else 
		{ 	
			e_str = "COULDNT LOCK SAME INPUT " 
		}
		
		if ( newGroup.player1.p.IBMM_grace_period == 0 && newGroup.GROUP_INPUT_LOCKED == false )
		{ e_str = "ANY INPUT"; }
		
			Message_New( newGroup.player1 , e_str, "VS: " + newGroup.player2.GetPlayerName() + "   USING -> " + FetchInputName( newGroup.player2 ) , 2.5)
		
		
		if ( newGroup.player2.p.IBMM_grace_period == 0 && newGroup.GROUP_INPUT_LOCKED == false )
		{ e_str = "ANY INPUT"; }
		
			Message_New( newGroup.player2 , e_str, "VS: " + newGroup.player1.GetPlayerName() + "   USING -> " + FetchInputName( newGroup.player1 ) , 2.5)

	}//while(true)

	OnThreadEnd(
		function() : (  )
		{
			// Warning(Time() + "Solo thread is down!!!!!!!!!!!!!!!")
			GameRules_ChangeMap( GetMapName(), GetCurrentPlaylistName() )
		}
	)

}//thread

void function InputWatchdog( entity player, entity opponent, soloGroupStruct group )
{
	while ( !group.IsFinished )
	{
		if( GetGameState() != eGameState.Playing ) 
			break

		if ( !isGroupValid( group ) ) break
		//if ( !IsAlive(player) || !IsAlive( opponent ) ) break
		if ( isPlayerInRestingList( player ) || isPlayerInRestingList( opponent ) ) break
		//sqprint("Waiting for input to change");
	
		if ( player.p.input != opponent.p.input ){
							
			Remote_CallFunction_NonReplay( player, "ForceScoreboardLoseFocus" );			
			Message( player, "INPUT CHANGED", "A player's input changed during the fight", 10, "weapon_vortex_gun_explosivewarningbeep" )
			
			Remote_CallFunction_NonReplay( opponent, "ForceScoreboardLoseFocus" );
			Message( opponent, "INPUT CHANGED", "A player's input changed during the fight", 10, "weapon_vortex_gun_explosivewarningbeep" )
			
			group.IsFinished = true
			
			break;
		
		}
		
		wait 0.1
	}
	
	if ( IsValid ( player ) ) player.p.inputmode = "OPEN";
	if ( IsValid ( opponent ) ) opponent.p.inputmode = "OPEN";
	//sqprint( format("THREAD FOR GROUP ENDED" ))
	
}

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
			
			if (!GetCurrentPlaylistVarBool("lg_duel_mode_60p", false))
			{
				player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
				player.GiveOffhandWeapon( "melee_pilot_emptyhanded", OFFHAND_MELEE, [] )
			}	
				
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

	if( GetCurrentPlaylistName() != "fs_lgduels_1v1" )
		SetupInfiniteAmmoForWeapon( player, weaponNew )
	else
	{
		int ammoType = weaponNew.GetWeaponAmmoPoolType()
		player.AmmoPool_SetCapacity( 65535 )
		player.AmmoPool_SetCount( ammoType, 9999 )
	}
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
	
	if( GetCurrentPlaylistName() == "fs_lgduels_1v1" )
		return "mp_weapon_lightninggun"

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

	if( GetCurrentPlaylistName() == "fs_lgduels_1v1" )
		return "mp_weapon_lightninggun"
	
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
		FS_ClearRealmsAndAddPlayerToAllRealms( player )
	}
	
	soloPlayersInProgress.clear()
}

//mkos

vector function Return_Loc_Data( string _type )
{
	
	string map = GetMapName(); //better set as global string
	vector coordinates = < 0,0,0 >
	vector angles = < 0,0,0 >
	
	if ( _type == "matching_inputs_coordinates" ) 
	{
	
		switch(map)
		{
			
			case "mp_rr_arena_composite":
			
				coordinates = < 6.94531, 687.949, 286.174 >
				return coordinates
				break
			
			
			case "mp_rr_aqueduct":
				
				coordinates = < 717.151, -5387.85, 580.00 >
				return coordinates
				break
			
			case "mp_rr_canyonlands_staging":
				
				coordinates = < 3480.93, -8729.28, -10144.3 >
				return coordinates
				break
			
			case "mp_rr_canyonlands_64k_x_64k":
				coordinates = < -532.278, 20713.6, 4746.85 >
				return coordinates
				break
				
			default: 
			
				coordinates = <0,0,0>;
				return coordinates
				break
		} 
		
		
	} 	
	
	else if ( _type == "matching_inputs_angles" ) 
	{

		switch(map)
		{
			
			case "mp_rr_arena_composite":
			
				angles = < 5.64701, 87.8268, 0 >
				return angles
				break
			
			
			case "mp_rr_aqueduct":
			
				angles = < 355.891, 88.4579, 0 >
				return angles
				break
			
			case "mp_rr_canyonlands_staging":
			
				angles = < 358.91, 268.637, 0 >
				return angles
				break
				
			case "mp_rr_canyonlands_64k_x_64k":
				angles = < 356.297, 45.561, 0 >
				return angles
				break
				
			default: 
			
				angles = < 0,0,0 >;
				return angles
				break
		} 
	
	}
	
	else if ( _type == "waiting_for_players_coordinates" )
	{
	
		switch(map)
		{
			
			case "mp_rr_arena_composite":
			
				coordinates = < 6.94531, 687.949, 300.174 >
				return coordinates
				break
			
			
			case "mp_rr_aqueduct":
				
				coordinates = < 717.151, -5387.85, 600.00 >
				return coordinates
				break
			
			case "mp_rr_canyonlands_staging":
				
				coordinates = < 3480.93, -8729.28, -10144.3 >
				return coordinates
				break
			
			
			case "mp_rr_canyonlands_64k_x_64k":
				coordinates = < -532.278, 20713.6, 4850.00 >
				return coordinates
				break
				
			default: 
			
				coordinates = <0,0,0>;
				return coordinates
				break
		} 
		
		
	} 	
	
	else if ( _type == "waiting_for_players_angles" ) 
	{

		switch(map)
		{
			
			case "mp_rr_arena_composite":
			
				angles = < 5.64701, 87.8268, 0 >;
				return angles
				break
			
			
			case "mp_rr_aqueduct":
			
				angles = < 355.891, 88.4579, 0 >
				return angles
				break
			
			case "mp_rr_canyonlands_staging":
			
				angles = < 358.91, 268.637, 0 >
				return angles
				break
			
			case "mp_rr_canyonlands_64k_x_64k":
				angles = < 356.297, 45.561, 0 >
				return angles
				break
				
			default: 
			
				angles = < 0,0,0 >;
				return angles
				break
		} 
	
	}
		
	//unreachable
	return < 0,0,0 >;
}


/*TODO: Create a singular modular funciton 
to calculate display locations based on 
waiting location spawns - mkos */

vector function IBMM_Coordinates()
{
	return Return_Loc_Data("matching_inputs_coordinates")
}

vector function IBMM_Angles()
{	
	return Return_Loc_Data("matching_inputs_angles")
}

vector function IBMM_WFP_Coordinates()
{
	return Return_Loc_Data("waiting_for_players_coordinates")
}

vector function IBMM_WFP_Angles()
{
	return Return_Loc_Data("waiting_for_players_angles")
}


void function notify_thread( entity player )
{
	int id = player.GetEncodedEHandle() + 1
	
	while(true){
			
		//sqprint("notify thread running")
		if (!IsValid( player )) break
		
	
		if ( player.p.notify == true && player.p.has_notify == false ){
		
			Remote_CallFunction_NonReplay( player, "ForceScoreboardLoseFocus" );
			CreatePanelText(player, "", "Matching for: " + FetchInputName( player ) , IBMM_Coordinates(), IBMM_Angles(), false, 2, id)
			//sqprint("Creating on screen match making for " + player.GetPlayerName() )
			player.p.has_notify = true; //let thread self know not to create multiple displays
			
		}
	
		if ( player.p.notify == false && player.p.destroynotify == true ){
			
			RemovePanelText( player, id )
			player.p.destroynotify = false;
			player.p.has_notify = false;
			
		}
		
		wait 1
	}
}