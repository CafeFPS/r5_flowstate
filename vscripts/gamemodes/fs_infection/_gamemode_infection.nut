//APEX INFECTED
//Made by @CafeFPS (@CafeFPS)

// Julefox - Mystery box scripts
// @KralRindo - Shadowfall gamemode initial implementation
// everyone else - advice

global function _GamemodeInfection_Init
global function _RegisterLocationINFECTION
global function FlowstateInfection_CallEvac

bool colombiaDebug = false
global const float SURVIVOR_STREAK_ANNOUNCE_TIME = 5
global const int ADD_ALPHA_EVERY_X_PLAYERS = 10
bool VOTING_PHASE_ENABLE_INFECTED = true

struct{
	bool isAlphaMoment = false
	bool moreThanHalfRound = false
	bool lastManStandingChosen = false
	entity CoolEvac
	bool CoolEvacSpawned
	bool forceLegendsWin //they took evac
	bool wonByAllLegendsKilled
	vector EvacShipLZ
	
	float endTime = 0
	int winnerTeam = 0
	vector chosenRingCircle
	entity ringBoundary
	
	// Voting
	array<entity> votedPlayers
	bool votingtime = false
	bool votestied = false
	array<int> mapVotes
	array<int> mapIds
	int mappicked = 0
	int currentRound = 1
	float allowedRadius
	array<LocationSettings> locationSettings
	LocationSettings& selectedLocation
} FS_INFECTION

void function _GamemodeInfection_Init()
{
	SetConVarInt("sv_quota_stringCmdsPerSecond", 100)
	
	if(GetCurrentPlaylistVarBool("enable_global_chat", true))
		SetConVarBool("sv_forceChatToTeamOnly", false)
	else
		SetConVarBool("sv_forceChatToTeamOnly", true)
	
	AddCallback_OnClientConnected( void function(entity player) { 
		thread _OnPlayerConnectedInfection(player)
    })
	
	AddCallback_OnPlayerKilled( void function(entity victim, entity attacker, var damageInfo) {
        _OnPlayerKilledInfection(victim, attacker, damageInfo)
    })
	
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
	
	// AddClientCommandCallback("next_round", ClientCommand_NextRoundINFECTION)
	// AddClientCommandCallback("sethunter", ClientCommand_AskForHunterTemp)
	// AddClientCommandCallback("kickplayer", ClientCommand_DuckHuntKick)
	AddClientCommandCallback("VoteForMap", ClientCommand_VoteForMap)
	AddClientCommandCallback("DisconnectAllClients", ClientCommand_Admin_DisconnectAllClients)
	
	PrecacheParticleSystem(DROPPOD_SPAWN_FX)
	PrecacheParticleSystem($"P_ar_holopilot_trail")
	PrecacheParticleSystem($"P_ar_titan_droppoint_tall")
	
	PrecacheModel($"mdl/door/canyonlands_door_single_02.rmdl")
	PrecacheModel($"mdl/door/door_canyonlands_large_01_animated.rmdl")
	PrecacheModel($"mdl/door/door_256x256x8_elevatorstyle02_animated.rmdl")
	PrecacheModel($"mdl/Humans/pilots/ptpov_master_chief.rmdl")
	PrecacheModel($"mdl/Humans/pilots/w_master_chief.rmdl")
	PrecacheModel($"mdl/Humans/pilots/w_blisk.rmdl")
	PrecacheModel($"mdl/Humans/pilots/pov_blisk.rmdl")
	
	RegisterSignal("EndScriptedPropsThread")
	RegisterSignal("EvacCompleted")
	RegisterSignal("MatchEndedEarlyDontCallEvac")
	thread Infection_StartGameThread()
	
	AddSpawnCallback( "prop_survival", OnPropSurvivalSpawned_Infection )
	//StartMysteryBoxesLoop()
}

// void function StartMysteryBoxesLoop()
// {
	// RegisterMysteryBoxLocation( < 4966.9502, 8444.75879, -4295.90625 >, < 0, 148.6, 0 > )
	// RegisterMysteryBoxLocation( < 2100.60107, 5354.08203, -3207.96875 >, < 0, -90, 0 > )
	// RegisterMysteryBoxLocation( < 6143.9292, 6060.78271, -3503.69702 >, < 0, -90, 0 > )
	// RegisterMysteryBoxLocation( < 2049.49829, 11961.0732, -3336.95386 >, < 0, 90, 0 > )
	// RegisterMysteryBoxLocation( <9651.8125, 5981.89258, -3695.96875>, < 0, -90, 0 > )
	
	// MysteryBoxMapInit( 1 )
// }
	
void function _OnPlayerConnectedInfection(entity player)
{
	while(IsDisconnected( player )) WaitFrame()

    if(!IsValid(player)) return

	AssignCharacter(player, RandomInt(9))
	player.SetPlayerGameStat( PGS_DEATHS, 0)
	SetTeam(player, TEAM_IMC)
	switch(GetGameState())
    {
		case eGameState.WaitingForPlayers:
		case eGameState.MapVoting:
		
			if(!IsValid(player)) return
			
			//Remote_CallFunction_NonReplay(player, "Minimap_DisableDraw_Internal")
			Remote_CallFunction_ByRef( player, "Minimap_DisableDraw_Internal" )
			player.FreezeControlsOnServer()

			Survival_SetInventoryEnabled( player, false )
			SetPlayerInventory( player, [] )
			
			if(IsPlayerEliminated(player))
				ClearPlayerEliminated(player)
			
			break
		case eGameState.Playing:
		
			if(!IsValid(player)) return
			
			if ( IsPlayerEliminated( player ) || FS_INFECTION.moreThanHalfRound || FS_INFECTION.lastManStandingChosen )
				thread StartSpectatingInfection(player, null)
			else
			{	
				_HandleRespawn(player)
				SpawnAsSurvivor(player)
			}
			break
		default:
			break
	}
	AddEntityCallback_OnDamaged( player, Infection_OnPlayerDamage )
	UpdatePlayerCounts()
}

void function _OnPlayerKilledInfection(entity victim, entity attacker, var damageInfo)
{
	if ( !IsValid( victim ) || !IsValid( attacker) || IsValid(victim) && !victim.IsPlayer() )
		return
	
	switch(GetGameState())
    {
		case eGameState.Playing:
		
			thread function() : (victim, attacker, damageInfo) 
			{
				if( attacker.IsPlayer() && attacker.GetTeam() == TEAM_IMC )
				{
					// Infection_KillStreakAnnounce(attacker)
					attacker.p.infectionRoundKills++
					// thread PerksSystem(attacker)
				}

				if(victim.GetTeam() == TEAM_IMC)
				{
					array<string> laughs = [
						"diag_ap_nocNotify_revengeKill_01_01_3p",
						"diag_ap_nocNotify_revengeKill_01_02_3p",
						// "diag_ap_nocNotify_revengeKill_01_03_3p",
						// "diag_ap_nocNotify_revengeKill_01_04_3p",
						// "diag_ap_nocNotify_revengeKill_01_05_3p"
					]
					
					if(CoinFlip())
						EmitSoundOnEntity(victim, laughs.getrandom())
					
					if(!FS_INFECTION.lastManStandingChosen)
						CreateWaypoint_Test( attacker, ePingType.SHADOWFALL_LEGEND_DEATH, victim.GetAttachmentOrigin( victim.LookupAttachment( "CHESTFOCUS" ) ), -1 )
						
					wait DEATHCAM_TIME_SHORT
					if( !IsValid(victim) || GetGameState() != eGameState.Playing) return

					Remote_CallFunction_NonReplay( victim, "CleanUpInfectedClientEffects" )
		
					foreach(entFx in victim.p.shadowAttachedEntities)
						if(IsValid(entFx))
						{
							EffectStop( entFx )
							entFx.Destroy()
						}
					SetTeam(victim, TEAM_MILITIA)
					_HandleRespawn(victim)					
					
					Remote_CallFunction_ByRef( victim, "Minimap_EnableDraw_Internal" )
					//Remote_CallFunction_NonReplay(victim, "Minimap_EnableDraw_Internal")

					victim.SetVelocity(Vector(0,0,0))

					LocPair bestspawn = FlowstateInfection_GetBestSpawnPoint()

					victim.SetOrigin(bestspawn.origin)
					victim.SetAngles(bestspawn.angles)		
						
					TakeAllWeapons(victim)
					TakeLoadoutRelatedWeapons(victim)
					
					ClearInvincible(victim)
					victim.SetThirdPersonShoulderModeOff()

					Survival_SetInventoryEnabled( victim, false )
					SetPlayerInventory( victim, [] )
					BecomeInfected( victim )
				}
				else if(victim.GetTeam() == TEAM_MILITIA)
				{
					if(!FS_INFECTION.lastManStandingChosen)
						CreateWaypoint_Test( attacker, ePingType.SHADOWFALL_SHADOW_DEATH, victim.GetAttachmentOrigin( victim.LookupAttachment( "CHESTFOCUS" ) ), -1 )
				
					Remote_CallFunction_NonReplay(attacker, "INFECTION_QuickHint", -3, false, 0)
					
					thread function() : (victim)
					{
						if(IsValid(victim.p.DEV_lastDroppedSurvivalWeaponProp))
							victim.p.DEV_lastDroppedSurvivalWeaponProp.Destroy()

						StopSoundOnEntity(victim, "ShadowLegend_Shadow_Loop_3P")
						StartParticleEffectOnEntity_ReturnEntity( victim, PrecacheParticleSystem( $"P_Bshadow_death" ), FX_PATTACH_POINT_FOLLOW, victim.LookupAttachment( "CHESTFOCUS" ) )
						
						MakeInvincible( victim )
						victim.Hide()

						WaitFrame() //guarantee player killed callback is completed so we can spawn properly + don't show ragdoll for shadows

						if(!IsValid(victim)) return
						
						Remote_CallFunction_NonReplay( victim, "CleanUpInfectedClientEffects" )
			
						foreach(entFx in victim.p.shadowAttachedEntities)
							if(IsValid(entFx))
							{
								EffectStop( entFx )
								entFx.Destroy()
							}
							
						SetTeam(victim, TEAM_MILITIA)

						victim.SetVelocity(Vector(0,0,0))

						int randomspawn = RandomIntRangeInclusive(0, FS_INFECTION.selectedLocation.spawns.len()-1)

						LocPair bestspawn = FlowstateInfection_GetBestSpawnPoint()

						victim.SetOrigin(bestspawn.origin)
						victim.SetAngles(bestspawn.angles)		

						//victim.SetOrigin(FS_INFECTION.selectedLocation.spawns[0].origin)
						
						ClearInvincible(victim)
						_HandleRespawn(victim)	
						
						Remote_CallFunction_ByRef( victim, "Minimap_EnableDraw_Internal" )
						//Remote_CallFunction_NonReplay(victim, "Minimap_EnableDraw_Internal")
							
						TakeLoadoutRelatedWeapons(victim)
						
						ClearInvincible(victim)
						victim.Show()
						victim.SetThirdPersonShoulderModeOff()

						Survival_SetInventoryEnabled( victim, false )
						SetPlayerInventory( victim, [] )
						
						BecomeInfected( victim )
					}()
				}
			}()
		break
	}	
	printt("Flowstate DEBUG - INFECTION player killed.", victim, " -by- ", attacker)
}

