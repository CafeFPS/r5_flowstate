// Search and Destroy
// Made by @CafeFPS - Server, Client and UI

// Aeon#0236 - Playtests and ideas
// AyeZee#6969 - Some of the economy system logic from his arenas mode draft - stamina
// @dea_bb - Shoothouse, de_cache and NCanals maps
// @CafeFPS and Darkes#8647 - de_dust2 map model port and fake collision
// VishnuRajan in https://sketchfab.com/3d-models/time-bomb-efb2e079c31349c1b2bd072f00d8fe79 - Bomb model and textures

global function _GamemodeSND_Init

global function SetBombEntity
global function GetBombEntity
global function SetBombState
global function GetBombState
global function SetPlantedBombEntity
global function GetPlantedBombEntity
global function UpdateRoundEndTime
global function GetRoundEndTime
global function _OnPlayerConnectedSND

struct{
	//general
	int currentRound = 1
	entity ringBoundary
	int currentLocation = 0
	int winnerTeam
	int lastRoundWinnerTeam = 0
	float endTime
	bool InProgress
	vector lobbyLocation
	vector lobbyAngles
	array<entity> playerSpawnedProps
	int attackerTeam
	bool forceRoundEnd
	bool buyAllowed

	//tiebreaker logic
	bool canImcWinNextRound = false
	bool canMilitiaWinNextRound = false

	//bomb system
	entity bomb
	entity plantedBomb
	int currentBombState

	//1-/1+ win/loss streak for economy system
	int IMC_ConsecutiveLoses = 0
	int MILITIA_ConsecutiveLoses = 0

	//team select system
	bool selectTeamMenuOpened = false
	int maxvotesallowedforTeamIMC = -1
	int maxvotesallowedforTeamMILITIA = -1
	int requestsforIMC = -1
	int requestsforMILITIA = -1

	bool forceGameStart
} FS_SND

global array<int> snd_allowedCharacters = [8, 7, 4, 9, 1]
const bool SND_GIVE_BODY_SHIELD_BASED_ON_ROUND = false
const bool SND_GIVE_BODY_SHIELD_BASIC = true
const bool SND_ECONOMY_SYSTEM = true
const int SND_GRENADES_LIMIT = 5
const int SND_MAX_MAPS = 5 //increment this 

bool debugdebug = false

void function _GamemodeSND_Init()
{
	if(GetCurrentPlaylistVarBool("enable_global_chat", true))
		SetConVarBool("sv_forceChatToTeamOnly", false)
	else
		SetConVarBool("sv_forceChatToTeamOnly", true)

	AddCallback_OnClientDisconnected( void function(entity player) { 
		SND_OnPlayerDisconnected( player )
	})

	AddCallback_OnPlayerKilled( void function(entity victim, entity attacker, var damageInfo) {
        _OnPlayerKilledSND(victim, attacker, damageInfo)
    })

	AddCallback_EntitiesDidLoad( Sv_EntitiesDidLoad )

	AddClientCommandCallback("AskForTeam", ClientCommand_SND_AskForTeam)

	AddClientCommandCallback("BuySNDWeapon", ClientCommand_BuySNDWeapon)
    AddClientCommandCallback("BuySNDGrenade", ClientCommand_BuySNDGrenade)
    AddClientCommandCallback("BuySNDAbility", ClientCommand_BuySNDAbility)

	AddClientCommandCallback("SellSNDAbility", ClientCommand_SellSNDAbility)
	AddClientCommandCallback("SellSNDGrenade", ClientCommand_SellSNDGrenade)
	AddClientCommandCallback("SellSNDWeapon", ClientCommand_SellSNDWeapon)
	
	#if DEVELOPER
	AddClientCommandCallback("next_round", ClientCommand_NextRoundSND)

	AddClientCommandCallback("Debug_OpenBuyMenu", ClientCommand_OpenBuyMenu)
    AddClientCommandCallback("Debug_ToggleSelectTeamMenu", ClientCommand_OpenSelectTeamMenu)
	AddClientCommandCallback("Debug_ForceStartGame", ClientCommand_ForceStartGame)
	#endif
	
	RegisterSignal("EndLobbyDistanceThread")
	RegisterSignal("EndWayPointThread")
	RegisterSignal( "FlagPhysicsEnd" )

	PrecacheModel($"mdl/Weapons/bomb/ptpov_bomb.rmdl")
	PrecacheModel($"mdl/Weapons/bomb/w_bomb.rmdl")
	
	FS_SND.currentLocation = GetCurrentPlaylistVarInt( "SND_force_initial_map", 0 )
	
	if( GetCurrentPlaylistVarInt( "SND_force_initial_map", 0 ) == SND_MAX_MAPS + 1 )
		FS_SND.currentLocation = RandomInt( SND_MAX_MAPS + 1 )

	PrecacheDust2()
	PrecacheDefuseMapProps()
	PrecacheDEAFPSMapProps()
	PrecacheZeesMapProps()
	de_NCanals_precache()

	thread SND_StartGameThread()
}

void function Sv_EntitiesDidLoad()
{
	switch( MapName() )
	{
		// case eMaps.mp_rr_olympus_mu1:
			// FS_SND.lobbyLocation = <-6940.96924, 21153.9219, -6147.95166>
			// FS_SND.lobbyAngles = <0, -101.100929, 0>
			
			// SpawnVotePhaseCustomMaps()
			// AddSpawnCallback("prop_dynamic", _OnPropDynamicSpawned)
			// break
		case eMaps.mp_rr_arena_empty:
			SpawnFlowstateLobbyProps( <0,0,5000> )
			SpawnVotePhaseCustomMaps()

			FS_SND.lobbyLocation = <0,0,5072>
			FS_SND.lobbyAngles = <0,0,0>

			AddSpawnCallback("prop_dynamic", _OnPropDynamicSpawned)
			DestroyPlayerProps()
		break

		case eMaps.mp_rr_arena_composite:
			entity startEnt = GetEnt( "info_player_start" )
			
			FS_SND.lobbyLocation = startEnt.GetOrigin()
			FS_SND.lobbyAngles = startEnt.GetAngles()
		break

		// case eMaps.mp_rr_desertlands_64k_x_64k:
			// FS_SND.lobbyLocation = <17791.3203, 10835.2314, -2985.83618>
			// FS_SND.lobbyAngles = <0, -114.427933, 0>
		// break

		// case "mp_rr_arena_skygarden":
			// FS_SND.lobbyLocation = <-208.090103, 6830.30225, 3138.40137>
			// FS_SND.lobbyAngles = <0, 122, 0>
		// break

		// case eMaps.mp_rr_party_crasher_new:
			// FS_SND.lobbyLocation = <-1399.06775, 427.32309, 1298.39697>
			// FS_SND.lobbyAngles = <0, 22, 0>
			
			// SpawnVotePhaseCustomMaps()
			// AddSpawnCallback("prop_dynamic", _OnPropDynamicSpawned)
			// DestroyPlayerProps()
		// break
		
	}
	AddSpawnCallback("prop_dynamic", _OnPropDynamicSpawned)
}

void function SND_StartGameThread()
{
    WaitForGameState(eGameState.Playing)
	SND_SHOULD_START_A_NEW_MATCH = true
	
    while(true)
	{
		SND_Lobby()
		SND_GameLoop()
	}
}

void function _OnPropDynamicSpawned(entity prop)
{
    FS_SND.playerSpawnedProps.append(prop)
}

void function DestroyPlayerProps()
{
    foreach(prop in FS_SND.playerSpawnedProps)
    {
        if(IsValid(prop))
            prop.Destroy()
    }
    FS_SND.playerSpawnedProps.clear()
}

void function AssignCharacter( entity player, int index )
{
	ItemFlavor PersonajeEscogido = GetAllCharacters()[index]
	CharacterSelect_AssignCharacter( ToEHI( player ), PersonajeEscogido )		
	
	ItemFlavor playerCharacter = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
	asset characterSetFile = CharacterClass_GetSetFile( playerCharacter )
	player.SetPlayerSettingsWithMods( characterSetFile, [] )

	TakeAllWeapons(player)
}

void function _OnPlayerConnectedSND(entity player)
{
	printt( "_OnPlayerConnectedSND - ", player )

	while(IsDisconnected( player )) WaitFrame()
	
    if(!IsValid(player)) return
	
	if( GetCurrentPlaylistVarBool( "fs_stamina_mod", false ) )
		thread TrackPlayerSprinting( player )
	
	ValidateDataTable( player, "datatable/flowstate_snd_buy_menu_data.rpak" )
	
	//Remote_CallFunction_NonReplay(player, "Minimap_DisableDraw_Internal")
	
	player.SetPlayerGameStat( PGS_DEATHS, 0)

	switch(GetGameState())
    {
		case eGameState.WaitingForPlayers:
		case eGameState.MapVoting:
			player.FreezeControlsOnServer()

			_HandleRespawn(player)
			Survival_SetInventoryEnabled( player, false )
			SetPlayerInventory( player, [] )
			
			if(IsPlayerEliminated(player))
				ClearPlayerEliminated(player)
			
			player.SetThirdPersonShoulderModeOn()
			player.SetVelocity(Vector(0,0,0))

			TakeLoadoutRelatedWeapons(player)

			// player.SetOrigin(FS_SND.lobbyLocation)
			// player.SetAngles(FS_SND.lobbyAngles)
			player.SnapToAbsOrigin( FS_SND.lobbyLocation )
			player.SnapEyeAngles( FS_SND.lobbyAngles )
			player.SnapFeetToEyes()
			break
		case eGameState.Playing:
			thread StartSpectatingSND(player)
			player.UnfreezeControlsOnServer()
			Remote_CallFunction_NonReplay( player, "ServerCallback_SetBombState", GetBombState() )
			//todo give team properly
			//spawn back in map if round is in progress
			
			// player.SetOrigin(FS_SND.lobbyLocation)
			// player.SetAngles(FS_SND.lobbyAngles)
			
			//Set required shit
			
			Remote_CallFunction_Replay(player, "SND_UpdateUIScoreOnPlayerConnected", FS_SND.currentRound, SND_GetIMCWins(), SND_GetMilitiaWins() )
			
			break
		default:
			// player.SetOrigin(FS_SND.lobbyLocation)
			// player.SetAngles(FS_SND.lobbyAngles)
			player.SnapToAbsOrigin( FS_SND.lobbyLocation )
			player.SnapEyeAngles( FS_SND.lobbyAngles )
			player.SnapFeetToEyes()
			break
	}

	player.SetMinimapZoomScale( 0.4, 0.0 )

	SetTeam( player, 99 )
	Remote_CallFunction_Replay( player, "Sh_SetAttackingLocations", FS_SND.currentLocation)
	// Remote_CallFunction_Replay( player, "SetCustomLightning", FS_SND.currentLocation)
	Remote_CallFunction_Replay( player, "Sh_SetAttackerTeam", Sh_GetAttackerTeam(), FS_SND.currentRound)
	
	//Remote_CallFunction_NonReplay(player, "RefreshImageAndScaleOnMinimapAndFullmap")
	Remote_CallFunction_ByRef( player, "RefreshImageAndScaleOnMinimapAndFullmap" )
	Remote_CallFunction_ByRef( player, "Minimap_DisableDraw_Internal" )

	UpdatePlayerCounts()
}

void function SND_OnPlayerDisconnected(entity player)
{
	printt( "_OnPlayerDisconnectedSND - ", player )
	if( !IsValid( player ) || !player.p.playerHasBomb )
		return

	SetBombEntity( SpawnGenericLoot( "snd_bomb", player.GetOrigin() + <0,0,15> , <0,0,0>, 1) )
	SetBombState( bombState.ONGROUND_IDLE )

	if(!IsValid(GetBombEntity())) return

	printt( "Spawned new bomb cuz player disconnected at " + GetBombEntity().GetOrigin() )

	foreach(sPlayer in GetPlayerArray())
	{
		if(!IsValid(sPlayer)) 
			continue

		Remote_CallFunction_NonReplay( sPlayer, "SND_HintCatalog", 11, 0)
	}

}

void function _OnPlayerKilledSND(entity victim, entity attacker, var damageInfo)
{
	if ( !IsValid( victim ) || IsValid(victim) && !victim.IsPlayer() )
		return

	victim.SetPlayerGameStat( PGS_DEATHS, victim.GetPlayerGameStat( PGS_DEATHS ) + 1)
	victim.p.survivedShouldSaveWeapons = false
	// TakeAllWeapons(victim)

	switch(GetGameState())
    {
		case eGameState.Playing:
			if(IsValid(attacker) && attacker.IsPlayer()) 
			{
				int moneytoGive
				bool victimWasBombCarrier = victim.p.playerHasBomb
				entity weapon = DamageInfo_GetWeapon( damageInfo )

				if ( IsValid( weapon ) )
				{
					switch(weapon.GetWeaponClassName())
					{
						case "mp_weapon_sniper":
							moneytoGive = 100
			
						break
						
						case "mp_weapon_wingman":
							moneytoGive = 150
							
						break
						
						default:
							moneytoGive = 200
							
						break							
					}
				}
				
				attacker.p.availableMoney += moneytoGive
				
				if(victimWasBombCarrier)
				{
					moneytoGive += 100
					Remote_CallFunction_NonReplay( attacker, "ServerCallback_OnMoneyAdded", moneytoGive)	
					// Remote_CallFunction_NonReplay( attacker, "SND_HintCatalog", 12, moneytoGive)
					AddPlayerScore( attacker, "FS_SND_EnemyKilled", victim, "", moneytoGive )
				}
				else
				{
					Remote_CallFunction_NonReplay( attacker, "ServerCallback_OnMoneyAdded", moneytoGive)	
					// Remote_CallFunction_NonReplay( attacker, "SND_HintCatalog", 8, moneytoGive)
					AddPlayerScore( attacker, "FS_SND_EnemyKilled", victim, "", moneytoGive )
				}
				
				// thread SND_KillStreakAnnounce(attacker)
			}
			
			if( victim.p.playerHasBomb && victim.p.isSNDAttackerPlayer )
			{
				SetBombEntity( SpawnGenericLoot( "snd_bomb", victim.GetOrigin() + <0,0,32> , <0,0,0>, 1) )
				SetBombState( bombState.ONGROUND_IDLE )
				
				if(!IsValid(GetBombEntity())) return
				
				printt( "spawned new bomb cuz player died at " + GetBombEntity().GetOrigin() )
				Remote_CallFunction_NonReplay( attacker, "SND_HintCatalog", 13, 0)
			}
			
			// CreateFlowStateDeathBoxForPlayer(victim, attacker, damageInfo)
			thread SURVIVAL_Death_DropLoot_Internal( victim, attacker, DamageInfo_GetDamageSourceIdentifier( damageInfo ), true )

			thread function() : (victim, attacker, damageInfo) 
			{
				Remote_CallFunction_NonReplay(victim, "SND_ToggleMoneyUI", false)
				Remote_CallFunction_NonReplay(victim, "ServerCallback_ToggleBombUIVisibility", false)
				
				Remote_CallFunction_NonReplay( victim, "ServerCallback_ForceDestroyPlantingRUI" )
				Remote_CallFunction_NonReplay( victim, "ServerCallback_ForceZoneHintDestroy", false)
				Remote_CallFunction_NonReplay( victim, "ServerCallback_ForceZoneHintDestroy", true)
		
				wait DEATHCAM_TIME_SHORT + 1
				
				if( !IsValid(victim) || GetGameState() != eGameState.Playing) return

				bool atleastOneValidTeammate = false
				foreach( player in GetPlayerArrayOfTeam( victim.GetTeam() ) )
				{
					if( !IsValid(player) || IsValid(player) && player == victim || !IsAlive(player) ) continue
					
					atleastOneValidTeammate = true
				}
				
				if(!atleastOneValidTeammate)
					return

				SetPlayerEliminated( victim )
				thread StartSpectatingSND(victim)
				
				// if( victim.GetTeam() == TEAM_MILITIA) //respawn
				// {
					// entity player = victim
					
					// _HandleRespawn(player)

					// player.SetVelocity(Vector(0,0,0))
				// }
			}()
			
			thread function () : (victim)
			{
				wait 2
				
				if( GetGameState() != eGameState.Playing || !IsValid(victim) ) return
				
				foreach ( player in GetPlayerArrayOfTeam_Alive(victim.GetTeam()) )
				{
					if(!IsValid(player)) continue
					
					//Remote_CallFunction_NonReplay( player, "UpdateRUITest")
					Remote_CallFunction_ByRef( player, "UpdateRUITest" )
				}
			}()
		break
	}
	if(IsValid(attacker) && attacker.IsPlayer() && IsAlive(attacker) && attacker != victim)
	{
		thread EmitSoundOnEntityOnlyToPlayer( attacker, attacker, "flesh_bulletimpact_downedshot_1p_vs_3p" )
		WpnAutoReloadOnKill(attacker)
		GameRules_SetTeamScore(attacker.GetTeam(), GameRules_GetTeamScore(attacker.GetTeam()) + 1)
	}

	UpdatePlayerCounts()
	printt("Flowstate DEBUG - SND player killed.", victim, " -by- ", attacker)
}

