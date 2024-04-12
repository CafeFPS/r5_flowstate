//Flowstate 1v1 gamemode
//made by __makimakima__
//redesigned by mkos [refactored/coderewrite/ibmm/sbmm]

//globalize_all_functions // why?

global const INVALID_ACCESS_DEBUG = false

global function isPlayerInRestingList
global function mkos_Force_Rest
global function INIT_playerChallengesStruct
global function GetScore
global function getSbmmSetting
global function setSbmmSetting
global function getGroupsInProgress
global function getPlayerToGroupMap
global function ClientCommand_Maki_SoloModeRest
global function ClientCommand_mkos_challenge
global function endSpectate
global function notify_thread
global function _soloModeInit
global function resetChallenges
global function soloModefixDelayStart
global function setChineseServer
global function isPlayerInWaitingList
global function getWaitingRoomLocation
global function maki_tp_player
global function returnSoloGroupOfPlayer
global function soloModePlayerToWaitingList
global function ForceAllRoundsToFinish_solomode
global function addStatsToGroup
global function getBotSpawn
global function RechargePlayerAbilities
global function GiveWeaponsToGroup //i hate this

global struct soloLocStruct
{
	LocPair &Loc1 //player1 respawn location
	LocPair &Loc2 //player2 respawn location
	array<LocPair> respawnLocations
	vector Center //center of Loc1 and Loc2
	entity Panel //keep current opponent panel
}

global struct groupStats 
{
	entity player
	string displayname
	float damage = 0
	int hits = 0
	int shots = 0
	int kills = 0
	int deaths = 0
}	

global struct soloGroupStruct
{
	int groupHandle
	entity player1
	entity player2
	
	int p1LegendIndex = -1
	int p2LegendIndex = -1
	
	entity ring//ring boundaries
	soloLocStruct &groupLocStruct

	int slotIndex
	bool GROUP_INPUT_LOCKED = false //lock group to their input - mkos
	bool IsFinished = false //player1 or player2 is died, set this to true and soloModeThread() will handle this
	bool IsKeep = false //player may want to play with current opponent,so we will keep this group
	bool cycle = false // locked 1v1s can choose to cycle spawns
	bool swap = false // locked 1v1s can have random side they spawn on
	
	float startTime
	table <entity,groupStats> statsRecap
}

global struct soloPlayerStruct
{
	entity player
	int handle
	float queue_time = 0.0 //marks the time when they queued, to allow checking for same input
	bool IBMM_Timeout_Reached = false //input based match making timeout 
	bool waitingmsg = true
	float waitingTime //players may want to play with random opponent(or a matched opponent), so adding a waiting time after they died can allow server to match proper opponent
	float kd //stored this player's kd to help server match proper opponent
	entity lastOpponent //opponent of last round
	bool IsTimeOut = false
}

struct ChallengesStruct
{
	entity player 
	table<int,float> challengers = {} // challenging entity handle, float Time()
}

array< bool > realmSlots

LocPair WaitingRoom

//this is fine
array <soloLocStruct> soloLocations //all respawn location stored here

//TODO:: move to r5rdev_config.json-- mkos
array <string> custom_weapons_primary = [] 
array <string> custom_weapons_secondary = [] 

struct {

	float lifetime_kd_weight
	float current_kd_weight
	float SBMM_kd_difference
	
	//playerHandle -> soloPlayerStruct
	table <int, soloPlayerStruct> soloPlayersWaiting = {} //moved to table for O(1) add/delete/lookup without shifting arrays, looping/scanning

	//playerHandle -> soloGroupStruct
	table<int, soloGroupStruct> playerToGroupMap = {} //map for quick assessment

	//groupHandle -> soloGroupStruct
	table<int, soloGroupStruct> groupsInProgress = {} //group map to group

	//playerHandle -> struct resting
	table <int,bool> soloPlayersResting = {}
	
	bool IS_CHINESE_SERVER = false
	bool APlayerHasMessage = false
	
	array<ChallengesStruct> allChallenges
	table<int,entity> acceptedChallenges //(player handle challenger -> player challenged )

} file


struct {

	int ibmm_wait_limit
	float default_ibmm_wait
	bool enableChallenges = false

} settings

//script vars 
bool mGroupMutexLock
int groupID = 112250000;
bool bMap_mp_rr_party_crasher
bool bMap_mp_rr_canyonlands_staging
bool bMap_mp_rr_canyonlands_64k_x_64k
bool bMap_mp_rr_aqueduct
bool bMap_mp_rr_arena_composite
bool bGiveSameRandomLegendToBothPlayers
bool bAllowLegend
bool bAllowTactical
bool bChalServerMsg

array<string> Weapons = []
array<string> WeaponsSecondary = []
vector IBMM_COORDINATES
vector IBMM_ANGLES
bool bIsKarma
float REST_GRACE = 5.0

const int MAX_CHALLENGERS = 12

array<ItemFlavor> characters
const array<string> charIndexMap = [
		"Bangalore", //0
		"Bloodhound", //1
		"Caustic", //2
		"Gibby", //3
		"Lifeline", //4
		"Mirage", //5
		"Octane", //6
		"Pathfinder", //7
		"Wraith", //8
		"Wattson", //9
		"Crypto", //10
		"Blisk", //11
		"Fade", //12
		"Amogus", //13
	];

void function resetChallenges()
{
	foreach ( chalStruct in file.allChallenges )
	{
		if( isChalValid( chalStruct ) )
		{	
			#if INVALID_ACCESS_DEBUG
			printl("Potential crash avoided 01")
			#endif
			chalStruct.challengers.clear()
		}
	}
	
	file.acceptedChallenges.clear()
}

table<int, soloGroupStruct> function getGroupsInProgress()
{
	return file.groupsInProgress
}

table<int, soloGroupStruct> function getPlayerToGroupMap()
{
	return file.playerToGroupMap
}

void function setChineseServer( bool value )
{
	file.IS_CHINESE_SERVER = value
}

//usage intended for display only queries from scripts, not game logic
float function getSbmmSetting( string setting )
{
	switch(setting)
	{
		case "lifetime_kd_weight":
			return file.lifetime_kd_weight
		case "current_kd_weight":
			return file.current_kd_weight
		case "SBMM_kd_difference":
			return file.SBMM_kd_difference
			
		default:
			return 0.0
	}
	
	unreachable
}

bool function setSbmmSetting( string setting, float value )
{
	switch(setting)
	{
		case "lifetime_kd_weight":
			file.lifetime_kd_weight = value
			return true
			
		case "current_kd_weight":
			file.current_kd_weight = value
			return true
			
		case "SBMM_kd_difference":
			file.SBMM_kd_difference = value
			return true
			
		default:
			return false
	}
	
	unreachable
}

bool function isPlayerInProgress( entity player )
{
	if ( !IsValid( player ) )
	{
		return false
	}
	
	if ( player.p.handle in file.playerToGroupMap )
	{
		if( IsValid(file.playerToGroupMap[player.p.handle]))
		{
			return true
		}
	}
	
	return false 
}


void function INIT_Flags()
{
	bGiveSameRandomLegendToBothPlayers	= GetCurrentPlaylistVarBool("give_random_legend_on_spawn", false )
	bIsKarma 							= GetCurrentPlaylistVarBool( "karma_server", false )
	bAllowLegend 						= GetCurrentPlaylistVarBool( "give_legend", true )
	bAllowTactical 						= GetCurrentPlaylistVarBool( "give_legend_tactical", true ) //challenge only
	bChalServerMsg 						= bBotEnabled() ? GetCurrentPlaylistVarBool( "challenge_recap_server_message", true ) : false;
	settings.ibmm_wait_limit 			= GetCurrentPlaylistVarInt( "ibmm_wait_limit", 999 )
	settings.default_ibmm_wait 			= GetCurrentPlaylistVarFloat( "default_ibmm_wait", 3 )
	settings.enableChallenges			= GetCurrentPlaylistVarBool( "enable_challenges", true )
}


int function GetUniqueID() 
{
    return groupID++;
}

bool function Fetch_IBMM_Timeout_For_Player( entity player ) 
{
    if ( !IsValid(player) ) return false

    if (  player.p.handle in file.soloPlayersWaiting ) 
	{
        return file.soloPlayersWaiting[player.p.handle].IBMM_Timeout_Reached;
    }
    return false;
}


void function ResetIBMM( entity player ) 
{
    if ( !IsValid(player) ) return

    if ( player.p.handle in file.soloPlayersWaiting ) 
	{
        file.soloPlayersWaiting[player.p.handle].IBMM_Timeout_Reached = false;
    }
}

void function SetMsg( entity player, bool value ) 
{
    if ( !IsValid(player) ) return

    if ( player.p.handle in file.soloPlayersWaiting ) 
	{
        file.soloPlayersWaiting[player.p.handle].waitingmsg = value;
    }
}

//used for display 
string function FetchInputName( entity player )
{
	return player.p.input == 0 ? "MnK" : "Controller";
}

//used for information display
string function GetScore( entity player )
{	
	if ( !IsValid( player ) ) 
	{
		return "INVALID_PLAYER";
	}
	
	float lt_kd = getkd( (player.GetPlayerNetInt( "kills" ) + player.p.lifetime_kills) , (player.GetPlayerNetInt( "deaths" ) + player.p.lifetime_deaths) )
	float cur_kd = getkd( player.GetPlayerNetInt( "kills" ) , player.GetPlayerNetInt( "deaths" )  )
	float score = (  ( lt_kd * file.lifetime_kd_weight ) + ( cur_kd * file.current_kd_weight ) )
	string name = player.p.name	
	
	return format("Player: %s, Lifetime KD: %.2f, Current KD: %.2f, Round Score: %.2f ", name, lt_kd, cur_kd, score )
}

void function INIT_1v1_sbmm()
{

	//convert strings from playlist into array and add to array memory structure -- mkos
	if ( Playlist_1v1_Primary_Array() != "" )
	{	
		
		string concatenate = Concatenate( Playlist_1v1_Primary_Array(), Playlist_1v1_Primary_Array_continue() )
	
		try 
		{	
			#if DEVELOPER 
			sqprint("Checking: custom_weapons_primary")
			#endif
			
			custom_weapons_primary = StringToArray( concatenate )
			
			for( int i = custom_weapons_primary.len() - 1 ; i >= 0 ; --i ) 
			{
				string before = trim( custom_weapons_primary[i] )
				
				custom_weapons_primary[i] = ParseWeapon( trim( custom_weapons_primary[i] ) )
				
				if ( trim(custom_weapons_primary[i]) != before )
				{				
					sqerror(format("Weapon %d was invalid and corrected. \n Old:\n \"%s\" \n New: \n \"%s\" \n\n", i, before, trim( custom_weapons_primary[i] ) ))
				}
				
				if ( custom_weapons_primary[i] == "" )
				{
					custom_weapons_primary.remove(i)
				}
			}
		} 
		catch ( error ) 
		{
			sqerror( "" + error )
		}
	
	}
		
	if ( Playlist_1v1_Secondary_Array() != "" )
	{
		string concatenate = Concatenate( Playlist_1v1_Secondary_Array(), Playlist_1v1_Secondary_Array_continue() )
	
		try 
		{	
			#if DEVELOPER 
			sqprint("Checking: custom_weapons_secondary")
			#endif
			custom_weapons_secondary = StringToArray( concatenate )
			
			for( int i = custom_weapons_secondary.len() - 1 ; i >= 0 ; --i ) 
			{
				string sbefore = trim( custom_weapons_secondary[i] )
				
				custom_weapons_secondary[i] = ParseWeapon( trim( custom_weapons_secondary[i] ) )
				
				if ( trim(custom_weapons_secondary[i]) != sbefore )
				{				
					sqerror(format("Weapon %d was invalid and corrected. \n Old:\n \"%s\" \n New: \n \"%s\"\n\n", i, sbefore, trim( custom_weapons_secondary[i] ) ))
				}
				
				if ( custom_weapons_secondary[i] == "" )
				{
					custom_weapons_secondary.remove(i)
				}
			}
		} 
		catch ( error ) 
		{
			sqerror( "" + error )
		}
	
	}
	
	//initialize defaults for SBMM
	if ( bGlobalStats() )
	{
		file.lifetime_kd_weight = GetCurrentPlaylistVarFloat( "lifetime_kd_weight", 0.90 )
		file.current_kd_weight = GetCurrentPlaylistVarFloat( "current_kd_weight", 1.3 )
		file.SBMM_kd_difference = GetCurrentPlaylistVarFloat( "kd_difference", 1.5 )
	} 
	else
	{
		//base values
		file.lifetime_kd_weight = 1
		file.current_kd_weight = 1
		file.SBMM_kd_difference = 3
	
	}

}

bool function IsLockable( entity player1, entity player2 )
{
	if (player1.p.lock1v1_setting == false || player2.p.lock1v1_setting == false)
	{
		return false
	}
	
	return true
}

string function LockSetting( entity player )
{
	return player.p.lock1v1_setting == true ? "Enabled" : "Disabled";
}

bool function Lock1v1Enabled()
{
	return GetCurrentPlaylistVarBool("enable_lock1v1", true)
}

//end mkos

int function getTimeOutPlayerAmount() 
{
    int timeOutPlayerAmount = 0;
	
    foreach ( playerHandle, eachPlayerStruct in file.soloPlayersWaiting ) 
	{
        if ( IsValid(eachPlayerStruct) && eachPlayerStruct.IsTimeOut && !eachPlayerStruct.player.p.waitingFor1v1 ) 
		{
            timeOutPlayerAmount++;
        }
    }
    return timeOutPlayerAmount;
}

entity function getTimeOutPlayer() 
{
    foreach ( playerHandle, eachPlayerStruct in file.soloPlayersWaiting ) 
	{
        if ( eachPlayerStruct.IsTimeOut ) 
		{
			if(!IsValid(eachPlayerStruct) || !IsValid(eachPlayerStruct.player) || eachPlayerStruct.player.p.waitingFor1v1  )
			{
				continue
			}
			
			//string set = eachPlayerStruct.player.p.waitingFor1v1 ? "true" : "false";
			//sqprint(format("TIMEOUTPLAYER IS player: %s setting for waiting is: %s", eachPlayerStruct.player.p.name, set))
            return eachPlayerStruct.player;
        }
    }
	
    entity p;
	return p
}

LocPair function getWaitingRoomLocation()
{
	return WaitingRoom
}