void function Infection_StartGameThread()
{
    WaitForGameState(eGameState.Playing)
	
    for(;;)
	{
		Infection_Lobby()
		Infection_GameLoop()
		WaitFrame()
	}
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

void function _HandleRespawn(entity player)
{
	if(!IsValid(player)) return

	try{
		if(player.p.isSpectating)
		{
			player.p.isSpectating = false
			player.SetPlayerNetInt( "spectatorTargetCount", 0 )
			player.SetSpecReplayDelay( 0 )
			player.SetObserverTarget( null )
			player.StopObserverMode()
			//Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Deactivate")
			Remote_CallFunction_ByRef( player, "ServerCallback_KillReplayHud_Deactivate" )
		}
	}catch(e420){}

	if(!IsAlive(player)) 
	{
		DecideRespawnPlayer(player, true)
	}

	player.UnforceStand()
	player.UnfreezeControlsOnServer()
	
	player.SetPlayerNetBool( "pingEnabled", true )
	player.SetHealth( player.GetMaxHealth() )
	player.SetMoveSpeedScale(1)
	TakeAllWeapons(player)
	
	//Remote_CallFunction_NonReplay(player, "Minimap_DisableDraw_Internal")
	Remote_CallFunction_ByRef( player, "Minimap_DisableDraw_Internal" )
	GivePassive(player, ePassives.PAS_PILOT_BLOOD)
	
	player.MovementEnable()
	player.SetPhysics( MOVETYPE_WALK )
	
	if(IsPlayerEliminated(player))
		ClearPlayerEliminated(player)
}

void function Infection_Lobby()
{
	WaitFrame()
	SetGameState(eGameState.MapVoting)
	
	if(IsValid(FS_INFECTION.CoolEvac))
	{
		FS_INFECTION.CoolEvac.Destroy()
	}

	foreach(player in GetPlayerArray())
	{
		if(!IsValid(player)) continue

		if( !IsAlive( player ) )
		{
			player.kv.jumpHeight = 100
			//DoRespawnPlayer(player, null)
		}
		
		StopSoundOnEntity(player, "ShadowLegend_Shadow_Loop_3P")
		player.MakeVisible()
		player.p.infectionRoundKills = 0
		player.p.amIAlphaZombie = false
		player.SetPlayerNetInt( "kills", 0 ) //Reset for kills
		player.SetPlayerNetInt( "deaths", 0 ) //Reset for deaths
		player.SetPlayerGameStat( PGS_KILLS, 0 )
		player.SetPlayerGameStat( PGS_DEATHS, 0 )
		player.p.playerDamageDealt = 0.0
		player.SetPlayerNetInt( "damage", 0 )

		//perks reset
		player.p.hasSecondaryWeaponPerk = false
		player.p.hasQuickReloadPerk = false
		player.p.hasBetterMagsPerk = false
		player.p.hasHardenedPerk = false
	
		if( player.HasPassive( ePassives.PAS_PILOT_BLOOD ) )
			TakePassive(player, ePassives.PAS_PILOT_BLOOD)
		
		Remote_CallFunction_NonReplay( player, "CleanUpInfectedClientEffects" )

		foreach(entFx in player.p.shadowAttachedEntities)
			if(IsValid(entFx))
			{
				EffectStop( entFx )
				entFx.Destroy()
			}
		
		AlphaInfectedTrail(player, false)

		player.kv.airSpeed = player.GetPlayerSettingFloat( "airSpeed" )
		player.kv.airAcceleration = player.GetPlayerSettingFloat( "airAcceleration" )
		// player.kv.jumpHeight = player.GetPlayerSettingFloat( "jumpHeight" )
		// player.kv.gravityScale = player.GetPlayerSettingFloat( "gravityScale" )
		// player.kv.stepHeight = player.GetPlayerSettingFloat( "stepHeight" )
		
		player.p.shadowAttachedEntities.clear()
		
		if(player.IsShadowForm())
			player.LeaveShadowForm()
		player.SetPlayerNetBool( "isPlayerShadowForm", false )
		
		ItemFlavor skin = GetDefaultItemFlavorForLoadoutSlot( ToEHI(player), Loadout_CharacterSkin( LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() ) ) )
		CharacterSkin_Apply( player, skin )
	
		SetPlayerInventory( player, [] )
		Inventory_SetPlayerEquipment(player, "", "armor")
		
		player.FreezeControlsOnServer()
		
		Remote_CallFunction_ByRef( player, "Minimap_DisableDraw_Internal" )
		//Remote_CallFunction_NonReplay(player, "Minimap_DisableDraw_Internal")
		
		Remote_CallFunction_NonReplay(player, "Infection_DestroyEvacCountdown")
		
		SetTeam(player, TEAM_IMC)
		
		if( IsAlive( player ) )
			player.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_despawn } )
	}

	if( !VOTING_PHASE_ENABLE_INFECTED )
	{
		WaitFrame()
	} else{
			thread function() : ()
			{
				if(FS_INFECTION.locationSettings.len() < NUMBER_OF_MAP_SLOTS_FSDM) 
				{
					VOTING_PHASE_ENABLE_INFECTED = false
					return
				}

				for( int i = 0; i < NUMBER_OF_MAP_SLOTS_FSDM; ++i )
				{
					while( true )
					{
						// Get a random location id from the available locations
						int randomId = RandomIntRange(0, FS_INFECTION.locationSettings.len())

						// If the map already isnt picked for voting then append it to the array, otherwise keep looping till it finds one that isnt picked yet
						if( !FS_INFECTION.mapIds.contains( randomId ) )
						{
							FS_INFECTION.mapIds.append( randomId )
							break
						}
					}
				}
			}()
			
	}

	if( VOTING_PHASE_ENABLE_INFECTED ) //&& !colombiaDebug )
	{
		ResetMapVotes()

		// Set voting to be allowed
		FS_INFECTION.votingtime = true
		float endtimeVotingTime = Time() + 16
		
		// For each player, set voting screen and update maps that are picked for voting
		foreach( player in GetPlayerArray() )
		{
			if( !IsValid( player ) )
				continue
			
			Remote_CallFunction_Replay(player, "ServerCallback_FSDM_OpenVotingPhase", true)
			//Remote_CallFunction_NonReplay(player, "ServerCallback_FSDM_CoolCamera")
			Remote_CallFunction_ByRef( player, "ServerCallback_FSDM_CoolCamera" )
			Remote_CallFunction_Replay(player, "ServerCallback_FSDM_UpdateMapVotesClient", FS_INFECTION.mapVotes[0], FS_INFECTION.mapVotes[1], FS_INFECTION.mapVotes[2], FS_INFECTION.mapVotes[3])
			Remote_CallFunction_Replay(player, "ServerCallback_FSDM_UpdateVotingMaps", FS_INFECTION.mapIds[0], FS_INFECTION.mapIds[1], FS_INFECTION.mapIds[2], FS_INFECTION.mapIds[3])
			Remote_CallFunction_Replay(player, "ServerCallback_FSDM_SetScreen", eFSDMScreen.VoteScreen, endtimeVotingTime, eFSDMScreen.NotUsed, eFSDMScreen.NotUsed)
			
		}

		wait 16

		FS_INFECTION.votestied = false
		bool anyVotes = false

		// Make voting not allowed
		FS_INFECTION.votingtime = false

		// See if there was any votes in the first place
		foreach( int votes in FS_INFECTION.mapVotes )
		{
			if( votes > 0 )
			{
				anyVotes = true
				break
			}
		}

		if ( anyVotes )
		{
			// store the highest vote count for any of the maps
			int highestVoteCount = -1

			// store the last map id of the map that has the highest vote count
			int highestVoteId = -1

			// store map ids of all the maps with the highest vote count
			array<int> mapsWithHighestVoteCount


			for(int i = 0; i < NUMBER_OF_MAP_SLOTS_FSDM; ++i)
			{
				int votes = FS_INFECTION.mapVotes[i]
				if( votes > highestVoteCount )
				{
					highestVoteCount = votes
					highestVoteId = FS_INFECTION.mapIds[i]

					// we have a new highest, so clear the array
					mapsWithHighestVoteCount.clear()
					mapsWithHighestVoteCount.append(FS_INFECTION.mapIds[i])
				}
				else if( votes == highestVoteCount ) // if this map also has the highest vote count, add it to the array
				{
					mapsWithHighestVoteCount.append(FS_INFECTION.mapIds[i])
				}
			}

			// if there are multiple maps with the highest vote count then it's a tie
			if( mapsWithHighestVoteCount.len() > 1 )
			{
				FS_INFECTION.votestied = true
			}
			else // else pick the map with the highest vote count
			{
				// Set the vote screen for each player to show the chosen location
				foreach( player in GetPlayerArray() )
				{
					if( !IsValid( player ) )
						continue

					Remote_CallFunction_Replay(player, "ServerCallback_FSDM_SetScreen", eFSDMScreen.SelectedScreen, eFSDMScreen.NotUsed, highestVoteId, eFSDMScreen.NotUsed)
				}

				// Set the location to the location that won
				FS_INFECTION.mappicked = highestVoteId
			}

			if ( FS_INFECTION.votestied )
			{
				foreach( player in GetPlayerArray() )
				{
					if( !IsValid( player ) )
						continue

					Remote_CallFunction_Replay(player, "ServerCallback_FSDM_SetScreen", eFSDMScreen.TiedScreen, eFSDMScreen.NotUsed, 42069, eFSDMScreen.NotUsed)
				}

				mapsWithHighestVoteCount.randomize()
				waitthread RandomizeTiedLocations(mapsWithHighestVoteCount)
			}
		}
		else // No one voted so pick random map
		{
			// Pick a random location id from the aviable locations
			FS_INFECTION.mappicked = RandomIntRange(0, FS_INFECTION.locationSettings.len() - 1)

			// Set the vote screen for each player to show the chosen location
			foreach( player in GetPlayerArray() )
			{
				if( !IsValid( player ) )
					continue

				Remote_CallFunction_Replay(player, "ServerCallback_FSDM_SetScreen", eFSDMScreen.SelectedScreen, eFSDMScreen.NotUsed, FS_INFECTION.mappicked, eFSDMScreen.NotUsed)
			}
		}

		//Set selected location
		FS_INFECTION.selectedLocation = FS_INFECTION.locationSettings[ FS_INFECTION.mappicked ]

		if( FS_INFECTION.selectedLocation.name == "Shipment" )
			printt("shipment time")

		array<LocPair> spawns = FS_INFECTION.selectedLocation.spawns
		int numAirdropsForThisRound = 1
		int tries
		
		FS_INFECTION.chosenRingCircle = OriginToGround(GetCenterOfCircle( spawns ))
		
		thread FlowstateInfection_GetLandingZoneForEvacShip()

		printt("Next location center: " + FS_INFECTION.chosenRingCircle + " - Colombia")
		
		//wait for timing
		wait 5

		// Close the votemenu for each player
		foreach( player in GetPlayerArray() )
		{
			if( !IsValid( player ) )
				continue
			
			ScreenCoverTransition_Player(player, Time() + 2)
		}
		
		wait 1

		foreach( player in GetPlayerArray() )
		{
			if( !IsValid( player ) )
				continue
			
			Remote_CallFunction_Replay(player, "ServerCallback_FSDM_OpenVotingPhase", false)
		}
		// Clear players the voted for next voting
		FS_INFECTION.votedPlayers.clear()

		// Clear mapids for next voting
		FS_INFECTION.mapIds.clear()
	}
	else
	{
		FS_INFECTION.selectedLocation = FS_INFECTION.locationSettings[ 0 ]
		array<LocPair> spawns = FS_INFECTION.selectedLocation.spawns
		FS_INFECTION.chosenRingCircle = OriginToGround(GetCenterOfCircle( spawns ))		
	}
}