void function StartSpectatingSND( entity player )
{	
	WaitFrame()

	if( !IsValid(player) || GetGameState() != eGameState.Playing )
		return
	
	array<entity> clientTeam = GetPlayerArrayOfTeam_Alive( player.GetTeam() )
	clientTeam.fastremovebyvalue( player )
	
	if( clientTeam.len() == 0 ) 
		return
	
	entity specTarget = clientTeam.getrandom()

	if( IsValid( specTarget ) && ShouldSetObserverTarget( specTarget ) )
	{
		//player.SetPlayerNetInt( "spectatorTargetCount", clientTeam.len() )
		printt( "spectator target count set to " + clientTeam.len() )
		player.SetSpecReplayDelay( 1 )
		player.StartObserverMode( OBS_MODE_IN_EYE )
		player.SetObserverTarget( specTarget )
		
		//can we fix spectator system
		printt("[+] " + player.GetObserverTarget(), player.GetFirstObserverTarget())
		
		entity nextTarget = player.GetFirstObserverTarget()
		bool reverse = false
		
		if(IsValid(nextTarget) && nextTarget.GetTeam() != player.GetTeam())
			reverse = true
		
		printt("[+] reverse spectate debug " +  reverse)

		Remote_CallFunction_NonReplay(player, "ServerCallback_UpdateSpectatorTargetCount", clientTeam.len(), reverse)
		//Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Activate")
		Remote_CallFunction_ByRef( player, "ServerCallback_KillReplayHud_Activate" )
		player.p.isSpectating = true
		
		// thread CheckForObservedTarget( specTarget, player )
	}
}

// void function CheckForObservedTarget(entity player, entity observerTarget)
// {
	// if( !IsValid(observerTarget) || !IsValid(player) || observerTarget.GetTeam() != player.GetTeam() )
		// return
	
	// OnThreadEnd(
		// function() : ( player )
		// {
			// if(!IsValid(player.p.lastFrameObservedTarget) || player.p.lastFrameObservedTarget.GetTeam() != player.GetTeam() ) return
			
			// player.p.lastFrameObservedTarget.SetPlayerNetInt( "playerObservedCount", max(0, player.p.lastFrameObservedTarget.GetPlayerNetInt( "playerObservedCount" ) - 1) )
			// player.p.lastFrameObservedTarget = null
		// }
	// )
	// player.p.lastFrameObservedTarget = observerTarget
	// observerTarget.SetPlayerNetInt( "playerObservedCount", observerTarget.GetPlayerNetInt( "playerObservedCount" ) + 1 )
	
	// while(IsValid(player) && player.p.isSpectating && GetGameState() == eGameState.Playing )
	// {
		// observerTarget = player.GetObserverTarget()
		
		// if( !IsValid(observerTarget) || observerTarget != player.p.lastFrameObservedTarget || observerTarget.GetTeam() != player.GetTeam() )
			// break

		// player.p.lastFrameObservedTarget = player.GetObserverTarget()
		// WaitFrame()
	// }
// }

void function _HandleRespawn(entity player)
{
	if(!IsValid(player)) return

	try{
		if(player.p.isSpectating)
		{
			player.p.isSpectating = false
			player.SetObserverTarget( null )
			player.SetPlayerNetInt( "spectatorTargetCount", 0 )
			player.SetSpecReplayDelay( 0 )
			player.StopObserverMode()
			Remote_CallFunction_ByRef( player, "ServerCallback_KillReplayHud_Deactivate" )
			//Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Deactivate")
			Remote_CallFunction_NonReplay(player, "ServerCallback_UpdateSpectatorTargetCount", 0)
		}
	}catch(e420){}

	if(!IsAlive(player)) 
	{
		DecideRespawnPlayer(player, true)
		//Remote_CallFunction_NonReplay(player, "RefreshImageAndScaleOnMinimapAndFullmap")
		Remote_CallFunction_ByRef( player, "RefreshImageAndScaleOnMinimapAndFullmap" )
	}

	player.UnforceStand()
	player.UnfreezeControlsOnServer()
	
	player.SetPlayerNetBool( "pingEnabled", true )
	player.SetMaxHealth( 75 )
	player.SetHealth( 75 )
	player.SetMoveSpeedScale(1)
	
	player.TakeOffhandWeapon(OFFHAND_TACTICAL)
	player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
		
	if(!player.p.survivedShouldSaveWeapons)
		TakeAllWeapons(player)
	
	//GivePassive(player, ePassives.PAS_PILOT_BLOOD)
	player.MovementEnable()
	
	if(IsPlayerEliminated(player))
		ClearPlayerEliminated(player)

	//give flowstate holo sprays
	player.TakeOffhandWeapon( OFFHAND_EQUIPMENT )
	player.GiveOffhandWeapon( "mp_ability_emote_projector", OFFHAND_EQUIPMENT )	
	//GivePassive(player, ePassives.PAS_PILOT_BLOOD)
}

void function SND_Lobby()
{
	FS_SND.InProgress = false
	FS_SND.forceRoundEnd = false
	
	SetGameState(eGameState.MapVoting)
	SetBombState(bombState.NONE)
	
	if(FS_SND.currentRound == 1 && SND_SHOULD_START_A_NEW_MATCH)
	{
		bool enteredwaitingidk = false //Data should be removed, a new game should be created
		FS_SND.forceGameStart = false
		
		wait 5
		
		if(GetPlayerArray().len() < GetCurrentPlaylistVarInt( "max_players", 0 ))
		{
			enteredwaitingidk = true
			
			if(IsValid(FS_SND.ringBoundary))
				FS_SND.ringBoundary.Destroy()
			
			SetDeathFieldParams( <0,0,0>, 100000, 0, 90000, 99999 )
			
			foreach(player in GetPlayerArray())
			{
				if(!IsValid(player)) continue
				Signal( player, "EndLobbyDistanceThread" )
				
				TakeAllWeapons(player)
				thread CheckDistanceWhileInLobby(player)
				Remote_CallFunction_ByRef(player, "Minimap_DisableDraw_Internal")
			}
			
			while( GetPlayerArray().len() < GetCurrentPlaylistVarInt( "max_players", 0 ) && !FS_SND.forceGameStart )
			{
				foreach(player in GetPlayerArray())
				{
					if(!IsValid(player)) continue
					
					Message(player, "SEARCH AND DESTROY", GetPlayerArray_Alive().len() + " players connected of " + GetCurrentPlaylistVarInt( "max_players", 0 ).tostring(), 2, "")
				}
				
				wait 5
			}
		}

		if(enteredwaitingidk)
		{
			foreach(player in GetPlayerArray())
			{
				if(!IsValid(player)) continue
				
				Message(player, "SEARCH AND DESTROY", "STARTING - Get six points to win", 3, "")
			}
			
			wait 3
		}
		
		float endtime = Time() + 10
		
		FS_SND.maxvotesallowedforTeamIMC = int(min(ceil(float(GetPlayerArray().len()) / float(2)), 5.0))
		FS_SND.maxvotesallowedforTeamMILITIA = GetPlayerArray().len() - FS_SND.maxvotesallowedforTeamIMC
		FS_SND.requestsforIMC = 0
		FS_SND.requestsforMILITIA = 0
		FS_SND.selectTeamMenuOpened = true
		FS_SND.canImcWinNextRound = false
		FS_SND.canMilitiaWinNextRound = false
		
		if(!debugdebug)
		{
			foreach ( player in GetPlayerArray() )
			{
				if(!IsValid(player)) continue
				
				player.p.teamasked = -1
				Remote_CallFunction_UI( player, "Open_FSSND_BuyMenu", endtime)	//Team select menu
			}

			wait 10.5
		}
		GiveTeamToSNDPlayer()

		FS_SND.selectTeamMenuOpened = false

		DestroyPlayerProps()
		SND_DestroyCircleFXEntity()

		foreach ( player in GetPlayerArray() )
		{
			if(!IsValid(player)) continue

			ScreenCoverTransition_Player(player, Time() + 4)
		}

		wait 1
		
		//add check for map
		if( MapName() == eMaps.mp_rr_arena_empty )
		{
			switch(FS_SND.currentLocation)
			{
				case 0:
					dust2part1()
					dust2part2()		
				break	
				
				case 1:
					Shoothouse()
				break
				
				case 2:
					de_cache_Start()
				break
				
				case 3:
					nuketown()
				break
				
				case 4:
					de_NCanals_init()
				break
				
				case 5:
					Killyard()
				break
			}
		}

		foreach ( player in GetPlayerArray() )
		{
			if(!IsValid(player)) continue

			Remote_CallFunction_UI( player, "Close_FSSND_BuyMenu")
		}

		SND_SUDDEN_DEATH_ROUND = false

		if(IsValid(FS_SND.ringBoundary))
			FS_SND.ringBoundary.Destroy()

		SetDeathFieldParams( <0,0,0>, 100000, 0, 90000, 99999 )

		ClearMatchPoints()

		foreach(player in GetPlayerArray())
		{
			if(!IsValid(player)) continue
			Remote_CallFunction_NonReplay(player, "ServerCallback_ResetMoney")

			Signal(player, "EndLobbyDistanceThread")
			Remote_CallFunction_ByRef( player, "ClearMatchPoints" )
			//Remote_CallFunction_NonReplay( player, "ClearMatchPoints" )
		}

		Sh_SetAttackingLocations(FS_SND.currentLocation)

		foreach(player in GetPlayerArray())
		{
			if(!IsValid(player)) continue
			
			Remote_CallFunction_NonReplay( player, "Sh_SetAttackingLocations", FS_SND.currentLocation)
		}
		
		int startTeam = CoinFlip() == true ? TEAM_IMC : TEAM_MILITIA 
		int theOtherOne = startTeam == TEAM_IMC ? TEAM_MILITIA : TEAM_IMC

		Sh_SetAttackerTeam( startTeam, FS_SND.currentRound)
		
		foreach(player in GetPlayerArray())
		{
			if(!IsValid(player)) continue
			
			Remote_CallFunction_NonReplay( player, "Sh_SetAttackerTeam", startTeam, FS_SND.currentRound)
		}

		foreach(player in GetPlayerArrayOfTeam( startTeam ))
		{
			if(!IsValid(player)) continue
			
			player.p.isSNDAttackerPlayer = true
		}	

		foreach(player in GetPlayerArrayOfTeam( theOtherOne ))
		{
			if(!IsValid(player)) continue
			
			player.p.isSNDAttackerPlayer = false
		}
		
		FS_SND.lastRoundWinnerTeam = -1
		FS_SND.IMC_ConsecutiveLoses = 0
		FS_SND.MILITIA_ConsecutiveLoses = 0
		
		SND_SHOULD_START_A_NEW_MATCH = false //New match started, defaulting bool
		SurvivalCommentary_ResetAllData()
		
		foreach(player in GetPlayerArray())
		{
			if(!IsValid(player)) continue
			
			//Reset player stats
			player.p.playerDamageDealt = 0.0
			player.SetPlayerNetInt( "kills", 0 ) //Reset for kills
			// player.SetPlayerNetInt( "playerObservedCount", 0 )
			player.SetPlayerNetInt( "planted", 0 )
			player.SetPlayerNetInt( "defused", 0 )

			player.SetPlayerGameStat( PGS_SCORE, 0 )
			player.SetPlayerGameStat( PGS_DEATHS, 0)
			player.SetPlayerGameStat( PGS_TITAN_KILLS, 0)
			player.SetPlayerGameStat( PGS_KILLS, 0)
			player.SetPlayerGameStat( PGS_PILOT_KILLS, 0)
			player.SetPlayerGameStat( PGS_ASSISTS, 0)
			player.SetPlayerGameStat( PGS_ASSAULT_SCORE, 0)
			player.SetPlayerGameStat( PGS_DEFENSE_SCORE, 0)
			player.SetPlayerGameStat( PGS_ELIMINATED, 0)
			
			player.p.playerIsPlantingBomb = false
			player.p.availableMoney = 500
			Remote_CallFunction_NonReplay(player, "ServerCallback_OnMoneyAdded", player.p.availableMoney)

		}
	}
}