void function SetIsUsedBoolForRealmSlot( int realmID, bool usedState )
{
	try
	{
		if ( !realmID ) { return } //temporary crash fix
		realmSlots[ realmID ] = usedState
	}
	catch(e)
	{	
		#if DEVELOPER
		sqprint("SetIsUsedBoolForRealmSlot crash " + e )
		#endif
	}
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

//p
soloGroupStruct function returnSoloGroupOfPlayer( entity player ) 
{
	soloGroupStruct group;	
	if(!IsValid (player) )
	{	
		#if DEVELOPER
		sqprint("returnSoloGroupOfPlayer entity was invalid")
		#endif
		
		return group; 
	}
	
	try
	{
		if ( player.p.handle in file.playerToGroupMap ) 
		{	
			if(IsValid(file.playerToGroupMap[player.p.handle]))
			{
				return file.playerToGroupMap[player.p.handle]
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

//p
void function addGroup(soloGroupStruct newGroup) 
{
	if(!IsValid(newGroup))
	{
		sqerror("[addGroup]: Logic Flow Error: group is invalid during creation")
		return
	}
	mGroupMutexLock = true
	
	try 
	{
		int groupHandle = GetUniqueID();
		
		newGroup.groupHandle = groupHandle
		newGroup.startTime = Time()
		
		#if DEVELOPER
		sqprint(format("adding group: %d", groupHandle ))
		#endif
		if( !( groupHandle in file.groupsInProgress ) )
		{
			bool success = true
			
			if( IsValid(newGroup.player1 && IsValid(newGroup.player2) ))
			{
				file.playerToGroupMap[newGroup.player1.p.handle] <- newGroup;
				#if DEVELOPER
				sqprint(format("player 1 added to group: %s", newGroup.player1.p.name ))
				#endif
				file.playerToGroupMap[newGroup.player2.p.handle] <- newGroup;
				#if DEVELOPER
				sqprint(format("player 2 added to group: %s", newGroup.player2.p.name ))
				#endif
			}
			else 
			{	
				#if DEVELOPER
				sqerror("FAILURE adding players to group")
				#endif
				success = false
			}
			
			if(success)
			{
				file.groupsInProgress[groupHandle] <- newGroup
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
	
	mGroupMutexLock = false
}


void function removeGroupByHandle( int handle )
{
	if ( handle in file.groupsInProgress )
	{	
		#if DEVELOPER
		sqprint(format("Removing group by handle: %d", handle))
		#endif
		delete file.groupsInProgress[handle]
	}
	else
	{
		if(!handle)
		{
			sqerror("[removeGroupByHandle] ERROR: handle was null")
		}
		else 
		{
			sqerror(format("[removeGroupByHandle] Handle: \"%d\" does not exist in table: \"file.groupsInProgress\"", handle ))
		}
	}
}

void function removeGroup(soloGroupStruct groupToRemove) 
{
	mGroupMutexLock = true  
	if(!IsValid(groupToRemove))
	{
		sqerror("Logic flow error:  groupToRemove is invalid")
		return
	}
	
	try
	{	
		if ( IsValid(groupToRemove.player1) && groupToRemove.player1.p.handle in file.playerToGroupMap )
		{	
			#if DEVELOPER
			sqprint(format("deleting player 1 handle: %d from group map",groupToRemove.player1.p.handle))
			#endif
			delete file.playerToGroupMap[groupToRemove.player1.p.handle]
		}
			
		if ( IsValid(groupToRemove.player2) && groupToRemove.player2.p.handle in file.playerToGroupMap )
		{	
			#if DEVELOPER
			sqprint(format("deleting player 2 handle: %d from group map",groupToRemove.player2.p.handle))
			#endif
			delete file.playerToGroupMap[groupToRemove.player2.p.handle];
		}
		
		if( groupToRemove.groupHandle in file.groupsInProgress )
		{
			#if DEVELOPER
			sqprint(format("removing group: %d", groupToRemove.groupHandle) )
			#endif
			delete file.groupsInProgress[groupToRemove.groupHandle]
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
	
	mGroupMutexLock = false
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
	if(!IsValid (player) )
	{	
		#if DEVELOPER
		sqprint("isPlayerInSoloMode entity was invalid")
		#endif
		return false 
	}
	
    return ( player.p.handle in file.playerToGroupMap );
}

bool function isPlayerInWaitingList(entity player)
{
	//mkos
	if(!IsValid (player) )
	{	
		#if DEVELOPER
		sqprint("isPlayerInWaitingList entity was invalid")
		#endif
		return false 
	}
		
	return ( player.p.handle in file.soloPlayersWaiting )
}


// lg_duel mkos
bool function return_rest_state( entity player )
{
	if(!IsValid (player) )
	{	
		#if DEVELOPER
		sqprint("return_rest_state entity was invalid")
		#endif
		return false 
	}
	
	if ( !g_bIs1v1 ) return false
	
	if (isPlayerInRestingList( player ))
	{
		return true;
	}
	return false;
}

bool function isPlayerInRestingList( entity player )
{	
	if(!IsValid (player) )
	{	
		#if DEVELOPER
		sqprint("isPlayerInRestingList entity was invalid")
		#endif
		return false 
	}
	
	return ( player.p.handle in file.soloPlayersResting )
}

void function deleteSoloPlayerResting( entity player )
{
	try 
	{
		if ( player.p.handle in file.soloPlayersResting )
		{
			delete file.soloPlayersResting[player.p.handle]
		}
	}
	catch(e)
	{	
		#if DEVELOPER
		sqprint( "crash in deleteSoloPlayerResting: " + e )
		#endif
	}
}

void function addSoloPlayerResting( entity player )
{
	if( !IsValid (player) )
	{	
		#if DEVELOPER
		sqprint("addSoloPlayerResting enttiy was invalid")
		#endif
		return
	}
	
	try 
	{
		file.soloPlayersResting[player.p.handle] <- true
	}
	catch(e)
	{
		#if DEVELOPER
		sqprint("crass in addSoloPlayerResting: " + e )
		#endif
	}
}

void function deleteWaitingPlayer( int handle )
{	
	if ( handle in file.soloPlayersWaiting )
	{
		delete file.soloPlayersWaiting[handle]
	}
}

void function AddPlayerToWaitingList(soloPlayerStruct playerStruct) 
{
	try 
	{
		if( !IsValid(playerStruct) )
		{
			sqerror( "[AddPlayerToWaitingList] playerStruct was invalid" )
		}
		else 
		{
			if( IsValid(playerStruct.player) )
			{
				file.soloPlayersWaiting[playerStruct.player.p.handle] <- playerStruct
			}
			else 
			{
				sqerror( "[AddPlayerToWaitingList] player to add was invalid" )
			}
		}
	}
	catch(e)
	{
		#if DEVELOPER
		sqprint("crash in AddPlayerToWaitingList: " + e )
		#endif
	}
}

bool function mkos_Force_Rest(entity player, array<string> args)
{
	if( !g_bIs1v1 && !g_bLGmode )
		return false
	
	if( !IsValid(player) ) //|| !IsAlive(player) )
		return false

	if( player.p.handle in file.soloPlayersResting )
	{	
		HolsterAndDisableWeapons(player)
		return false
	} 
	
	if(isPlayerInWaitingList(player))
	{	
		deleteWaitingPlayer(player.p.handle)
	}
	
		thread soloModePlayerToRestingList(player)
		
		try
		{
			player.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_suicide } )
		}
		catch (error)
		{

		}
	
	HolsterAndDisableWeapons(player)
	//TakeAllWeapons( player )	
	player.p.lastRestUsedTime = Time()

	return true
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////// mkos challenge system  ///////////////////////////////////////
//client command: challenge

bool function ClientCommand_mkos_challenge(entity player, array<string> args)
{
	if (!CheckRate( player )) return false
	player.p.messagetime = Time()
	
	if( GetTDMState() != eTDMState.IN_PROGRESS )
	{
		Message( player, "Game is not playing" )
		return true
	}
	
	if( !settings.enableChallenges )
	{
		Message( player, "Host has disabled challenges" )
		return true
	}
	
	if ( args.len() < 1)
	{	
		Message( player, "\n\n\nUsage: ", "challenge chal [playername/id] - Challenges a player to 1v1 \n challenge accept [playername/id] - Accepts challenge by playername or id. If no player is specified accepts most recent challenge \n challenge list - Shows a list of all challenges and their times \n ", 5 )
		return true;	
	}
	
	string requestedData = args[0];
	string param = "";
	
	if ( args.len() >= 2 )
	{
		param = args[1]
	}

	switch(requestedData)
	{
		
		case "challenge":
		case "chal":
		
			if( args.len() < 2 )
			{
				Message( player, "CHALLENGES", "\n\n\n/chal [playername/id] -challenges a player to 1v1\n/chal player -challenges current fight player\n/accept [playername/id] -accepts a specific challenge or the most recent if none specified\n/list -incoming challenges\n/outlist -outgoing challenges\n/end -ends and removes current challenge\n/remove [playername/id] -removes challenge from list\n/clear -clears all incoming challenges\n/revoke [playername/id/all] -Revokes a challenge sent to a player or all players\n/cycle -random spawn\n/swap -random side of spawn\n/legend -choose legend by number or name", 30 )			
			}
			else 
			{	
				entity challengedPlayer;
				
				if ( param == "player" )
				{				
					soloGroupStruct group = returnSoloGroupOfPlayer( player )
					
					if( !IsValid( group.player1 ) )
					{
						Message( player, "NOT IN A FIGHT")
						return true
					}
					
					challengedPlayer = player == group.player1 ? group.player2 : group.player1;
					
				}
				else 
				{
					challengedPlayer = GetPlayer(param)
				}
				
				if( player == challengedPlayer )
				{
					Message( player, "CANT CHALLENGE SELF")
					return true
				}

				if (IsValid(challengedPlayer))
				{
					int result = addToChallenges( player, challengedPlayer )
					string error = ""
					
					switch(result)
					{
						case 1: 
							challengedPlayer.p.messagetime = Time()
							Message( player, "CHALLENGE SENT", "", 5)
							string details = format("Player: %s wants to 1v1. \n Type /accept to accept the most recent challenge \n or /accept [playername] to accept a specific 1v1 ", player.p.name  )
							Message( challengedPlayer, "NEW REQUEST", details , 10 )
							break; 
						
						case 2:
							error = "Player has recieved too many challenges";
							break;
						
						case 3:
							error = "Too many requests sent, please wait a moment and try again";
							break;
						
						case 4:
							error = "Player has disabled 1v1 requests";
							break
							
						case 5:
							error = "Player not initialized";
							break
					}
					
					if(result > 1)
					{
						Message( player, "FAILED", "Couldn't add challenge: " + error, 5)
					}
					
				}
				else 
				{
					Message( player, "INVALID PLAYER...", "", 1)
				}
			}
			return true //end chal
		
		case "accept":
			
			if( args.len() <= 1 )
			{
				acceptRecentChallenge( player )		
			}
			else 
			{
				entity challenger = GetPlayer( param )
				
				if(!IsValid( challenger ))
				{
					Message( player, "INVALID PLAYER")
					return true
				}
				
				if (acceptChallenge( player, challenger ))
				{
					//sqprint("success")
				}
				else 
				{
					//sqprint("failure")
				}
			}
			return true;
			
		case "list":
		
			string list = listPlayerChallenges( player )
			string title = "CURRENT CHALLENGERS";
			
			if( ( list.len() + title.len() ) > 599 )
			{
				Message( player, "Failed", "Cannot execute this command due to return result of overflow")
			}
			else 
			{
				Message( player, title, list, 20 )
			}
				
			return true

		case "end":
			
			endLock1v1( player )
		
		case "remove":
		
			entity challenger = GetPlayer( param )
			
			if( IsValid( challenger ) )
			{
				if (removeChallenger( player, challenger.p.handle ))
				{
					Message( player, "REMOVED " + challenger.p.name )
				}
				else 
				{
					Message( player, "PLAYER NOT IN CHALLENGES" )
				}
				
				endLock1v1( player, false )
			}
			return true 
			
		case "clear":
			
			player.p.waitingFor1v1 = false
			ChallengesStruct chalStruct = getChallengeListForPlayer( player )
			
			if( isChalValid( chalStruct ) )
			{
				chalStruct.challengers.clear()
			}
			else 
			{
				#if INVALID_ACCESS_DEBUG
				PrintDebug( player, 2 )
				#endif
			}
			
			endLock1v1( player, false )
			Message( player, "CHALLENGERS CLEARED")
			
			return true
			
		case "revoke":
		
			if( param == "all" )
			{
				int revoked = 0
				string removed = "";
				
				foreach ( revokedFromPlayer in GetPlayerArray() )
				{
					if( IsValid( revokedFromPlayer ) )
					{
						if( removeChallenger( revokedFromPlayer, player.p.handle ) )
						{
							revoked++;
							removed += revokedFromPlayer.p.name + "\n";
						}
					}
				}
				
				if ( revoked > 0 )
				{
					endLock1v1( player, false )
					Message( player, format( "REVOKED %d CHALLENGES", revoked ), format( "\n----FROM PLAYERS---- \n\n %s", removed ), 10 )
				}
				else 
				{
					Message( player, "NO CHALLENGES TO REMOVE" )
				}
				
				return true
			}
			
			entity playerToRevoke = GetPlayer( param )
			
			if(IsValid( playerToRevoke ))
			{
				if( removeChallenger( playerToRevoke, player.p.handle ) )
				{
					endLock1v1( player, false, true )
					Message( player, "Challenge revoked")
				}
				else 
				{
					endLock1v1( player, false, false )
					Message( player, "PLAYER NOT IN CHALLENGES" )
				}
			}
			else
			{
				Message( player, "Player QUIT")
			}
			
			return true
			
		case "cycle":
		
			if( isPlayerPendingChallenge( player ) || isPlayerPendingLockOpponent( player ) )
			{}
			else 
			{
				Message( player, "NOT IN CHALLENGE" )
				return true
			}
			
			soloGroupStruct group = returnSoloGroupOfPlayer( player )
			
			if(IsValid( group ))
			{
				if(group.cycle)
				{
					group.cycle = false;
					Message( group.player1, "SPAWN CYCLE DISABLED" )
					Message( group.player2, "SPAWN CYCLE DISABLED" )
				}
				else 
				{
					group.cycle = true;
					Message( group.player1, "SPAWN CYCLE ENABLED" )
					Message( group.player2, "SPAWN CYCLE ENABLED" )
				}
			}
			
			return true
			
			
		case "swap":
			
			if( isPlayerPendingChallenge( player ) || isPlayerPendingLockOpponent( player ) )
			{}
			else 
			{
				Message( player, "NOT IN CHALLENGE" )
				return true
			}
			
			soloGroupStruct group = returnSoloGroupOfPlayer( player )
			
			if(IsValid( group ))
			{
				if(group.swap)
				{
					group.swap = false;
					Message( group.player1, "SPAWN SWAP DISABLED" )
					Message( group.player2, "SPAWN SWAP DISABLED" )
				}
				else 
				{
					group.swap = true;
					Message( group.player1, "SPAWN SWAP ENABLED" )
					Message( group.player2, "SPAWN SWAP ENABLED" )
				}
			}
			
			return true
			
		case "legend":
		
			if(!bAllowLegend)
			{
				Message( player, "Admin has disabled legends" )
				return true
			}
			
			if( param == "" )
			{
				string legendList = "";
				
				int ii = 0
				foreach( legend in charIndexMap )
				{
					legendList += format("%d = %s \n", ii, legend)
					ii++;
				}
				
				Message( player, "LEGENDS", legendList, 10 )
				return true
			}
		
			string legend = "undefined";
			int index;
			int indexMapLen = charIndexMap.len();
			
			if( IsNumeric( param, indexMapLen ) )
			{
				index = param.tointeger()
			}
			else 
			{
				index = -1
				for( int i = 0; i < indexMapLen; i++ )
				{
					if ( charIndexMap[i].tolower() == param.tolower() )
					{
						legend = charIndexMap[i] 
						index = i;
					}
				}	
			}
			
			if( index >= indexMapLen || index < 0 )
			{
				Message( player, "INVALID LEGEND INDEX" )
				return true
			}
			
			if( isPlayerPendingChallenge( player ) || isPlayerPendingLockOpponent( player ) )
			{}
			else 
			{
				Message( player, "NOT IN CHALLENGE" )
				return true
			}
			
			soloGroupStruct group = returnSoloGroupOfPlayer( player )
			
			if( !IsValid( group ))
			{
				Message( player, "INVALID GROUP" )
				return true
			}
			
			if( group.player1 == player )
			{
				group.p1LegendIndex = index
			}
			else if( group.player2 == player )
			{
				group.p2LegendIndex = index
			}
			
			Message( player, "PLAYING AS: " + legend )
			
			if( index <= 10 )
			{
				ItemFlavor select_character = characters[characterslist[index]]
				CharacterSelect_AssignCharacter( ToEHI( player ), select_character )
				
				if(!bAllowTactical)
				{
					player.TakeOffhandWeapon(OFFHAND_TACTICAL)
				}
			}
			else 
			{
				SetPlayerCustomModel( player, index )
			}
			
			return true
			
			
		case "outlist":
		
			string list = "";
			
			foreach( chalplayer in GetPlayerArray() )
			{
				if ( !IsValid( chalplayer ) ){continue}
				
				ChallengesStruct chalStruct = getChallengeListForPlayer( chalplayer )
				
				if( isChalValid( chalStruct ) )
				{
					if ( player.p.handle in chalStruct.challengers )
					{
						list += format("Outgoing challenge to: %s \n", chalplayer.p.name )
					}
				}
			}
			
			if( list != "" )
			{
				Message( player, "OUTGOING CHALLENGES", list, 15 )
			}
			else 
			{
				Message( player, "NO OUTGOING CHALLENGES")
			}
		
			return true
		
		default:
			Message( player, "Failed: ", "Unknown command \n", 5 )
			return true
	}
	
	return false;
}


void function INIT_playerChallengesStruct( entity player )
{
	ChallengesStruct chalStruct;
	
	chalStruct.player = player
	
	file.allChallenges.append(chalStruct)
}

int function addToChallenges( entity challenger, entity challengedPlayer )
{
	ChallengesStruct chalStruct = getChallengeListForPlayer( challengedPlayer )
	
	if( !isChalValid( chalStruct ) )
	{
		#if INVALID_ACCESS_DEBUG
		PrintDebug( challengedPlayer, 7 )
		#endif
		return 5;
	}
	
	if( !challengedPlayer.p.lock1v1_setting )
	{
		return 4;
	}
	
	if ( Time() - checkChallengeTime( challenger, challengedPlayer ) <= 10 )
	{
		return 3;
	}
	
	if ( chalStruct.challengers.len() >= MAX_CHALLENGERS )
	{
		return 2;
	}
	
	//add challenger to table
	chalStruct.challengers[challenger.p.handle] <- Time()
	
	return 1;
}


bool function isChalValid( ChallengesStruct chalStruct )
{
	return ( IsValid( chalStruct ) && IsValid( chalStruct.player ) )
}


float function checkChallengeTime( entity challenger, entity challengedPlayer )
{
	ChallengesStruct chalStruct = getChallengeListForPlayer( challengedPlayer )
	
	if ( !isChalValid( chalStruct ) )
	{
		#if INVALID_ACCESS_DEBUG
		if( IsValid( challengedPlayer ) )
		{
			PrintDebug( challengedPlayer, 3 )
		}
		else 
		{
			printl("Invalid player during chal access #8")
		}
		#endif
		return 0.0 
	}
	
	if( challenger.p.handle in chalStruct.challengers )
	{
		return getChallengeListForPlayer( challengedPlayer ).challengers[challenger.p.handle]
	}
	
	return 0.0
}


ChallengesStruct function getChallengeListForPlayer( entity player )
{
	ChallengesStruct chalStruct;
	
	if( !IsValid( player ) )
	{
		return chalStruct;
	}
	
	foreach ( challengeStruct in file.allChallenges )
	{
		if( !IsValid( challengeStruct ) )
		{
			continue
		}
		
		if ( IsValid( challengeStruct.player ) && challengeStruct.player == player )
		{
			return challengeStruct
		}
	}
	
	return chalStruct;
}


string function listPlayerChallenges( entity player )
{
	ChallengesStruct chalStruct = getChallengeListForPlayer( player )
	
	string list = "";
	string emphasis = ""
	entity opponent
	
	if( isPlayerPendingChallenge( player ) || isPlayerPendingLockOpponent( player ))
	{
		opponent = returnChallengedPlayer( player )
		
		if( IsValid(opponent) )
		{
			list += format("***ACTIVE CHALLENGE***:[ %s ]\n\n", opponent.p.name )
		}	
	}
	else 
	{
		list += "No active challenge yet... \n\n";
	}
	
	if ( !isChalValid( chalStruct ) )
	{
		#if INVALID_ACCESS_DEBUG
		PrintDebug( player, 4 )
		#endif
		return list;
	}
	
	if( chalStruct.challengers.len() == 0 )
	{
		list += "No incoming challenges yet...";
	}
	
	foreach ( challenger_eHandle, chalTime in chalStruct.challengers )
	{
		entity challenger = GetEntityFromEncodedEHandle ( challenger_eHandle )
		
		if ( IsValid( challenger ) )
		{		
			list += format("Challenger: %s, Seconds ago: %d \n", challenger.p.name, Time() - chalTime )
		}
		else 
		{
			removeChallenger( player, challenger_eHandle )
		}
	}

	return list;
}


bool function removeChallenger( entity player, int challenger_eHandle )
{
	ChallengesStruct chalStruct = getChallengeListForPlayer( player )
	
	if ( !isChalValid( chalStruct ) )
	{	
		#if INVALID_ACCESS_DEBUG
		PrintDebug( player, 5 )
		#endif
		
		return false 
	}
	
	if ( challenger_eHandle in chalStruct.challengers )
	{
		delete getChallengeListForPlayer( player ).challengers[challenger_eHandle]
		return true
	}
	
	return false
}

void function PrintDebug( entity player, int functioncall )
{
	printt( format("Potential invalid access for player: %s, %s --CALL: %d", player.p.name, player.p.UID, functioncall) )
}

bool function acceptChallenge( entity player, entity challenger )
{
	//todo, Assert? 
	if( !IsValid(challenger))
	{
		return false
	}
	
	if( isPlayerPendingChallenge( player ) || isPlayerPendingLockOpponent( player ))
	{
		Message( player, "ALREADY IN CHALLENGE", "do /end or /clear to finish" )
		return true
	} 
	
	if( isPlayerPendingChallenge( challenger ) ||  isPlayerPendingLockOpponent( challenger ) )
	{
		Message( player, "PLAYER ALREADY IN CHALLENGE" )
	}
	
	//sqprint("accepted")
	ChallengesStruct chalStruct = getChallengeListForPlayer( player )
	
	if ( isChalValid( chalStruct ) && challenger.p.handle in chalStruct.challengers )
	{
		file.acceptedChallenges[player.p.handle] <- challenger 
		removeChallenger( player, challenger.p.handle ) //removes from incoming list	
		SetUpChallengeNotifications( player, challenger )
	}
	else 
	{
		Message( player, "NO CHALLENGES FROM PLAYER", "Maybe revoked? Check with /list")
		return false 
	}
	
	return true
}

bool function acceptRecentChallenge( entity player )
{
	if( isPlayerPendingChallenge( player ) || isPlayerPendingLockOpponent( player ))
	{
		Message( player, "ALREADY IN CHALLENGE", "do /end or /clear to finish" )
		return true
	} 
	
	ChallengesStruct chalStruct = getChallengeListForPlayer( player )
	
	if( !isChalValid( chalStruct ) )
	{
		#if INVALID_ACCESS_DEBUG
		PrintDebug( player, 6 )
		#endif
		return false;
	}
	
	if( chalStruct.challengers.len() <= 0 )
	{
		Message( player, "NO CHALLENGES", "Maybe revoked? Check with /list")
		return false
	}
	
	entity recentChallenger;
	int recentChallenger_eHandle = -1;
	
	float mostRecentTime = 0.0;
	
	foreach ( challenger_eHandle, chalTime in chalStruct.challengers )
	{
		mostRecentTime = chalTime 
		
		if( chalTime >= mostRecentTime )
		{
			recentChallenger = GetEntityFromEncodedEHandle( challenger_eHandle )
			recentChallenger_eHandle = challenger_eHandle
		}
	}
		
	if( !IsValid( recentChallenger ) )
	{
		if ( removeChallenger( player, recentChallenger_eHandle ) )
		{
			Message( player, "CHALLENGER QUIT" )
		}
		else 
		{
			Message( player, "PLAYER NOT IN CHALLENGES" )
		}
		
		return false
	}
	
	if( !IsValid( recentChallenger ) || isPlayerPendingChallenge( recentChallenger ) || isPlayerPendingLockOpponent( recentChallenger ) )
	{
		Message( player, "PLAYER ALREADY IN CHALLENGE")
		return false
	}
	//sqprint("accepted")
	
	file.acceptedChallenges[player.p.handle] <- recentChallenger 
	removeChallenger( player, recentChallenger.p.handle )
	SetUpChallengeNotifications( player, recentChallenger )
	
	return true
}

void function SetUpChallengeNotifications( entity player, entity challenger ) //this shit needs a system
{
	player.p.waitingFor1v1 = true 
	challenger.p.waitingFor1v1 = true
	Message( player, "CHALLENGE ACCEPTED")
	Message( challenger, "CHALLENGE ACCEPTED")
	SetChallengeNotifications( [player,challenger], true )
	player.p.eLastChallenger = challenger
	challenger.p.eLastChallenger = player
	player.p.destroynotify = true
	challenger.p.destroynotify = true
	RemovePanelText( player, player.p.handle )
	RemovePanelText( player, challenger.p.handle )
}

void function SetChallengeNotifications( array<entity> players, bool setting )
{
	foreach ( player in players )
	{
		if( !IsValid( player ) ){continue}	
		player.p.challengenotify = setting
	}
}

bool function endLock1v1( entity player, bool addmsg = true, bool revoke = false )
{
	if( !IsValid (player) )
	{
		return false
	}
	
	player.Signal( "NotificationChanged" )
	int iRemoveOpponent = 0
	entity opponent = getLock1v1OpponentOfPlayer( player )
	entity challenged;
	
	if( player.p.handle in file.acceptedChallenges )
	{
		delete file.acceptedChallenges[player.p.handle]
		iRemoveOpponent = 1
	}
	else 
	{
		challenged = returnChallengedPlayer( player )
		
		if ( IsValid( challenged ) )
		{	
			if( challenged.p.handle in file.acceptedChallenges )
			{
				delete file.acceptedChallenges[challenged.p.handle]
				iRemoveOpponent = 2
			}			
		}
		else
		{
			if(addmsg)
			{
				Message( player, "NO CHALLENGE TO END")
				return true
			}
		}
		
	}
	
	if( iRemoveOpponent == 1 && IsValid( opponent ))
	{
		if(addmsg || revoke)
		{
			Message( opponent, "CHALLENGE ENDED")
		}
		
		removeChallenger( player, opponent.p.handle )
		player.p.waitingFor1v1 = false
		opponent.p.waitingFor1v1 = false
	}
	
	if ( iRemoveOpponent == 2 && IsValid( challenged ) )
	{
		if(addmsg || revoke)
		{
			Message( challenged, "CHALLENGE ENDED")	
		}
		
		removeChallenger( challenged, player.p.handle )
		player.p.waitingFor1v1 = false
		challenged.p.waitingFor1v1 = false
	}
	
	if ( iRemoveOpponent > 0 && isPlayerInProgress( player ) )
	{
		soloGroupStruct group = returnSoloGroupOfPlayer( player )
		
		if(addmsg)
		{
			Message( player, "CHALLENGE ENDED")
		}
		
		if( IsValid( group ) )
		{	
			sendGroupRecapsToPlayers( group )
			addmsg = false
			
			group.IsKeep = false;
			group.IsFinished = true;
			mkos_Force_Rest( group.player1, [] )
			mkos_Force_Rest( group.player2 , [] )
		}
	}
	
	if( iRemoveOpponent > 0 )
	{
		entity opp;
		
		if( IsValid( opponent ) )
		{
			opponent.Signal( "NotificationChanged" )
			opp = opponent
		}
		else if( IsValid(challenged) )
		{
			challenged.Signal( "NotificationChanged" )
			opp = challenged
		}
		
		if(addmsg)
		{
			Message( player, "CHALLENGE ENDED")
		}
		
		player.Signal( "NotificationChanged" )
		SetChallengeNotifications( [player,opp], false )
	}
	
	return true
}

bool function isPlayerPendingChallenge( entity player )
{
	return ( player.p.handle in file.acceptedChallenges )
}

bool function isPlayerPendingLockOpponent( entity player )
{
	foreach ( challenged, opponent in file.acceptedChallenges )
	{
		if( !IsValid( opponent ) )
		{
			continue
		}
		
		if ( player == opponent )
		{
			return true
		}
	}
	
	return false
}

entity function returnChallengedPlayer( entity player )
{
	entity p
	
	foreach( challenged_eHandle, challenger in file.acceptedChallenges )
	{
		if( !IsValid(challenger) )
		{
			continue
		}
		
		if ( challenger == player )
		{
			return GetEntityFromEncodedEHandle( challenged_eHandle )
		}
		else  if ( challenged_eHandle == player.p.handle )
		{
			return challenger
		}
	}
	
	return p
}

entity function getLock1v1OpponentOfPlayer( entity player )
{
	entity p;
	
	if( player.p.handle in file.acceptedChallenges )
	{
		if( IsValid( file.acceptedChallenges[player.p.handle] ))
		{
			if( player.p.handle in file.soloPlayersWaiting )
			{
				return file.acceptedChallenges[player.p.handle]
			}
		}
	}
	
	return p
}

void function sendGroupRecapsToPlayers( soloGroupStruct group )
{
	if( !IsValid(group) || !IsValid(group.player1) || !IsValid(group.player2) )
	{
		return
	}
	
	if ( !( group.player1 in group.statsRecap ) || !( group.player2 in group.statsRecap ) )
	{
		return
	}
	
	groupStats player1 = group.statsRecap[group.player1]
	groupStats player2 = group.statsRecap[group.player2]
	
	string serverMsg = ""
	string winner = ""
	string defeated = ""
	int winnerKills = 0
	int defeatedDeaths = 0
	bool tied = false
	
	#if TRACKER
	if( bChalServerMsg )
	{
		if( player1.kills > player2.kills )
		{
			winner = group.player1.p.name 
			winnerKills = player1.kills
			defeated = group.player2.p.name 
			defeatedDeaths = player2.kills
		}
		else if ( player2.kills > player1.kills )
		{
			winner = group.player2.p.name 
			winnerKills = player2.kills
			defeated = group.player1.p.name 
			defeatedDeaths = player1.kills
		}
		else if ( player1.kills == player2.kills )
		{
			tied = true
			winner = group.player1.p.name
			winnerKills = player1.kills
			defeated = group.player2.p.name 
			defeatedDeaths = player2.kills
		}
		
		if ( tied )
		{
			serverMsg = group.player1.p.name + " tied in a challenge vs " + group.player2.p.name 
		}
		else 
		{
			serverMsg = format(" %s won a challenge vs %s,  %d - %d", winner, defeated, winnerKills, defeatedDeaths )
		}
		
		SendServerMessage( serverMsg + ChatEffects()["SKULL"] )
	}
	#endif
	
	groupRecapStats( group.player1, player1.damage, player1.hits, player1.shots, player1.kills, player1.deaths, player2.displayname, player2.damage, player2.hits, player2.shots, player2.kills, player2.deaths, group.startTime ) 
	groupRecapStats( group.player2, player2.damage, player2.hits, player2.shots, player2.kills, player2.deaths, player1.displayname, player1.damage, player1.hits, player1.shots, player1.kills, player1.deaths, group.startTime ) 
}

void function addStatsToGroup( entity player, soloGroupStruct group, float damage, int hits, int shots, bool bIsKill )
{
	if( !IsValid( player ) || !IsValid( group ) ){ return }
	
	if ( !( player in group.statsRecap ) )
	{
		groupStats gS;	
		group.statsRecap[player] <- gS
		group.statsRecap[player].player = player 
		group.statsRecap[player].displayname = player.p.name
	}
	
	group.statsRecap[player].damage += damage
	group.statsRecap[player].hits += hits
	group.statsRecap[player].shots += shots
	
	if(bIsKill)
	{
		group.statsRecap[player].kills++;
	}
	else 
	{
		group.statsRecap[player].deaths++;
	}	
}

void function groupRecapStats(entity player, float damage, int hits, int shots, int kills, int deaths, string opponent, float opponentdamage, int opponenthits, int opponentshots, int opponentkills, int opponentdeaths, float startTime ) 
{
    float accuracy = 0.0;
    float opponent_accuracy = 0.0;
	
    if (shots > 0.0) 
	{
        accuracy = (hits.tofloat() / shots.tofloat() ) * 100.0;
		
        if (accuracy >= 100.0) 
		{
            accuracy = 100.0;
        }
    }
	
	float kd = deaths > 0 ? kills.tofloat() / deaths.tofloat() : kills.tofloat()
	float opponentkd = opponentdeaths > 0 ? opponentkills.tofloat() / opponentdeaths.tofloat() : opponentkills.tofloat()
	
    if (opponentshots > 0.0) 
	{
        opponent_accuracy = ( opponenthits.tofloat() / opponentshots.tofloat() ) * 100.0;
		
        if (opponent_accuracy >= 100.0) 
		{
            opponent_accuracy = 100.0;
        }
    }

	float lasted = Time() - startTime;
    string print_totals = format("\n Fight lasted %d seconds. \n\n\n Your Dmg: %d \n Hits: %d \n Shots %d \n Your Accuracy: %d%% \n Your Kills: %d \n Your Deaths: %d \n Challenge KD: %.2f \n\n\n\n %s's Dmg: %d \n %s's Hits: %d \n %s's Shots %d \n %s's Accuracy: %d%% \n %s's Kills: %d \n %s's Deaths: %d \n %s's Challenge KD: %.2f", lasted, damage, hits, shots, accuracy, kills, deaths, kd, opponent, opponentdamage, opponent, opponenthits, opponent, opponentshots, opponent, opponent_accuracy, opponent, opponentkills, opponent, opponentdeaths, opponent, opponentkd);
 
	if(IsValid(player))
	{
		player.p.messagetime = Time()
		Message( player, "\n\n\n\n\n\n\n\n\n Recap vs: " + opponent, print_totals, 30 );
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////

//modified by mkos
bool function ClientCommand_Maki_SoloModeRest(entity player, array<string> args )
{
	if( !IsValid(player) ) //|| !IsAlive(player) )
		return false
	
	if( Time() < player.p.lastRestUsedTime + 3 )
	{
		Message(player, "REST COOLDOWN")
		return false
	}
	
	string restText = "Type rest in console to pew pew again.";

	if( player.p.handle in file.soloPlayersResting )
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

		if(file.IS_CHINESE_SERVER)
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
		
		HolsterAndDisableWeapons(player)
	}
	else
	{		

		if( isPlayerInProgress( player ) )
		{		
			entity opponent;
			float timeNow;
			bool skip = false
			soloGroupStruct group = returnSoloGroupOfPlayer( player )
			
			if(!IsValid(group))
			{
				skip = true
			}
			
			if(!skip)
			{
				opponent = player == group.player1 ? group.player2 : group.player1;
				timeNow = Time()
			}
			
			if ( !IsValid (opponent)) { skip = true }
			
			if(!skip)
			{
				DamageEvent event = getEventByPlayerHandle(opponent.p.handle) 
				
				float lasthittime = event.lastHitTimestamp
				
				float difference = ( timeNow - lasthittime )
				
				bool start_grace_exceeded = false
				
				if( ( timeNow - group.startTime ) > REST_GRACE )
				{
					start_grace_exceeded = true
				}
				
				if( difference < REST_GRACE || !start_grace_exceeded )
				{	
					float fTryAgainIn;
					
					if(start_grace_exceeded)
					{
						fTryAgainIn = REST_GRACE - ( timeNow - lasthittime )
					}
					else 
					{
						fTryAgainIn = REST_GRACE - ( timeNow - group.startTime )
					}
					
					string sTryAgain = format("Or.. try again in: %d seconds", floor( fTryAgainIn.tointeger() ) )
					#if DEVELOPER
					sqprint(format( "Time was too soon: difference:  %d, REST_GRACE: %d ", difference, REST_GRACE ))
					#endif
					Message( player, "SENDING TO REST AFTER FIGHT", sTryAgain, 1 )
					player.p.rest_request = true;
					return true
				}
				else 
				{
					#if DEVELOPER
					sqprint(format("Time was good: difference: %d, REST_GRACE: %d ", difference, REST_GRACE ))
					#endif
					restText = format("Sent to rest because time since last damage recieved was greater than %d seconds.", REST_GRACE );
				}
			}
		}
	
		
		if(file.IS_CHINESE_SERVER)
			Message(player,"您已处于休息室", "在控制台中输入'rest'重新开始匹配")
		else
			Message(player,"You are resting now", restText )
		
		thread soloModePlayerToRestingList(player)
		try
		{
			player.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_suicide } )
		}
		catch (error)
		{

		}
		
		HolsterAndDisableWeapons(player)
		thread respawnInSoloMode(player)
		//TakeAllWeapons( player )
	}
	
	player.p.lastRestUsedTime = Time()

	return true
}

bool function processRestRequest( entity player )
{
	if( !IsValid( player ) )
	{
		return  false
	}
	
	if ( player.p.rest_request )
	{
		player.p.rest_request = false;
		expliciteRest( player )
		return true
	}
	
	return false
}


void function expliciteRest( entity player )
{
	if( player.p.handle in file.soloPlayersResting )
	{
		return 
	}
	
		if(file.IS_CHINESE_SERVER)
		Message(player,"您已处于休息室", "在控制台中输入'rest'重新开始匹配")
	else
		Message(player,"You are resting now", "Type rest in console to pew pew again.")
	
	thread soloModePlayerToRestingList(player)
	
	try
	{
		player.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_suicide } )
	}
	catch (error){}
	
	HolsterAndDisableWeapons(player)
	thread respawnInSoloMode(player)
	//TakeAllWeapons( player )
	
	player.p.lastRestUsedTime = Time()
}

//mkos -new 

entity function getRandomOpponentOfPlayer(entity player)
{
    entity p;
	
    if (!IsValid(player)) return p;

    array<entity> eligible = [];

    foreach ( playerHandle, eachPlayerStruct in file.soloPlayersWaiting )
    {   		
		if( !playerHandle || (!IsValid(eachPlayerStruct)) )
		{
			return p
		}
		
        if ( IsValid(eachPlayerStruct.player) && player != eachPlayerStruct.player && !eachPlayerStruct.player.p.waitingFor1v1 )
		{
            if ( eachPlayerStruct.player.p.input == player.p.input || (eachPlayerStruct.IBMM_Timeout_Reached == true && Fetch_IBMM_Timeout_For_Player(player) == true))
            {
                eligible.append(eachPlayerStruct.player);
            }
		}
    }
	
	int count = eligible.len()
	
	if( count > 0 )
	{
		entity foundOpponent = eligible[RandomIntRangeInclusive( 0, count - 1 )]
		if(IsValid(foundOpponent))
		{
			//string set = foundOpponent.p.waitingFor1v1 ? "true" : "false";
			//sqprint(format("FOUDN player: %s setting for waiting is: %s", foundOpponent.p.name, set))
			return foundOpponent
		}
	}
    
	return p
}



entity function returnOpponentOfPlayer(entity player) 
{
    entity opponent;

    soloGroupStruct group = returnSoloGroupOfPlayer( player );

    if ( IsValid(group) && IsValid(player) ) 
	{
        if ( IsValid( group.player2 ) && player == group.player1 ) 
		{
            opponent = group.player2
        } 
		else if ( IsValid( group.player1 ) && player == group.player2 ) 
		{
            opponent = group.player1
        }
    }
	
    return opponent;
}


void function soloModePlayerToWaitingList( entity player )
{
	if(!IsValid(player) || isPlayerInWaitingList(player) ) 	
	{	
		return
	}
	
	player.TakeOffhandWeapon(OFFHAND_MELEE)

	player.SetPlayerNetEnt( "FSDM_1v1_Enemy", null )

	soloPlayerStruct playerStruct
	playerStruct.player = player
	playerStruct.waitingTime = Time() + 2
	playerStruct.handle = player.p.handle
	
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
		playerStruct.kd = (  ( lifetime_kd * file.lifetime_kd_weight ) + ( current_kd * file.current_kd_weight ) )
	}
	else
	{
		return
		//playerStruct.kd = 0
	}
	playerStruct.lastOpponent = player.p.lastKiller

	playerStruct.queue_time = Time()
	ResetIBMM( player )
	//soloPlayersWaiting.append(playerStruct) //maki 
	AddPlayerToWaitingList( playerStruct ) // mkos
	
	TakeAllWeapons( player )

	//set realms for resting player
	FS_ClearRealmsAndAddPlayerToAllRealms( player )
	
	Remote_CallFunction_NonReplay( player, "ForceScoreboardFocus" )

	//检查InProgress是否存在该玩家
	// Check if the player is part of any group
	
	//mkos version
	
	if ( player.p.handle in file.playerToGroupMap ) 
	{
		soloGroupStruct group = returnSoloGroupOfPlayer(player);
		entity opponent = returnOpponentOfPlayer(player);	
		
		if(mGroupMutexLock)
		{ 
			sqerror("tried to modify groups in use")
			throw "tried to modify groups in use.";
		}
		else if(!IsValid(group))
		{
			#if DEVELOPER
			sqprint("remove group request 01")
			#endif
			destroyRingsForGroup(group);
			removeGroup(group);
		}
		
		soloModePlayerToWaitingList(player); 
		
		if (IsValid(opponent)) 
		{
			soloModePlayerToWaitingList(opponent);
		}
	}
	
	//检查resting list 是否有该玩家
	deleteSoloPlayerResting( player )
	
}

void function soloModePlayerToInProgressList( soloGroupStruct newGroup ) 
{
    entity player = newGroup.player1;
    entity opponent = newGroup.player2;
    
    if ( !IsValid(player) || !IsValid(opponent) ) 
	{  
        return;
    }
	if(player == opponent)
	{
		// Warning("Try to add same players to InProgress list:" + player.GetPlayerName())
		player.SetPlayerNetEnt( "FSDM_1v1_Enemy", null )
		return
	}
	
    player.SetPlayerNetEnt("FSDM_1v1_Enemy", opponent);
    opponent.SetPlayerNetEnt("FSDM_1v1_Enemy", player);

    if ( player.p.handle in file.playerToGroupMap || opponent.p.handle in file.playerToGroupMap ) 
	{	
		//directly assign since we checked. - mkos
        soloGroupStruct existingGroup = player.p.handle in file.playerToGroupMap ? file.playerToGroupMap[player.p.handle] : file.playerToGroupMap[opponent.p.handle];
		
        destroyRingsForGroup(existingGroup);
		
		#if DEVELOPER
		sqprint("remove group request 02")
		#endif
		
		while(mGroupMutexLock) 
		{
			#if DEVELOPER
			sqprint("Waiting for lock to release R002")
			#endif
			WaitFrame() 
		}
		
        removeGroup(existingGroup);

        return
    }

	//not found 
	newGroup.player1 = player
	newGroup.player2 = opponent
		
    deleteWaitingPlayer(player.p.handle);
    deleteWaitingPlayer(opponent.p.handle);
    deleteSoloPlayerResting(player);
    deleteSoloPlayerResting(opponent);

    
    int slotIndex = getAvailableRealmSlotIndex();
    if (slotIndex > -1) 
	{
        newGroup.slotIndex = slotIndex;
        newGroup.groupLocStruct = soloLocations.getrandom()
		
		while(mGroupMutexLock) 
		{
			#if DEVELOPER
			sqprint("Waiting for lock to release R001")
			#endif
			WaitFrame() 
		}
		addGroup(newGroup); 
    } 

    return
}


void function soloModePlayerToRestingList(entity player)
{
	if(!IsValid(player))
	{	
		return
	}
	
	player.TakeOffhandWeapon(OFFHAND_MELEE)
	ResetIBMM( player )
	player.p.destroynotify = true
	player.p.notify = false
	
	player.SetPlayerNetEnt( "FSDM_1v1_Enemy", null )
	deleteWaitingPlayer(player.p.handle)

	soloGroupStruct group = returnSoloGroupOfPlayer(player)
	if(IsValid(group))
	{
	
		if( isPlayerPendingChallenge( player ) || isPlayerPendingLockOpponent( player ))
		{
			endLock1v1( player, true )
		}
	
		entity opponent = returnOpponentOfPlayer(player)

		// if(IsValid(soloLocations[group.slotIndex].Panel)) //Panel in current Location
			// soloLocations[group.slotIndex].Panel.SetSkin(1) //set panel to red(default color)

		destroyRingsForGroup(group)
		
		#if DEVELOPER
		sqprint("remove group request 03")
		#endif
		
		while(mGroupMutexLock) 
		{
			#if DEVELOPER
			sqprint("Waiting for lock to release R003")
			#endif
			WaitFrame() 
		}
		
		removeGroup(group) //mkos remove -- 销毁这个group

		if(IsValid(opponent))
		{		//找不到对手
			soloModePlayerToWaitingList(opponent) //将对手放回waiting list
		}
	}
	else 
	{
		endLock1v1( player, false )
	}

	//deleteSoloPlayerResting( player ) // ??why do we do this (replaced with my functions as well)
	addSoloPlayerResting( player ) // ??
}

void function soloModefixDelayStart(entity player)
{	
	string tracker = "";
	
	#if HAS_TRACKER_DLL && TRACKER
		tracker = "       Tracker Edition";
	#endif
	
	if(file.IS_CHINESE_SERVER)
		Message(player, format("加载中 FS 1v1 %s\n\n\n", tracker ) )
	else
		Message(player, format("Flowstate 1v1 %s\n\n\n", tracker ) )
	
	HolsterAndDisableWeapons(player)
	
	wait 12
	
	if(!IsValid(player))
	{
		return
	}
	
	if(!isPlayerInRestingList(player))
	{
		soloModePlayerToWaitingList(player)
	}

	try
	{
		//player.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_suicide } )
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
	if( !IsValid( ent ) || !ent.IsPlayer() ) return
	HolsterAndDisableWeapons( ent )
	EntityOutOfBounds( trigger, ent, null, null )
}

void function forbiddenZone_leave(entity trigger , entity ent)
{
	if( !IsValid(ent) || !ent.IsPlayer() ) return
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
	else if( !bIsKarma && shields <= 125 )
		Inventory_SetPlayerEquipment(player, "armor_pickup_lv5", "armor")

	player.SetShieldHealth( shields )
}

bool function isGroupValid(soloGroupStruct group)
{
	if(!IsValid(group)) return false
	if(!IsValid(group.player1) || !IsValid(group.player2)) return false
	return true
}

void function respawnInSoloMode(entity player, int respawnSlotIndex = -1) //复活死亡玩家和同一个sologroup的玩家
{
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

	soloGroupStruct group = returnSoloGroupOfPlayer(player)

	if( !isGroupValid( group ) )
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
	
	
	GivePlayerCustomPlayerModel( player )
	
	soloLocStruct groupLocStruct = group.groupLocStruct
	maki_tp_player(player, groupLocStruct.respawnLocations[ respawnSlotIndex ] )
	

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

	//re-enable for inventory. 
	Survival_SetInventoryEnabled( player, true )
	SetPlayerInventory( player, [] ) //TODO: set array to list of custom attachments if any - mkos
	
	wait 0.1
	ReCheckGodMode(player)
}

void function _decideLegend( soloGroupStruct group )
{
	if ( !isGroupValid(group) ){ return }
	
	ItemFlavor select_character
	
	if ( group.p1LegendIndex > 0 )
	{
		if( group.p1LegendIndex <= 10 )
		{
			select_character = characters[characterslist[group.p1LegendIndex]]
			CharacterSelect_AssignCharacter( ToEHI( group.player1 ), select_character )
		}
		else 
		{
			SetPlayerCustomModel( group.player1, group.p1LegendIndex )
		}	
	}

	if ( group.p2LegendIndex > 0 )
	{
		if( group.p2LegendIndex <= 10 )
		{
			select_character = characters[characterslist[group.p2LegendIndex]]
			CharacterSelect_AssignCharacter( ToEHI( group.player2 ), select_character )
		}
		else 
		{
			SetPlayerCustomModel( group.player2, group.p2LegendIndex )
		}
	}	
	
	if(!bAllowTactical)
	{
		group.player1.TakeOffhandWeapon(OFFHAND_TACTICAL)
		group.player2.TakeOffhandWeapon(OFFHAND_TACTICAL)
	}
	else 
	{
		RechargePlayerAbilities( group.player1 )
		RechargePlayerAbilities( group.player2 )
	}
}

void function GivePlayerCustomPlayerModel( entity ent )
{
	if( FlowState_ChosenCharacter() > 10 )
	{
		SetPlayerCustomModel( ent, FlowState_ChosenCharacter() )
	}
}

void function SetPlayerCustomModel( entity ent, int index )
{
	switch(index)
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

void function _soloModeInit(string mapName)
{	
	//RegisterSignal("On1v1Death") //TODO
	RegisterSignal( "NotificationChanged" )
	INIT_1v1_sbmm()
	INIT_Flags()
	
	IBMM_COORDINATES = IBMM_Coordinates()
	IBMM_ANGLES = IBMM_Angles()
	
	REST_GRACE = GetCurrentPlaylistVarFloat( "rest_grace", 0.0 )
	
	characters = GetAllCharacters()
	characterslist = [0,1,2,3,4,5,6,7,8,9,10,11,12,13]
	
	//INIT PRIMARY WEAPON SELECTION
	if ( g_bLGmode ) 
	{
		Weapons = [
			"mp_weapon_lightninggun" //Lg_Duel
		]
		
	} 
	else 
	{	
		Weapons = custom_weapons_primary;
	}
			
	if ( Weapons.len() <= 0 )
	{
		
		Weapons = [
				//default R5R.DEV selection
				"mp_weapon_r97 optic_cq_hcog_classic stock_tactical_l1 bullets_mag_l2",	
				"mp_weapon_rspn101 optic_cq_hcog_classic stock_tactical_l1 bullets_mag_l2",
				"mp_weapon_vinson optic_cq_hcog_classic stock_tactical_l1 highcal_mag_l3",
				"mp_weapon_energy_ar optic_cq_hcog_classic stock_tactical_l1 hopup_turbocharger",
				"mp_weapon_volt_smg optic_cq_hcog_classic energy_mag_l1 stock_tactical_l1"
			]
	
	}

	foreach(weapon in Weapons)
	{
		array<string> weaponfullstring = split( weapon , " ")
		string weaponName = weaponfullstring[0]
		if(GetBlackListedWeapons().find(weaponName) != -1)
				Weapons.removebyvalue(weapon)
	}
	
	
	//INIT SECONDARY WEAPON SELECTION	
	if ( g_bLGmode ) {

		WeaponsSecondary = [
			"mp_weapon_lightninggun" //Lg_Duel beta
		]
		
	} else
	{
		
		WeaponsSecondary = custom_weapons_secondary;
	
	}
	
	if ( WeaponsSecondary.len() <= 0 )
	{

		WeaponsSecondary = [
		
			//default R5R.DEV selection
			"mp_weapon_wingman optic_cq_hcog_classic sniper_mag_l1",
			"mp_weapon_energy_shotgun shotgun_bolt_l1",
			"mp_weapon_mastiff shotgun_bolt_l2",
			"mp_weapon_doubletake energy_mag_l3 stock_sniper_l3",
			
		]
	
	}

	foreach(weapon in WeaponsSecondary)
	{
		array<string> weaponfullstring = split( weapon , " ")
		string weaponName = weaponfullstring[0]
		if(GetBlackListedWeapons().find(weaponName) != -1)
				WeaponsSecondary.removebyvalue(weapon)
	}
	
	switch(mapName)
	{
		case "mp_rr_arena_composite":
			WaitingRoom.origin = <-7.62,200,184.57>
			WaitingRoom.angles = <0,90,0>
			break;
			
		case "mp_rr_aqueduct":
			WaitingRoom.origin = <719.94,-5805.13,494.03>
			WaitingRoom.angles = <0,90,0>
			break;
			
		case "mp_rr_canyonlands_64k_x_64k":
			WaitingRoom.origin = <-762.59,20485.05,4626.03>
			WaitingRoom.angles = <0,45,0>
			break;
			
		case "mp_rr_canyonlands_staging":
			WaitingRoom.origin = < 3477.69, -8364.02, -10252 >
			WaitingRoom.angles = <356.203, 269.459, 0>
			break;		
			
		case "mp_rr_party_crasher":
			WaitingRoom.origin = < 1881.75, -4210.87, 626.106 > 
			WaitingRoom.angles = < 359.047, 104.246, 0 >
			break;
	}
	
	array<LocPair> allSoloLocations
	array<LocPair> panelLocations
	LocPair waitingRoomPanelLocation
	// LocPair waitingRoomLocation
	if (mapName == "mp_rr_arena_composite")
	{	
		bMap_mp_rr_arena_composite = true
		
		// waitingRoomLocation = NewLocPair( <-7.62,200,184.57>, <0,90,0>)
		waitingRoomPanelLocation = NewLocPair( <-3.0,645,125>, <0,0,0>)//休息区观战面板

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
		
		if(Lock1v1Enabled())
		{
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
			
			
			//drop off patch mkos
			array<LocPair> dropoff_patch
			array<LocPair> dropoff_panel_patch
			
			dropoff_patch = [
				
				//removed skyroom
				//NewLocPair( <-1378.05, 559.458, 1026.54 >, < 359.695, 307.314, 0 >),//13
				//NewLocPair( <-1469.03, -117.677, 1026.54 >, < 1.34318, 60.0746, 0 >),
				
				NewLocPair( < -2824.9, 2868.1, -111.969 >, < 0.354577, 31.8209, 0 >), //13
				NewLocPair( < -2541.81, 3919.45, -111.969 >, < 358.65, 315.899, 0 >),

				
				NewLocPair( < -2958.52, 183.899, 190.063 >, < 0.905181, 353.701, 0 >),//14
				NewLocPair( < -1693.05, -663.034, 190.063 >, < 0.514909, 140.627, 0 >),
				
				
				NewLocPair( <2544.54, 3934.15, -111.969 >, < 3.3168, 218.85, 0>), //15
				NewLocPair( <3196.49, 3010.24, -111.969 >, < 1.33276, 134.094, 0>),
				
				NewLocPair( < 2551.65, 515.938, 193.337 >, < 0.894581, 215.161, 0>), //16
				NewLocPair( <1637.37, -808.877, 193.67 >, < 0.0671947, 36.8544, 0>)
			
			]
		
			if(Lock1v1Enabled())
			{
				dropoff_panel_patch = [
				
						NewLocPair( < -3047.298, 3813.393, -151.6514 >, < 0, 36.8985, 0 >),//13
						NewLocPair( < -2178.562, 481.2845, 189.9998 >, < 0, -38.7379, 0 >),//14
						//NewLocPair( <-1008.24, 147.977, 687.264 >, < 53.1792, 2.4232, 0>),//14
						NewLocPair( < 3077.486, 3859.245, -151.6514 >, < 0, -39.3852, 0 >), //15
						NewLocPair( < 1868.973, 211.2266, 191.9968 >, < 0, 36.8535, 0 >) //16
				
				]
			}
			
			if ( GetCurrentPlaylistVarBool( "patch_for_dropoff", false ) )
			{
			
				foreach ( loc in dropoff_patch ) 
				{
					allSoloLocations.append(loc);
				}
					
				if(Lock1v1Enabled())
				{
					foreach ( loc in dropoff_panel_patch ) 
					{
						panelLocations.append(loc);
					}
				}
				
			}
			
		}
		else if (mapName == "mp_rr_aqueduct")
		{
			bMap_mp_rr_aqueduct = true
			
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
			
			if(Lock1v1Enabled())
			{
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
			
		}
		else if (mapName == "mp_rr_canyonlands_64k_x_64k")
		{
			bMap_mp_rr_canyonlands_64k_x_64k = true
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
			
			if(Lock1v1Enabled())
			{
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
		}	
		else if ( mapName == "mp_rr_canyonlands_staging" && g_bLGmode ) //_LG_duels
		{
			bMap_mp_rr_canyonlands_staging = true
			//waitingRoomLocation = NewLocPair( < 3477.74, -8544.55, -10252 >, < 356.203, 269.459, 0 >)  
			waitingRoomPanelLocation = NewLocPair( < 3486.38, -9283.15, -10252 >, < 0, 180, 0 >) //休息区观战面板

			allSoloLocations= [

			NewLocPair( < 1317.27, 10573.3, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.367, 0.169666, 0 > ),//1
			NewLocPair( < 1912.15, 10630.3, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.431, 180.377, 0 > ),
			
			
			NewLocPair( < 1314.7, 11484.3, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 359.433, 359.118, 0 > ),//2
			NewLocPair( < 1920.17, 11083.7, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.616, 179.015, 0 > ),
			
			
			NewLocPair( < 1342.6, 12083.1, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 359.021, 359.681, 0 > ),//3
			NewLocPair( < 1928.12, 12062, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.46, 179.056, 0 > ),
			
			
			NewLocPair( < 1334.54, 12767, 135.001 > + LG_DUELS_OFFSET_ORIGIN, < 359.376, 359.648, 0 > ),//4
			NewLocPair( < 1929.33, 12617.3, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.646, 179.52, 0 > ),
			
			
			NewLocPair( < 1314.61, 13608.2, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 359.413, 359.458, 0 > ),//5
			NewLocPair( < 1932.81, 13588.9, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.417, 179.147, 0 > ),
			
			
			NewLocPair( < 1327.13, 14445.1, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 359.142, 359.982, 0 > ),//6
			NewLocPair( < 1895.99, 14101.3, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 359.454, 179.149, 0 > ),
			
			
			NewLocPair( < 2027.17, 14255.7, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 359.44, 0.900257, 0 > ),//7
			NewLocPair( < 2705.93, 14519.9, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.557, 179.749, 0 > ),
						
			
			NewLocPair( < 2022.17, 13587.2, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.804, 1.26951, 0 > ),//8
			NewLocPair( < 2649.07, 13569.1, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.587, 177.486, 0 > ),
			
			
			NewLocPair( < 2012.83, 12907, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.71, 358.894, 0 > ),//9
			NewLocPair( < 2705.93, 12639.9, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.306, 179.909, 0 > ),
			
			
			NewLocPair( < 2007.38, 12065.2, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.02, 1.20616, 0 > ),//10
			NewLocPair( < 2705.93, 12187.1, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.205, 179.637, 0 > ),
						
			
			NewLocPair( < 2010.97, 11294.1, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.677, 1.92442, 0 > ),//11
			NewLocPair( < 2684.01, 11274.2, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.706, 181.528, 0 > ),
			
			
			NewLocPair( < 2018.2, 10553.4, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.365, 0.918914, 0 > ),//12
			NewLocPair( < 2695.21, 10658.3, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.73, 180.507, 0 > ),
			
			
			NewLocPair( < 3454.38, 10463.6, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.461, 179.844, 0 >),//13
			NewLocPair( < 2774.57, 10563.2, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.25, 359.569, 0 > ),
						
			
			NewLocPair( < 2789.48, 11318, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.431, 359.476, 0 > ),//14
			NewLocPair( < 3419.66, 11296.9, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.114, 178.214, 0 > ),
			
			
			NewLocPair( < 2851.9, 12073.4, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 359.097, 0.0967312, 0 > ),//15
			NewLocPair( < 3410.55, 11985.1, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.553, 178.984, 0 > ),
			
			
			NewLocPair( < 3434.33, 12949.8, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.217, 180.349, 0 > ),//16
			NewLocPair( < 2789.41, 12696.9, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.063, 0.618432, 0 > ),
						
			
			NewLocPair( < 2821.61, 13592.5, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.434, 0.300493, 0 > ),//17
			NewLocPair( < 3445.45, 13501.6, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.302, 178.999, 0 > ),
			
			
			NewLocPair( < 2785.1, 14336.5, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 357.755, 1.08752, 0 > ),//18
			NewLocPair( < 3418.27, 14335, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.706, 178.716, 0 > ),
			
			
			NewLocPair( < 3556.97, 14536.3, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.44, 359.719, 0 > ),//19
			NewLocPair( < 4190.3, 14080.3, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.096, 178.87, 0 > ),
						
			
			NewLocPair( < 3567.85, 13604.9, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.768, 359.636, 0 > ),//20
			NewLocPair( < 4201.19, 13668.7, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.71, 180.051, 0 > ),
			
			
			NewLocPair( < 3551.94, 13015.2, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.056, 359.814, 0 > ),//21
			NewLocPair( < 4194.56, 12673.9, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.854, 180.855, 0 > ),
			
			
			NewLocPair( < 3542.06, 11949.6, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.863, 0.431551, 0 > ),//22
			NewLocPair( < 4212.53, 12181.8, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.223, 179.777, 0 > ),
						
			
			NewLocPair( < 3535.76, 11498.9, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.982, 359.36, 0 > ),//23
			NewLocPair( < 4155.54, 11130.5, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.654, 179.863, 0 > ),
			
			
			NewLocPair( < 3542.66, 10485.4, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.779, 359.757, 0 > ),//24
			NewLocPair( < 4216.37, 10769.5, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.249, 180.085, 0 > ),
			
			
			NewLocPair( < 4312.77, 10552.7, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.922, 0.222934, 0 > ),//25
			NewLocPair( < 4934.16, 10569.1, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.363, 179.387, 0 > ),
						
			
			NewLocPair( < 4934.63, 11044.4, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.444, 179.237, 0 > ),//26
			NewLocPair( < 4293.06, 11584.1, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 359.283, 358.251, 0 > ),
			
			
			NewLocPair( < 4939.28, 12050.6, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.252, 178.744, 0 > ),//27
			NewLocPair( < 4317.15, 12075.5, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 357.813, 359.825, 0 > ),
			
			
			NewLocPair( < 4953.12, 12665.2, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.416, 179.383, 0 > ),//28
			NewLocPair( < 4288.89, 12679.3, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.572, 359.256, 0 > ),
						
			
			NewLocPair( < 4949.51, 13535, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.109, 179.168, 0 > ),//29
			NewLocPair( < 4334.56, 13790.7, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.745, 359.199, 0 > ),
			
			
			NewLocPair( < 4854.76, 14333.8, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.84, 179.242, 0 > ),//30
			NewLocPair( < 4449.29, 14355.9, 136.275 > + LG_DUELS_OFFSET_ORIGIN, < 358.114, 359.415, 0 > ),
			
			]
			
			
			panelLocations = [

			]
		}
		else if (mapName == "mp_rr_party_crasher")
		{
			bMap_mp_rr_party_crasher = true
			//waitingRoomLocation = NewLocPair( < 3477.74, -8544.55, -10252 >, < 356.203, 269.459, 0 >)  
			waitingRoomPanelLocation = NewLocPair( < 1822, -3977, 626 >, < 0, 15, 0 > ) //休息区观战面板

			allSoloLocations= [

				NewLocPair( < -2053.13, 4360.61, 563.285 >, < 0, 186, 0 > ),
				NewLocPair( < -2958.06, 3402.03, 563.271 >, < 0, 85, 0 > ),
				
				NewLocPair( < -1387.71, 2184.46, 834.302 >, < 0, 40, 0 > ),
				NewLocPair( < -1050.73, 2471.19, 834.302 >, < 0, 220, 0 > ),
				
				NewLocPair( < -1774.73, 42.2706, 1177.18 >, < 0, 30, 0 > ),
				NewLocPair( < -875.26, 530.277, 1079.86 >, < 0, 208, 0 > ),
				
				NewLocPair( < -978.056, -28.7255, 1290.62 >, < 0, 133, 0 > ),
				NewLocPair( < -1421.04, 475.461, 1298.05 >, < 0, 305, 0 > ),
				
				NewLocPair( < 772.704, -1660.51, 835.302 >, < 0, 22, 0 > ),
				NewLocPair( < 1197.34, -1487.04, 835.302 >, < 0, 203, 0 > ),
				
				NewLocPair( < 1046.13, -3527.3, 563.272 >, < 0, 331, 0 > ),
				NewLocPair( < 2342.18, -3197.44, 563.285 >, < 0, 233, 0 > ),
				
				NewLocPair( < 2663.09, -487.083, 730.031 >, < 0, 109, 0 > ),
				NewLocPair( < 2512.93, -32.7122, 730.031 >, < 0, 290, 0 > ),
				
				NewLocPair( < 2837.64, -258.927, 930.031 >, < 0, 109, 0 > ),
				NewLocPair( < 2686.48, 186.067, 930.031 >, < 0, 288, 0 > ),
				
				NewLocPair( < 2013.12, 2245.02, 920.031 >, < 0, 300, 0 > ),
				NewLocPair( < 2550.29, 1371.93, 920.031 >, < 0, 121, 0 > ),
				
				NewLocPair( < 835.26, 2797.75, 940.031 >, < 0, 132, 0 > ),
				NewLocPair( < 544.371, 3121.64, 940.031 >, < 0, 313, 0 > ),
				
				NewLocPair( < 930.568, 3029.09, 740.031 >, < 0, 133, 0 > ),
				NewLocPair( < 582.145, 3424.91, 740.031 >, < 0, 311, 0 > ),
				
				NewLocPair( < 1843.89, 816.934, 703.031 >, < 0, 119, 0 > ),
				NewLocPair( < 1220.95, 1939.03, 703.031 >, < 0, 300, 0 > ),
				
				NewLocPair( < 1509.87, 195.799, 543.613 >, < 0, 181, 0 > ),
				NewLocPair( < 839.514, 191.83, 543.613 >, < 0, 0, 0 > ),
			
			]
			
			
			panelLocations = [

			]
		}
		else
		{
			return
		}

	//resting room init ///////////////////////////////////////////////////////////////////////////////////////
	
	string buttonText
	
	if(file.IS_CHINESE_SERVER)
		buttonText = "%&use% 开始观战"
	else
		buttonText = "%&use% Start spectating"

	string buttonText3
	
	if(file.IS_CHINESE_SERVER)
		buttonText3 = "%&use% 开始休息"
	else
		buttonText3 = "%&use% Rest (or) Enter Queue"
	
	//mkos 
	string buttonText4
	
		buttonText4 = "%&use% Toggle IBMM";
		
	string buttonText5
	
		buttonText5 = "%&use% Enable/Disable 1v1 Challenges";
		
	string buttonText6
	
		buttonText6 = "%&use% Toggle \"Start In Rest\" Setting";
		
	string buttonText7 
	
		buttonText7 = "%&use% Toggle Input Banner";
	//endkos, - initialized in case we want to dynamically change it for chinese server
	
	entity restingRoomPanel = CreateFRButton( waitingRoomPanelLocation.origin + AnglesToForward( waitingRoomPanelLocation.angles ) * 40, waitingRoomPanelLocation.angles, buttonText )
	entity restingRoomPanel_RestButton = CreateFRButton( waitingRoomPanelLocation.origin - AnglesToForward( waitingRoomPanelLocation.angles ) * 40, waitingRoomPanelLocation.angles, buttonText3 )
	
	//mkos 
	entity restingRoomPanel_IBMM_button = CreateFRButton( waitingRoomPanelLocation.origin - (AnglesToForward( waitingRoomPanelLocation.angles ) * 100) - <0,25,0>, waitingRoomPanelLocation.angles + <0,45,0>, buttonText4 )
	entity restingRoomPanel_lock1v1_button = CreateFRButton( waitingRoomPanelLocation.origin + (AnglesToForward( waitingRoomPanelLocation.angles ) * 100) - <0,25,0>, waitingRoomPanelLocation.angles - <0,45,0>, buttonText5 )
	
	
	float rest_offset = -20;
	float nothing_offset = 20;
	if(bMap_mp_rr_party_crasher)
	{
		rest_offset = -40;
		nothing_offset = 10;
	}
	
	entity restingRoomPanel_start_in_rest_setting_button = CreateFRButton( waitingRoomPanelLocation.origin + (AnglesToForward( waitingRoomPanelLocation.angles ) * 100) - <rest_offset,80,0>, waitingRoomPanelLocation.angles - <0,90,0>, buttonText6 )
	entity restingRoomPanel_toggle_input_banner = CreateFRButton( waitingRoomPanelLocation.origin - (AnglesToForward( waitingRoomPanelLocation.angles ) * 100) - <nothing_offset,80,0>, waitingRoomPanelLocation.angles - <0,-90,0>, buttonText7 )
	//endkos
	
	AddCallback_OnUseEntity( restingRoomPanel, void function(entity panel, entity user, int input)
	{
		if(!IsValid(user)) return
		if(!isPlayerInRestingList(user))
		{
			if(file.IS_CHINESE_SERVER)
				Message(user,"您必须在休息模式中才能使用观战功能您","请在控制台中输入'rest'进入休息模式")
			else
				Message(user,"You must be in resting mode to spectate others!","Input 'rest' in console to enter resting mode ")
			
			return //不在休息队列中不能使用观战功能
		}
		if( GetTDMState() != eTDMState.IN_PROGRESS )
		{
			Message( user, "Game is not playing" )
			return
		}



	    try
	    {
	    	array<entity> enemiesArray = GetPlayerArray_Alive()
			enemiesArray.fastremovebyvalue( user )
			
			#if TRACKER
			if( bBotEnabled() && IsValid ( eMessageBot() ) && IsAlive( eMessageBot() ) )
			{
				enemiesArray.fastremovebyvalue( eMessageBot() )
			}
			#endif
			
		    entity specTarget = enemiesArray.getrandom()

	    	user.p.isSpectating = true
			user.SetPlayerNetInt( "spectatorTargetCount", GetPlayerArray().len() )
			user.SetObserverTarget( specTarget )
			user.SetSpecReplayDelay( 0.5 )
			user.StartObserverMode( OBS_MODE_IN_EYE )
			thread CheckForObservedTarget(user)
			user.p.lastTimeSpectateUsed = Time()

			if(file.IS_CHINESE_SERVER)
				Message(user,"按一下空格后结束观战")
			else
				Message(user,"Jump to stop spectating")
			
			user.MakeInvisible()

	    }
	    catch (error333)
	    {}
	    AddButtonPressedPlayerInputCallback( user, IN_JUMP,endSpectate  )
	})
	
	//mkos
	AddCallback_OnUseEntity( restingRoomPanel_IBMM_button, void function(entity panel, entity user, int input)
	{
		if( !IsValid( user ) ){ return }
		
		if( user.p.IBMM_grace_period > 0 )
		{
			user.p.IBMM_grace_period = 0;
			SavePlayer_wait_time( user, 0.0 )
			Message( user, "IBMM set to ANY INPUT (disabled).");
		}
		else
		{	
			if ( settings.ibmm_wait_limit >= 3)
			{	
				if ( settings.default_ibmm_wait == 0)
				{
					user.p.IBMM_grace_period = 3;
					SavePlayer_wait_time( user, 3.0 )
				}
				else
				{
					SetDefaultIBMM( user )
				}
				
				Message( user, "IBMM set to search for same input type.");
			}
			else 
			{
				Message( user, "Server does not allow this setting.");
			}
		}
		
	})
	
	
	AddCallback_OnUseEntity( restingRoomPanel_lock1v1_button, void function(entity panel, entity user, int input)
	{
		if(!IsValid(user)) return
		
		if(user.p.lock1v1_setting == true)
		{
			user.p.lock1v1_setting = false;
			SavePlayer_lock1v1_setting( user, false )
			Message( user, "ACCEPT CHALLENGES DISABLED.");
		}
		else
		{	
			user.p.lock1v1_setting = true;
			SavePlayer_lock1v1_setting( user, true )
			Message( user, "ACCEPT CHALLENGES ENABLED.");
		}
		
	})
	
	
	AddCallback_OnUseEntity( restingRoomPanel_start_in_rest_setting_button, void function(entity panel, entity user, int input)
	{
		if(!IsValid(user)) return
		
		if(user.p.start_in_rest_setting == true)
		{
			user.p.start_in_rest_setting = false;
			SavePlayer_start_in_rest_setting( user, false )
			Message( user, "START_IN_REST Disabled");
		}
		else
		{	
			user.p.start_in_rest_setting = true;
			SavePlayer_start_in_rest_setting( user, true )
			Message( user, "START_IN_REST Enabled.");
		}
		
	})
	
	AddCallback_OnUseEntity( restingRoomPanel_toggle_input_banner, void function(entity panel, entity user, int input)
	{
		if(!IsValid(user)) return
		
		if(user.p.enable_input_banner == true)
		{
			user.p.enable_input_banner = false;
			SavePlayer_enable_input_banner( user, false )
			Message( user, "INPUT_BANNER Disabled");
		}
		else
		{	
			user.p.enable_input_banner = true;
			SavePlayer_enable_input_banner( user, true )
			Message( user, "INPUT_BANNER Enabled.");
		}
		
	})
	
	
	//endkos
	
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
	realmSlots.resize( MAX_REALM + 1 )
	realmSlots[ 0 ] = true
	for (int i = 1; i < realmSlots.len(); i++)
	{
		realmSlots[ i ] = false
	}
	
	string buttonText2
	
	if(file.IS_CHINESE_SERVER)
	{
		buttonText2 = "%&use% 不再更换对手"
	}
	else
	{
		buttonText2 = "%&use% Never change your opponent"
	}

	forbiddenZoneInit(GetMapName())
	thread soloModeThread(getWaitingRoomLocation())

}

void function soloModeThread(LocPair waitingRoomLocation)
{
	//printt("solo mode thread start!")

	string Text5

	if(file.IS_CHINESE_SERVER)
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
		
		//遍历等待队列 - cycle waiting queue (mkos version)
		foreach ( playerHandle, playerInWaitingStruct in file.soloPlayersWaiting )
		{
			if ( !IsValid( playerInWaitingStruct.player ) )
			{
				deleteWaitingPlayer(playerInWaitingStruct.handle) //struct contains players handle as basic int
				continue
			}

			// check/update ibmm timeouts -- temporary try catch to test pinpoint
			try 
			{
				if ( Time() - playerInWaitingStruct.queue_time > playerInWaitingStruct.player.p.IBMM_grace_period )
				{
					playerInWaitingStruct.IBMM_Timeout_Reached = true;
				}
				else
				{
					playerInWaitingStruct.IBMM_Timeout_Reached = false;
				}
			} 
			catch (varerror)
			{
				sqerror("\n\n --- DEBUGIT ERROR --- \n " + varerror )
				if( typeof( playerInWaitingStruct.queue_time ) != "float" )
				{
					sqerror( "playerInWaitingStruct.queue_time was not a float" )
				}
				
				if( typeof( playerInWaitingStruct.player.p.IBMM_grace_period ) != "float" )
				{
					sqerror( "playerInWaitingStruct.player.p.IBMM_grace_period was not a float" )
				}
				
				continue //onward
			}

			//timeout preferred matchmaking 
			if (playerInWaitingStruct.waitingTime < Time() && !playerInWaitingStruct.IsTimeOut && IsValid(playerInWaitingStruct.player))
			{
				playerInWaitingStruct.IsTimeOut = true;
			}
		}//foreach


		//遍历游玩队列
		array<soloGroupStruct> groupsToRemove;
		bool quit;
		bool removed;
		
		foreach (groupHandle, group in file.groupsInProgress) 
		{
			quit = false
			removed = false
			//if(!IsValid(group))
			//{
			//	sqerror("Logic flow error 0002: group was invalid")
			//	removeGroupByHandle(groupHandle)
			//}
			//else 
			//{	
				if(!IsValid(group))
				{
					removed = true
				}
				
				if ( !removed && group.IsFinished ) //this round has been finished //IsValid(group) &&
				{
					SetIsUsedBoolForRealmSlot( group.slotIndex, false )
					
					soloModePlayerToWaitingList( group.player1 )
					soloModePlayerToWaitingList( group.player2 )
					destroyRingsForGroup( group )
					
					if ( IsValid(group.player1) )
					{
						processRestRequest( group.player1 )
						HolsterAndDisableWeapons( group.player1 )
					}					
					if ( IsValid(group.player2) )
					{
						processRestRequest( group.player2 )
						HolsterAndDisableWeapons( group.player2 )
					}	
					
					#if DEVELOPER
					sqprint("remove group request 04")
					#endif
					
					while(mGroupMutexLock) 
					{
						#if DEVELOPER
						sqprint("Waiting for lock to release R004")
						#endif
						WaitFrame() 
					}
					
					groupsToRemove.append(group)
					quit = true
				}
				
				if ( !removed && group.IsKeep ) 
				{
					if (IsValid( group.player1 ) && IsValid( group.player2 ) && ( !IsAlive( group.player1 ) || !IsAlive( group.player2 ) )) 
					{
						int p1 = 0
						int p2 = 1
						
						if(group.cycle)
						{
							group.groupLocStruct = soloLocations.getrandom()	
						}
						
						if(group.swap)
						{
							p1 = CoinFlip() ? 1 : 0;		
							p2 = p1 == 0 ? 1 : 0;
						}
						
						bool nowep = false;
						if ( processRestRequest( group.player1 ))
						{	
							nowep = true
							processRestRequest( group.player1 )
						}
						else 
						{
							_CleanupPlayerEntities( group.player1 )
							thread respawnInSoloMode(group.player1, p1)
						}
						
						
						if ( processRestRequest( group.player1 ))
						{
							nowep = true
							processRestRequest( group.player1 )
						}
						else 
						{
							_CleanupPlayerEntities( group.player2 )
							thread respawnInSoloMode(group.player2, p2)
						}
						
						if(!nowep)
						{					
							GiveWeaponsToGroup( [group.player1, group.player2] )						
						}	
					}//keep
				}
				
				if ( !IsValid( group.player1 ) || !IsValid( group.player2 )) 
				{	
					//printt("solo player quit!!!!!")
					if ( !removed && IsValid(group.player1)) 
					{
						if(processRestRequest( group.player1 )){ continue }	
						soloModePlayerToWaitingList( group.player1 ) //back to wating list
						HolsterAndDisableWeapons( group.player1 )
						Message( group.player1, Text5 ) 
					}

					if ( !removed && IsValid( group.player2 ) ) 
					{
						if(processRestRequest( group.player2 )){ continue }
						soloModePlayerToWaitingList(group.player2) //back to wating list
						HolsterAndDisableWeapons(group.player2)
						Message(group.player2, Text5);
					}
					
					if(!removed)
					{
						SetIsUsedBoolForRealmSlot(group.slotIndex, false);
					}
					
					#if DEVELOPER
					sqprint("remove group request 05")
					#endif
					groupsToRemove.append(group)
					quit = true
				}
				
				//检测乱跑的脑残
				if(!removed && !quit)
				{
					soloLocStruct groupLocStruct = group.groupLocStruct
					vector Center = groupLocStruct.Center
					array<entity> players = [group.player1,group.player2]
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
			//} //valid
		}//foreach
		
		foreach ( group in groupsToRemove )
		{	
			#if DEVELOPER
			sqprint(format("arrayloop: Removing group: %d", group.groupHandle ))
			#endif 
			while(mGroupMutexLock) 
			{	
				#if DEVELOPER
				sqprint("Waiting for lock to release arrayloop") //no mutex print has ever happened in tests but its still possible
				#endif
				WaitFrame() 
			}
			if(IsValid(group))
			{
				removeGroup(group)
			}
			else 
			{
				#if DEVELOPER
				sqerror("Invalid group cannot be removed by reference alone")
				#endif
			}
		}

		//遍历休息队列
		foreach ( restingPlayerHandle,restingStruct in file.soloPlayersResting )
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
				thread respawnInSoloMode(restingPlayerEntity)
			}
			
			//TakeAllWeapons( restingPlayer )
			HolsterAndDisableWeapons( restingPlayerEntity )
		}

		foreach ( player in GetPlayerArray() )
		{
			if( !IsValid( player ) ) 
				continue
			
			if( isPlayerInSoloMode( player ) )
				continue
			
			//mkos LG_Duel
			float t_radius = 600;
			if ( bMap_mp_rr_canyonlands_staging )
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
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//开始匹配
		
		if(file.soloPlayersWaiting.len()<2) //等待队列人数不足,无法开始匹配
		{	
			
			//mkos
			foreach ( player, solostruct in file.soloPlayersWaiting )
			{			
				if ( !IsValid( player ) )
				{
					continue
				}
				
				if ( solostruct.waitingmsg == true && !solostruct.player.p.challengenotify )
				{
					if(!IsValid(solostruct) || !IsValid(solostruct.player))
					{
						continue
					}
					
					Remote_CallFunction_NonReplay( solostruct.player, "ForceScoreboardLoseFocus" );
					CreatePanelText(solostruct.player, "", "Waiting for\n   players...",IBMM_WFP_Coordinates(),IBMM_WFP_Angles(), false, 2.5, solostruct.player.p.handle )
					SetMsg( solostruct.player, false )
					file.APlayerHasMessage = true;	
				}
			}

			continue		
		}  
		else if (file.APlayerHasMessage) 
		{
			foreach ( player in GetPlayerArray() )
			{
				if ( !IsValid( player ) )
				{
					continue
				}
				
				RemovePanelText( player, player.p.handle )
			}
			
			file.APlayerHasMessage = false;
		}

		// printt("------------------more than 2 player in solo waiting array,matching------------------")
		soloGroupStruct newGroup
		entity opponent
		bool bMatchFound = false
		//优先处理超时玩家
		//player1:超时的玩家,player2:随机从等待队列里找一个玩家
		
		//check challenges first
		foreach ( playerHandle, eachPlayerStruct in file.soloPlayersWaiting ) //找player1
		{	
			if(!IsValid(eachPlayerStruct))
			{
				continue
			}					
			
			entity playerSelf = eachPlayerStruct.player
			bool player_IBMM_timeout = eachPlayerStruct.IBMM_Timeout_Reached		
			//challenge system
			if( isPlayerPendingChallenge(playerSelf) )
			{
				entity Lock1v1Opponent = getLock1v1OpponentOfPlayer( playerSelf )
				
				if (IsValid(Lock1v1Opponent))
				{
					//sqprint("HERE IT IS")
					newGroup.player1 = playerSelf
					newGroup.player2 = Lock1v1Opponent
					
					newGroup.IsKeep = true
					newGroup.player1.p.waitingFor1v1 = false 
					newGroup.player2.p.waitingFor1v1 = false
					Message(newGroup.player1, "1v1 CHALLENGE STARTED")
					Message(newGroup.player2, "1v1 CHALLENGE STARTED")
					bMatchFound = true
					break
				}
				else 
				{
					//sqprint("waiting for lockmatch TIMEOUT matching")
					continue //these guys are still waiting for each other
				}
			}
		}
	
		if( !bMatchFound && getTimeOutPlayerAmount() > 0 )//存在已经超时的玩家
		{
			//sqprint("TIME OUT MATCHING")
			// Warning("Time out matching")
			newGroup.player1 = getTimeOutPlayer()  //获取超时的玩家
			if(IsValid(newGroup.player1))//存在超时等待玩家
			{
				//sqprint("Player 1 found: " + newGroup.player1.GetPlayerName() + " waiting for same input or IBMM grace period time out")
				opponent = getRandomOpponentOfPlayer(newGroup.player1)
				
				//mkos
				if(IsValid(opponent))
				{
					newGroup.player1.p.notify = false;
					newGroup.player1.p.destroynotify = true;
					newGroup.player2 = opponent
				} 
				else 
				{
					newGroup.player1.p.notify = true;
					newGroup.player1.p.destroynotify = false;
				}
							
			}
		}//超时玩家处理结束
		else if ( !bMatchFound )//不存在已超时玩家,正常按照kd匹配	
		{	
		
			// Warning("Normal matching")
			foreach ( playerHandle, eachPlayerStruct in file.soloPlayersWaiting ) //找player1
			{	
				if(!IsValid(eachPlayerStruct))
				{
					continue
				}					
				
				entity playerSelf = eachPlayerStruct.player
				bool player_IBMM_timeout = eachPlayerStruct.IBMM_Timeout_Reached
				float selfKd = eachPlayerStruct.kd
				table <entity,float> properOpponentTable
				
				foreach ( opponentHandle, eachOpponentPlayerStruct in file.soloPlayersWaiting ) //找player2
				{					
					entity eachOpponent = eachOpponentPlayerStruct.player
					float opponentKd = eachOpponentPlayerStruct.kd
					bool opponent_IBMM_timeout = eachOpponentPlayerStruct.IBMM_Timeout_Reached
					
					if( isPlayerPendingChallenge(eachOpponent) || isPlayerPendingLockOpponent(eachOpponent) )
					{
						//sqprint("waiting for lockmatch main matching")
						continue //these guys are trying to lock with each other
					}
					
					//this makes sure we don't compare same player as opponent during MM -- mkos clarification
					if(playerSelf == eachOpponent || !IsValid(eachOpponent))//过滤非法对手
						continue
						
					if(fabs(selfKd - opponentKd) > file.SBMM_kd_difference ) //过滤kd差值
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
				if( (bestOpponent != lastOpponent && Fetch_IBMM_Timeout_For_Player( bestOpponent ) == true && Fetch_IBMM_Timeout_For_Player( playerSelf ) == true ) || ( bestOpponent != lastOpponent && Fetch_IBMM_Timeout_For_Player( playerSelf ) == false && Fetch_IBMM_Timeout_For_Player( bestOpponent ) == false && playerSelf.p.input == bestOpponent.p.input ) ) //最合适玩家是上局对手,用第二合适玩家代替
				{				
						bool inputresult = playerSelf.p.input == bestOpponent.p.input ? true : false;
						
						//sqprint(format("Player found: ibmm timeout: %s, INputs are same?: ", Fetch_IBMM_Timeout_For_Player(bestOpponent), inputresult  ));
					
						// Warning("Best opponent, kd gap: " + lowestKd)
						newGroup.player1 = playerSelf
						newGroup.player2 = bestOpponent			
					
						break			
				}
				else if ( IsValid(scondBestOpponent) && scondBestOpponent != lastOpponent && Fetch_IBMM_Timeout_For_Player( playerSelf ) == true && Fetch_IBMM_Timeout_For_Player( scondBestOpponent ) == true || IsValid(scondBestOpponent) && scondBestOpponent != lastOpponent && Fetch_IBMM_Timeout_For_Player( playerSelf ) == false && Fetch_IBMM_Timeout_For_Player( scondBestOpponent ) == false && playerSelf.p.input == scondBestOpponent.p.input )
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

		if ( !IsValid(newGroup.player1) || !IsValid(newGroup.player2) ) 
		{
			SetIsUsedBoolForRealmSlot(newGroup.slotIndex, false);
			if (IsValid(newGroup.player1)) 
			{
				soloModePlayerToWaitingList(newGroup.player1);
			}
			
			if (IsValid(newGroup.player2)) 
			{
				soloModePlayerToWaitingList(newGroup.player2);
			}
			continue;
		}
		
		//don't pair players if they are waiting for their chal player
		if( !newGroup.player1.p.waitingFor1v1 && !newGroup.player2.p.waitingFor1v1 )
		{		

			//already matched two players
			array<entity> players = [newGroup.player1,newGroup.player2]
		
			//mkos
			if ( Fetch_IBMM_Timeout_For_Player( newGroup.player1 ) == false || Fetch_IBMM_Timeout_For_Player( newGroup.player2 ) == false && newGroup.player1.p.input == newGroup.player2.p.input )
			{			
				newGroup.GROUP_INPUT_LOCKED = true;
			} 
			else 
			{
				newGroup.GROUP_INPUT_LOCKED = false;
			}
			
			thread soloModePlayerToInProgressList(newGroup)

			foreach (index,eachPlayer in players )
			{
				EnableOffhandWeapons( eachPlayer )
				DeployAndEnableWeapons( eachPlayer )
				thread respawnInSoloMode(eachPlayer, index)
			}
			
			GiveWeaponsToGroup( players )

			FS_SetRealmForPlayer( newGroup.player1, newGroup.slotIndex )
			FS_SetRealmForPlayer( newGroup.player2, newGroup.slotIndex )		
			
			//mkos
			
			string e_str = "";
			
			if ( newGroup.GROUP_INPUT_LOCKED == true )
			{	
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
			
			if(newGroup.player1.p.enable_input_banner && !bMatchFound )
			{
				Message( newGroup.player1 , e_str, "VS: " + newGroup.player2.p.name + "   USING -> " + FetchInputName( newGroup.player2 ) , 2.5)
			}
			
			if ( newGroup.player2.p.IBMM_grace_period == 0 && newGroup.GROUP_INPUT_LOCKED == false )
			{ e_str = "ANY INPUT"; }
			
			if(newGroup.player2.p.enable_input_banner && !bMatchFound )
			{
				Message( newGroup.player2 , e_str, "VS: " + newGroup.player1.p.name + "   USING -> " + FetchInputName( newGroup.player1 ) , 2.5)
			}
		} //not waiting
		
		array<int> deletions // player_eHandle
		
		//cleanup lock1v1 table
		foreach( player1_eHandle, player2 in file.acceptedChallenges ) 
		{
			entity player1 = GetEntityFromEncodedEHandle( player1_eHandle )
			
			if ( !IsValid(player1) || !IsValid(player2) ) 
			{
				
				if( IsValid(player1 ) )
				{
					player1.p.waitingFor1v1 = false
				}
				
				if( IsValid( player2 ) )
				{
					player2.p.waitingFor1v1 = false
				}
				
				deletions.append(player1_eHandle);
			}
		}
		
		if( deletions.len() > 0 )
		{
			foreach( playerKey in deletions ) 
			{
				delete file.acceptedChallenges[playerKey];
			}
			
			deletions.resize(0)
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

//mkos input watch
void function InputWatchdog( entity player, entity opponent, soloGroupStruct group )
{
	#if DEVELOPER
	sqprint( format("THREAD FOR GROUP STARTED" ))
	#endif
	
	EndSignal( player, "InputChanged" )
	EndSignal( opponent, "InputChanged" )
	EndSignal( player, "OnDeath" )
	EndSignal( opponent, "OnDeath" )
	EndSignal( player, "PlayerDisconnected" )
	EndSignal( opponent, "PlayerDisconnected" )
		
		#if DEVELOPER
		sqprint("Waiting for input to change");
		#endif
	
	OnThreadEnd(
		function() : ( player, opponent, group )
		{
			#if DEVELOPER
			sqprint( format("THREAD FOR GROUP ENDED" ))
			#endif
			
			if ( player.p.input != opponent.p.input )
			{	
				if(IsValid(player))
				{
					Remote_CallFunction_NonReplay( player, "ForceScoreboardLoseFocus" );			
					Message( player, "INPUT CHANGED", "A player's input changed during the fight", 3, "weapon_vortex_gun_explosivewarningbeep" )
				}
				
				if(IsValid(opponent))
				{
					Remote_CallFunction_NonReplay( opponent, "ForceScoreboardLoseFocus" );
					Message( opponent, "INPUT CHANGED", "A player's input changed during the fight", 3, "weapon_vortex_gun_explosivewarningbeep" )
				}
				
				if(IsValid(group))
				{
					group.IsFinished = true
				}
			}
		}	
	)
	
	WaitForever()
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
		
		int random_character_index 
		ItemFlavor random_character
		
		if (bGiveSameRandomLegendToBothPlayers)
		{
			random_character_index = RandomIntRangeInclusive(0,characterslist.len()-1)
			
			if( random_character_index <= 10 )
			{
				random_character = characters[characterslist[random_character_index]]
			}
		}
		
		foreach( player in players )
		{
			if( !IsValid( player ) )
				continue
			
			if (bGiveSameRandomLegendToBothPlayers && random_character_index <= 10 )
			{	
				CharacterSelect_AssignCharacter( ToEHI( player ), random_character )
			}
			
			
			DeployAndEnableWeapons( player )

			if ( !(player.p.name in weaponlist))//avoid give weapon twice if player saved his guns //TODO: change to eHandle - mkos
			{
				TakeAllWeapons(player)

				GivePrimaryWeapon_1v1( player, primaryWeaponWithAttachments, WEAPON_INVENTORY_SLOT_PRIMARY_0 )
				GivePrimaryWeapon_1v1( player, secondaryWeaponWithAttachments, WEAPON_INVENTORY_SLOT_PRIMARY_1 )
				//Remote_CallFunction_NonReplay(player, "ServerCallback_ToggleDotForHitscanWeapons", true)			
			} 
			else
			{
				thread LoadCustomWeapon(player)
			}

			player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
			player.TakeOffhandWeapon( OFFHAND_MELEE )
			
			if (!g_bLGmode)
			{	
				player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
				player.GiveOffhandWeapon( "melee_pilot_emptyhanded", OFFHAND_MELEE, [] )
			}	
				
		}
		
		isPlayerPendingChallenge( players[0] )
		{
			soloGroupStruct group = returnSoloGroupOfPlayer( players[0] )
			
			if(group.IsKeep)
			{
				_decideLegend( group )	
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
	//entity weaponNew = player.GiveWeapon_NoDeploy( weaponclass , slot, Mods, false )

	//SetupInfiniteAmmoForWeapon( player, weaponNew )
	
	int ammoType = weaponNew.GetWeaponAmmoPoolType()
	player.AmmoPool_SetCapacity( 65535 )
	player.AmmoPool_SetCount( ammoType, 9999 )
	
	player.ClearFirstDeployForAllWeapons()
	player.DeployWeapon()

	if( weaponNew.UsesClipsForAmmo() )
		weaponNew.SetWeaponPrimaryClipCount( weaponNew.GetWeaponPrimaryClipCountMax())
		

	if( weaponNew.LookupAttachment( "CHARM" ) != 0 )
		weaponNew.SetWeaponCharm( $"mdl/props/charm/charm_nessy.rmdl", "CHARM")
}

string function ReturnRandomPrimaryMetagame_1v1()
{	
	return Weapons.getrandom()
}

string function ReturnRandomSecondaryMetagame_1v1()
{	
	return WeaponsSecondary.getrandom()
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
		{
			continue
		}

		soloGroupStruct group = returnSoloGroupOfPlayer(player) 	
		if(IsValid(group))
		{
			destroyRingsForGroup(group)		
			if(!group.IsKeep)
			{
				group.IsFinished = true //tell solo thread this round has finished
			}
		}
		
		soloModePlayerToWaitingList( player )
		FS_ClearRealmsAndAddPlayerToAllRealms( player )
		HolsterAndDisableWeapons( player )
	}
	
	foreach( challengeStruct in file.allChallenges )
	{
		if( !IsValid( challengeStruct ) ){ continue }
		
		if( IsValid (challengeStruct.player) )
		{
			endLock1v1( challengeStruct.player )
		}
	}
	
	if(GetCurrentRound() > 0)
	{
		//soloPlayersInProgress.clear()
		//file.soloPlayersWaiting = {} //needed?
		file.groupsInProgress.clear()
		file.playerToGroupMap.clear()
		ClearAllNotifications()
	}
	
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
				
			//TODO add party crasher?
				
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
				
			case "mp_rr_party_crasher":
				angles = < 1822.39, -3977.1, 626.106 >
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
			
				coordinates = < -3, 687.949, 300.174 >
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
				
			case "mp_rr_party_crasher":
				coordinates = < 1785, -3835.48, 810.953 >
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
			
				angles = < 0, 90, 0 >;
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
				
			case "mp_rr_party_crasher":
				angles = < 0, 105, 0 >
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


void function notify_thread( entity player ) //whole thing is convoluted as fuck
{	
	if ( !IsValid( player ) )
	{
		return //this is threaded off so we want to check again
	}
	
	EndSignal( player, "PlayerDisconnected" )
	
	int id = player.p.handle + 1
	int iChallengeTextID = id + 1
	int iStatusText = 0
	
	//challenges
	bool waitingForSelfToJoin = false 
	bool HasChalText = false
	
	while(true)
	{		
		//sqprint( "notify thread running for " + player.p.name )	
		wait 1
		
		if (!IsValid( player )){break}
		
		if ( player.p.notify == true && player.p.has_notify == false )
		{
			//sqprint("CREATING 001")
			Remote_CallFunction_NonReplay( player, "ForceScoreboardLoseFocus" );
			CreatePanelText(player, "", "Matching for: " + FetchInputName( player ) , IBMM_COORDINATES, IBMM_ANGLES, false, 2, id )
			//sqprint("Creating on screen match making for " + player.GetPlayerName() )
			player.p.has_notify = true; //let thread self know not to create multiple displays	
		}
	
		if ( player.p.destroynotify == true && player.p.notify == false )
		{	
			//sqprint("REMOVING 001")
			RemovePanelText( player, id )
			player.p.destroynotify = false;
			player.p.has_notify = false;		
		}
		
		///////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////
		
		if( player.p.challengenotify )
		{
			if( !HasChalText )
			{
				//sqprint("CREATING 002")
				RemovePanelText( player, player.p.handle ) //removes waiting for players
				thread UpdateChallengeText( player, iChallengeTextID, "Challenge Started" )
				HasChalText = true 
				wait 2
				if (!IsValid( player )){break}
				iStatusText = 2
			}
		
			if ( !isPlayerInWaitingList( player ) )
			{			
				if( iStatusText != 3 )
				{
					//sqprint("CREATING 003")
					player.Signal( "NotificationChanged" )
					thread UpdateChallengeText( player, iChallengeTextID, "Join the queue to start the challenge" )
					iStatusText = 3
				}
				
				wait 1
				continue
			}
			
			entity challenged = player.p.eLastChallenger
			
			if( !IsValid (challenged) )
			{
				continue //do something
			}
			else 
			{			
				if( !isPlayerInWaitingList(challenged) )
				{			
					wait 1
						
					if( iStatusText != 4 )
					{
						//sqprint("CREATING 004")	
						Remote_CallFunction_NonReplay( player, "ForceScoreboardLoseFocus" )
						string alert = "Waiting for " + challenged.p.name + "\n to join the queue..."
						if (!IsValid( player )){break}
						player.Signal( "NotificationChanged" )
						thread UpdateChallengeText( player, iChallengeTextID, alert )
						iStatusText = 4
					}
				}
			}
		}
		else 
		{
			HasChalText = false
			iStatusText = 0			
		}
	}
}

void function UpdateChallengeText( entity player, int id, string text )
{
	wait .2
	entity opponent = player.p.eLastChallenger
	EndSignal( player, "NotificationChanged" )
	EndSignal( opponent, "PlayerDisconnected" )
	CreatePanelText( player, "", text, IBMM_COORDINATES, IBMM_ANGLES, false, 2, id )
	
	OnThreadEnd( function() : ( player, id )
		{
			if( IsValid( player ) )
			{
				//sqprint( format( "Removing panel for player %s id: %d", player.p.name, id ) )
				RemovePanelText( player, id )
			}
		}
	)
	WaitForever()
}

void function ClearAllNotifications()
{
	foreach ( player in GetPlayerArray() )
	{
		if( !IsValid( player ) ){continue}
		
		RemovePanelText( player, player.p.handle )
		RemovePanelText( player, player.p.handle + 1 )
		RemovePanelText( player, player.p.handle + 2 )
	}
}

void function _CleanupPlayerEntities( entity player )
{
	DestroyAllTeslaTrapsForPlayer( player )	// no signal for destroying by owner.. (designed to persist)
	//player.Signal( "OnDestroy" ) //this takes care of most tacticals
	
	player.Signal( "CleanUpChallenge1v1" ) 	
	
	if( IsValid( CryptoDrone_GetPlayerDrone( player ) ) )
	{
		GetPlayerOutOfCamera( player )// why isn't this set up? -> Signal( "ExitCameraView" )
		CryptoDrone_GetPlayerDrone( player ).Destroy()
	}
	
	if( IsValid(player.p.lastDecoy) )
	{
		player.p.lastDecoy.Destroy()
	}
}

LocPair function getBotSpawn()
{	
	LocPair move;
	switch(GetMapName())
	{
		case "mp_rr_arena_composite":
			move.origin = < 4.00458, -219.602, 202.3 >
			move.angles = < 9.97307, 83.8519, 0 >
			break
		case "mp_rr_aqueduct":
			move.origin = < 1044.03, -5510.88, 336.031 >
			move.angles = < 12.4284, 314.095, 0 >
			break	
		case "mp_rr_party_crasher":
			move.origin = < 2065.89, -4216.35, 626.106 >
			move.angles = < 15.6277, 115.51, 0 >
			break
			
		default: 
		move.origin = <0,0,0>
		move.angles = <0,0,0>
	}
	
	return move
}

const array<int> LegendGUID_EnabledPassives = [
	
	725342087, //ref character_bangalore
	
]

const array<int> LegendGUID_EnabledUltimates = [
	
	898565421, //ref character_bloodhound
	187386164, //ref character_wattson
	2045656322, //ref character_mirage
	843405508 //ref character_octane

]

void function RechargePlayerAbilities( entity player )
{
	if( !IsValid( player ) ){ return }
	
	ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
	
	//sqprint( format("LEGEND: %s, GUID: %d", ItemFlavor_GetHumanReadableRef( character ), ItemFlavor_GetGUID( character ) ))
	ItemFlavor tacticalAbility = CharacterClass_GetTacticalAbility( character )
	player.GiveOffhandWeapon(CharacterAbility_GetWeaponClassname(tacticalAbility), OFFHAND_TACTICAL, [] )
	
	int charID = ItemFlavor_GetGUID( character )
	
	if( LegendGUID_EnabledPassives.contains( charID ) )
	{
		GivePassive( player, 0 )
		/* //Only needed if passive list expands
		TakeAllPassives( player )
		ItemFlavor passive = CharacterClass_GetPassiveAbility( character )
		GivePassive( player, CharacterAbility_GetPassiveIndex( passive ) )
		*/
	}

	if( LegendGUID_EnabledUltimates.contains( charID ) ) 
	{
		ItemFlavor ultiamteAbility = CharacterClass_GetUltimateAbility( character )
		player.GiveOffhandWeapon( CharacterAbility_GetWeaponClassname( ultiamteAbility ), OFFHAND_ULTIMATE, [] )
	}

	
	if(IsValid(player.GetOffhandWeapon( OFFHAND_INVENTORY )))
	player.GetOffhandWeapon( OFFHAND_INVENTORY ).SetWeaponPrimaryClipCount( player.GetOffhandWeapon( OFFHAND_INVENTORY ).GetWeaponPrimaryClipCountMax() )

	if(IsValid(player.GetOffhandWeapon( OFFHAND_LEFT )))
	{
		player.GetOffhandWeapon( OFFHAND_LEFT ).SetWeaponPrimaryClipCount( player.GetOffhandWeapon( OFFHAND_LEFT ).GetWeaponPrimaryClipCountMax() )
		
		//Fix for grapple not recharging after grappling server created props
		player.SetSuitGrapplePower(100)
	}
}