void function Infection_GameLoop()
{
	array<LocPair> spawns = FS_INFECTION.selectedLocation.spawns
	array<LocPair> actualSpawns
	
	FS_INFECTION.allowedRadius = float(minint(5000 + 80*GetPlayerArray().len(), 8000))
	
	if( MapName() == eMaps.mp_rr_thepit )
	{
		FS_INFECTION.allowedRadius = 5000
		
		array<vector> lzthepit		
		lzthepit.append(<366.916016, 1710.0614, 16.25>)
		lzthepit.append(<-1566.07056, 1678.12781, 87.25>)
		lzthepit.append(<-1520.65747, -484.283447, 86.84375>)
		lzthepit.append(<454.871857, -484.992889, 16.25>)

		FS_INFECTION.EvacShipLZ = lzthepit.getrandom()
		
		printt("Pit time, hardcoded LZ. Next LZ point: " + FS_INFECTION.EvacShipLZ)
	}
	
	//get spawn points inside allowed radius
	foreach(spawn in spawns)
	{
		if( Distance( spawn.origin, FS_INFECTION.chosenRingCircle ) <= FS_INFECTION.allowedRadius )
			actualSpawns.append(spawn)
	}

	if(actualSpawns.len() == 0) //just in case it doesn't found spawn points inside allowed radius
	{
		//get initial seed for ring, the nearest spawn point to the center
		array<float> SpawnsDistances
		foreach(spawn in spawns)
		{
			SpawnsDistances.append(Distance( spawn.origin, FS_INFECTION.chosenRingCircle ))
		}
		float compare = 99999
		int j = 0
		for(int i = 0; i < spawns.len(); i++)
		{
			if(SpawnsDistances[i] < compare)
			{
				compare = SpawnsDistances[i]
				j = i
			}
		}		
		FS_INFECTION.chosenRingCircle = spawns[j].origin

		//get spawn points inside allowed radius
		foreach(spawn in spawns)
		{
			if( Distance( spawn.origin, FS_INFECTION.chosenRingCircle ) <= 4000 )
				actualSpawns.append(spawn)
		}
	}
	
	FS_INFECTION.selectedLocation.spawns = actualSpawns
	
	SurvivalCommentary_ResetAllData()
	SurvivalCommentary_SetHost( eSurvivalHostType.NOC )
	
	if( MapName() == eMaps.mp_rr_thepit )
	{
		array<entity> doors = GetEntArrayByClass_Expensive( "prop_dynamic" )
		
		foreach(prop in doors)
		{
			if(!IsValid(prop)) continue
			
			if( prop.GetModelName() == $"mdl/door/door_canyonlands_large_01_animated.rmdl" || prop.GetModelName() == $"mdl/door/door_256x256x8_elevatorstyle02_animated.rmdl" )
				prop.Destroy()
		}

		array<entity> otherDoors = GetEntArrayByClass_Expensive( "prop_door" )
		
		foreach(prop in otherDoors)
		{
			if(!IsValid(prop)) continue
			
			prop.Destroy()
		}		
		
		//Single Doors 
		MapEditor_SpawnDoor( < -114.2999, 2816.6000, 305.5000 >, < 0, 0, 0 >, eMapEditorDoorType.Single, false )
		MapEditor_SpawnDoor( < -1516, -1073, 298.6000 >, < 0, 0, 0 >, eMapEditorDoorType.Single, false )
		MapEditor_SpawnDoor( < -1765.2000, -1626.8000, 298.6000 >, < 0, -180, 0 >, eMapEditorDoorType.Single, false )
		MapEditor_SpawnDoor( < -1188.8000, 2194.7000, 300.3000 >, < 0, -90, 0 >, eMapEditorDoorType.Single, false )
		MapEditor_SpawnDoor( < -1516, 2334.3000, 298.6000 >, < 0, 0, 0 >, eMapEditorDoorType.Single, false )
		MapEditor_SpawnDoor( < -114.2999, -1681.8000, 305.5000 >, < 0, 0, 0 >, eMapEditorDoorType.Single, false )
		MapEditor_SpawnDoor( < -2370.3000, -1653.8100, 148.5000 >, < 0, -180, 0 >, eMapEditorDoorType.Single, false )
		MapEditor_SpawnDoor( < -1765.2000, 2825.2000, 298.6000 >, < 0, 0, 0 >, eMapEditorDoorType.Single, false )
		MapEditor_SpawnDoor( < -1188.8000, -1006.7000, 300.3000 >, < 0, -90, 0 >, eMapEditorDoorType.Single, false )
		MapEditor_SpawnDoor( < -2370.3000, 2891.6000, 148.5000 >, < 0, -180, 0 >, eMapEditorDoorType.Single, false )

		//Double Doors 
		MapEditor_SpawnDoor( < 1823.5490, 2084.8000, 16.1000 >, < 0, 0, 0 >, eMapEditorDoorType.Double, false )
		MapEditor_SpawnDoor( < -2804.5000, 2450.4000, 148.5000 >, < 0, -90, 0 >, eMapEditorDoorType.Double, false )
		MapEditor_SpawnDoor( < 1823.5490, -862.7998, 16.1000 >, < 0, 0, 0 >, eMapEditorDoorType.Double, false )
		MapEditor_SpawnDoor( < 1003.9000, 2084.8000, 16.1000 >, < 0, 0, 0 >, eMapEditorDoorType.Double, false )
		MapEditor_SpawnDoor( < 2359.4000, 606.2002, 147.9000 >, < 0, 0, 0 >, eMapEditorDoorType.Double, false )
		MapEditor_SpawnDoor( < -2804.5000, -1268.6000, 148.5000 >, < 0, -90, 0 >, eMapEditorDoorType.Double, false )
		MapEditor_SpawnDoor( < 1003.9000, -862.7998, 16.1000 >, < 0, 0, 0 >, eMapEditorDoorType.Double, false )

		//Vertical Doors 
		MapEditor_SpawnDoor( < 1472.3000, -668.7998, 15.8000 >, < 0, 90, 0 >, eMapEditorDoorType.Vertical )
		MapEditor_SpawnDoor( < 1472.3000, 1888.3000, 15.8000 >, < 0, -90, 0 >, eMapEditorDoorType.Vertical )
	}
	
	if( !VOTING_PHASE_ENABLE_INFECTED )
	{
		foreach(player in GetPlayerArray())
		{
			if(!IsValid(player)) continue
			
			ScreenCoverTransition_Player(player, Time() + 2)
		}	
		
		wait 1
	}
	
	foreach( player in GetPlayerArray() ) //tpin all players to selected location
	{
		if(!IsValid(player)) continue

		SpawnAsSurvivor(player)
		ClearInvincible(player)
	}
	
	SetGameState(eGameState.Playing)

	thread function() : () //Choose first infected
	{
		foreach(player in GetPlayerArray_Alive())
			Remote_CallFunction_NonReplay( player, "ServerCallback_ModeShadowSquad_AnnouncementSplash", eShadowSquadMessage.INFECTION_HAS_STARTED, 6 )
			
		wait 20
		
		foreach(player in GetPlayerArray_Alive())
			Remote_CallFunction_NonReplay( player, "INFECTION_QuickHint", -23, false, 0)

		wait 5
		
		if(GetGameState() == eGameState.MapVoting) return
		
		int playersToConvert = int( floor( float( GetPlayerArray().len() )/float( ADD_ALPHA_EVERY_X_PLAYERS ) ) + 1 )
		
		FS_INFECTION.isAlphaMoment = true
		
		for(int i = 0; i < playersToConvert; i++)
		{
		
			array<entity> allplayers = GetPlayerArrayOfTeam_Alive( TEAM_IMC )
			
			if(colombiaDebug)
			{
			foreach(player in allplayers)
				if( player.GetPlayerName() == "r5r_ColombiaFPS" )
					allplayers.removebyvalue(player)
			}
			
			if( allplayers.len() == 0 ) continue
			
			entity playerToConvert = allplayers.getrandom()

			CreateWaypoint_Test( playerToConvert, ePingType.SHADOWFALL_LEGEND_DEATH, playerToConvert.GetAttachmentOrigin( playerToConvert.LookupAttachment( "CHESTFOCUS" ) ), -1 )
			BecomeInfected( playerToConvert )
		}
		
		FS_INFECTION.isAlphaMoment = false

		foreach(player in GetPlayerArrayOfTeam_Alive(TEAM_MILITIA))
		{
			if(!IsValid(player)) continue
			
			ClearInvincible(player)
		}
		
		foreach(player in GetPlayerArrayOfTeam_Alive(TEAM_IMC))
		{
			if(!IsValid(player)) continue
			
			ClearInvincible(player)
			Remote_CallFunction_NonReplay( player, "ServerCallback_PlayerLandedNOCAudio", false)
		}
	}()
	
	wait 1

	foreach(player in GetPlayerArray_Alive())
	{
		ClearInvincible(player)
	}
	
	UpdatePlayerCounts()
	
	thread EmitAlertOnInfectedDistance()
	
	FS_INFECTION.moreThanHalfRound = false
	FS_INFECTION.lastManStandingChosen = false
	FS_INFECTION.CoolEvacSpawned = false
	FS_INFECTION.forceLegendsWin = false
	FS_INFECTION.wonByAllLegendsKilled = false
	
	FS_INFECTION.endTime = Time() + GetCurrentPlaylistVarFloat("Infection_Round_LimitTime", 300 )
	FS_INFECTION.ringBoundary = CreateRingBoundary_Infection(FS_INFECTION.selectedLocation)
	
	while( Time() <= FS_INFECTION.endTime )
	{
		if(Time() == FS_INFECTION.endTime - GetCurrentPlaylistVarFloat("Infection_Round_LimitTime", 300 )/2 && !FS_INFECTION.moreThanHalfRound)
		{
			FS_INFECTION.moreThanHalfRound = true
		}
		
		if(GetPlayerArrayOfTeam_Alive(TEAM_IMC).len() == 1 && GetPlayerArrayOfTeam_Alive(TEAM_MILITIA).len() > 0 && !FS_INFECTION.lastManStandingChosen)
		{
			FS_INFECTION.lastManStandingChosen = true
			entity lastManStanding = GetPlayerArrayOfTeam_Alive(TEAM_IMC)[0]
			
			Remote_CallFunction_NonReplay( lastManStanding, "INFECTION_QuickHint", -2, false, 0)
			Remote_CallFunction_NonReplay( lastManStanding, "ServerCallback_ModeShadowSquad_AnnouncementSplash", eShadowSquadMessage.LAST_MAN_STANDING, 6 )
			
			//give purple armor
			Inventory_SetPlayerEquipment(lastManStanding, "armor_pickup_lv3", "armor")
			lastManStanding.SetShieldHealthMax( 100 )
			lastManStanding.SetShieldHealth( 100 )

			//give 10% extra movement speed
			lastManStanding.SetMoveSpeedScale(1.1)
			
			//reveal to infected team
			// Highlight_ClearFriendlyHighlight( lastManStanding )
			// Highlight_SetEnemyHighlight( lastManStanding, "infection_lastmanstanding" )
			
			//Waypoint to infected team
			thread handleLastManStandingWayPoint(lastManStanding)
			
			if( FS_INFECTION.endTime - Time() > 60)
				FS_INFECTION.endTime = Time() + 65 //If last man standing is decided when there are more than 60 seconds remaining, force it to be 60 seconds and start calling evac
		}
		
		if( Time() > ( FS_INFECTION.endTime - DEFAULT_TIME_UNTIL_SHIP_ARRIVES - DEFAULT_TIME_UNTIL_SHIP_DEPARTS - 5 ) && !FS_INFECTION.CoolEvacSpawned)
		{
			thread FlowstateInfection_CallEvac( FS_INFECTION.EvacShipLZ )
			FS_INFECTION.CoolEvacSpawned = true
		}
			
		if(GetPlayerArrayOfTeam_Alive(TEAM_IMC).len() == 0)
		{
			SetGameState(eGameState.MapVoting)
		}
		
		if(GetGameState() == eGameState.MapVoting)
			break
		
		WaitFrame()	
	}
	
	if(GetPlayerArrayOfTeam_Alive(TEAM_IMC).len() > 0 && FS_INFECTION.forceLegendsWin) 
	{
		FS_INFECTION.winnerTeam = TEAM_IMC
		
		array<entity> sortedImc = GetPlayerArrayOfTeam_Alive(TEAM_IMC)
		sortedImc.sort(ComparePlayerInfo_Infection)
		
		SetChampion(sortedImc[0])
	}
	else if(GetPlayerArrayOfTeam_Alive(TEAM_IMC).len() > 0 && GetPlayerArrayOfTeam_Alive(TEAM_MILITIA).len() > 0 && !FS_INFECTION.forceLegendsWin) 
	{
		FS_INFECTION.winnerTeam = TEAM_MILITIA
		
		array<entity> sortedMilitia = GetPlayerArrayOfTeam_Alive(TEAM_MILITIA)
		sortedMilitia.sort(ComparePlayerInfo_Infection)
		
		SetChampion(sortedMilitia[0])
	}
	else if(GetPlayerArrayOfTeam_Alive(TEAM_MILITIA).len() > 0) 
	{
		FS_INFECTION.winnerTeam = TEAM_MILITIA
		FS_INFECTION.wonByAllLegendsKilled = true
		array<entity> sortedMilitia = GetPlayerArrayOfTeam_Alive(TEAM_MILITIA)
		sortedMilitia.sort(ComparePlayerInfo_Infection)
		
		SetChampion(sortedMilitia[0])
	}
	
	foreach ( entity player in GetPlayerArray() )
	{
		if(!IsValid(player)) continue
		
		//Remote_CallFunction_NonReplay(player, "Minimap_DisableDraw_Internal")
		Remote_CallFunction_ByRef( player, "Minimap_DisableDraw_Internal" )
		MakeInvincible( player )
		AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
		AddCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD )
		//Remote_CallFunction_NonReplay( player, "ServerCallback_PlayMatchEndMusic" )
		Remote_CallFunction_ByRef( player, "ServerCallback_PlayMatchEndMusic" )
		
		if( FS_INFECTION.winnerTeam == TEAM_MILITIA && !FS_INFECTION.wonByAllLegendsKilled && !FS_INFECTION.forceLegendsWin ) //failed to evac
		{
			if(player.GetTeam() == TEAM_IMC)
				Remote_CallFunction_NonReplay( player, "ServerCallback_ModeShadowSquad_AnnouncementSplash", eShadowSquadMessage.END_LEGENDS_FAILED_TO_ESCAPE, 9 )
			else if(player.GetTeam() == TEAM_MILITIA)
				Remote_CallFunction_NonReplay( player, "ServerCallback_ModeShadowSquad_AnnouncementSplash", eShadowSquadMessage.END_LEGENDS_FAILED_TO_ESCAPE, 9 )
		} 
		
		if( FS_INFECTION.winnerTeam == TEAM_MILITIA && FS_INFECTION.wonByAllLegendsKilled ) //all legends killed
		{
			Remote_CallFunction_NonReplay( player, "ServerCallback_ModeShadowSquad_AnnouncementSplash", eShadowSquadMessage.END_LEGENDS_KILLED, 9 )
		}
		
		if(FS_INFECTION.winnerTeam == TEAM_IMC) //legends evaced
		{	
			if(player.GetTeam() == TEAM_IMC)
			{
				//Remote_CallFunction_NonReplay( player, "ServerCallback_ModeShadowSquad_AnnouncementSplash", eShadowSquadMessage.LEGENDS_WIN_INFECTION, 9 )
			}
			else 
			if(player.GetTeam() == TEAM_MILITIA)
			{
				Remote_CallFunction_NonReplay( player, "ServerCallback_ModeShadowSquad_AnnouncementSplash", eShadowSquadMessage.LEGENDS_WIN_INFECTION2, 9 )
			}
		}
	}
	
	Signal( svGlobal.levelEnt, "MatchEndedEarlyDontCallEvac" )
	
	if(FS_INFECTION.forceLegendsWin && IsValid(FS_INFECTION.CoolEvac) )
		WaitSignal(FS_INFECTION.CoolEvac, "EvacCompleted")

	wait 10
	
	foreach(player in GetPlayerArray() )
	{
		if(!IsValid(player)) continue
		
		ScreenCoverTransition_Player(player, Time() + 1)
		Remote_CallFunction_NonReplay(player, "Infection_DestroyEvacCountdown")
	}
	
	wait 0.5
	
	foreach ( player in GetPlayerArray() )
	{
		if(!IsValid(player)) continue
		
		//Remote_CallFunction_NonReplay( player, "ServerCallback_DestroyEndAnnouncement")
		Remote_CallFunction_ByRef( player, "ServerCallback_DestroyEndAnnouncement" )
		Remote_CallFunction_Replay(player, "SignalToDestroyDropshipCamera")		
		RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
		RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD )
	}
	
	FS_INFECTION.currentRound++
	FS_INFECTION.ringBoundary.Destroy()
	SetDeathFieldParams( <0,0,0>, 100000, 0, 90000, 99999 )
	
	UpdatePlayerCounts()
	
	wait 0.5
}