void function SND_GameLoop()
{
	//Switch attacking / defending roles after  4 rounds
	if(FS_SND.currentRound == 4 || FS_SND.currentRound == 7 || FS_SND.currentRound == 10 || FS_SND.currentRound == 13) //todo fix this
	{
		if(Sh_GetAttackerTeam() == TEAM_IMC)
			Sh_SetAttackerTeam(TEAM_MILITIA, FS_SND.currentRound)
		else if(Sh_GetAttackerTeam() == TEAM_MILITIA)
			Sh_SetAttackerTeam(TEAM_IMC, FS_SND.currentRound)

		foreach(player in GetPlayerArray())
		{
			if(!IsValid(player)) continue

			Remote_CallFunction_NonReplay( player, "Sh_SetAttackerTeam", Sh_GetAttackerTeam(), FS_SND.currentRound)
			
			if(player.GetTeam() == Sh_GetAttackerTeam())
				Message(player, "SWITCHING SIDES", "You're attacking now", 4, "ui_ingame_markedfordeath_countdowntoyouaremarked")
			else if(player.GetTeam() == Sh_GetDefenderTeam())
				Message(player, "SWITCHING SIDES", "You're defending now", 4, "ui_ingame_markedfordeath_countdowntoyouaremarked")
		}
		wait 5
		printt("SWITCHING SIDES")
	}
	
	vector pos = GetSidesSpawns()[0].Attackers
	vector pos2 = GetSidesSpawns()[0].Defenders

	pos.z += 5
	int i = 1

	pos2.z += 5
	int j = 1
	foreach( player in GetPlayerArray() ) //tpin players
	{
		if(!IsValid(player)) continue
		
		if(player.GetTeam() == TEAM_IMC)
		{
			player.SetSkin(2) //full body camo skin, works for all characters very nice
			player.SetCamo(IMC_color)
		}
		else if(player.GetTeam() == TEAM_MILITIA)
		{
			player.SetSkin(2) //full body camo skin, works for all characters very nice
			player.SetCamo(MILITIA_color)
		}

		if( player.p.assignedCustomModel != -1 )
		{
			Flowstate_SetAssignedCustomModelToPlayer( player, player.p.assignedCustomModel )
		}
	
		player.p.playerHasBomb = false
		_HandleRespawn(player)

		player.SetVelocity(Vector(0,0,0))
		player.MovementDisable()
		// player.FreezeControlsOnServer()
		
		if( player.GetTeam() == Sh_GetAttackerTeam() )
		{
			float r = float(i) / float( GetPlayerArrayOfTeam( Sh_GetAttackerTeam() ).len() ) * 2 * PI
			// player.SetOrigin(pos + 100.0 * <sin( r ), cos( r ), 0.0>)
			player.SnapToAbsOrigin( pos + 100.0 * <sin( r ), cos( r ), 0.0> )
			i++
			player.SnapEyeAngles( VectorToAngles( pos - player.GetOrigin() ) ) //Make them look to the bomb
			player.SnapFeetToEyes()
		} else if ( player.GetTeam() == Sh_GetDefenderTeam() )
		{
			float r = float(j) / float( GetPlayerArrayOfTeam( Sh_GetDefenderTeam() ).len() ) * 2 * PI
			player.SnapToAbsOrigin( pos2 + 100.0 * <sin( r ), cos( r ), 0.0> )
			j++
			player.SnapEyeAngles( VectorToAngles( pos2 - player.GetOrigin() ) ) //Make them look to the bomb
			player.SnapFeetToEyes()
		}
		Remote_CallFunction_NonReplay( player, "SND_HintCatalog", 5, 0)

		TakeLoadoutRelatedWeapons(player)
		
		player.HolsterWeapon()
		player.Server_TurnOffhandWeaponsDisabledOn()
		
		Survival_SetInventoryEnabled( player, true )
		
		player.SetThirdPersonShoulderModeOff()
		
		SetPlayerInventory( player, [] )
		
		if(SND_GIVE_BODY_SHIELD_BASED_ON_ROUND)
		{
			if( FS_SND.currentRound < 4 )
			{
				Inventory_SetPlayerEquipment(player, "armor_pickup_lv1", "armor")
				player.SetShieldHealth( 50 )		
			} else if ( FS_SND.currentRound >= 4 && FS_SND.currentRound < 7 )
			{
				Inventory_SetPlayerEquipment(player, "armor_pickup_lv2", "armor")
				player.SetShieldHealth( 75 )
			} else if ( FS_SND.currentRound >= 7 )
			{
				Inventory_SetPlayerEquipment(player, "armor_pickup_lv3", "armor")
				player.SetShieldHealth( 100 )
			}
		} else if( SND_GIVE_BODY_SHIELD_BASIC )
		{
			Inventory_SetPlayerEquipment(player, "armor_pickup_lv1", "armor")
			player.SetShieldHealth( 50 )
		}
		
		// Inventory_SetPlayerEquipment( player, "backpack_pickup_lv3", "backpack")		
		//Remote_CallFunction_NonReplay(player, "Minimap_EnableDraw_Internal")	
		Remote_CallFunction_ByRef( player, "Minimap_EnableDraw_Internal" )
		
		// array<string> loot = [ "health_pickup_combo_small", "health_pickup_combo_large", "health_pickup_health_small", "health_pickup_health_large" ] //, "health_pickup_combo_full"]
			// foreach(item in loot)
				// SURVIVAL_AddToPlayerInventory(player, item)
	}
	
	if(FS_SND.currentRound == 1 )
	{
		FS_SND.ringBoundary = CreateRingBoundary()
		wait 2
	}
	
	//SetCustomLightning(-1)
	
	if(FS_SND.currentRound > 1 && !debugdebug)
	{
		foreach ( player in GetPlayerArray() )
		{
			if(!IsValid(player)) continue
			
			ScreenFadeFromBlack( player, 0.1, 0.1 )
			
			//Remote_CallFunction_NonReplay(player, "SetCustomLightning", -1)
			Remote_CallFunction_NonReplay(player, "ServerCallback_FSDM_OpenVotingPhase", true)
			//Remote_CallFunction_NonReplay(player, "ServerCallback_FSDM_CoolCamera")
			Remote_CallFunction_ByRef( player, "ServerCallback_FSDM_CoolCamera" )
			
			Remote_CallFunction_NonReplay(player, "ServerCallback_FSDM_SetScreen", eFSDMScreen.ScoreboardUI, FS_SND.winnerTeam, eFSDMScreen.NotUsed, eFSDMScreen.NotUsed)
			EmitSoundOnEntityOnlyToPlayer(player, player, "UI_Menu_RoundSummary_Results")
		}
		 
		wait 5
		
		foreach ( player in GetPlayerArray() )
		{
			if(!IsValid(player)) continue
			
			Remote_CallFunction_NonReplay(player, "ServerCallback_FSDM_OpenVotingPhase", false)
		}
	}
	
	ToggleBuyMenuBackgroundProps(true)
	
	if(!debugdebug)
	{
		FS_SND.buyAllowed = true
		foreach(player in GetPlayerArray())
		{
			if(!IsValid(player)) continue

			Remote_CallFunction_NonReplay(player, "Thread_SNDBuyMenuTimer", Time() + 25)
			
			AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
			AddCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD )
			
			player.p.grenadesBought = 0
			//player.p.availableMoney = 5000 //debug
			
			if(!player.p.survivedShouldSaveWeapons)
			{
				player.p.weapon1ref = ""
				player.p.weapon2ref = ""
				player.p.weapon1lvl = -1
				player.p.weapon2lvl = -1
				player.p.didPlayerBuyAWeapon = false
				
				Remote_CallFunction_NonReplay(player, "FlowstateSND_CustomBuyMenu_Start", FS_SND.currentRound, player.p.availableMoney, 0, 0, 0, 0, false)
			}
			else
			{
				//Revisar por armas que el jugador botó en la partida, si intercambió armas también debería ser penalizado
				entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
				entity secondary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
				
				if ( IsValid(primary) && primary.GetWeaponClassName() != player.p.weapon1ref || !IsValid(primary) )
				{
					player.p.weapon1ref = ""
					player.p.weapon1lvl = -1
				}

				if ( IsValid(secondary) && secondary.GetWeaponClassName() != player.p.weapon2ref || !IsValid(secondary) )
				{
					player.p.weapon2ref = ""
					player.p.weapon2lvl = -1
				}
				
				if ( !IsValid(primary) && !IsValid(secondary) ) //dar p2020 solo cuando no tenga armas, si el jugador botó una pero aún le quedó una de las originales que compró no dar la p2020
					player.p.didPlayerBuyAWeapon = false
				
				Remote_CallFunction_NonReplay(player, "FlowstateSND_CustomBuyMenu_Start", FS_SND.currentRound, player.p.availableMoney, GetWeaponIDFromRef(player.p.weapon1ref), GetWeaponIDFromRef(player.p.weapon2ref), player.p.weapon1lvl, player.p.weapon2lvl, true)	
			}
			
			ScreenFadeFromBlack( player, 0.1, 0.1 )
		}

		if( debugdebug )
			wait 5
		else
			wait 25
		
		FS_SND.buyAllowed = false
	}
	
	
	//Spawning bomb
	SetBombEntity( SpawnGenericLoot( "snd_bomb", pos, <0,0,0>, 1) )
	SetBombState( bombState.ONGROUND_IDLE )
	
	AddHintInPlantZone()
	
	foreach(entity player in GetPlayerArray())
	{
		if(!IsValid(player)) continue

		RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT | CE_FLAG_HIDE_PERMANENT_HUD )
		//Remote_CallFunction_NonReplay(player, "FlowstateSND_CustomBuyMenu_Stop")
		Remote_CallFunction_ByRef( player, "FlowstateSND_CustomBuyMenu_Stop" )
		Remote_CallFunction_NonReplay(player, "ServerCallback_ToggleBombUIVisibility", true)
		
		//update client money with actual server money
		Remote_CallFunction_NonReplay(player, "ServerCallback_ResetMoney")
		Remote_CallFunction_NonReplay(player, "ServerCallback_OnMoneyAdded", player.p.availableMoney )
	}

	ToggleBuyMenuBackgroundProps(false)
	
	SetGameState(eGameState.Playing)
	// SetCustomLightning(FS_SND.currentLocation)
	
	foreach(player in GetPlayerArray())
	{
		if(!IsValid(player)) continue
		
		// Remote_CallFunction_NonReplay(player, "SetCustomLightning", FS_SND.currentLocation)
		player.MovementEnable()
		// player.UnfreezeControlsOnServer()
		player.DeployWeapon()
		
		player.GiveWeapon("mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [])
		player.GiveOffhandWeapon("melee_pilot_emptyhanded", OFFHAND_MELEE, [])
		
		if(!player.p.didPlayerBuyAWeapon)
		{
			entity currentweapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )

			if (IsValid(currentweapon))
				player.TakeWeaponByEntNow( currentweapon )
				
			entity p2020 = player.GiveWeapon("mp_weapon_semipistol", WEAPON_INVENTORY_SLOT_PRIMARY_0, [])
			player.SetActiveWeaponByName( eActiveInventorySlot.mainHand, "mp_weapon_semipistol" )
			SetupInfiniteAmmoForWeapon( player, p2020 )
		}
		player.p.survivedShouldSaveWeapons = true
		Remote_CallFunction_NonReplay( player, "ServerCallback_RefreshInventoryAndWeaponInfo" )
		player.ClearFirstDeployForAllWeapons()
		
		Remote_CallFunction_NonReplay(player, "SND_ToggleScoreboardVisibility", true)
		
		if( IsValid( player.GetOffhandWeapon( OFFHAND_SLOT_FOR_CONSUMABLES ) ) )
			player.TakeOffhandWeapon( OFFHAND_SLOT_FOR_CONSUMABLES )
			
		player.GiveOffhandWeapon( CONSUMABLE_WEAPON_NAME, OFFHAND_SLOT_FOR_CONSUMABLES, [] )
			
		if( player.GetTeam() == Sh_GetAttackerTeam() )
		{

			player.Server_TurnOffhandWeaponsDisabledOff()
			ClearInvincible(player)
			
			if(!SND_SUDDEN_DEATH_ROUND)
				Message(player, "ROUND " + FS_SND.currentRound, "Plant the bomb or eliminate defenders")
			
		} else if ( player.GetTeam() == Sh_GetDefenderTeam() )
		{
			if(!SND_SUDDEN_DEATH_ROUND)
				Message(player, "ROUND " + FS_SND.currentRound, "Eliminate attackers or defuse the bomb")
		}
		
		if(SND_SUDDEN_DEATH_ROUND)
		{
			if( FS_SND.canImcWinNextRound && !FS_SND.canMilitiaWinNextRound && player.GetTeam() == TEAM_IMC )
				Message(player, "TIE BREAKER", "Win this round to end the game")
			else if( FS_SND.canImcWinNextRound && !FS_SND.canMilitiaWinNextRound && player.GetTeam() == TEAM_MILITIA )
				Message(player, "TIE BREAKER", "Win this round to have another chance")
			else if( !FS_SND.canImcWinNextRound && FS_SND.canMilitiaWinNextRound && player.GetTeam() == TEAM_MILITIA )
				Message(player, "TIE BREAKER", "Win this round to end the game")
			else if( !FS_SND.canImcWinNextRound && FS_SND.canMilitiaWinNextRound && player.GetTeam() == TEAM_IMC )
				Message(player, "TIE BREAKER", "Win this round to have another chance")
			else if( FS_SND.canImcWinNextRound && FS_SND.canMilitiaWinNextRound )
				Message(player, "SUDDEN DEATH", "Win this round or you lose")
		}
		
		ClientCommand(player, "+forward") //Hack para que se quite el input del hud más rápido, usualmente toca moverse (usar wasd) antes para que la cámara de desbloquee. AL parecer si el jugador tiene el juego altabeado el viewmodel se buggea si el jugador no se mueve rápido, esto arreglaría ese problema, buscar una forma más efectiva de cortar el input del hud
		ClientCommand(player, "-forward")
	}
	
	//Game thread
	float starttime = Time()

	FS_SND.InProgress = true
	
	UpdateRoundEndTime( Time() + GetCurrentPlaylistVarFloat("SND_Round_LimitTime", 300 ) )

	//update: it only happens when alt tabbed, seems to be related to hud input handling? Colombia 
	thread function() : ()
	{	
		wait 2
		foreach(entity player in GetPlayerArray())
		{
				if( !IsValid(player) || !IsAlive(player) ) continue
				ClearInvincible(player)
				player.Server_TurnOffhandWeaponsDisabledOff()
				ClearInvincible(player)
				player.Server_TurnOffhandWeaponsDisabledOff()
				DeployAndEnableWeapons( player )
		}
		
		wait 1

		foreach(entity player in GetPlayerArray())
		{
				if( !IsValid(player) || !IsAlive(player) ) continue
				ClearInvincible(player)
				player.Server_TurnOffhandWeaponsDisabledOff()
				ClearInvincible(player)
				player.Server_TurnOffhandWeaponsDisabledOff()
				DeployAndEnableWeapons( player )
		}
	}()

	array<entity> AttackersAlive = GetPlayerArrayOfTeam_Alive( Sh_GetAttackerTeam() )
	array<entity> DefendersAlive = GetPlayerArrayOfTeam_Alive( Sh_GetDefenderTeam() )
	
	UpdatePlayerCounts()

	if( GetCurrentPlaylistVarBool( "fs_stamina_mod", false ) )
		foreach( entity player in GetPlayerArray() )
		{
			player.SetPlayerNetBool( "playerStaminaRecovering", false )
			player.SetPlayerNetInt( "playerStamina", 100 )
		}

	bool showDefuseBombHintAfterAttackersKilledOnlyOneTime = false 
	
	while( Time() <= FS_SND.endTime )
	{
		AttackersAlive = GetPlayerArrayOfTeam_Alive( Sh_GetAttackerTeam() )
		DefendersAlive = GetPlayerArrayOfTeam_Alive( Sh_GetDefenderTeam() )
	
		if( GetBombState() == bombState.ONGROUND_EXPLODED )
		{
			SetGameState(eGameState.MapVoting)
			CommonEndFunct()
			
			FS_SND.winnerTeam = Sh_GetAttackerTeam()

			foreach(player in GetPlayerArray())
			{
				if(!IsValid(player)) continue
				
				Remote_CallFunction_NonReplay(player, "FlowstateSND_CustomWinnerScreen_Start", FS_SND.winnerTeam, 1)	
			}
				
			GeneralMatchPointsHandling()
			
			wait 5
			
			break
		}
		
		if( GetBombState() == bombState.ONGROUND_DEFUSED )
		{
			SetGameState(eGameState.MapVoting)
			CommonEndFunct()
			
			FS_SND.winnerTeam = Sh_GetDefenderTeam()

			foreach(player in GetPlayerArray())
			{
				if(!IsValid(player)) continue
				
				Remote_CallFunction_NonReplay(player, "FlowstateSND_CustomWinnerScreen_Start", FS_SND.winnerTeam, 2)	
			}

			GeneralMatchPointsHandling()
			
			wait 5
			break
		}
		
		if( AttackersAlive.len() == 0 && DefendersAlive.len() > 0 && GetBombState() < bombState.ONGROUND_PLANTED )
		{
			SetGameState(eGameState.MapVoting)
			CommonEndFunct()
			
			FS_SND.winnerTeam = Sh_GetDefenderTeam()
			
			foreach ( player in GetPlayerArrayOfTeam( FS_SND.winnerTeam ) )
			{
				if(!IsValid(player)) continue
				
				player.p.availableMoney += 3250
				Remote_CallFunction_NonReplay(player, "ServerCallback_OnMoneyAdded", 3250)
			}
			
			foreach(player in GetPlayerArray())
			{
				if(!IsValid(player)) continue
				
				Remote_CallFunction_NonReplay(player, "FlowstateSND_CustomWinnerScreen_Start", FS_SND.winnerTeam, 0)	
			}
			
			GeneralMatchPointsHandling()
			
			wait 5
			break
		} else if( DefendersAlive.len() == 0 && AttackersAlive.len() > 0 && GetBombState() < bombState.ONGROUND_PLANTED )
		{
			SetGameState(eGameState.MapVoting)
			CommonEndFunct()
			
			FS_SND.winnerTeam = Sh_GetAttackerTeam()
			
			foreach ( player in GetPlayerArrayOfTeam( FS_SND.winnerTeam ) )
			{
				if(!IsValid(player)) continue
				
				player.p.availableMoney += 3250
				Remote_CallFunction_NonReplay(player, "ServerCallback_OnMoneyAdded", 3250)
			}
			
			foreach(player in GetPlayerArray())
			{
				Remote_CallFunction_NonReplay(player, "FlowstateSND_CustomWinnerScreen_Start", FS_SND.winnerTeam, 0)	
			}
			
			GeneralMatchPointsHandling()
			
			wait 5
			break
		}
		
		if( DefendersAlive.len() == 0 && AttackersAlive.len() > 0 && GetBombState() == bombState.ONGROUND_PLANTED )
		{
			SetGameState(eGameState.MapVoting)
			CommonEndFunct()
			
			FS_SND.winnerTeam = Sh_GetAttackerTeam()
			
			foreach ( player in GetPlayerArrayOfTeam( FS_SND.winnerTeam ) )
			{
				if(!IsValid(player)) continue
				
				player.p.availableMoney += 3250
				Remote_CallFunction_NonReplay(player, "ServerCallback_OnMoneyAdded", 3250)
			}
			
			foreach(player in GetPlayerArray())
			{
				if(!IsValid(player)) continue
				
				Remote_CallFunction_NonReplay(player, "FlowstateSND_CustomWinnerScreen_Start", FS_SND.winnerTeam, 0)	
			}
			
			GeneralMatchPointsHandling()
			
			wait 5
			break
		}
		
		if( AttackersAlive.len() == 0 && DefendersAlive.len() > 0 && GetBombState() == bombState.ONGROUND_PLANTED && !showDefuseBombHintAfterAttackersKilledOnlyOneTime )
		{
			foreach(player in DefendersAlive)
				Remote_CallFunction_NonReplay( player, "SND_HintCatalog", 4, 0) //All attackers are dead, defuse the bomb
				
			showDefuseBombHintAfterAttackersKilledOnlyOneTime = true
		}
		
		if( GetGameState() == eGameState.MapVoting )
			break
		
		if( FS_SND.forceRoundEnd )
			break
		
		WaitFrame()	
	}
	
	if( GetGameState() == eGameState.Playing ) // Time ran out, if attackers are alive and bomb wasn't planted, defenders win 
	{
		AttackersAlive = GetPlayerArrayOfTeam_Alive( Sh_GetAttackerTeam() )
		DefendersAlive = GetPlayerArrayOfTeam_Alive( Sh_GetDefenderTeam() )
	
		SetGameState(eGameState.MapVoting)
		
		int savedbombstate = GetBombState()
		
		CommonEndFunct()
		
		if( DefendersAlive.len() > 0 && AttackersAlive.len() > 0 && savedbombstate < bombState.ONGROUND_PLANTED )
		{
			FS_SND.winnerTeam = Sh_GetDefenderTeam()

			foreach ( player in GetPlayerArrayOfTeam( FS_SND.winnerTeam ) )
			{
				if(!IsValid(player)) continue
				
				player.p.availableMoney += 3250
				Remote_CallFunction_NonReplay(player, "ServerCallback_OnMoneyAdded", 3250)
			}
			
			foreach( player in GetPlayerArray() )
			{
				AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD | CE_FLAG_HIDE_PERMANENT_HUD )

				Remote_CallFunction_NonReplay(player, "FlowstateSND_CustomWinnerScreen_Start", FS_SND.winnerTeam, 3)	
			}
			
			GeneralMatchPointsHandling()
		}
		
		//old tie logic, it doesn't incentivate planting the bomb so the game feels more like a tdm
		
		// if( AttackersAlive.len() > DefendersAlive.len())
		// {
			// FS_SND.winnerTeam = Sh_GetAttackerTeam()

			// foreach ( player in GetPlayerArrayOfTeam( FS_SND.winnerTeam ) )
			// {
				// if(!IsValid(player)) continue
				
				// player.p.availableMoney += 3250
				// Remote_CallFunction_NonReplay(player, "ServerCallback_OnMoneyAdded", 3250)
			// }

			// foreach(player in GetPlayerArray())
			// {
				// Remote_CallFunction_NonReplay(player, "FlowstateSND_CustomWinnerScreen_Start", FS_SND.winnerTeam, 3)	
			// }
			
			// GeneralMatchPointsHandling()
		// }
		// else if( DefendersAlive.len() > AttackersAlive.len() )
		// {
			// FS_SND.winnerTeam = Sh_GetDefenderTeam()
			
			// foreach ( player in GetPlayerArrayOfTeam( Sh_GetDefenderTeam() ) )
			// {
				// if(!IsValid(player)) continue
				
				// player.p.availableMoney += 3250
				// Remote_CallFunction_NonReplay(player, "ServerCallback_OnMoneyAdded", 3250)
			// }

			// foreach(player in GetPlayerArray())
			// {
				// Remote_CallFunction_NonReplay(player, "FlowstateSND_CustomWinnerScreen_Start", FS_SND.winnerTeam, 4)	
			// }
			
			// GeneralMatchPointsHandling()
		// }
		// else if( DefendersAlive.len() == AttackersAlive.len() )
		// {
			// FS_SND.winnerTeam = 5

			// foreach(player in GetPlayerArray())
			// {
				// Remote_CallFunction_NonReplay(player, "FlowstateSND_CustomWinnerScreen_Start", FS_SND.winnerTeam, 5)	
			// }

			// GeneralMatchPointsHandling()
		// }

		wait 5
	}
	
	printt(ReturnTeamWins(TEAM_IMC), ReturnTeamWins(TEAM_MILITIA))
	
	if( ReturnTeamWins(TEAM_IMC) == SND_ROUNDS_TO_WIN-1 && ReturnTeamWins(TEAM_MILITIA) == SND_ROUNDS_TO_WIN-1 )
	{
		foreach ( player in GetPlayerArray() )
		{
			if(!IsValid(player)) continue
			
			Message(player, "TIEBREAKER ENABLED", "An additional round to win is required")
		}
	}

	if( ReturnTeamWins(TEAM_IMC) == SND_ROUNDS_TO_WIN && ReturnTeamWins(TEAM_MILITIA) < SND_ROUNDS_TO_WIN-1 && CanImcWin() || SND_SUDDEN_DEATH_ROUND && ReturnTeamWins(TEAM_IMC) > ReturnTeamWins(TEAM_MILITIA) && FS_SND.canImcWinNextRound )
	{
		printt("IMC WON THE MATCH, STARTING NEW GAME")
		
		DestroyPlayerProps()
		SND_SHOULD_START_A_NEW_MATCH = true
		SetBombState(bombState.NONE)
		thread SurvivalCommentary_HostAnnounce( eSurvivalCommentaryBucket.WINNER, 3.0 )
		
		if(IsValid(FS_SND.ringBoundary))
			FS_SND.ringBoundary.Destroy()
		
		SetDeathFieldParams( <0,0,0>, 100000, 0, 90000, 99999 )
		
		foreach ( player in GetPlayerArray() )
		{
			if(!IsValid(player)) continue
			
			try{
				if(player.p.isSpectating)
				{
					player.p.isSpectating = false
					player.SetObserverTarget( null )
					player.SetPlayerNetInt( "spectatorTargetCount", 0 )
					player.SetSpecReplayDelay( 0 )
					player.StopObserverMode()
					Remote_CallFunction_ByRef( player, "ServerCallback_KillReplayHud_Deactivate" )
					//Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Deactivate")
					Remote_CallFunction_NonReplay(player, "ServerCallback_UpdateSpectatorTargetCount", 0)
				}
			}catch(e420){}
			
			if(!IsAlive(player)) 
			{
				DecideRespawnPlayer(player, true)
			}

			TakeAllWeapons(player)	
			thread CheckDistanceWhileInLobby(player)
			StartParticleEffectInWorld( GetParticleSystemIndex( $"P_impact_shieldbreaker_sparks" ), player.GetOrigin(), Vector(0,0,0) )
			EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
			EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )
			// player.SetOrigin(FS_SND.lobbyLocation)
			// player.SetAngles(FS_SND.lobbyAngles)
			player.SnapToAbsOrigin( FS_SND.lobbyLocation )
			player.SnapEyeAngles( FS_SND.lobbyAngles )
			player.SnapFeetToEyes()
			if( player.GetTeam() == TEAM_IMC )
				Message(player, "IMC WON THE MATCH", "You won" )
			else
				Message(player, "IMC WON THE MATCH", "You lost" )
		}
		
		wait 5
		
		foreach ( player in GetPlayerArray() )
		{
			if(!IsValid(player)) continue
			
			AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
			AddCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD )
			Remote_CallFunction_NonReplay(player, "SND_ToggleScoreboardVisibility", false)
			//Remote_CallFunction_NonReplay( player, "ServerCallback_PlayMatchEndMusic" )
			Remote_CallFunction_ByRef( player, "ServerCallback_PlayMatchEndMusic" )
			Remote_CallFunction_NonReplay( player, "ServerCallback_MatchEndAnnouncement", player.GetTeam() == TEAM_IMC, TEAM_IMC )
		}
		
		wait 3.5
	}
	
	if( ReturnTeamWins(TEAM_MILITIA) == SND_ROUNDS_TO_WIN && ReturnTeamWins(TEAM_IMC) < SND_ROUNDS_TO_WIN-1 && CanMilitiaWin() || SND_SUDDEN_DEATH_ROUND && ReturnTeamWins(TEAM_MILITIA) > ReturnTeamWins(TEAM_IMC) && FS_SND.canMilitiaWinNextRound)
	{
		printt("MILITIA WON THE MATCH, STARTING NEW GAME")
		
		DestroyPlayerProps()
		SND_SHOULD_START_A_NEW_MATCH = true
		SetBombState(bombState.NONE)
		thread SurvivalCommentary_HostAnnounce( eSurvivalCommentaryBucket.WINNER, 3.0 )

		if(IsValid(FS_SND.ringBoundary))
			FS_SND.ringBoundary.Destroy()
		
		SetDeathFieldParams( <0,0,0>, 100000, 0, 90000, 99999 )
		
		foreach ( player in GetPlayerArray() )
		{
			if(!IsValid(player)) continue

			try{
				if(player.p.isSpectating)
				{
					player.p.isSpectating = false
					player.SetObserverTarget( null )
					player.SetPlayerNetInt( "spectatorTargetCount", 0 )
					player.SetSpecReplayDelay( 0 )
					player.StopObserverMode()
					Remote_CallFunction_ByRef( player, "ServerCallback_KillReplayHud_Deactivate" )
					//Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Deactivate")
					Remote_CallFunction_NonReplay(player, "ServerCallback_UpdateSpectatorTargetCount", 0)
				}
			}catch(e420){}

			if(!IsAlive(player)) 
			{
				DecideRespawnPlayer(player, true)
			}
			
			TakeAllWeapons(player)
			thread CheckDistanceWhileInLobby(player)
			StartParticleEffectInWorld( GetParticleSystemIndex( $"P_impact_shieldbreaker_sparks" ), player.GetOrigin(), Vector(0,0,0) )
			EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
			EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )
			// player.SetOrigin(FS_SND.lobbyLocation)
			// player.SetAngles(FS_SND.lobbyAngles)
			player.SnapToAbsOrigin( FS_SND.lobbyLocation )
			player.SnapEyeAngles( FS_SND.lobbyAngles )
			player.SnapFeetToEyes()
			if( player.GetTeam() == TEAM_MILITIA )
				Message(player, "MILITIA WON THE MATCH", "You won" )
			else
				Message(player, "MILITIA WON THE MATCH", "You lost" )
		}
		
		wait 5
		
		foreach ( player in GetPlayerArray() )
		{
			if(!IsValid(player)) continue
			
			AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
			AddCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD )
			Remote_CallFunction_NonReplay(player, "SND_ToggleScoreboardVisibility", false)
			//Remote_CallFunction_NonReplay( player, "ServerCallback_PlayMatchEndMusic" )
			Remote_CallFunction_ByRef( player, "ServerCallback_PlayMatchEndMusic" )
			Remote_CallFunction_NonReplay( player, "ServerCallback_MatchEndAnnouncement", player.GetTeam() == TEAM_MILITIA, TEAM_MILITIA )
		}
		
		wait 3.5
	}
	
	//Si van 6-5, la siguiente ronda podría terminar la partida
	if( ReturnTeamWins(TEAM_IMC) == SND_ROUNDS_TO_WIN && ReturnTeamWins(TEAM_MILITIA) == SND_ROUNDS_TO_WIN-1 && !SND_SHOULD_START_A_NEW_MATCH)
	{
		SND_SUDDEN_DEATH_ROUND = true
		
		FS_SND.canImcWinNextRound = true
		FS_SND.canMilitiaWinNextRound = false
		
	} else if( ReturnTeamWins(TEAM_MILITIA) == SND_ROUNDS_TO_WIN && ReturnTeamWins(TEAM_IMC) == SND_ROUNDS_TO_WIN-1 && !SND_SHOULD_START_A_NEW_MATCH) 
	{
		SND_SUDDEN_DEATH_ROUND = true
		
		FS_SND.canImcWinNextRound = false
		FS_SND.canMilitiaWinNextRound = true
	}
	
	//si van 6-6, forzar la ronda final
	if( ReturnTeamWins(TEAM_IMC) == SND_ROUNDS_TO_WIN && ReturnTeamWins(TEAM_MILITIA) == SND_ROUNDS_TO_WIN && !SND_SHOULD_START_A_NEW_MATCH)
	{
		SND_SUDDEN_DEATH_ROUND = true 
		FS_SND.canImcWinNextRound = true
		FS_SND.canMilitiaWinNextRound = true
	}
	
	if( !SND_SHOULD_START_A_NEW_MATCH )
	{
		CleanupGroundAfterEachRound()
		
		foreach( player in GetPlayerArray() )
		{
			if(!IsValid(player)) continue
			
			RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
			RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD )
			
			//Remote_CallFunction_NonReplay( player, "ServerCallback_DestroyEndAnnouncement")
			Remote_CallFunction_ByRef( player, "ServerCallback_DestroyEndAnnouncement" )
			Remote_CallFunction_NonReplay(player, "ServerCallback_ToggleBombUIVisibility", false)
			Remote_CallFunction_NonReplay(player, "SND_ToggleScoreboardVisibility", false)
			ScreenFadeToBlack( player, 2, 3 )
		}
		
		FS_SND.currentRound++
		FS_SND.lastRoundWinnerTeam = FS_SND.winnerTeam
		wait 3
	}
	else
	{
		CleanupGroundAfterEachRound()
		FS_SND.currentRound = 1
		foreach( player in GetPlayerArray() )
		{
			if(!IsValid(player)) continue
			
			player.p.survivedShouldSaveWeapons = false
			RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
			RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD )
			
			//Remote_CallFunction_NonReplay( player, "ServerCallback_DestroyEndAnnouncement")
			Remote_CallFunction_ByRef( player, "ServerCallback_DestroyEndAnnouncement" )
			Remote_CallFunction_NonReplay(player, "SND_ToggleScoreboardVisibility", false)
			ScreenCoverTransition_Player(player, Time() + 2)
		}
		wait 1
		foreach( player in GetPlayerArray() )
		{
			if(!IsValid(player)) continue
			
			TakeAllWeapons(player)
		}
		
		if( GetCurrentPlaylistVarBool( "SND_change_to_next_map_when_game_finishes", true ) )
			FS_SND.currentLocation++
		
		if(FS_SND.currentLocation == 6) FS_SND.currentLocation = 0
	}
	
	FS_SND.winnerTeam = 5
	
	UpdatePlayerCounts()
}