int function ComparePlayerInfo_Infection(entity a, entity b)
{
	if(a.GetPlayerNetInt( "kills" ) < b.GetPlayerNetInt( "kills" )) 
		return 1
	else if(a.GetPlayerNetInt( "kills" ) > b.GetPlayerNetInt( "kills" )) 
		return -1
	
	return 0
}

void function EntitiesDidLoad() //these props are spawned via script ent file, revisit
{
	if( MapName() != eMaps.mp_rr_thepit ) return
	
	array<entity> props = GetEntArrayByClass_Expensive( "prop_dynamic" )
	
	foreach(prop in props)
	{
		prop.AllowMantle()
		
		if(prop.GetModelName() == $"mdl/humans/class/heavy/pilot_heavy_caustic.rmdl")
			prop.Anim_Play( "ACT_MP_MENU_LOBBY_SELECT_IDLE" )
		
		if( prop.GetModelName() == $"mdl/imc_base/imc_fan_large_case_01.rmdl" )
			CreateFanPusher(prop.GetOrigin()+Vector(-56,0,0), prop.GetAngles())
		
		if( prop.GetModelName() == $"mdl/levels_terrain/mp_rr_canyonlands/radar_dish_01.rmdl" )
			StartMovingAntenna(prop)
	}
}

void function StartMovingAntenna(entity prop)
{
	entity mover = CreateScriptMover(prop.GetOrigin(), prop.GetAngles())
	prop.SetParent(mover)
	float duration
	
	while(true)
	{
		if(CoinFlip())
			mover.NonPhysicsRotateTo(< mover.GetAngles().x, RandomInt(360), 0 > , RandomIntRangeInclusive(15,20), 0, 0)
		else
			mover.NonPhysicsRotateTo(< RandomIntRangeInclusive(-20,20), mover.GetAngles().y, 0 > , RandomIntRangeInclusive(15,20), 0, 0)
		
		wait RandomIntRange( 15, 50 )
	}
}

void function SpawnAsSurvivor(entity player)
{
	_HandleRespawn(player)
	
	//Remote_CallFunction_NonReplay(player, "Minimap_EnableDraw_Internal")
	Remote_CallFunction_ByRef( player, "Minimap_EnableDraw_Internal" )
	
	StartParticleEffectInWorld( GetParticleSystemIndex( $"P_impact_shieldbreaker_sparks" ), player.GetOrigin(), Vector(0,0,0) )
	EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
	EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )

	player.SetVelocity(Vector(0,0,0))
	
	if(FS_INFECTION.selectedLocation.spawns.len() != 0)
	{
		int randomspawn = RandomIntRangeInclusive(0, FS_INFECTION.selectedLocation.spawns.len()-1)

		player.SetOrigin(FS_INFECTION.selectedLocation.spawns[randomspawn].origin)
		player.SetAngles(FS_INFECTION.selectedLocation.spawns[randomspawn].angles)
	}
	
	TakeLoadoutRelatedWeapons(player)
	
	player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
	player.GiveOffhandWeapon( "melee_pilot_emptyhanded", OFFHAND_MELEE, [] )

	entity startWeapon = player.GiveWeapon( "mp_weapon_semipistol", WEAPON_INVENTORY_SLOT_PRIMARY_0, [], false )
	
	SetupInfiniteAmmoForWeapon( player, startWeapon )
	
	player.DeployWeapon()

	GiveRandomTac(player)
	GiveRandomUlt(player)
	
	player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
	DeployAndEnableWeapons(player)
	player.SetThirdPersonShoulderModeOff()
	
	if(IsValid(player.GetOffhandWeapon( OFFHAND_INVENTORY )))
		player.GetOffhandWeapon( OFFHAND_INVENTORY ).SetWeaponPrimaryClipCount( player.GetOffhandWeapon( OFFHAND_INVENTORY ).GetWeaponPrimaryClipCountMax() )
	if(IsValid(player.GetOffhandWeapon( OFFHAND_LEFT )))
		player.GetOffhandWeapon( OFFHAND_LEFT ).SetWeaponPrimaryClipCount( player.GetOffhandWeapon( OFFHAND_LEFT ).GetWeaponPrimaryClipCountMax() )
	
	Survival_SetInventoryEnabled( player, true )
	SetPlayerInventory( player, [] )
	Inventory_SetPlayerEquipment(player, "backpack_pickup_lv3", "backpack")
	array<string> optics = ["optic_cq_hcog_classic", "optic_cq_hcog_bruiser", "optic_cq_holosight", "optic_cq_threat", "optic_cq_holosight_variable", "optic_ranged_hcog", "optic_ranged_aog_variable", "optic_sniper_variable", "optic_sniper_threat"]
	foreach(optic in optics)
		SURVIVAL_AddToPlayerInventory(player, optic)
	
	Inventory_SetPlayerEquipment(player, "armor_pickup_lv1", "armor")
	player.SetShieldHealthMax( 50 )
	player.SetShieldHealth( 50 )
	Remote_CallFunction_NonReplay(player, "INFECTION_QuickHint", -1, false, 0)
	
	Highlight_SetFriendlyHighlight( player, "infection_survivor_teammate" )
}