float function GetRoundEndTime()
{
 return FS_SND.endTime	
}

void function UpdateRoundEndTime(float endtime)
{
	FS_SND.endTime = endtime

	foreach(entity player in GetPlayerArray())
	{
		if(!IsValid(player)) continue
		
		Remote_CallFunction_NonReplay(player, "Thread_SNDTimer", FS_SND.endTime)
	}	
}

bool function CanMilitiaWin()
{
	return ReturnTeamWins(TEAM_MILITIA) - ReturnTeamWins(TEAM_IMC) >= 2
}

bool function CanImcWin()
{
	return ReturnTeamWins(TEAM_IMC) - ReturnTeamWins(TEAM_MILITIA) >= 2
}

void function GeneralMatchPointsHandling()
{
	foreach ( player in GetPlayerArray() )
	{
		if(!IsValid(player)) continue
		
		SendScoreboardToClient()
	}
	
	// if( FS_SND.winnerTeam == 5 )
	// {
		// AddRoundPointTied()
		
		// foreach ( player in GetPlayerArray() )
		// {
			// if(!IsValid(player)) continue
			
			//// Remote_CallFunction_NonReplay( player, "AddRoundPointTied" )
			// Remote_CallFunction_ByRef( player, "AddRoundPointTied" )
			
			//// Remote_CallFunction_NonReplay( player, "SND_UpdateUIScore" )
			// Remote_CallFunction_ByRef( player, "SND_UpdateUIScore" )
		// }
		// return
	// }

	//General match points handling
	if( FS_SND.winnerTeam == TEAM_IMC )
	{
		AddRoundPointToWinner_IMC()
		
		foreach ( player in GetPlayerArray() )
		{
			if(!IsValid(player)) continue
			
			//Remote_CallFunction_NonReplay( player, "AddRoundPointToWinner_IMC" )
			Remote_CallFunction_ByRef( player, "AddRoundPointToWinner_IMC" )
			//Remote_CallFunction_NonReplay( player, "SND_UpdateUIScore" )
			Remote_CallFunction_ByRef( player, "SND_UpdateUIScore" )
		}
		
		if(FS_SND.IMC_ConsecutiveLoses > 0)
			FS_SND.IMC_ConsecutiveLoses--

		FS_SND.MILITIA_ConsecutiveLoses++
		
		printt("GENERAL MATCH POINTS HANDLING Winner: " + FS_SND.winnerTeam + " | IMC CONSECUTIVE LOSES: " +  FS_SND.IMC_ConsecutiveLoses + " | MILITIA CONSECUTIVE LOSES: " + FS_SND.MILITIA_ConsecutiveLoses )
		
		int moneyToGive = 0
		
		switch( FS_SND.MILITIA_ConsecutiveLoses )
		{
			case 1:
				moneyToGive = 1400
			break
			
			case 2:
				moneyToGive = 1900
			break
			
			case 3:
				moneyToGive = 2400
			break
		
			case 4:
				moneyToGive = 2900
			break
	
			case 5:
				moneyToGive = 3400
			break
			
			case 6:
				moneyToGive = 3400
			break
		
			default:
				moneyToGive = 3400
			break
		}
		
		foreach ( player in GetPlayerArrayOfTeam( TEAM_MILITIA ) )
		{
			if(!IsValid(player)) continue
					
			player.p.availableMoney += moneyToGive
			Remote_CallFunction_NonReplay(player, "ServerCallback_OnMoneyAdded", moneyToGive)
		}
		return
		
	}
	
	if(FS_SND.winnerTeam == TEAM_MILITIA) //should update UI too
	{
		AddRoundPointToWinner_Militia()
		
		foreach ( player in GetPlayerArray() )
		{
			if(!IsValid(player)) continue
			
			//Remote_CallFunction_NonReplay( player, "AddRoundPointToWinner_Militia" )
			Remote_CallFunction_ByRef( player, "AddRoundPointToWinner_Militia" )
			//Remote_CallFunction_NonReplay( player, "SND_UpdateUIScore" )
			Remote_CallFunction_ByRef( player, "SND_UpdateUIScore" )
		}
		
		if(FS_SND.MILITIA_ConsecutiveLoses > 0)
			FS_SND.MILITIA_ConsecutiveLoses--

		FS_SND.IMC_ConsecutiveLoses++
		
		printt("GENERAL MATCH POINTS HANDLING Winner: " + FS_SND.winnerTeam + " | IMC CONSECUTIVE LOSES: " +  FS_SND.IMC_ConsecutiveLoses + " | MILITIA CONSECUTIVE LOSES: " + FS_SND.MILITIA_ConsecutiveLoses )
		
		int moneyToGive = 0
		
		switch( FS_SND.IMC_ConsecutiveLoses )
		{
			case 1:
				moneyToGive = 1400
			break
			
			case 2:
				moneyToGive = 1900
			break
			
			case 3:
				moneyToGive = 2400
			break
		
			case 4:
				moneyToGive = 2900
			break
	
			case 5:
				moneyToGive = 3400
			break
			
			case 6:
				moneyToGive = 3400
			break
		
			default:
				moneyToGive = 3400
			break
		}
		
		foreach ( player in GetPlayerArrayOfTeam( TEAM_IMC ) )
		{
			if(!IsValid(player)) continue
					
			player.p.availableMoney += moneyToGive
			Remote_CallFunction_NonReplay(player, "ServerCallback_OnMoneyAdded", moneyToGive)
		}
		
		return
		
	}

}

void function CheckDistanceWhileInLobby(entity player)
{
	EndSignal( player, "EndLobbyDistanceThread" )
	
	while(IsValid(player))
	{
		if(Distance(player.GetOrigin(),FS_SND.lobbyLocation)>2000)
		{
			player.SetVelocity(Vector(0,0,0))
			// player.SetOrigin(FS_SND.lobbyLocation)
			// player.SetAngles(FS_SND.lobbyAngles)
			player.SnapToAbsOrigin( FS_SND.lobbyLocation )
			player.SnapEyeAngles( FS_SND.lobbyAngles )
			player.SnapFeetToEyes()
		}
		WaitFrame()
	}	
}

void function CommonEndFunct()
{
	if(IsValid(GetBombEntity())) 
		GetBombEntity().Destroy()

	if(IsValid(GetPlantedBombEntity())) 
		GetPlantedBombEntity().Destroy()

	foreach ( player in GetPlayerArray() )
	{
		if(!IsValid(player)) continue
		
		if( IsValid( player.GetOffhandWeapon( OFFHAND_SLOT_FOR_CONSUMABLES ) ) )
			player.TakeOffhandWeapon( OFFHAND_SLOT_FOR_CONSUMABLES )
		
		Signal( player, "OnChargeEnd" )
		Remote_CallFunction_NonReplay( player, "ServerCallback_ForceDestroyPlantingRUI" )
		Remote_CallFunction_NonReplay( player, "ServerCallback_ForceZoneHintDestroy", false)
		Remote_CallFunction_NonReplay( player, "ServerCallback_ForceZoneHintDestroy", true)
		
		MakeInvincible( player )
		Survival_SetInventoryEnabled( player, false )
		SetPlayerInventory( player, [] )	
	}
	
	FS_SND.InProgress = false	
	SetBombState(bombState.NONE)
}

int function GetBombState()
{
	return FS_SND.currentBombState
}

void function SetBombState(int state)
{
	svGlobal.levelEnt.Signal( "EndWayPointThread" )
	
	FS_SND.currentBombState = state
	
	foreach ( player in GetPlayerArray() )
	{
		if(!IsValid(player)) continue
		
		Remote_CallFunction_NonReplay( player, "ServerCallback_SetBombState", state)
	}
	
	if(state == bombState.ONGROUND_IDLE)
	{
		thread function() : ()
		{
			svGlobal.levelEnt.EndSignal( "EndWayPointThread" )
			wait 1
			
			if(!IsValid(GetBombEntity())) return
			
			while(GetBombState() == bombState.ONGROUND_IDLE )
			{
				entity waypoint
			
				if( GetPlayerArrayOfTeam_Alive( Sh_GetAttackerTeam() ).len() > 0 && IsValid(GetBombEntity()))
					waypoint = CreateWaypoint_Test( GetPlayerArrayOfTeam_Alive( Sh_GetAttackerTeam() )[0], ePingType.SND_BOMB, GetBombEntity().GetOrigin(), -1, true )
				
				wait 5
			}

		}()	
	}
}

void function SetBombEntity(entity bomb)
{
	if(IsValid(FS_SND.bomb)) 
		FS_SND.bomb.Destroy()
	
	FS_SND.bomb = bomb
	
	thread AddBombToMinimap( FS_SND.bomb )
}

entity function GetBombEntity()
{
	return FS_SND.bomb
}

void function SetPlantedBombEntity(entity bomb)
{
	if(IsValid(FS_SND.plantedBomb)) 
		FS_SND.plantedBomb.Destroy()
	
	FS_SND.plantedBomb = bomb
	
	thread AddBombToMinimap( FS_SND.plantedBomb )
}

entity function GetPlantedBombEntity()
{
	return FS_SND.plantedBomb
}

// Creates the Ring
entity function CreateRingBoundary()
{
    array<sidesSpawns> spawns = GetSidesSpawns()

    vector ringCenter

	ringCenter += spawns[0].Defenders
	ringCenter += spawns[0].Attackers

    ringCenter /= 2

    float ringRadius = 0

    if( Distance( spawns[0].Defenders, ringCenter ) > ringRadius )
        ringRadius = Distance(spawns[0].Defenders, ringCenter)

    if( Distance( spawns[0].Attackers, ringCenter ) > ringRadius )
        ringRadius = Distance(spawns[0].Attackers, ringCenter)
	
    ringRadius += 3500 //padding
	//We watch the ring fx with this entity in the threads
	entity circle = CreateEntity( "prop_script" )
	circle.SetValueForModelKey( $"mdl/fx/ar_survival_radius_1x100.rmdl" )
	circle.kv.fadedist = -1
	circle.kv.modelscale = ringRadius
	circle.kv.renderamt = 50
	circle.kv.rendercolor = "235, 110, 52"
	circle.kv.solid = 0
	circle.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE
	circle.SetOrigin( ringCenter )
	circle.SetAngles( <0, 0, 0> )
	circle.NotSolid()
	circle.DisableHibernation()
	
    // circle.Minimap_SetObjectScale( min(ringRadius / SURVIVAL_MINIMAP_RING_SCALE, 1) )
    // circle.Minimap_SetAlignUpright( true )
    // circle.Minimap_SetZOrder( 2 )
    // circle.Minimap_SetClampToEdge( true )
    // circle.Minimap_SetCustomState( eMinimapObject_prop_script.OBJECTIVE_AREA )
	//SetTargetName( circle, "hotZone" )
	
	DispatchSpawn(circle)

    foreach ( player in GetPlayerArray() )
    {
        circle.Minimap_AlwaysShow( 0, player )
    }

	SetDeathFieldParams( ringCenter, ringRadius, ringRadius, 90000, 99999 ) // This function from the API allows client to read ringRadius from server so we can use visual effects in shared function. Colombia

	//Audio thread for ring
	foreach(sPlayer in GetPlayerArray())
		thread AudioThread(circle, sPlayer, ringRadius)

	//Damage thread for ring
	thread RingDamage(circle, ringRadius)

    return circle
}

void function AudioThread(entity circle, entity player, float radius)
{
	EndSignal(player, "OnDestroy")
	entity audio
	string soundToPlay = "Survival_Circle_Edge_Small"
	OnThreadEnd(
		function() : ( soundToPlay, audio)
		{

			if(IsValid(audio)) audio.Destroy()
		}
	)
	audio = CreateScriptMover()
	audio.SetOrigin( circle.GetOrigin() )
	audio.SetAngles( <0, 0, 0> )
	EmitSoundOnEntity( audio, soundToPlay )

	while(IsValid(circle)){
		if(!IsValid(player)) continue
		vector fwdToPlayer   = Normalize( <player.GetOrigin().x, player.GetOrigin().y, 0> - <circle.GetOrigin().x, circle.GetOrigin().y, 0> )
		vector circleEdgePos = circle.GetOrigin() + (fwdToPlayer * radius)
		circleEdgePos.z = player.EyePosition().z
		if ( fabs( circleEdgePos.x ) < 61000 && fabs( circleEdgePos.y ) < 61000 && fabs( circleEdgePos.z ) < 61000 )
		{
			audio.SetOrigin( circleEdgePos )
		}
		WaitFrame()
	}

	StopSoundOnEntity(audio, soundToPlay)
}