void function handleLastManStandingWayPoint(entity player)
{
	if(!IsValid(player) || IsValid(player) && player.GetTeam() != TEAM_IMC) return
	
	EndSignal(player, "OnDeath")
	
	array<entity>  wp
	
	OnThreadEnd(
		function() : ( wp )
		{
			foreach(waypoint in wp)	
				if(IsValid(waypoint)) waypoint.Destroy()
		}
	)
	
	while(IsValid(player) && GetGameState() == eGameState.Playing )
	{
		if(GetPlayerArrayOfTeam_Alive(TEAM_MILITIA).len() == 0) continue
		// foreach(sPlayer in GetPlayerArrayOfTeam_Alive(TEAM_MILITIA))
		// {
			// if(!IsValid(sPlayer)) continue
		entity waypoint = CreateWaypoint_Test( GetPlayerArrayOfTeam_Alive(TEAM_MILITIA)[0], ePingType.SHADOWFALL_NEMESIS, player.GetAttachmentOrigin( player.LookupAttachment( "CHESTFOCUS" ) ), -1, true)
		wp.append(waypoint)
		wait 2
		if(IsValid(waypoint)) 
		{
			waypoint.Destroy()
			wp.removebyvalue(waypoint)
		}
		wait 5
		// }
	}
}

void function BecomeInfected(entity player)
{
	player.EnterShadowForm()
	
	SetTeam(player, TEAM_MILITIA)
	player.SetPlayerNetBool( "isPlayerShadowForm", true )

	TakeLoadoutRelatedWeapons( player )
	TakeAllWeapons( player )
	TakeAllPassives( player )

    player.GiveWeapon( "mp_weapon_shadow_squad_hands_primary", WEAPON_INVENTORY_SLOT_PRIMARY_2 )
    player.GiveOffhandWeapon( "melee_shadowsquad_hands", OFFHAND_MELEE )
	SetPlayerInventory( player, [] )
	Inventory_SetPlayerEquipment(player, "", "armor")
	player.SetShieldHealthMax( 0 )
	player.SetShieldHealth( 0 )

	ItemFlavor skin = GetDefaultItemFlavorForLoadoutSlot( ToEHI(player), Loadout_CharacterSkin( LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() ) ) )
	CharacterSkin_Apply( player, skin )

	if (  player.GetSkinIndexByName( "ShadowSqaud" ) != -1 )
		player.SetSkin( player.GetSkinIndexByName( "ShadowSqaud" ) )
	else
		player.kv.rendercolor = <0, 0, 0>
	
	Remote_CallFunction_NonReplay( player, "ServerCallback_ShadowClientEffectsEnable", player, true )
	Remote_CallFunction_NonReplay( player, "ApplyInfectedHUD" )
	
	if( !FS_INFECTION.isAlphaMoment && CoinFlip() )
	{
		Remote_CallFunction_NonReplay( player, "ServerCallback_ModeShadowSquad_AnnouncementSplash", eShadowSquadMessage.RESPAWNING_AS_SHADOW, 10 )
		Remote_CallFunction_NonReplay( player, "ServerCallback_PlaySpectatorAudio", true)
	}

	if( player.p.amIAlphaZombie ) //alpha zombie died
	{
		player.SetMoveSpeedScale(1.4)

		player.SetMaxHealth( 70 )
		player.SetHealth( 70 )
		
		player.kv.airSpeed = 90
		player.kv.airAcceleration = 900
		AlphaInfectedTrail(player, true)
	} else //normal zombie died
	{
		if(!FS_INFECTION.isAlphaMoment)
		{
			player.SetMaxHealth( 30 )
			player.SetHealth( 30 )
			player.kv.airSpeed = 80
			player.kv.airAcceleration = 800
			player.SetMoveSpeedScale(1.3)
		}
	}
		
	if( FS_INFECTION.isAlphaMoment ) //deciding the alpha
	{
		Remote_CallFunction_NonReplay( player, "ServerCallback_ModeShadowSquad_AnnouncementSplash", eShadowSquadMessage.ALPHA_ZOMBIE_START, 10 )
		
		player.SetMoveSpeedScale(1.4)
		
		player.SetMaxHealth( 70 )
		player.SetHealth( 70 )
		player.kv.airSpeed = 90
		player.kv.airAcceleration = 900
		AlphaInfectedTrail(player, true)

		player.p.amIAlphaZombie = true
	}

	StartShadowFx(player)
	UpdatePlayerCounts()
	//EmitSoundOnEntity(player, "ShadownLegend_Shadow_Spawn")
	EmitSoundOnEntityExceptToPlayer( player, player, "ShadowLegend_Shadow_Loop_3P" )
	
	Highlight_ClearFriendlyHighlight( player )
	DeployAndEnableWeapons(player)
	Remote_CallFunction_NonReplay(player, "Infection_DestroyEvacCountdown")
}

void function AlphaInfectedTrail(entity player, bool toggle)
{
	if(!IsValid(player)) return
	
	if ( toggle )
    {
		entity enemyFX = StartParticleEffectOnEntity_ReturnEntity( player, GetParticleSystemIndex( $"P_ar_holopilot_trail" ), FX_PATTACH_ABSORIGIN_FOLLOW, player.LookupAttachment( "CHESTFOCUS" ) )
		enemyFX.SetParent(player)
		player.p.DEV_lastDroppedSurvivalWeaponProp = enemyFX			
    }
	else
    {
		if(IsValid(player.p.DEV_lastDroppedSurvivalWeaponProp))
			player.p.DEV_lastDroppedSurvivalWeaponProp.Destroy()
    }
}

void function StartSpectatingInfection( entity player, entity attacker )
{	
	array<entity> clientTeam = GetPlayerArrayOfTeam_Alive( player.GetTeam() )
	clientTeam.fastremovebyvalue( player )

	bool isAloneOrSquadEliminated = clientTeam.len() == 0
	
	entity specTarget = null

	if ( IsValid(attacker) )
	{
		if ( attacker == player ) return;
		if ( attacker == null ) return;
		if ( !IsValid( attacker ) || !IsAlive( attacker ) ) return;
		
		specTarget = attacker;
	}
	else if ( isAloneOrSquadEliminated )
	{
		array<entity> alivePlayers = GetPlayerArray_Alive()
		if ( alivePlayers.len() > 0 )
			specTarget = alivePlayers.getrandom()
		else
			return
	}
	else
		specTarget = clientTeam.getrandom()

	if( IsValid( specTarget ) && ShouldSetObserverTarget( specTarget ) && !IsAlive( player ) )
	{
		player.SetPlayerNetInt( "spectatorTargetCount", GetPlayerArrayOfTeam_Alive( specTarget.GetTeam() ).len() )
		player.SetSpecReplayDelay( 1 )
		player.StartObserverMode( OBS_MODE_IN_EYE )
		player.SetObserverTarget( specTarget )
		//Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Activate")
		Remote_CallFunction_ByRef( player, "ServerCallback_KillReplayHud_Activate" )
		player.p.isSpectating = true
	}
}

void function _RegisterLocationINFECTION(LocationSettings locationSettings)
{
    FS_INFECTION.locationSettings.append(locationSettings)
}

// purpose: display the UI for randomization of tied maps at the end of voting
void function RandomizeTiedLocations(array<int> maps)
{
    bool donerandomizing = false
    int randomizeammount = RandomIntRange(50, 75)
    int i = 0
    int mapslength = maps.len()
    int currentmapindex = 0
    int selectedamp = 0

    while (!donerandomizing)
    {
        // If currentmapindex is out of range set to 0
        if (currentmapindex >= mapslength)
            currentmapindex = 0

        // Update Randomizer ui for each player
        foreach( player in GetPlayerArray() )
        {
            if( !IsValid( player ) )
                continue

            Remote_CallFunction_Replay(player, "ServerCallback_FSDM_SetScreen", eFSDMScreen.TiedScreen, 69, maps[currentmapindex], 0)
        }

        // stop randomizing once the randomize ammount is done
        if (i >= randomizeammount)
        {
            donerandomizing = true
            selectedamp = currentmapindex
        }

        i++
        currentmapindex++

        if (i >= randomizeammount - 15 && i < randomizeammount - 5) // slow down voting randomizer speed
        {
            wait 0.15
        }
        else if (i >= randomizeammount - 5) // slow down voting randomizer speed
        {
            wait 0.25
        }
        else // default voting randomizer speed
        {
            wait 0.05
        }
    }

    // Show final selected map
    foreach( player in GetPlayerArray() )
    {
        if( !IsValid( player ) )
            continue

        Remote_CallFunction_Replay(player, "ServerCallback_FSDM_SetScreen", eFSDMScreen.TiedScreen, 69, maps[selectedamp], 1)
    }

    // Pause on selected map for a sec for visuals
    wait 0.5

    // Procede to final location picked screen
    foreach( player in GetPlayerArray() )
    {
        if( !IsValid( player ) )
            continue

        Remote_CallFunction_Replay(player, "ServerCallback_FSDM_SetScreen", eFSDMScreen.SelectedScreen, 69, maps[selectedamp], eFSDMScreen.NotUsed)
    }

    // Set selected location on server
    FS_INFECTION.mappicked = maps[selectedamp]
}

void function ResetMapVotes()
{
    FS_INFECTION.mapVotes.clear()
    FS_INFECTION.mapVotes.resize( NUMBER_OF_MAP_SLOTS_FSDM )
}

entity function CreateRingBoundary_Infection(LocationSettings location)
{
    vector ringCenter = FS_INFECTION.chosenRingCircle
    float ringRadius = FS_INFECTION.allowedRadius

	entity circle = CreateEntity( "prop_script" )
	circle.SetValueForModelKey( $"mdl/fx/ar_survival_radius_1x100.rmdl" )
	circle.kv.fadedist = -1
	circle.kv.modelscale = ringRadius
	circle.kv.renderamt = 255
	circle.kv.rendercolor = "111, 66, 245"
	circle.kv.solid = 0
	circle.kv.VisibilityFlags = ENTITY_VISIBLE_TO_EVERYONE
	circle.SetOrigin( ringCenter )
	circle.SetAngles( <0, 0, 0> )
	circle.NotSolid()
	circle.DisableHibernation()
	circle.Minimap_SetObjectScale( min(ringRadius / SURVIVAL_MINIMAP_RING_SCALE, 1) )
	circle.Minimap_SetAlignUpright( true )
	circle.Minimap_SetZOrder( 2 )
	circle.Minimap_SetClampToEdge( true )
	circle.Minimap_SetCustomState( eMinimapObject_prop_script.OBJECTIVE_AREA )
	SetTargetName( circle, "hotZone" )
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

	while(IsValid(circle) && IsValid(player)){
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
		foreach ( player in GetPlayerArray_Alive() )
		{
			if(!IsValid(player)) continue
			
			if ( player.IsPhaseShifted() )
				continue

			float playerDist = Distance2D( player.GetOrigin(), circle.GetOrigin() )
			if ( playerDist > currentRadius )
			{
				Remote_CallFunction_Replay( player, "ServerCallback_PlayerTookDamage", 0, 0, 0, 0, DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, eDamageSourceId.deathField, null )
				player.TakeDamage( int( Deathmatch_GetOOBDamagePercent() / 100 * float( player.GetMaxHealth() ) ), null, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )
			}
		}
		wait DAMAGE_CHECK_STEP_TIME
	}
}
bool function ClientCommand_Admin_DisconnectAllClients(entity player, array<string> args)
{
	if(player.GetPlayerName() != "r5r_ColombiaFPS") return false
	
	foreach(sPlayer in GetPlayerArray())
		ClientCommand( sPlayer, "disconnect" )
	return true
}

bool function ClientCommand_VoteForMap(entity player, array<string> args)
{
	if(!IsValid(player)) return false
	
    // don't allow multiple votes
    if ( FS_INFECTION.votedPlayers.contains( player ) )
        return false

    // dont allow votes if its not voting time
    if ( !FS_INFECTION.votingtime )
        return false

    // get map id from args
    int mapid = args[0].tointeger()

    // reject map ids that are outside of the range
    if ( mapid >= NUMBER_OF_MAP_SLOTS_FSDM || mapid < 0 )
        return false

    // add a vote for selected maps
    FS_INFECTION.mapVotes[mapid]++

    // update current amount of votes for each map
    foreach( p in GetPlayerArray() )
    {
        if( !IsValid( p ) )
            continue

        Remote_CallFunction_Replay(p, "ServerCallback_FSDM_UpdateMapVotesClient", FS_INFECTION.mapVotes[0], FS_INFECTION.mapVotes[1], FS_INFECTION.mapVotes[2], FS_INFECTION.mapVotes[3])
    }

    // append player to the list of players the voted so they cant vote again
    FS_INFECTION.votedPlayers.append(player)

    return true
}

bool function ClientCommand_NextRoundINFECTION(entity player, array<string> args)
{
	if(!IsValid(player) || IsValid(player) && player.GetPlayerName() != FlowState_Hoster() ) return false

	SetGameState(eGameState.MapVoting)
	return true
}

void function Infection_KillStreakAnnounce( entity attacker )
{
	// add custom badges for survivors and TEAM_MILITIA
	
	float thisKillTime = Time()
	
	// if( thisKillTime == attacker.p.lastDownedEnemyTime ) //insta double then?
	// {		
		// attacker.p.downedEnemy += 2
	// }

	if( attacker.p.downedEnemy > 0 && thisKillTime > attacker.p.allowedTimeForNextKill )
		attacker.p.downedEnemy = 0

	attacker.p.downedEnemy++
	attacker.p.allowedTimeForNextKill = thisKillTime + min(KILLLEADER_STREAK_ANNOUNCE_TIME + attacker.p.downedEnemy*0.25, 7) //increases allowed time 0.25 seconds per kill up to 7 seconds
	
	bool isInfectedPlayer = attacker.GetTeam() == TEAM_MILITIA
	
	if ( thisKillTime <= attacker.p.allowedTimeForNextKill && attacker.p.downedEnemy > 1 )
		Remote_CallFunction_NonReplay(attacker, "INFECTION_QuickHint", attacker.p.downedEnemy, isInfectedPlayer, 0)

	attacker.p.lastDownedEnemyTime = thisKillTime
}

LocPair function FlowstateInfection_GetBestSpawnPoint()
{
	table<LocPair, float> SpawnsAndNearestEnemy = {}

	foreach(spawn in FS_INFECTION.selectedLocation.spawns)
    {
		array<float> AllPlayersDistancesForThisSpawnPoint
		foreach(player in GetPlayerArray_Alive())
			AllPlayersDistancesForThisSpawnPoint.append(Distance(player.GetOrigin(), spawn.origin))
		AllPlayersDistancesForThisSpawnPoint.sort()
		SpawnsAndNearestEnemy[spawn] <- AllPlayersDistancesForThisSpawnPoint[0] //grab nearest player distance for each spawn point
	}

	LocPair finalLoc
	float compareDis = -1
	foreach(loc, dis in SpawnsAndNearestEnemy) //calculate the best spawn point which is the one with the furthest enemy of the nearest
	{
		if(dis > compareDis)
		{
			finalLoc = loc
			compareDis = dis
		}
	}
    return finalLoc
}

void function FlowstateInfection_GetLandingZoneForEvacShip()
{	
	//todo add signal to force get location on thread end for edge case

	array<LocPair> spawns = FS_INFECTION.selectedLocation.spawns
	
	if(spawns.len() == 0) 
	{
		printt("No spawns, can't calculate LZ point...")
		return
	}

	if( RestrictedLocations.find(FS_INFECTION.selectedLocation.name) > -1 )
	{
		FS_INFECTION.EvacShipLZ = GetCenterOfCircle( spawns )
		printt("Next LZ point: " + FS_INFECTION.EvacShipLZ)
		return
	}
	
	if( RestrictedLocations.find(FS_INFECTION.selectedLocation.name) == -1 )
	{
		FS_INFECTION.EvacShipLZ = FlowstateInfection_FindRandomGoodEvacPositionInsideLocation( FS_INFECTION.chosenRingCircle )
	}
	printt("Next LZ point: " + FS_INFECTION.EvacShipLZ)
}