void function RingDamage( entity circle, float currentRadius)
{
	WaitFrame()
	const float DAMAGE_CHECK_STEP_TIME = 1.5

	while ( IsValid(circle) )
	{
		foreach ( dummy in GetNPCArray() )
		{
			if ( dummy.IsPhaseShifted() )
				continue

			float playerDist = Distance2D( dummy.GetOrigin(), circle.GetOrigin() )
			if ( playerDist > currentRadius )
			{
				dummy.TakeDamage( int( Deathmatch_GetOOBDamagePercent() / 100 * float( dummy.GetMaxHealth() ) ), null, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )
			}
		}

		foreach ( player in GetPlayerArray_Alive() )
		{
			if ( player.IsPhaseShifted() )
				continue

			float playerDist = Distance2D( player.GetOrigin(), circle.GetOrigin() )
			if ( playerDist > currentRadius )
			{
				Remote_CallFunction_NonReplay( player, "ServerCallback_PlayerTookDamage", 0, 0, 0, 0, DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, eDamageSourceId.deathField, null )
				player.TakeDamage( int( Deathmatch_GetOOBDamagePercent() / 100 * float( player.GetMaxHealth() ) ), null, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )
			}
		}
		wait DAMAGE_CHECK_STEP_TIME
	}
}

void function SND_KillStreakAnnounce( entity attacker )
{
	float thisKillTime = Time()
	
	// if( thisKillTime == attacker.p.lastDownedEnemyTime ) //insta double then?
	// {		
		// attacker.p.downedEnemy += 2
	// }

	if( attacker.p.downedEnemy > 0 && thisKillTime > attacker.p.allowedTimeForNextKill )
		attacker.p.downedEnemy = 0

	attacker.p.downedEnemy++
	attacker.p.allowedTimeForNextKill = thisKillTime + min(KILLLEADER_STREAK_ANNOUNCE_TIME + attacker.p.downedEnemy*0.25, 7) //increases allowed time 0.25 seconds per kill up to 7 seconds

	if ( thisKillTime <= attacker.p.allowedTimeForNextKill && attacker.p.downedEnemy > 1 )
		Remote_CallFunction_NonReplay(attacker, "INFECTION_QuickHint", attacker.p.downedEnemy, false, 0)

	attacker.p.lastDownedEnemyTime = thisKillTime
}

array<ConsumableInventoryItem> function FlowStateGetAllDroppableItems( entity player )
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
		if ( data.ref == "" || data.ref == "snd_bomb")
			continue

		// Add the equipped loot
		ConsumableInventoryItem equippedItem

		equippedItem.type = data.index
		equippedItem.count = 1

		final.append( equippedItem )
	}

	return final
}


void function CreateFlowStateDeathBoxForPlayer( entity victim, entity attacker, var damageInfo )
{
	if(FlowStateGetAllDroppableItems( victim ).len() == 0) 
		return
	
	entity deathBox = FlowState_CreateDeathBox( victim, true )

	foreach ( invItem in FlowStateGetAllDroppableItems( victim ) )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByIndex( invItem.type )

		if( ShouldntAddItemToDeathbox( data.ref ) )
		    continue
		else
		{
		    entity loot = SpawnGenericLoot( data.ref, deathBox.GetOrigin(), deathBox.GetAngles(), invItem.count )
		    AddToDeathBox( loot, deathBox )
		}
	}

	UpdateDeathBoxHighlight( deathBox )

	foreach ( func in svGlobal.onDeathBoxSpawnedCallbacks )
		func( deathBox, attacker, damageInfo != null ? DamageInfo_GetDamageSourceIdentifier( damageInfo ) : 0 )
}

bool function ShouldntAddItemToDeathbox( string ref )
{
	switch( ref )
	{
		case "snd_bomb":
		case "health_pickup_combo_small":
		case "health_pickup_combo_large":
		case "health_pickup_health_small":
		case "health_pickup_health_large":
		
		return true
	}
	
	return false
}

entity function FlowState_CreateDeathBox( entity player, bool hasCard )
{
	vector endpos 
	
	vector maxs          = <128,128,128>
	vector mins          = <128,128,128>
	vector pos = player.GetOrigin()
	vector normalDir = Vector(0,0,1)
		
	TraceResults result = TraceHull( pos + <0, 0, 10>, pos, mins, maxs, null, TRACE_MASK_SOLID | CONTENTS_PLAYERCLIP, TRACE_COLLISION_GROUP_NONE )
		
	endpos = result.endPos
	vector normal = result.surfaceNormal		

	vector anglesonground = AnglesOnSurface(Normalize(player.GetUpVector()), player.GetUpVector())
	
	//they should rotate
	//deathboxes should have physics? update july i already did them port them from survival
	
	entity box = CreatePropDeathBox_NoDispatchSpawn( DEATH_BOX, endpos, Vector(0, anglesonground.y, anglesonground.z), 6 )
	box.kv.fadedist = 10000
	if ( hasCard )
		SetTargetName( box, DEATH_BOX_TARGETNAME )

	DispatchSpawn( box )

	box.RemoveFromAllRealms()
	box.AddToOtherEntitysRealms( player )
	box.Solid()
	box.SetUsable()
	box.SetUsableValue( USABLE_BY_ALL | USABLE_CUSTOM_HINTS )
	box.SetOwner( player )
	box.SetNetInt( "ownerEHI", player.GetEncodedEHandle() )
	
	
	if ( hasCard )
	{
		box.SetNetBool( "overrideRUI", false )
		box.SetCustomOwnerName( player.GetPlayerName() )
		box.SetNetInt( "characterIndex", ConvertItemFlavorToLoadoutSlotContentsIndex( Loadout_CharacterClass() , LoadoutSlot_GetItemFlavor( ToEHI( player ) , Loadout_CharacterClass() ) ) )
	}

	if ( hasCard )
	{
		Highlight_SetNeutralHighlight( box, "sp_objective_entity" )
		Highlight_ClearNeutralHighlight( box )

		vector restPos = box.GetOrigin()
		vector fallPos = restPos + < 0, 0, 54 >

		thread (void function( entity box , vector restPos , vector fallPos) {
			entity mover = CreateScriptMover( restPos, box.GetAngles(), 0 )
			if ( IsValid( box ) )
				{
				box.SetParent( mover, "", true )
				mover.NonPhysicsMoveTo( fallPos, 0.5, 0.0, 0.5 )
				}
			wait 0.5
			if ( IsValid( box ) )
				mover.NonPhysicsMoveTo( restPos, 0.5, 0.5, 0.0 )
			wait 0.5
			if ( IsValid( box ) )
				box.ClearParent()
			if ( IsValid( mover ) )
				mover.Destroy()

		}) ( box , restPos , fallPos)

		thread (void function( entity box) {
			wait 0.5
			if(IsValid(box))
				box.AllowMantle()
			
			wait 20
			if(IsValid(box))
				box.Destroy()
		}) ( box )
	}

	return box
}

void function GiveTeamToSNDPlayer()
{
	int newIMC = 0
	int newMILITIA = 0
	
	array<int> togiveCharacters = clone snd_allowedCharacters
	togiveCharacters.randomize()
	
	foreach( player in GetPlayerArray() )
	{
		if(!IsValid(player)) 
			continue
		
		if(player.p.teamasked != -1)
		{
			switch(player.p.teamasked)
			{
				case 0:
					SetTeam(player, TEAM_IMC )
					
					if( newIMC < togiveCharacters.len() && player.p.assignedCustomModel == -1 )
					{
						AssignCharacter(player, togiveCharacters[ newIMC ])
					} else if( newIMC < togiveCharacters.len() && player.p.assignedCustomModel != -1 )
					{
						AssignCharacter( player, 5 )
					}
					
					//Set ppink
					player.SetSkin(2) //full body camo skin, works for all characters very nice
					player.SetCamo(IMC_color)
					player.p.snd_knifecolor = SND_knifeColors[0]
					Remote_CallFunction_NonReplay(player, "SetSNDKnifeColor", 0)
					
					newIMC++
					
					continue
				case 1:
					SetTeam(player, TEAM_MILITIA )

					if( newMILITIA < togiveCharacters.len() && player.p.assignedCustomModel == -1 )
					{
						AssignCharacter(player, togiveCharacters[ newMILITIA ])
					} else if( newMILITIA < togiveCharacters.len() && player.p.assignedCustomModel != -1 )
					{
						AssignCharacter( player, 5 )
					}
					//Set blue
					player.SetSkin(2)
					player.SetCamo(MILITIA_color)
					player.p.snd_knifecolor = SND_knifeColors[1]
					Remote_CallFunction_NonReplay(player, "SetSNDKnifeColor", 1)
					
					newMILITIA++
					continue
			}
		}
		
		if( newMILITIA < FS_SND.maxvotesallowedforTeamMILITIA )
		{
			SetTeam( player, TEAM_MILITIA )
			
			if( newMILITIA < togiveCharacters.len() && player.p.assignedCustomModel == -1 )
			{
				AssignCharacter(player, togiveCharacters[ newMILITIA ])
			} else if( newMILITIA < togiveCharacters.len() && player.p.assignedCustomModel != -1 )
			{
				AssignCharacter( player, 5 )
			}
			
			//Set blue
			player.SetSkin(2)
			player.SetCamo(MILITIA_color)
			player.p.snd_knifecolor = SND_knifeColors[1]
			Remote_CallFunction_NonReplay(player, "SetSNDKnifeColor", 1)
			
			newMILITIA++
			continue
		}
		
		if (newIMC < FS_SND.maxvotesallowedforTeamIMC)
		{
			SetTeam( player, TEAM_IMC )
			
			if( newIMC < togiveCharacters.len() && player.p.assignedCustomModel == -1 )
			{
				AssignCharacter(player, togiveCharacters[ newIMC ])
			} else if( newIMC < togiveCharacters.len() && player.p.assignedCustomModel != -1 )
			{
				AssignCharacter( player, 5 )
			}
			
			//Set pink
			player.SetSkin(2)
			player.SetCamo(IMC_color)
			player.p.snd_knifecolor = SND_knifeColors[0]
			Remote_CallFunction_NonReplay(player, "SetSNDKnifeColor", 0)
			
			newIMC++
			continue
		}
	}
	
	foreach ( player in GetPlayerArray() )
	{
		if(!IsValid(player)) continue
		
		//Remote_CallFunction_NonReplay( player, "UpdateRUITest")
		Remote_CallFunction_ByRef( player, "UpdateRUITest" )
	}
}

//Client commands

bool function ClientCommand_NextRoundSND(entity player, array<string> args)
{
	if( !IsValid(player) ) return false
	
	if(GetGameState() == eGameState.Playing)
		FS_SND.forceRoundEnd = true
	return true
}

bool function ClientCommand_OpenSelectTeamMenu(entity player, array<string> args)
{
	if( !IsValid(player) || player.GetPlayerName() != FlowState_Hoster() ) return false
	
	int endtime = int( Time() ) + 15

	if(!FS_SND.selectTeamMenuOpened)
	{
		FS_SND.selectTeamMenuOpened = true
			
		Remote_CallFunction_UI( player, "Open_FSSND_BuyMenu")
		Remote_CallFunction_UI( player, "Thread_SNDVoteForTeamTimer", endtime)	
	} else {
		FS_SND.selectTeamMenuOpened = false
		Remote_CallFunction_UI( player, "Close_FSSND_BuyMenu")		
	}

	return true
}

bool function ClientCommand_ForceStartGame(entity player, array<string> args)
{
	if( !IsValid(player) )// || player.GetPlayerName() != FlowState_Hoster() ) return false
		return false
		
	FS_SND.forceGameStart = true
	return true
}

bool function ClientCommand_SND_AskForTeam(entity player, array < string > args) 
{	
	if( !IsValid(player) || args.len() != 1 || !FS_SND.selectTeamMenuOpened || player.p.teamasked != -1 ) return false

	switch(args[0])
	{
		case "0":
			if(FS_SND.requestsforIMC <= FS_SND.maxvotesallowedforTeamIMC)
			{
				player.p.teamasked = 0
				FS_SND.requestsforIMC++
				
				foreach( sPlayer in GetPlayerArray() )
				{
					if( !IsValid(sPlayer) ) continue
					
					Remote_CallFunction_UI( sPlayer, "SND_UpdateVotesForTeam", 0, FS_SND.requestsforIMC )
				}
			}
			
			if(FS_SND.requestsforIMC == FS_SND.maxvotesallowedforTeamIMC)
			{
				foreach(sPlayer in GetPlayerArray()) //no more votes allowed for imc, disable this button for all players that have not voted yet and select the other team for them
				{
					if(!IsValid(sPlayer) || IsValid(sPlayer) && sPlayer == player ) continue
					
					if(sPlayer.p.teamasked == -1)
					{
						sPlayer.p.teamasked = 1
						Remote_CallFunction_UI( sPlayer, "SND_Disable_IMCButton")	
					}
				}
			}
		break
		
		case "1":
			if(FS_SND.requestsforMILITIA <= FS_SND.maxvotesallowedforTeamMILITIA)
			{
				player.p.teamasked = 1
				FS_SND.requestsforMILITIA++

				foreach( sPlayer in GetPlayerArray() )
				{
					if( !IsValid(sPlayer) ) continue
					
					Remote_CallFunction_UI( sPlayer, "SND_UpdateVotesForTeam", 1, FS_SND.requestsforMILITIA )
				}
			}
			
			if(FS_SND.requestsforMILITIA == FS_SND.maxvotesallowedforTeamMILITIA)
			{
				foreach(sPlayer in GetPlayerArray()) //no more votes allowed for militia, disable this button for all players that have not voted yet and select the other team for them
				{
					if(!IsValid(sPlayer) || IsValid(sPlayer) && sPlayer == player ) continue
					
					if(sPlayer.p.teamasked == -1)
					{
						sPlayer.p.teamasked = 0
						Remote_CallFunction_UI( sPlayer, "SND_Disable_MILITIAButton")	
					}						
				}					
			}			
		break
		
		default:
			player.p.teamasked = -1
		break
	}	
	
	return true
}

bool function ClientCommand_OpenBuyMenu(entity player, array<string> args)
{
	if( !IsValid(player) ) return false
	
	FS_SND.buyAllowed = true

	AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
	AddCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD )
		
	player.p.availableMoney = 10000 //debug
	player.p.weapon1ref = ""
	player.p.weapon2ref = ""
	player.p.weapon1lvl = -1
	player.p.weapon2lvl = -1
		
	Remote_CallFunction_NonReplay(player, "FlowstateSND_CustomBuyMenu_Start", FS_SND.currentRound, player.p.availableMoney, 0, 0, 0, 0, false)
		
	return true
}

bool function ClientCommand_BuySNDAbility(entity player, array<string> args)
{
	if(!IsValid(player) || args.len() <= 0) 
		return false
	
	entity weaponEntity
    string weapon = args[0]
    int weaponprice
    int weaponid = GetWeaponIDFromRef(weapon)
	
	if( !FS_SND.buyAllowed || weaponid == -1 || weapon == "" ) 
	{
		Remote_CallFunction_ByRef( player, "ServerCallback_BuyRejected" )
		//Remote_CallFunction_NonReplay(player, "ServerCallback_BuyRejected")
		return false
	}
	
	weaponprice = GetWeaponPriceFromRefAndUpgradeLevel(-1, weapon)
	
	if (player.p.availableMoney < weaponprice)
	{
		Remote_CallFunction_ByRef( player, "ServerCallback_BuyRejected" )
		//Remote_CallFunction_NonReplay(player, "ServerCallback_BuyRejected")
		return false
	}
	player.p.availableMoney -= weaponprice
	
	try{
		player.TakeOffhandWeapon( OFFHAND_TACTICAL )
		player.GiveOffhandWeapon(weapon, OFFHAND_TACTICAL)
		player.GetOffhandWeapon( OFFHAND_TACTICAL ).SetWeaponPrimaryClipCount( player.GetOffhandWeapon( OFFHAND_TACTICAL ).GetWeaponPrimaryClipCountMax() )
	}catch(e420){}
	
	Remote_CallFunction_NonReplay(player, "ServerCallback_BuySuccessful", weaponid, -1, -1, weaponprice)

	// Remote_CallFunction_NonReplay( player, "ServerCallback_RefreshInventoryAndWeaponInfo" )
	// Remote_CallFunction_NonReplay(player, "ServerCallback_FlowstateSND_CustomBuyMenu_UpdateValues", player.p.availableMoney, GetWeaponIDFromRef(player.p.weapon1ref), GetWeaponIDFromRef(player.p.weapon2ref), player.p.weapon1lvl, player.p.weapon2lvl)

    return true
}
bool function ClientCommand_BuySNDGrenade(entity player, array<string> args)
{
	if(!IsValid(player) || args.len() <= 0) 
		return false
	
	entity weaponEntity
    string weapon = args[0]
    int weaponprice
    int weaponid = GetWeaponIDFromRef(weapon)
	
	if( weaponid == -1 || weapon == "")
	{
		//Remote_CallFunction_NonReplay(player, "ServerCallback_BuyRejected")
		Remote_CallFunction_ByRef( player, "ServerCallback_BuyRejected" )
		return false
	}
	
    if (!FS_SND.buyAllowed || player.p.grenadesBought >= SND_GRENADES_LIMIT )
	{
		//Remote_CallFunction_NonReplay(player, "ServerCallback_BuyRejected")
		Remote_CallFunction_ByRef( player, "ServerCallback_BuyRejected" )
        return false
	}

	weaponprice = GetWeaponPriceFromRefAndUpgradeLevel(-1, weapon)
	
	if (player.p.availableMoney < weaponprice)
	{
		//Remote_CallFunction_NonReplay(player, "ServerCallback_BuyRejected")
		Remote_CallFunction_ByRef( player, "ServerCallback_BuyRejected" )
		return false
	}

	player.p.availableMoney -= weaponprice
	
	SURVIVAL_AddToPlayerInventory(player, weapon, 1, true)
	player.p.grenadesBought++
	
	Remote_CallFunction_NonReplay(player, "ServerCallback_BuySuccessful", weaponid, OFFHAND_SLOT_FOR_CONSUMABLES, -1, weaponprice)

	Remote_CallFunction_NonReplay( player, "ServerCallback_RefreshInventoryAndWeaponInfo" )
	Remote_CallFunction_NonReplay(player, "ServerCallback_FlowstateSND_CustomBuyMenu_UpdateValues", player.p.availableMoney, GetWeaponIDFromRef(player.p.weapon1ref), GetWeaponIDFromRef(player.p.weapon2ref), player.p.weapon1lvl, player.p.weapon2lvl)
	
	Remote_CallFunction_NonReplay( player, "ClientCodeCallback_OnPlayerConsumableInventoryChanged", player)
	//UpdateInventoryCounter( player, weapon, true )

    return true
}
bool function ClientCommand_BuySNDWeapon(entity player, array<string> args)
{
	if(!IsValid(player) || args.len() == 0) 
		return false

	entity weaponEntity
    string weapon = args[0]
    int weaponprice
    int weaponid = GetWeaponIDFromRef(weapon)
	
	//if its grenade or ability return, create new functions for them
	
	if( weaponid == -1 || weapon == "") 
		return false
	
    if (!FS_SND.buyAllowed)
        return false

    if (player.p.weapon1ref == weapon && player.p.weapon1lvl < 2)
    {
        UpgradeSNDWeapon(player, weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, false)
        return true
    }

    if (player.p.weapon2ref == weapon && player.p.weapon2lvl < 2)
    {
        UpgradeSNDWeapon(player, weapon, WEAPON_INVENTORY_SLOT_PRIMARY_1, false)
        return true
    }

    if (player.p.weapon1ref != "" && player.p.weapon2ref != "")
	{
		//Remote_CallFunction_NonReplay(player, "ServerCallback_BuyRejected")
		Remote_CallFunction_ByRef( player, "ServerCallback_BuyRejected" )
        return false
	}

    if (player.p.weapon1ref == weapon || player.p.weapon2ref == weapon)
	{
		//Remote_CallFunction_NonReplay(player, "ServerCallback_BuyRejected")
		Remote_CallFunction_ByRef( player, "ServerCallback_BuyRejected" )
        return false
	}
	
    if (player.p.weapon1ref == "")
    {
		weaponprice = GetWeaponPriceFromRefAndUpgradeLevel(player.p.weapon1lvl, weapon)
		
		if (player.p.availableMoney < weaponprice)
		{
		//Remote_CallFunction_NonReplay(player, "ServerCallback_BuyRejected")
		Remote_CallFunction_ByRef( player, "ServerCallback_BuyRejected" )
			return false
		}

        entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )

        if (primary != null)
            player.TakeWeaponByEntNow( primary )

        weaponEntity = player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0 )
		SetupInfiniteAmmoForWeapon( player, weaponEntity )		
		player.p.didPlayerBuyAWeapon = true
	
        player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)

        player.p.weapon1ref = weapon

        player.p.availableMoney -= weaponprice

		Remote_CallFunction_NonReplay(player, "ServerCallback_BuySuccessful", weaponid, WEAPON_INVENTORY_SLOT_PRIMARY_0, -1, weaponprice)
		
		if( IsValid( weaponEntity ) )
		{
			weaponEntity.SetWeaponCharm( $"mdl/props/charm/charm_nessy.rmdl", "CHARM")
		}

		Remote_CallFunction_NonReplay( player, "ServerCallback_RefreshInventoryAndWeaponInfo" )
		Remote_CallFunction_NonReplay( player, "ServerCallback_FlowstateSND_CustomBuyMenu_UpdateValues", player.p.availableMoney, GetWeaponIDFromRef(player.p.weapon1ref), GetWeaponIDFromRef(player.p.weapon2ref), player.p.weapon1lvl, player.p.weapon2lvl)
		
		return true
    } else if(player.p.weapon2ref == "") {
		weaponprice = GetWeaponPriceFromRefAndUpgradeLevel(player.p.weapon2lvl, weapon)
		
		if (player.p.availableMoney < weaponprice)
		{
			//Remote_CallFunction_NonReplay(player, "ServerCallback_BuyRejected")
			Remote_CallFunction_ByRef( player, "ServerCallback_BuyRejected" )
			return false
		}
		
        entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )

        if (primary != null)
            player.TakeWeaponByEntNow( primary )

        weaponEntity = player.GiveWeapon( weapon, WEAPON_INVENTORY_SLOT_PRIMARY_1 )
		SetupInfiniteAmmoForWeapon( player, weaponEntity )
		player.p.didPlayerBuyAWeapon = true
	
        player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_1)

        player.p.weapon2ref = weapon

        player.p.availableMoney -= weaponprice
		
		Remote_CallFunction_NonReplay(player, "ServerCallback_BuySuccessful", weaponid, WEAPON_INVENTORY_SLOT_PRIMARY_1, -1, weaponprice)
		
		if( IsValid( weaponEntity ) )
		{
			weaponEntity.SetWeaponCharm( $"mdl/props/charm/charm_nessy.rmdl", "CHARM")
		}

		Remote_CallFunction_NonReplay( player, "ServerCallback_RefreshInventoryAndWeaponInfo" )
		Remote_CallFunction_NonReplay(player, "ServerCallback_FlowstateSND_CustomBuyMenu_UpdateValues", player.p.availableMoney, GetWeaponIDFromRef(player.p.weapon1ref), GetWeaponIDFromRef(player.p.weapon2ref), player.p.weapon1lvl, player.p.weapon2lvl)
		return true
    }

	//Remote_CallFunction_NonReplay(player, "ServerCallback_BuyRejected")
	Remote_CallFunction_ByRef( player, "ServerCallback_BuyRejected" )
    return false
}

bool function ClientCommand_SellSNDAbility(entity player, array<string> args)
{
	if(!IsValid(player) || args.len() == 0) 
		return false

    string weapon = args[0]
    int weaponprice
	int weaponid = GetWeaponIDFromRef(weapon)
	
	if( weaponid == -1 || weapon == "") 
		return false
	
    if (!FS_SND.buyAllowed)
        return false

	weaponprice = GetWeaponPriceFromRefAndUpgradeLevel(-1, weapon)
	
	if(IsValid(player.GetOffhandWeapon( OFFHAND_TACTICAL ) && player.GetOffhandWeapon( OFFHAND_TACTICAL ).GetWeaponClassName() == weapon))
	{
		player.TakeOffhandWeapon( OFFHAND_TACTICAL )
	}
	else 
		return false
	
	Remote_CallFunction_NonReplay(player, "ServerCallback_SellSuccessful", weaponid, OFFHAND_TACTICAL, -1, weaponprice)

    player.p.availableMoney += weaponprice

	Remote_CallFunction_NonReplay( player, "ServerCallback_RefreshInventoryAndWeaponInfo" )
	Remote_CallFunction_NonReplay(player, "ServerCallback_FlowstateSND_CustomBuyMenu_UpdateValues", player.p.availableMoney, GetWeaponIDFromRef(player.p.weapon1ref), GetWeaponIDFromRef(player.p.weapon2ref), player.p.weapon1lvl, player.p.weapon2lvl)
    return true
}

bool function ClientCommand_SellSNDGrenade(entity player, array<string> args)
{
	if(!IsValid(player) || args.len() == 0) 
		return false

    string weapon = args[0]
    int weaponprice
	int weaponid = GetWeaponIDFromRef(weapon)
	
	if( weaponid == -1 || weapon == "") 
		return false
	
    if (!FS_SND.buyAllowed)
        return false

	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	LootData data = SURVIVAL_Loot_GetLootDataByRef( weapon )
	int type = data.index
	
	bool hasGrenadeToDelete = false
	
	for ( int i=playerInventory.len()-1; i>=0; i-- )
	{
		if(playerInventory[i].type == type)
		{
			hasGrenadeToDelete = true
			break
		}
	}
	
	if(!hasGrenadeToDelete) 
		return false
	
	SURVIVAL_RemoveFromPlayerInventory(player, weapon, 1)
	player.p.grenadesBought = maxint(0, player.p.grenadesBought-1)
	
	weaponprice = GetWeaponPriceFromRefAndUpgradeLevel(-1, weapon)
		
	Remote_CallFunction_NonReplay(player, "ServerCallback_SellSuccessful", weaponid, OFFHAND_SLOT_FOR_CONSUMABLES, -1, weaponprice)

    player.p.availableMoney += weaponprice

	Remote_CallFunction_NonReplay( player, "ServerCallback_RefreshInventoryAndWeaponInfo" )
	Remote_CallFunction_NonReplay(player, "ServerCallback_FlowstateSND_CustomBuyMenu_UpdateValues", player.p.availableMoney, GetWeaponIDFromRef(player.p.weapon1ref), GetWeaponIDFromRef(player.p.weapon2ref), player.p.weapon1lvl, player.p.weapon2lvl)
    return true
}

bool function ClientCommand_SellSNDWeapon(entity player, array<string> args)
{
	if(!IsValid(player) || args.len() == 0) 
		return false

    string weapon = args[0]
    int weaponprice
	int weaponid = GetWeaponIDFromRef(weapon)
	
	if( weaponid == -1 || weapon == "") 
		return false
	
    if (!FS_SND.buyAllowed)
        return false

    if (player.p.weapon1ref == weapon)
    {
		weaponprice = GetWeaponPriceFromRefAndUpgradeLevel(player.p.weapon1lvl, weapon)
		
        if (player.p.weapon1lvl > -1)
        {
            UpgradeSNDWeapon(player, weapon, WEAPON_INVENTORY_SLOT_PRIMARY_0, true)
            return true
        }

        // Remote_CallFunction_NonReplay(player, "ServerCallback_UpdateWeaponUpgrades", -1, GetWeaponID(weapon))
		Remote_CallFunction_NonReplay(player, "ServerCallback_SellSuccessful", weaponid, WEAPON_INVENTORY_SLOT_PRIMARY_0, -1, weaponprice)
		
        entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )

        if (primary != null)
            player.TakeWeaponByEntNow( primary )

        player.p.weapon1ref = ""
		player.p.weapon1lvl = -1
		
        if (player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ) != null)
            player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_1)

        player.p.availableMoney += weaponprice
		
		if ( IsValid(player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )))
				player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
		
		Remote_CallFunction_NonReplay( player, "ServerCallback_RefreshInventoryAndWeaponInfo" )
		Remote_CallFunction_NonReplay(player, "ServerCallback_FlowstateSND_CustomBuyMenu_UpdateValues", player.p.availableMoney, GetWeaponIDFromRef(player.p.weapon1ref), GetWeaponIDFromRef(player.p.weapon2ref), player.p.weapon1lvl, player.p.weapon2lvl)
	
		if( player.p.weapon1ref == "" && player.p.weapon2ref == "" )
			player.p.didPlayerBuyAWeapon = false

		return true
    } else if(player.p.weapon2ref == weapon) 
	{
		weaponprice = GetWeaponPriceFromRefAndUpgradeLevel(player.p.weapon2lvl, weapon)
		
        if (player.p.weapon2lvl > -1)
        {
            UpgradeSNDWeapon(player, weapon, WEAPON_INVENTORY_SLOT_PRIMARY_1, true)
            return true
        }

        // Remote_CallFunction_NonReplay(player, "ServerCallback_UpdateWeaponUpgrades", -1, GetWeaponID(weapon))
		Remote_CallFunction_NonReplay(player, "ServerCallback_SellSuccessful", weaponid, WEAPON_INVENTORY_SLOT_PRIMARY_1, -1, weaponprice)
		
        entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )

        if (primary != null)
            player.TakeWeaponByEntNow( primary )

        player.p.weapon2ref = ""
		player.p.weapon2lvl = -1
		
        if (player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ) != null)
            player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_1)

        player.p.availableMoney += weaponprice
		
		if ( IsValid(player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )))
				player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_1)
		
		Remote_CallFunction_NonReplay( player, "ServerCallback_RefreshInventoryAndWeaponInfo" )
		Remote_CallFunction_NonReplay(player, "ServerCallback_FlowstateSND_CustomBuyMenu_UpdateValues", player.p.availableMoney, GetWeaponIDFromRef(player.p.weapon1ref), GetWeaponIDFromRef(player.p.weapon2ref), player.p.weapon1lvl, player.p.weapon2lvl)
	
		if( player.p.weapon1ref == "" && player.p.weapon2ref == "" )
			player.p.didPlayerBuyAWeapon = false

		return true
	}

    return false
}