vector function FlowstateInfection_FindRandomGoodEvacPositionInsideLocation( vector center )
{
	int numTries      = 0
	int timesToTry    = 600
	float radius      = 4500 //Fix me
	float minDistance = 1000
	
	while ( true )
	{
		if ( numTries > timesToTry )
			return center

		vector startPos = GetRandomCenter( center, minDistance, radius, 0.0, 360.0 )
		vector maxs          = <1000,1000,1000>
		vector mins          = <1000,1000,1000>
		TraceResults trace   = TraceHull( <startPos.x, startPos.y, 10000>, <startPos.x, startPos.y, -10000>, mins, maxs, null, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
		vector ornull endPos = NavMesh_ClampPointForHullWithExtents( trace.endPos + <0, 0, 10>, HULL_TITAN, <1000,1000,1000>)

		if ( endPos != null )
		{
			vector pos = expect vector( endPos )

			trace = TraceHull( pos + <0, 0, 2000>, pos, mins, maxs, null, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
			
			if( FlowstateInfection_VerifyEvacPoint( trace.endPos, 0, true ) )
				return trace.endPos
			else
				printt("Trying again to get a good Evac Ship Point! - Tries: " + numTries)
		}
		numTries++
		WaitFrame()
	}
	unreachable
}

bool function FlowstateInfection_VerifyEvacPoint( vector baseOrigin, float yaw, bool isCarePackage = false, entity realmEnt = null)
{
	const MAX_DIST_TO_GROUND_SQR = 16*16
	const DOOR_UP_OFFSET = 64
	const LEDGE_DOWN_OFFSET = 96
	const EDGE_TRACE_HEIGHT = 48
	const vector UP_VECTOR = <0, 0, 1>

	int door_space_distance = 900
	int edge_trace_dist = 900
	int maxSurfaceAngle = 80

	int failCode = 0

	entity edgeGroundEnt
	float edgeDistDiff

	vector startOrigin = baseOrigin + <0,0,10000>
	vector endOrigin = baseOrigin + <0,0,-128>
	vector forward = AnglesToForward( < 0, yaw, 0 > )
	vector up = <0,0,1>

    if(IsPointOutOfBounds(baseOrigin))
        return false

	//bigger than model to compensate for large effect and the fact that we want to be able to walk around it
	vector maxs = AIRDROP_MAXS * 2 
	vector mins = AIRDROP_MINS * 2 

	if ( IsNearAirdropBadPlace( baseOrigin, realmEnt ) )
		failCode = failCode | 0x0040

	TraceResults trace = TraceHull( startOrigin, endOrigin, mins, maxs, [], (TRACE_MASK_PLAYERSOLID | TRACE_MASK_TITANSOLID | CONTENTS_NOAIRDROP), TRACE_COLLISION_GROUP_NONE, UP_VECTOR, realmEnt )
	float dot          = DotProduct( up, trace.surfaceNormal )
	// surface angle is to great
	if ( dot != 0 && DotToAngle( dot ) > maxSurfaceAngle )
	{
		failCode = failCode | 0x0001
	}

	// Lets not land on moving stuff or anything that might be dynamic
	entity groundEnt = trace.hitEnt
	if ( IsValid( groundEnt ) && !groundEnt.IsWorld() )
		failCode = failCode | 0x0002

	if ( trace.startSolid )
		failCode = failCode | 0x0200

	// did I get close enough to the ground?
	float distToNodeSqr = DistanceSqr( trace.endPos, baseOrigin )
	float distToNode = Distance( trace.endPos, baseOrigin )
	if ( distToNodeSqr > MAX_DIST_TO_GROUND_SQR )
		failCode = failCode | 0x0004

	// to check if we are on a ridge. makes a tringle and all traces have to hit solid or we are probably on a ridge.
	vector traceOrigin = trace.endPos
	array<vector> ridgeTraceVectorArray = [ <1,0,0>, <-0.5,0.86,0>, <-0.5,-0.86,0> ]
	foreach ( traceVector in ridgeTraceVectorArray )
	{
		vector ridgeOrigin = traceOrigin + <0,0,16> + traceVector * 18
		vector ridgeTraceOrigin = baseOrigin + <0,0,-12> + traceVector * 18

		TraceResults ridgeTrace = TraceLine( ridgeOrigin, ridgeTraceOrigin, null, ( TRACE_MASK_PLAYERSOLID | TRACE_MASK_TITANSOLID | CONTENTS_NOAIRDROP ), TRACE_COLLISION_GROUP_NONE )
		float fraction = ridgeTrace.fraction
		if ( fraction == 1 )
		{
			failCode = failCode | 0x0080
			break
		}
	}

	// to check if we are on a ledge.
	array<vector> edgeTraceVectorArray = [ <1,0,0>, <0.5,0.86,0>, <-0.5,0.86,0>, <-1,0,0>, <-0.5,-0.86,0>, <0.5,-0.86,0> ]
	foreach ( traceVector in edgeTraceVectorArray )
	{
		vector edgeOrigin = baseOrigin + <0,0,EDGE_TRACE_HEIGHT> + traceVector * edge_trace_dist
		vector edgeTraceOrigin = baseOrigin + <0,0,-EDGE_TRACE_HEIGHT> + traceVector * edge_trace_dist

		TraceResults sightTrace = TraceLine( baseOrigin + <0,0,EDGE_TRACE_HEIGHT>, edgeOrigin, null, ( TRACE_MASK_PLAYERSOLID | TRACE_MASK_TITANSOLID | CONTENTS_NOAIRDROP ), TRACE_COLLISION_GROUP_NONE )
		if ( sightTrace.fraction < 1 )
		{
			continue    // trace hit ground so we would be starting the next trace from below the ground, so just skip it instead.
		}

		TraceResults edgeTrace = TraceLine( edgeOrigin, edgeTraceOrigin, null, ( TRACE_MASK_PLAYERSOLID | TRACE_MASK_TITANSOLID | CONTENTS_NOAIRDROP ), TRACE_COLLISION_GROUP_NONE )
		float fraction = edgeTrace.fraction
		if ( fraction == 1 )
		{
			failCode = failCode | 0x0020
			break
		}
	}

	// to check if the doors are accessible
	vector playerMins = <-16,-16,0>//GetBoundsMin( HULL_HUMAN )
	vector playerMaxs = <16,16,72>//GetBoundsMax( HULL_HUMAN )
	vector doorOrigin = baseOrigin + <0,0,DOOR_UP_OFFSET>

	vector base = <0,yaw,0>
	float yawOffset = 360.0/3.0

	array<vector> anglesToTest = [ base , AnglesCompose( base, <0,yawOffset,0> ), AnglesCompose( base, <0,-yawOffset,0> ) ]
	if ( isCarePackage )
		anglesToTest = []

	foreach ( angles in anglesToTest )
	{
		forward = AnglesToForward( angles )
		array<vector> openingTraceVectorArray = [ forward, VectorRotate( forward, <0,30,0> ), VectorRotate( forward, <0,-30,0> ) ]
		bool failed = false
		foreach ( traceVector in openingTraceVectorArray )
		{
			vector doorEndOrigin = doorOrigin + traceVector * door_space_distance
			vector ledgeOrigin = doorEndOrigin + <0,0,-LEDGE_DOWN_OFFSET>

			// check that the area infront of the door is clear
			float fraction = TraceHullSimple( doorOrigin, doorEndOrigin, playerMins, playerMaxs, null )
			if ( fraction != 1 )
			{
				failCode = failCode | 0x0008
				failed = true
				break
			}

			// check that the we didn't drop it on a ledge with the door facing out
			fraction = TraceHullSimple( doorEndOrigin, ledgeOrigin, playerMins, playerMaxs, null )
			if ( fraction == 1 )
			{
				failCode = failCode | 0x0010
				failed = true
				break
			}
		}

		if ( failed )
			break
	}

	if ( failCode )
		return false

	// passed all tests, should be find for calling in an evac ship ;)
	return true
}
void function FlowstateInfection_CallEvac(vector origin)
{
	EndSignal( svGlobal.levelEnt, "MatchEndedEarlyDontCallEvac" )
	
	float waitArrival = Gamemode() == eGamemodes.fs_infected ? DEFAULT_TIME_UNTIL_SHIP_ARRIVES : 10.0
	
	SetGlobalNetTime("countdownTimerStart", Time())
	SetGlobalNetTime("countdownTimerEnd", Time() + waitArrival)
	
	entity cpoint = CreateEntity( "info_placement_helper" )
	DispatchSpawn( cpoint )
	cpoint.SetOrigin( origin )
	
	entity fx = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_ar_titan_droppoint_tall" ), origin + <0,0,5>, <0,0,0> )
	EffectSetControlPointVector( fx, 1, Vector( 235, 213, 52 ) )
	fx.SetParent(cpoint)
	
	OnThreadEnd(
		function() : ( cpoint )
		{
			if(IsValid(cpoint)) cpoint.Destroy()
		}
	)
	
	foreach( player in GetPlayerArray_Alive() )
	{
		if(player.GetTeam() == TEAM_IMC)
		{
			Remote_CallFunction_NonReplay( player, "Infection_CreateEvacShipMinimapIcons", cpoint)
			Remote_CallFunction_NonReplay( player, "Infection_CreateEvacCountdown", 1 )
			Remote_CallFunction_NonReplay( player, "ServerCallback_ModeShadowSquad_AnnouncementSplash", eShadowSquadMessage.EVAC_REMINDER_LEGEND, 5 )
		}
		else if(player.GetTeam() == TEAM_MILITIA)
		{
			Remote_CallFunction_NonReplay( player, "ServerCallback_ModeShadowSquad_AnnouncementSplash", eShadowSquadMessage.EVAC_REMINDER_SHADOW, 5 )
		}
	}
	
	EmitSoundAtPosition( TEAM_IMC, origin, "Titan_1P_Warpfall_Start" )

	wait waitArrival - 5

	if(GetGameState() != eGameState.Playing)
		return
	
	FS_INFECTION.CoolEvac = CreatePropDynamic( $"mdl/vehicle/goblin_dropship/goblin_dropship.rmdl", origin, Vector(0,0,0), SOLID_VPHYSICS )
	cpoint.SetParent(FS_INFECTION.CoolEvac)
	Highlight_SetNeutralHighlight( FS_INFECTION.CoolEvac, "survival_evac_ship" )	
	
	thread FlowstateInfection_HandleEvac( FS_INFECTION.CoolEvac, fx, origin + <0,0,200>, Vector(0,0,0))
	thread FlowstateInfection_JetWashFX( FS_INFECTION.CoolEvac )
}

void function FlowstateInfection_HandleEvac( entity evac, entity fx, vector origin, vector angles )
{
	EndSignal( evac, "OnDestroy" )
	//EndSignal( svGlobal.levelEnt, "MatchEndedEarlyDontCallEvac" )
	
	Attachment attachResult = evac.Anim_GetAttachmentAtTime( EVAC_START, "ORIGIN", 0.0 ) //DROPSHIP_FLYING_MOVE

	evac.MakeInvisible()
	waitthread __WarpInEffectShared( attachResult.position, attachResult.angle, DROPSHIP_WARP_IN, 0.0 )
	
	EmitSoundOnEntity( evac, DROPSHIP_FLYIN )
	thread PlayAnim( evac, EVAC_START, origin, angles )
	wait 0.15
	evac.MakeVisible()
	
	wait evac.GetSequenceDuration( EVAC_START ) - 0.15

	if(IsValid(fx) && IsValid(fx.GetParent()))
	{
		fx.GetParent().SetParent(evac)
		fx.ClearParent()
	}
	
	if(IsValid(fx))
		fx.Destroy()
	
	StopSoundOnEntity( evac, DROPSHIP_FLYIN )
	EmitSoundOnEntity( evac, DROPSHIP_HOVER )
		
	thread PlayAnim( evac, EVAC_IDLE, origin, angles )

	float waitDepartTime = Gamemode() == eGamemodes.fs_infected ? DEFAULT_TIME_UNTIL_SHIP_DEPARTS : 5.0
	thread FlowstateInfection_HandleEvacTrigger( FS_INFECTION.CoolEvac, origin - <0,0,200>, waitDepartTime )
	
	SetGlobalNetTime("countdownTimerStart", Time())
	SetGlobalNetTime("countdownTimerEnd", Time() + waitDepartTime)

	foreach( player in GetPlayerArray_Alive() )
	{
		if( player.GetTeam() == TEAM_IMC )
		{
			Remote_CallFunction_NonReplay( player, "Infection_CreateEvacCountdown", 2)
			Remote_CallFunction_NonReplay( player, "ServerCallback_ModeShadowSquad_AnnouncementSplash", eShadowSquadMessage.EVAC_ARRIVED_LEGEND, 5 )
		} else if( player.GetTeam() == TEAM_MILITIA )
		{
			Remote_CallFunction_NonReplay( player, "ServerCallback_ModeShadowSquad_AnnouncementSplash", eShadowSquadMessage.EVAC_ARRIVED_SHADOW, 5 )
		}
	}
	
	wait waitDepartTime
	
	if(GetGameState() != eGameState.Playing)
		return

	if(GetGameState() != eGameState.MapVoting)
		SetGameState(eGameState.MapVoting)
	
	WaitFrame()
	
	StopSoundOnEntity( evac, DROPSHIP_HOVER )
	EmitSoundOnEntity( evac, DROPSHIP_FLYOUT )
	
	Signal(FS_INFECTION.CoolEvac, "EvacCompleted")

	thread PlayAnim( evac, EVAC_END, origin, angles )	

	wait evac.GetSequenceDuration( EVAC_END ) - 1

	foreach(player in GetPlayerArrayOfTeam_Alive(TEAM_IMC))
		if(player.GetParent() == FS_INFECTION.CoolEvac)
		{
			player.MakeInvisible()
			Remote_CallFunction_NonReplay( player, "CreateCoolCameraForCoolDropship", evac )
			player.UnforceCrouch()
			ClearInvincible(player)
			player.ClearParent()
			player.SetPhysics( MOVETYPE_NOCLIP )
			HolsterAndDisableWeapons( player )
		}

	wait 1
	
	__WarpOutEffectShared( evac )

	evac.MakeInvisible()
	
	StopSoundOnEntity( evac, DROPSHIP_FLYOUT )
	
	thread function() : ()
	{
		if(!FS_INFECTION.forceLegendsWin) return
		
		wait 1.5
		
		foreach(player in GetPlayerArrayOfTeam_Alive(TEAM_IMC))
		{
			//Remote_CallFunction_NonReplay( player, "ServerCallback_PlayMatchEndMusic" )
			Remote_CallFunction_ByRef( player, "ServerCallback_PlayMatchEndMusic" )
			Remote_CallFunction_NonReplay( player, "ServerCallback_MatchEndAnnouncement", true, TEAM_IMC )
		}
	}()
	evac.Destroy()
}

void function FlowstateInfection_HandleEvacTrigger( entity evac, vector origin, float waitDepartTime)
{
	EndSignal( evac, "OnDestroy" )
	
    const float radius = DEFAULT_EVAC_RADIUS
	
	origin += AnglesToForward(evac.GetAngles())*50
	
	entity trigger = CreateEntity("trigger_cylinder")
	trigger.SetRadius( radius )
	trigger.SetAboveHeight( 300 )
	trigger.SetBelowHeight( 50 )
	trigger.SetOrigin( origin )
	trigger.SetOwner( evac )
	trigger.SetEnterCallback( FlowstateInfection_EvacTriggerEnter )
	DispatchSpawn( trigger )
	
	array<entity> CirclePoints = FlowstateInfection_CreateEvacFX( trigger.GetOrigin(), radius , 28 )
	
	OnThreadEnd(
		function() : ( trigger, CirclePoints )
		{
			if(IsValid(trigger)) trigger.Destroy()

			foreach( flare in CirclePoints )
			  flare.Destroy()
		}
	)
	wait waitDepartTime
}

void function FlowstateInfection_EvacTriggerEnter( entity trigger, entity ent )
{
	if( !IsValid( ent ) || !ent.IsPlayer() || ent.Player_IsFreefalling() || ent.GetPhysics() == MOVETYPE_NOCLIP || ent.GetTeam() != TEAM_IMC || ent.GetParent() == trigger.GetOwner() || GetGameState() == eGameState.MapVoting )
		return

	if( ent.IsShadowForm() )
	    return

	entity evac = trigger.GetOwner()

	if( !IsValid( evac ) )
	   return

	FS_INFECTION.forceLegendsWin = true
	
	thread function() : (ent, evac)
	{
		MakeInvincible(ent)		
		ScreenFadeToBlack( ent, 0.5, 0.0 )
		
		ent.TakeOffhandWeapon(OFFHAND_TACTICAL)
		ent.TakeOffhandWeapon(OFFHAND_ULTIMATE)
		
		wait 0.5
		if(!IsValid(ent)) return
		
		string attachmentToUse = EvacAttachments.getrandom()
		
		ent.SetParent( evac, attachmentToUse)
		ent.SetOrigin( evac.GetAttachmentOrigin( evac.LookupAttachment( attachmentToUse ) ) )
		
		if( attachmentToUse == "RampAttachA" ||  attachmentToUse == "RampAttachB" )
			ent.ForceCrouch()
		
		ent.MovementDisable()
		
		ScreenFadeFromBlack( ent, 1.5, 0.0 )
		Remote_CallFunction_NonReplay( ent, "ServerCallback_ModeShadowSquad_AnnouncementSplash", eShadowSquadMessage.SAFE_ON_EVAC_SHIP, 5 )
				
		foreach(player in GetPlayerArray())
		{
			if(!IsValid(player)) continue
			
			Remote_CallFunction_NonReplay( player, "INFECTION_QuickHint", -4, false, ent.GetEncodedEHandle())
		}
	}()
}

array<entity> function FlowstateInfection_CreateEvacFX( vector origin , float radius , int segments = 16 ) //thx zero (?)
{
	float degrees =  360.0 / float( segments )

	bool firstLoop = true
	vector start
	vector end
	vector firstend

	array<vector> pointsOnCircle = []

	for ( int i = 0; i < segments; i++ )
	{
		vector angles2 = AnglesCompose( ZERO_VECTOR, <0, degrees * i, 0> )
		vector forward = AnglesToForward( angles2 )
		end = origin + ( forward * radius )

		if ( firstLoop )
			firstend = end

		pointsOnCircle.append( end )

		start = end

		firstLoop = false
	}

	array<entity> Markers = []

    foreach( point in pointsOnCircle)
	{
		TraceResults result = TraceLineHighDetail( point + <0,0,-35>, point + <0,0,400>, null, TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
		if ( !IsValid( result.hitEnt )  )
		   continue

		Markers.append( FlowstateInfection_CreateEnvSprite(result.endPos, "81, 173, 0", 0.25) )
	}
	
	return Markers
}

entity function FlowstateInfection_CreateEnvSprite( vector origin, string lightcolor, float scale )
{
	entity env_sprite = CreateEntity( "env_sprite" )
	env_sprite.SetScriptName( UniqueString( "molotov_sprite" ) )
	env_sprite.kv.rendermode = 5
	env_sprite.kv.origin = origin + Vector(0,0,15)
	env_sprite.kv.angles = Vector(0,0,0)
	env_sprite.kv.fadedist = -1
	env_sprite.kv.rendercolor = lightcolor
	env_sprite.kv.renderamt = 255
	env_sprite.kv.framerate = "10.0"
	env_sprite.SetValueForModelKey( $"sprites/glow_05.vmt" )
	env_sprite.kv.scale = string( scale )
	env_sprite.kv.spawnflags = 1
	env_sprite.kv.GlowProxySize = 15.0
	env_sprite.kv.HDRColorScale = 15.0
	DispatchSpawn( env_sprite )
	EntFireByHandle( env_sprite, "ShowSprite", "", 0, null, null )

	return env_sprite
}

void function FlowstateInfection_JetWashFX(entity evac)
{
	while(IsValid(evac))
	{
		vector start = evac.GetOrigin() - < 0, 0, 60 >
		vector end = start - < 0, 0, 300 >
		TraceResults downTraceResult = TraceLine( start, end, [evac], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
		if ( downTraceResult.fraction < 1.0 )
		{
			PlayImpactFXTable( downTraceResult.endPos, evac, "dropship_dust" )
		}
		
		wait 0.5
	}
}

void function GiveRandomTac(entity player)
{
    array<string> Weapons = [
		//"mp_ability_grapple",
		"mp_ability_phase_walk",
		"mp_ability_heal",
		//"mp_weapon_bubble_bunker",
		"mp_weapon_grenade_bangalore",
		// "mp_ability_area_sonar_scan",
		//"mp_weapon_grenade_sonar",
		//"mp_ability_holopilot",
		"mp_ability_cloak",
		//"mp_ability_space_elevator_tac",
		"mp_ability_phase_rewind"
	]

	if(IsValid(player))
	{
		player.TakeOffhandWeapon(OFFHAND_TACTICAL)
	    player.GiveOffhandWeapon(Weapons[ RandomIntRange( 0, Weapons.len()) ], OFFHAND_TACTICAL)
	}
}

void function GiveRandomUlt(entity player )
{
    array<string> Weapons = [
		//"mp_weapon_grenade_gas",
		"mp_weapon_jump_pad",
		"mp_weapon_phase_tunnel"
		//"mp_ability_3dash",
		//"mp_ability_hunt_mode",
		//"mp_weapon_grenade_creeping_bombardment",
		//"mp_weapon_grenade_defensive_bombardment"

	]

	if(IsValid(player))
	{
		player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
	    player.GiveOffhandWeapon(Weapons[ RandomIntRange( 0, Weapons.len()) ],  OFFHAND_ULTIMATE)
	}
}

void function EmitAlertOnInfectedDistance()
{
	OnThreadEnd(
		function() : ()
		{
			foreach(player in GetPlayerArray())
			{
				player.p.hasInfectedNear = false
				Remote_CallFunction_NonReplay(player, "ShowInfectedNearUI", player.p.hasInfectedNear)				
			}
		}
	)
	
	while( GetGameState() == eGameState.Playing )
	{
		foreach(legend in GetPlayerArrayOfTeam_Alive(TEAM_IMC))
		{
			legend.p.hasInfectedNear = false
			
			if(!IsValid(legend)) continue
			
			foreach(infected in GetPlayerArrayOfTeam_Alive(TEAM_MILITIA))
			{
				if(!IsValid(infected)) continue
				
				float playerDist = Distance2D( legend.GetOrigin(), infected.GetOrigin() )
				if ( playerDist < 1000 )
				{
					legend.p.hasInfectedNear = true
				}
			}
			
			Remote_CallFunction_NonReplay(legend, "ShowInfectedNearUI", legend.p.hasInfectedNear)
		}
		
		wait 0.5
	}
}

void function PerksSystem(entity attacker)
{
	if( !IsValid(attacker) || !IsAlive(attacker) ) return
	
	if(attacker.p.infectionRoundKills % 3 == 0)
	{
		attacker.p.gainedPerks++
		switch(attacker.p.gainedPerks)
		{
			case 1:
				attacker.p.hasSecondaryWeaponPerk = true
	
				Remote_CallFunction_NonReplay( attacker, "INFECTION_QuickHint", -14, false, 0)
				
				foreach(player in GetPlayerArray())
				{
					if(!IsValid(player)) continue
					
					Remote_CallFunction_NonReplay( player, "INFECTION_QuickHint", -5, false, player.GetEncodedEHandle())
				}
			break
			
			case 2:
				attacker.p.hasBetterMagsPerk = true
				
				Remote_CallFunction_NonReplay( attacker, "INFECTION_QuickHint", -15, false, 0)

				array<entity> weapons = attacker.GetMainWeapons()
				foreach ( weapon in weapons )
				{
					array<string> mods = weapon.GetMods()
					foreach(mag in InfectionMags)
					{
						if( CanAttachToWeapon( mag, weapon.GetWeaponClassName() ) )
							mods.append( mag )
					}
					try{weapon.SetMods( mods )} catch(e42069){printt(weapon.GetWeaponClassName() + " failed to put infectionPerkQuickReload mod.")}
				}
				
				Remote_CallFunction_NonReplay( attacker, "ServerCallback_RefreshInventory" )
				
				foreach(player in GetPlayerArray())
				{
					if(!IsValid(player)) continue
					
					Remote_CallFunction_NonReplay( player, "INFECTION_QuickHint", -6, false, player.GetEncodedEHandle())
				}

			break
			
			case 3:
				//give quickreload
				attacker.p.hasQuickReloadPerk = true

				Remote_CallFunction_NonReplay( attacker, "INFECTION_QuickHint", -16, false, 0)

				array<entity> weapons = attacker.GetMainWeapons()
				foreach ( weapon in weapons )
				{
					array<string> mods = weapon.GetMods()
					mods.append( "infectionPerkQuickReload" )
					try{weapon.SetMods( mods )} catch(e42069){printt(weapon.GetWeaponClassName() + " failed to put infectionPerkQuickReload mod.")}
				}
				
				foreach(player in GetPlayerArray())
				{
					if(!IsValid(player)) continue
					
					Remote_CallFunction_NonReplay( player, "INFECTION_QuickHint", -7, false, player.GetEncodedEHandle())
				}

			break
			
			case 4:
			
				attacker.TakeOffhandWeapon(OFFHAND_ULTIMATE)
				attacker.GiveOffhandWeapon("mp_ability_area_sonar_scan", OFFHAND_ULTIMATE)
				
				if(IsValid(attacker.GetOffhandWeapon( OFFHAND_ULTIMATE )))
					attacker.GetOffhandWeapon( OFFHAND_ULTIMATE ).SetWeaponPrimaryClipCount( attacker.GetOffhandWeapon( OFFHAND_ULTIMATE ).GetWeaponPrimaryClipCountMax() )
				
				Remote_CallFunction_NonReplay( attacker, "INFECTION_QuickHint", -17, false, 0)
				
				foreach(player in GetPlayerArray())
				{
					if(!IsValid(player)) continue
					
					Remote_CallFunction_NonReplay( player, "INFECTION_QuickHint", -8, false, player.GetEncodedEHandle())
				}

			break
			
			case 5:
				attacker.SetMoveSpeedScale(1.25)
				
				Remote_CallFunction_NonReplay( attacker, "INFECTION_QuickHint", -18, false, 0)
				
				foreach(player in GetPlayerArray())
				{
					if(!IsValid(player)) continue
					
					Remote_CallFunction_NonReplay( player, "INFECTION_QuickHint", -9, false, player.GetEncodedEHandle())
				}

			break
			
			case 6:
			
				attacker.TakeOffhandWeapon(OFFHAND_ULTIMATE)
				attacker.GiveOffhandWeapon("mp_ability_3dash", OFFHAND_ULTIMATE)
				
				if(IsValid(attacker.GetOffhandWeapon( OFFHAND_ULTIMATE )))
					attacker.GetOffhandWeapon( OFFHAND_ULTIMATE ).SetWeaponPrimaryClipCount( attacker.GetOffhandWeapon( OFFHAND_ULTIMATE ).GetWeaponPrimaryClipCountMax() )
				
				Remote_CallFunction_NonReplay( attacker, "INFECTION_QuickHint", -19, false, 0)
				
				foreach(player in GetPlayerArray())
				{
					if(!IsValid(player)) continue
					
					Remote_CallFunction_NonReplay( player, "INFECTION_QuickHint", -10, false, player.GetEncodedEHandle())
				}

			break
			
			case 7:
				attacker.p.hasHardenedPerk = true
				
				Remote_CallFunction_NonReplay( attacker, "INFECTION_QuickHint", -20, false, 0)
				
				foreach(player in GetPlayerArray())
				{
					if(!IsValid(player)) continue
					
					Remote_CallFunction_NonReplay( player, "INFECTION_QuickHint", -11, false, player.GetEncodedEHandle())
				}

			break
			
			case 8:
				GivePassive(attacker, ePassives.PAS_PILOT_BLOOD)
				
				Remote_CallFunction_NonReplay( attacker, "INFECTION_QuickHint", -21, false, 0)
				
				foreach(player in GetPlayerArray())
				{
					if(!IsValid(player)) continue
					
					Remote_CallFunction_NonReplay( player, "INFECTION_QuickHint", -12, false, player.GetEncodedEHandle())
				}

			break
			
			case 9:
				//give satchel
				
				// foreach(player in GetPlayerArray())
				// {
					// if(!IsValid(player)) continue
					
					// Remote_CallFunction_NonReplay( player, "INFECTION_QuickHint", -4, false, ent.GetEncodedEHandle())
				// }

			break
		}
	}
}

void function OnPropSurvivalSpawned_Infection(entity prop)
{
	thread function() : ( prop )
	{
		wait 0.5
		if(prop == null || IsValid(prop) == false)
			return

		entity par = prop.GetParent()
		if(par && par.GetClassName() == "prop_physics")
			prop.Dissolve(ENTITY_DISSOLVE_CORE, <0,0,0>, 200)		
	}()
}

void function Infection_OnPlayerDamage( entity player, var damageInfo )
{
	if ( !IsValid( player ) || !player.IsPlayer() )
		return

	entity attacker = InflictorOwner( DamageInfo_GetAttacker( damageInfo ) )
	
	if(!attacker.IsPlayer()) return
	
	player.e.lastAttacker = attacker
	UpdateLastDamageTime(player)
	
	float damage = DamageInfo_GetDamage( damageInfo )
		
	if( player.p.hasHardenedPerk )
		DamageInfo_SetDamage( damageInfo, min(100, damage/3) )
}