void function UpgradeSNDWeapon(entity player, string weapon, int slot, bool downgrade)
{
	if(!IsValid(player)) return
	
    //Mastiff and lstar dont have attachments
    if (weapon == "mp_weapon_mastiff" || weapon == "mp_weapon_lstar" || weapon == "mp_weapon_sniper")
	{
		//Remote_CallFunction_NonReplay(player, "ServerCallback_BuyRejected")
		Remote_CallFunction_ByRef( player, "ServerCallback_BuyRejected" )
		return
	}
    
	int currentupgradelevel

    if(slot == WEAPON_INVENTORY_SLOT_PRIMARY_0) {
        
		if(player.p.weapon1lvl == -1) 
			player.p.weapon1lvl = 0
		else
		{
			if(!downgrade)
				player.p.weapon1lvl++
		}
		
		currentupgradelevel = player.p.weapon1lvl
		
    } else if(slot == WEAPON_INVENTORY_SLOT_PRIMARY_1) {


		if(player.p.weapon2lvl == -1) 
			player.p.weapon2lvl = 0
		else
		{
			if(!downgrade)
				player.p.weapon2lvl++
		}
		
        currentupgradelevel = player.p.weapon2lvl
		
    }
	
    if(!downgrade)
    {
		int price = GetWeaponPriceFromRefAndUpgradeLevel(currentupgradelevel, weapon)

		if (player.p.availableMoney < price)
		{
			if(slot == WEAPON_INVENTORY_SLOT_PRIMARY_0)
			{
				player.p.weapon1lvl--
			} else if(slot == WEAPON_INVENTORY_SLOT_PRIMARY_1) {
				player.p.weapon2lvl--
			}

			//Remote_CallFunction_NonReplay(player, "ServerCallback_BuyRejected")
			Remote_CallFunction_ByRef( player, "ServerCallback_BuyRejected" )
			return
		}

        player.p.availableMoney -= price
		Remote_CallFunction_NonReplay(player, "ServerCallback_BuySuccessful", GetWeaponIDFromRef(weapon), slot, currentupgradelevel, price)
    } else 
	{
		int price = GetWeaponPriceFromRefAndUpgradeLevel(currentupgradelevel, weapon)

        player.p.availableMoney += price
		Remote_CallFunction_NonReplay(player, "ServerCallback_SellSuccessful", GetWeaponIDFromRef(weapon), slot, currentupgradelevel, price)
	}

    if(slot == WEAPON_INVENTORY_SLOT_PRIMARY_0) {

		if(downgrade)
			currentupgradelevel--
		
		player.p.weapon1lvl = currentupgradelevel
		
    } else if(slot == WEAPON_INVENTORY_SLOT_PRIMARY_1) {

		if(downgrade)
			currentupgradelevel--

        player.p.weapon2lvl = currentupgradelevel
		
    }
	
    entity currentweapon = player.GetNormalWeapon( slot )

    if (IsValid(currentweapon))
        player.TakeWeaponByEntNow( currentweapon )
	
	array<string> modsToAttach = []
	
	switch(weapon)
	{
		case "mp_weapon_semipistol":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_cq_hcog_classic", "bullets_mag_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_cq_hcog_classic", "bullets_mag_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_cq_hcog_bruiser", "bullets_mag_l3", "hopup_unshielded_dmg"]
				break
			}
		break
		
		case "mp_weapon_shotgun_pistol":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_cq_hcog_classic", "shotgun_bolt_l1", "stock_tactical_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_cq_hcog_classic", "shotgun_bolt_l2", "stock_tactical_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_cq_hcog_bruiser", "shotgun_bolt_l3", "hopup_unshielded_dmg", "stock_tactical_l3"]
				break
			}
		break
		
		case "mp_weapon_wingman":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_cq_hcog_classic", "highcal_mag_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_cq_hcog_classic", "highcal_mag_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_cq_hcog_bruiser", "highcal_mag_l3"]
				break
			}
		break
		
		case "mp_weapon_autopistol":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_cq_holosight", "bullets_mag_l1", "barrel_stabilizer_l2"]
				break
				
				case 1:
					modsToAttach = ["optic_cq_hcog_bruiser", "bullets_mag_l2", "barrel_stabilizer_l3"]
				break
				
				case 2:
					modsToAttach = ["optic_cq_hcog_bruiser", "bullets_mag_l3", "barrel_stabilizer_l4_flash_hider"]//, "hopup_shield_breaker"]
				break
			}
		break
		
		case "mp_weapon_alternator_smg":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_cq_hcog_classic", "bullets_mag_l1", "barrel_stabilizer_l2", "stock_tactical_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_cq_hcog_bruiser", "bullets_mag_l2", "barrel_stabilizer_l3", "stock_tactical_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_cq_hcog_bruiser", "bullets_mag_l3", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3"]
				break
			}
		break
		
		case "mp_weapon_r97":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_cq_hcog_classic", "bullets_mag_l1", "barrel_stabilizer_l2", "stock_tactical_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_cq_hcog_bruiser", "bullets_mag_l2", "barrel_stabilizer_l3", "stock_tactical_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_cq_hcog_classic", "bullets_mag_l3", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3"]
				break
			}
		break
		
		case "mp_weapon_volt_smg":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_cq_hcog_classic", "energy_mag_l1", "barrel_stabilizer_l2", "stock_tactical_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_cq_hcog_bruiser", "energy_mag_l2", "barrel_stabilizer_l3", "stock_tactical_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_cq_hcog_bruiser", "energy_mag_l3", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3"]
				break
			}
		break

		case "mp_weapon_pdw":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_cq_hcog_classic", "highcal_mag_l1", "stock_tactical_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_cq_hcog_bruiser", "highcal_mag_l2", "stock_tactical_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_cq_holosight", "highcal_mag_l3", "stock_tactical_l3"]
				break
			}
		break
		
		case "mp_weapon_shotgun":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_cq_hcog_classic","shotgun_bolt_l1", "stock_tactical_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_cq_hcog_classic", "shotgun_bolt_l2", "stock_tactical_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_cq_hcog_classic", "shotgun_bolt_l3", "stock_tactical_l3"]
				break
			}
		break
		
		case "mp_weapon_energy_shotgun":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_cq_hcog_classic","shotgun_bolt_l1", "stock_tactical_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_cq_hcog_classic", "shotgun_bolt_l2", "stock_tactical_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_cq_hcog_classic", "shotgun_bolt_l3", "stock_tactical_l3"]
				break
			}
		break
		
		case "mp_weapon_energy_ar":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_cq_holosight", "energy_mag_l1", "stock_tactical_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_cq_hcog_bruiser", "energy_mag_l2", "stock_tactical_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_cq_hcog_bruiser", "energy_mag_l2", "stock_tactical_l2", "hopup_turbocharger"]
				break
			}
		break

		case "mp_weapon_hemlok":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_cq_holosight", "highcal_mag_l1", "barrel_stabilizer_l2", "stock_tactical_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_cq_hcog_bruiser", "highcal_mag_l2", "barrel_stabilizer_l3", "stock_tactical_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_cq_hcog_bruiser", "highcal_mag_l3", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3"]
				break
			}
		break
		
		case "mp_weapon_vinson":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_cq_holosight", "highcal_mag_l1", "stock_tactical_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_cq_hcog_bruiser", "highcal_mag_l2", "stock_tactical_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_cq_hcog_bruiser", "highcal_mag_l3", "stock_tactical_l3"]
				break
			}
		break
		
		case "mp_weapon_rspn101":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_cq_holosight", "bullets_mag_l1", "barrel_stabilizer_l2", "stock_tactical_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_cq_hcog_bruiser", "bullets_mag_l2", "barrel_stabilizer_l3", "stock_tactical_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_cq_hcog_bruiser", "bullets_mag_l3", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3"]
				break
			}
		break

		case "mp_weapon_esaw":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_cq_holosight", "energy_mag_l1", "barrel_stabilizer_l2", "stock_tactical_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_cq_hcog_bruiser", "energy_mag_l2", "barrel_stabilizer_l3", "stock_tactical_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_cq_hcog_bruiser", "energy_mag_l3", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l2", "hopup_turbocharger"]
				break
			}
		break

		case "mp_weapon_lmg":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_cq_hcog_classic", "highcal_mag_l1", "barrel_stabilizer_l2", "stock_tactical_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_cq_hcog_bruiser", "highcal_mag_l2", "barrel_stabilizer_l3", "stock_tactical_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_cq_hcog_bruiser", "highcal_mag_l3", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3"]
				break
			}
		break

		case "mp_weapon_g2":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_cq_hcog_bruiser", "bullets_mag_l1", "barrel_stabilizer_l2", "stock_sniper_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_ranged_hcog", "bullets_mag_l2", "barrel_stabilizer_l3", "stock_sniper_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_ranged_hcog", "highcal_mag_l3", "barrel_stabilizer_l4_flash_hider", "stock_tactical_l3"]
				break
			}
		break

		case "mp_weapon_doubletake":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_cq_hcog_bruiser", "energy_mag_l1", "stock_sniper_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_ranged_hcog", "energy_mag_l2", "stock_sniper_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_ranged_hcog", "energy_mag_l3", "stock_tactical_l3"]
				break
			}
		break

		case "mp_weapon_dmr":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_sniper", "highcal_mag_l1", "barrel_stabilizer_l2", "stock_sniper_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_sniper_variable", "highcal_mag_l2", "barrel_stabilizer_l3", "stock_sniper_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_sniper_variable", "highcal_mag_l3", "barrel_stabilizer_l4_flash_hider", "stock_sniper_l3"]
				break
			}
		break

		case "mp_weapon_defender":
			switch(currentupgradelevel)
			{
				case 0:
					modsToAttach = ["optic_ranged_hcog", "stock_sniper_l1"]
				break
				
				case 1:
					modsToAttach = ["optic_sniper", "stock_sniper_l2"]
				break
				
				case 2:
					modsToAttach = ["optic_sniper_variable", "stock_sniper_l3"]
				break
			}
		break	
	}
	
	printt("=== UpgradeSNDWeapon debug ", currentupgradelevel)
	
	foreach(mod in modsToAttach)
		printt(mod)
	
	entity givenWeapon

	try{
	givenWeapon = player.GiveWeapon( weapon, slot, modsToAttach )
	SetupInfiniteAmmoForWeapon( player, givenWeapon )
	}catch(e420){}
		
	if(!IsValid(givenWeapon)) return
	
	if( givenWeapon.LookupAttachment( "CHARM" ) != 0 )
		givenWeapon.SetWeaponCharm( $"mdl/props/charm/charm_nessy.rmdl", "CHARM")

	Remote_CallFunction_NonReplay(player, "ServerCallback_FlowstateSND_CustomBuyMenu_UpdateValues", player.p.availableMoney, GetWeaponIDFromRef(player.p.weapon1ref), GetWeaponIDFromRef(player.p.weapon2ref), player.p.weapon1lvl, player.p.weapon2lvl)

    player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, slot)
}

void function CleanupGroundAfterEachRound()
{
	array<entity> loot = GetEntArrayByClass_Expensive( "prop_survival" )

	foreach ( item in loot )
	{
		if ( IsValid( item ) )
			item.Destroy()
	}
}

void function TrackPlayerSprinting(entity player)
{
	AddPlayerMovementEventCallback( player, ePlayerMovementEvents.JUMP, OnPlayerJumpedStamina )
	AddPlayerMovementEventCallback( player, ePlayerMovementEvents.MANTLE, OnPlayerMantleStamina )

	while( IsValid( player ) )
	{
		if(player.GetPlayerNetInt( "playerStamina" ) == 0)
		{
			StatusEffect_AddEndless( player, eStatusEffect.move_slow, 0.1)
			StatusEffect_AddTimed( player, eStatusEffect.shellshock, 0.5, 1.5, 1.5 )
			StatusEffect_AddTimed( player, eStatusEffect.turn_slow, 0.5, 1.5, 1.5 )
			player.SetPlayerNetBool( "playerStaminaRecovering", true )
			player.ForceStand()
			waitthread StaminaRegenAfterOut(player)
			player.UnforceStand()
			StatusEffect_StopAllOfType( player, eStatusEffect.move_slow)
			player.SetPlayerNetBool( "playerStaminaRecovering", false )
		}

		if ( player.IsSprinting() && player.GetPlayerNetInt( "playerStamina" ) > 0)
			player.SetPlayerNetInt( "playerStamina", player.GetPlayerNetInt( "playerStamina" ) - 2 )

		if ( player.IsWallRunning() && player.GetPlayerNetInt( "playerStamina" ) > 0)
			player.SetPlayerNetInt( "playerStamina", player.GetPlayerNetInt( "playerStamina" ) - 1 )

		if ( !player.IsSprinting() && player.IsOnGround() && !player.IsWallRunning() && player.GetPlayerNetInt( "playerStamina" ) < 100)
			player.SetPlayerNetInt( "playerStamina", player.GetPlayerNetInt( "playerStamina" ) + 1 )

		//if( player.IsSliding() && player.GetPlayerNetInt( "playerStamina" ) > 0)
		//{
		//	int newvalue = player.GetPlayerNetInt( "playerStamina" ) - 5
		//	if(newvalue < 0)
		//		newvalue = 0
		//	
		//	player.SetPlayerNetInt( "playerStamina", newvalue )
		//}

		// printf("Stamina Left: " + player.GetPlayerNetInt( "playerStamina" ))

		WaitFrame()
	}
}

void function OnPlayerMantleStamina(entity player)
{
	if ( player.GetPlayerNetInt( "playerStamina" ) > 0 && StatusEffect_GetSeverity( player, eStatusEffect.move_slow ) == 0.0)
	{
		int newvalue = player.GetPlayerNetInt( "playerStamina" ) - 2
		if(newvalue < 0)
			newvalue = 0
		
		player.SetPlayerNetInt( "playerStamina", newvalue )
	}
}

void function OnPlayerJumpedStamina(entity player)
{
	if ( player.GetPlayerNetInt( "playerStamina" ) > 0 && StatusEffect_GetSeverity( player, eStatusEffect.move_slow ) == 0.0)
	{
		int newvalue = player.GetPlayerNetInt( "playerStamina" ) - 5
		if(newvalue < 0)
			newvalue = 0
		
		player.SetPlayerNetInt( "playerStamina", newvalue )
	}
}

void function StaminaRegenAfterOut(entity player)
{
	while( IsValid( player ) && player.GetPlayerNetInt( "playerStamina" ) < 100)
	{
		player.SetPlayerNetInt( "playerStamina", player.GetPlayerNetInt( "playerStamina" ) + 1 )
		WaitFrame()
	}

	player.SetPlayerNetInt( "playerStamina", 100 )
}