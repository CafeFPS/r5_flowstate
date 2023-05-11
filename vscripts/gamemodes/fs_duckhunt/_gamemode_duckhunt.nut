//APEX DUCKHUNT
//Made by @CafeFPS (Retículo Endoplasmático#5955)

// Darkes#8647 - duckhunt maps
// everyone else - advice

global function _GamemodeDuckhunt_Init
global function CreateFanPusher
global function SpawnKillerWalls
global function SpawnMovingPlatform
global function SpawnMovingPlatformWithFanPusher

const int MAX_DUCKS_PLAYERS = 2

struct {
	float endTime = 0
	bool InProgress = false
	int currentRound = 1
	int winnerTeam = 0
	array<entity> serverSpawnedProps
	int spawnedmap = 1
	
	vector lobbyLocation
	vector lobbyAngles
	vector huntersStartLocation
	vector huntersStartAngles
	vector ducksStartLocation
	vector ducksStartAngles
	vector ducksStartLocation2
	vector ducksStartAngles2
	vector ducksPostWinLocation
	vector ducksPostWinAngles
	vector ducksWinTriggerPos
	vector ducksWinTriggerPos2
	vector lastFloorTrigger2
} FS_DUCKHUNT

void function _GamemodeDuckhunt_Init()
{
	switch(GetMapName())
	{
		case "mp_rr_aqueduct_night":
		case "mp_rr_aqueduct":
			FS_DUCKHUNT.lobbyLocation = <-323.799377, -16008.7832, 11485.8652>
			FS_DUCKHUNT.lobbyAngles = <0, 24.2251167, 0>

			FS_DUCKHUNT.ducksPostWinLocation = <82.84478, 2112.39673, 1670.0625>
			FS_DUCKHUNT.ducksPostWinAngles = <0, 90, 0>

			FS_DUCKHUNT.huntersStartLocation = <88.0750809, 3188.95313, 1010>
			FS_DUCKHUNT.huntersStartAngles = <0, 90, 0>
			
			FS_DUCKHUNT.ducksStartLocation = <-1432.19141, 5648.50586, 71.0088806> //1
			FS_DUCKHUNT.ducksStartAngles = <0, 0, 0> //1
			
			FS_DUCKHUNT.ducksStartLocation2 = <-2619.22192, 5675.97754, -383.773621> //2
			FS_DUCKHUNT.ducksStartAngles2 = <0, 0, 0> //2
			
			FS_DUCKHUNT.ducksWinTriggerPos = <-1765.32825, 5725.50391, 2119.87378> //1
			FS_DUCKHUNT.ducksWinTriggerPos2 = <3288.87207, 5696.21826, 2150.01953> //2
			
			FS_DUCKHUNT.lastFloorTrigger2 = <-2554.42065, 5665.15186, 1735.33545> //2
		break
	}
	
	SetConVarInt("sv_quota_stringCmdsPerSecond", 100)
	
	if(GetCurrentPlaylistVarBool("enable_global_chat", true))
		SetConVarBool("sv_forceChatToTeamOnly", false)
	else
		SetConVarBool("sv_forceChatToTeamOnly", true)
	
	AddCallback_OnClientConnected( void function(entity player) { 
		thread _OnPlayerConnected(player)
    })
	
	AddCallback_OnPlayerKilled( void function(entity victim, entity attacker, var damageInfo) {
        thread _OnPlayerKilled(victim, attacker, damageInfo)
    })
	
	AddCallback_EntitiesDidLoad( _OnEntitiesDidLoad )
	
	PrecacheParticleSystem( $"P_s2s_flap_wind" )
	PrecacheParticleSystem($"P_impact_shieldbreaker_sparks")
	RegisterSignal("EndLobbyDistanceThread")
	RegisterSignal("EndScriptedPropsThread")
	thread DUCKHUNT_StartGameThread()
}

void function _OnPlayerConnected(entity player)
{
	while(IsDisconnected( player )) WaitFrame()

    if(!IsValid(player)) return
	
	DecideRespawnPlayer(player, true)
	AssignCharacter(player, RandomInt(9))
	
	Remote_CallFunction_NonReplay(player, "Minimap_DisableDraw_Internal")
	player.p.askedForHunter = false
	player.SetPlayerGameStat( PGS_DEATHS, 0)
	player.p.lastFloorCheckPoint = false
	
	AddEntityCallback_OnDamaged( player, OnPlayerDamaged )
	
	int maxplayers = GetPlayerArray().len()
	int idealImc = int(min(ceil(float(maxplayers) / float(4)), float(MAX_DUCKS_PLAYERS)))
	int idealMilitia = maxplayers - idealImc

	if(GetPlayerArrayOfTeam(TEAM_MILITIA).len() < idealMilitia)
	{
		SetTeam(player, TEAM_MILITIA )
	}else
	{
		SetTeam(player, TEAM_IMC )
	}

	switch(GetGameState())
    {
		case eGameState.WaitingForPlayers:
		case eGameState.MapVoting:
			Message(player, "APEX DUCK HUNT", "Made by @CafeFPS & Darkes#8647. Game is starting.", 4)
			
			_HandleRespawn(player)
			Survival_SetInventoryEnabled( player, false )
			SetPlayerInventory( player, [] )
			
			if(IsPlayerEliminated(player))
				ClearPlayerEliminated(player)
			
			player.SetThirdPersonShoulderModeOn()
			player.SetVelocity(Vector(0,0,0))
			
			player.SetOrigin(FS_DUCKHUNT.lobbyLocation)
			player.SetAngles(FS_DUCKHUNT.lobbyAngles)
			
			thread CheckDistanceWhileInLobby(player)
			
			TakeLoadoutRelatedWeapons(player)
			Remote_CallFunction_NonReplay(player, "ToggleSetHunterClient", true)
			break
		case eGameState.Playing:
			if ( IsPlayerEliminated( player ) )
				thread StartSpectatingDuckhunt(player, null, true)
			else
			{
				_HandleRespawn(player)
				if(player.GetTeam() == TEAM_IMC)
				{
					Signal(player, "EndLobbyDistanceThread")
					
					StartParticleEffectInWorld( GetParticleSystemIndex( $"P_impact_shieldbreaker_sparks" ), player.GetOrigin(), Vector(0,0,0) )
					EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
					EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )
					player.SetVelocity(Vector(0,0,0))
					player.SetOrigin(FS_DUCKHUNT.huntersStartLocation)
					player.SetAngles(FS_DUCKHUNT.huntersStartAngles)					
					TakeLoadoutRelatedWeapons(player)					
					player.GiveWeapon( "mp_weapon_bolo_sword_primary", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
					player.GiveOffhandWeapon( "melee_bolo_sword", OFFHAND_MELEE, [] )					
					DeployAndEnableWeapons(player)
					Survival_SetInventoryEnabled( player, true )
					Highlight_SetFriendlyHighlight( player, "prophunt_teammate" )
					ClearInvincible(player)
					player.SetThirdPersonShoulderModeOff()
					
					SetPlayerInventory( player, [] )
					Inventory_SetPlayerEquipment(player, "backpack_pickup_lv3", "backpack")
					array<string> optics = ["optic_cq_hcog_classic", "optic_cq_hcog_bruiser", "optic_cq_holosight", "optic_cq_threat", "optic_cq_holosight_variable", "optic_ranged_hcog", "optic_ranged_aog_variable", "optic_sniper_variable", "optic_sniper_threat"]
					foreach(optic in optics)
						SURVIVAL_AddToPlayerInventory(player, optic)
						
					thread CheckDistanceForHuntersOnPlatform(player)
				}else if(player.GetTeam() == TEAM_MILITIA)
				{
					Signal(player, "EndLobbyDistanceThread")

					StartParticleEffectInWorld( GetParticleSystemIndex( $"P_impact_shieldbreaker_sparks" ), player.GetOrigin(), Vector(0,0,0) )
					EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
					EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )						
					player.SetVelocity(Vector(0,0,0))
					if(FS_DUCKHUNT.spawnedmap == 2)
					{
						player.SetOrigin(FS_DUCKHUNT.ducksStartLocation2)
						player.SetAngles(FS_DUCKHUNT.ducksStartAngles2)
					}
					else if(FS_DUCKHUNT.spawnedmap == 1)
					{
						player.SetOrigin(FS_DUCKHUNT.ducksStartLocation)
						player.SetAngles(FS_DUCKHUNT.ducksStartAngles)
					}				
					TakeLoadoutRelatedWeapons(player)					
					player.GiveWeapon( "mp_weapon_bolo_sword_primary", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
					player.GiveOffhandWeapon( "melee_bolo_sword", OFFHAND_MELEE, [] )					
					DeployAndEnableWeapons(player)
					Survival_SetInventoryEnabled( player, false )
					Highlight_SetFriendlyHighlight( player, "prophunt_teammate" )
					ClearInvincible(player)
					player.SetThirdPersonShoulderModeOff()
				}
			}
			Remote_CallFunction_NonReplay(player, "ToggleSetHunterClient", false)
			break
		default:
			break
	}
	
	Remote_CallFunction_NonReplay( player, "UpdateRUITest")
	UpdatePlayerCounts()
}

void function _OnEntitiesDidLoad()
{
	AddSpawnCallback("zipline", _OnPropDynamicSpawned)
	AddSpawnCallback("prop_dynamic", _OnPropDynamicSpawned)
	SpawnDuckHuntMap() //fake spawn, this will precache props
	SpawnDuckHuntMap2() //fake spawn, this will precache props
}

void function _OnPropDynamicSpawned(entity prop)
{
	
    FS_DUCKHUNT.serverSpawnedProps.append(prop)
}

void function DestroyServerProps()
{
    foreach(prop in FS_DUCKHUNT.serverSpawnedProps)
    {
        if(IsValid(prop))
            prop.Destroy()
    }
    FS_DUCKHUNT.serverSpawnedProps.clear()
}

void function DUCKHUNT_StartGameThread()
{
    WaitForGameState(eGameState.Playing)
	
    for(;;)
	{
		DUCKHUNT_Lobby()
		DUCKHUNT_GameLoop()
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

void function OnPlayerDamaged( entity victim, var damageInfo )
{
	if ( !IsValid( victim ) || !victim.IsPlayer() || Bleedout_IsBleedingOut( victim ) )
		return
	
	entity attacker = InflictorOwner( DamageInfo_GetAttacker( damageInfo ) )
	
	int sourceId = DamageInfo_GetDamageSourceIdentifier( damageInfo )
	if ( sourceId == eDamageSourceId.bleedout || sourceId == eDamageSourceId.human_execution )
		return
	UpdateLastDamageTime(victim)
	float damage = DamageInfo_GetDamage( damageInfo )

	int currentHealth = victim.GetHealth()
	if ( !( DamageInfo_GetCustomDamageType( damageInfo ) & DF_BYPASS_SHIELD ) )
		currentHealth += victim.GetShieldHealth()
	
	vector damagePosition = DamageInfo_GetDamagePosition( damageInfo )
	int damageType = DamageInfo_GetCustomDamageType( damageInfo )
	entity weapon = DamageInfo_GetWeapon( damageInfo )

	//TakingFireDialogue( attacker, victim, weapon )
	
	if ( currentHealth - damage <= 0 && !IsInstantDeath( damageInfo ) )
	{	
		if( !IsValid(victim) || IsValid(victim) && victim.GetPlayerGameStat( PGS_DEATHS ) >= DUCKHUNT_MAX_LIFES_FOR_DUCKS && victim.GetTeam() == TEAM_MILITIA)
			return	
		
		// if(victim.GetTeam() == TEAM_MILITIA)
		// {
			// printt(victim.GetPlayerGameStat( PGS_DEATHS ))
			// int deaths = victim.GetPlayerGameStat( PGS_DEATHS )
			// deaths++
			// victim.SetPlayerGameStat( PGS_DEATHS, deaths)
		// }
		
		if(!Bleedout_AreThereAlivingMates( victim.GetTeam(), victim ) || !IsValid(attacker)) return
		
		// Remote_CallFunction_NonReplay( victim, "DUCKHUNT_CustomHint", 1, DUCKHUNT_MAX_LIFES_FOR_DUCKS - victim.GetPlayerGameStat( PGS_DEATHS ))
		
		thread EnemyDownedDialogue( attacker, victim )
		
		if( GetGameState() >= eGameState.Playing && attacker.IsPlayer() && attacker != victim )
			AddPlayerScore( attacker, "Sur_DownedPilot", victim )
	
		foreach ( cbPlayer in GetPlayerArray() )
			Remote_CallFunction_Replay( cbPlayer, "ServerCallback_OnEnemyDowned", attacker, victim, damageType, sourceId )	
			
		// Add the cool splashy blood and big red crosshair hitmarker
		DamageInfo_AddCustomDamageType( damageInfo, DF_KILLSHOT )
		
		if( victim.HasPassive( ePassives.PAS_PILOT_BLOOD ) )
			TakePassive(victim, ePassives.PAS_PILOT_BLOOD)
		
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

void function _OnPlayerKilled(entity victim, entity attacker, var damageInfo)
{
	if ( !IsValid( victim ) || !IsValid( attacker) || IsValid(victim) && !victim.IsPlayer() )
		return

	// Restore weapons for deathbox
	// if ( victim.p.storedWeapons.len() > 0 )
		// RetrievePilotWeapons( victim )
	
	// int droppableItems = GetAllDroppableItems( victim ).len()
	// if ( droppableItems > 0 )
		// CreateSurvivalDeathBoxForPlayer( victim, attacker, damageInfo )

	switch(GetGameState())
    {
		case eGameState.Playing:
		
			thread function() : (victim, attacker, damageInfo) 
			{
				if( victim.GetPlayerGameStat( PGS_DEATHS ) < DUCKHUNT_MAX_LIFES_FOR_DUCKS && victim.GetTeam() == TEAM_MILITIA ) //IsWorldSpawn( attacker )
				{
					printt(victim.GetPlayerGameStat( PGS_DEATHS ))
					int deaths = victim.GetPlayerGameStat( PGS_DEATHS )
					deaths++
					victim.SetPlayerGameStat( PGS_DEATHS, deaths)
				}
				
				if(victim.GetTeam() == TEAM_IMC && GetPlayerArrayOfTeam_Alive(TEAM_IMC).len() == 0)
				{
					FS_DUCKHUNT.winnerTeam = TEAM_MILITIA
					SetGameState(eGameState.MapVoting)
					return
				}
				
				wait DEATHCAM_TIME_SHORT
				
				if( !IsValid(victim) || GetGameState() != eGameState.Playing) return

				if( victim.GetPlayerGameStat( PGS_DEATHS ) >= DUCKHUNT_MAX_LIFES_FOR_DUCKS && victim.GetTeam() == TEAM_MILITIA) //no more lives
				{
					Remote_CallFunction_NonReplay(victim, "DUCKHUNT_Timer", false, 0)
					
					bool atleastOneValidTeammate = false
					foreach( player in GetPlayerArrayOfTeam(TEAM_MILITIA) )
					{
						if( !IsValid(player) || IsValid(player) && player == victim) continue
						
						if(  player.GetPlayerGameStat( PGS_DEATHS ) < DUCKHUNT_MAX_LIFES_FOR_DUCKS && !IsPlayerEliminated(player) )
							atleastOneValidTeammate = true
					}
					
					if(!atleastOneValidTeammate)
						return
					
					SetPlayerEliminated( victim )
					thread StartSpectatingDuckhunt(victim, attacker, false)
					return
				}
				
				if( victim.GetTeam() == TEAM_MILITIA) //respawn
				{
					entity player = victim
					
					_HandleRespawn(player)

					player.SetVelocity(Vector(0,0,0))

					if(!player.p.lastFloorCheckPoint)
					{
						if(FS_DUCKHUNT.spawnedmap == 2)
						{
							player.SetOrigin(FS_DUCKHUNT.ducksStartLocation2)
							player.SetAngles(FS_DUCKHUNT.ducksStartAngles2)
						}
						else if(FS_DUCKHUNT.spawnedmap == 1)
						{
							player.SetOrigin(FS_DUCKHUNT.ducksStartLocation)
							player.SetAngles(FS_DUCKHUNT.ducksStartAngles)
						}
					} else {
						player.SetOrigin(FS_DUCKHUNT.lastFloorTrigger2)
						player.SetAngles(FS_DUCKHUNT.ducksStartAngles2)						
					}
					
					player.TakeOffhandWeapon(OFFHAND_TACTICAL)
					player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
					player.GiveWeapon( "mp_weapon_bolo_sword_primary", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
					player.GiveOffhandWeapon( "melee_bolo_sword", OFFHAND_MELEE, [] )
					player.TakeOffhandWeapon( OFFHAND_EQUIPMENT )
					DeployAndEnableWeapons(player)
					Survival_SetInventoryEnabled( player, false )
					Highlight_SetFriendlyHighlight( player, "prophunt_teammate" )
					StartParticleEffectInWorld( GetParticleSystemIndex( $"P_impact_shieldbreaker_sparks" ), player.GetOrigin(), Vector(0,0,0) )
					EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
					EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )	
					
				} else if(victim.GetTeam() == TEAM_IMC)
				{
					thread StartSpectatingDuckhunt(victim, attacker, false)
					
					Message(victim, "Spawning in 30 seconds if possible")
					wait 30
					
					if( !IsValid(victim) || GetGameState() != eGameState.Playing || victim.GetTeam() != TEAM_IMC ) return
					
					entity player = victim
					_HandleRespawn(player)
					StartParticleEffectInWorld( GetParticleSystemIndex( $"P_impact_shieldbreaker_sparks" ), player.GetOrigin(), Vector(0,0,0) )
					EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
					EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )	
					
					player.SetVelocity(Vector(0,0,0))
					player.SetOrigin(FS_DUCKHUNT.huntersStartLocation)
					player.SetAngles(FS_DUCKHUNT.huntersStartAngles)
					
					player.TakeOffhandWeapon(OFFHAND_TACTICAL)
					player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
					player.GiveWeapon( "mp_weapon_bolo_sword_primary", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
					player.GiveOffhandWeapon( "melee_bolo_sword", OFFHAND_MELEE, [] )
					player.TakeOffhandWeapon( OFFHAND_EQUIPMENT )
					DeployAndEnableWeapons(player)
					Survival_SetInventoryEnabled( player, false )
					Highlight_SetFriendlyHighlight( player, "prophunt_teammate" )
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

	bool shouldEnd = true
	foreach( player in GetPlayerArrayOfTeam(TEAM_MILITIA) )
	{
		if( !IsValid(player) ) continue
		
		if ( player.GetPlayerGameStat( PGS_DEATHS ) < DUCKHUNT_MAX_LIFES_FOR_DUCKS && GetGameState() == eGameState.Playing && !IsPlayerEliminated(player) )
		{
			shouldEnd = false
		}
	}
	
	if(shouldEnd)
	{
		FS_DUCKHUNT.winnerTeam = TEAM_IMC
		SetGameState(eGameState.MapVoting)
		return
	}
	
	UpdatePlayerCounts()
	printt("Flowstate DEBUG - DUCKHUNT player killed.", victim, " -by- ", attacker)
}

void function StartSpectatingDuckhunt( entity player, entity attacker, bool FromConnectingPlayerEliminated = false)
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

	if ( !FromConnectingPlayerEliminated )
		player.SetPlayerNetInt( "respawnStatus", eRespawnStatus.WAITING_FOR_DELIVERY )
	else
		player.SetPlayerNetInt( "respawnStatus", eRespawnStatus.NONE )

	//wait GetDeathCamLength( player ) // To show deathcamera
	
	if( IsValid( specTarget ) && ShouldSetObserverTarget( specTarget ) && !IsAlive( player ) )
	{
		player.SetPlayerNetInt( "spectatorTargetCount", GetPlayerArrayOfTeam_Alive( specTarget.GetTeam() ).len() )
		player.SetSpecReplayDelay( Spectator_GetReplayDelay() )
		player.StartObserverMode( OBS_MODE_IN_EYE )
		player.SetObserverTarget( specTarget )
		Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Activate")
		player.p.isSpectating = true
	}
}

void function _HandleTeamForAllPlayers()
{
	int maxplayers = GetPlayerArray().len()	
	int idealImc = int(min(ceil(float(maxplayers) / float(4)), float(MAX_DUCKS_PLAYERS)))
	int idealMilitia = maxplayers - idealImc
	
	printt("Ideal IMC and MILITIA count for this round: " + idealImc + " " + idealMilitia)
	
	int imc = 0
	int mil = 0
	
	array<entity> players = GetPlayerArray()
	players.randomize()
	
	foreach(player in players)
	{
		if(!IsValid(player)) continue
		
		// if(player.p.askedForHunter)
			// SetTeam(player, TEAM_IMC )
		
		// if(!player.p.askedForHunter)
			// SetTeam(player, TEAM_MILITIA )
		
		if(mil < idealMilitia)
		{
			SetTeam(player, TEAM_MILITIA )
			mil++
		}else
		{
			SetTeam(player, TEAM_IMC )
			imc++
		}
		
		Remote_CallFunction_NonReplay( player, "UpdateRUITest")
	}
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
			Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Deactivate")
		}
	}catch(e420){}

	if(!IsAlive(player)) 
	{
		DecideRespawnPlayer(player, true)
	}

	player.UnforceStand()
	player.UnfreezeControlsOnServer()
	
	player.SetPlayerNetBool( "pingEnabled", true )
	player.SetHealth( 100 )
	player.SetMoveSpeedScale(1)
	TakeAllWeapons(player)
	
	Remote_CallFunction_NonReplay(player, "Minimap_DisableDraw_Internal")
	if(GetGameState() == eGameState.Playing)
		Remote_CallFunction_NonReplay( player, "DUCKHUNT_CustomHint", 1, DUCKHUNT_MAX_LIFES_FOR_DUCKS - player.GetPlayerGameStat( PGS_DEATHS ))
	GivePassive(player, ePassives.PAS_PILOT_BLOOD)
	player.MovementEnable()
	
	if(IsPlayerEliminated(player))
		ClearPlayerEliminated(player)
}

void function DUCKHUNT_Lobby()
{
	SetGameState(eGameState.MapVoting)
	
	FS_DUCKHUNT.InProgress = false
	
	foreach(player in GetPlayerArray())
	{
		if(!IsValid(player)) continue
		
		if(FS_DUCKHUNT.winnerTeam != 0)
		{
			Message(player, FS_DUCKHUNT.winnerTeam == TEAM_MILITIA ? "DUCKS WIN" : "HUNTERS WIN", "Use SET HUNTER button in Pause menu to become a hunter.", 6)
		} else
		{
			Message( player, "APEX DUCK HUNT", "Made by @CafeFPS & Darkes#8647", 4 )
		}
		
		_HandleRespawn(player)
		AssignCharacter(player, RandomInt(9))
		Survival_SetInventoryEnabled( player, false )
		SetPlayerInventory( player, [] )
		player.SetPlayerGameStat( PGS_DEATHS, 0)
		player.p.wasTeleported = false
		player.p.lastFloorCheckPoint = false
		
		player.SetThirdPersonShoulderModeOn()
		player.SetVelocity(Vector(0,0,0))
		
		player.SetOrigin(FS_DUCKHUNT.lobbyLocation)
		player.SetAngles(FS_DUCKHUNT.lobbyAngles)
		Inventory_SetPlayerEquipment(player, "", "armor")
		player.SetShieldHealth( 0 )
		
		thread CheckDistanceWhileInLobby(player)
		Remote_CallFunction_NonReplay(player, "DUCKHUNT_Timer", false, 0)
		//Remote_CallFunction_NonReplay(player, "ToggleSetHunterClient", true)
	}
	
	Signal(svGlobal.levelEnt, "EndScriptedPropsThread")
	
	WaitFrame()
	
	DestroyServerProps()
	
	bool enteredwaitingidk = false
	
	if(GetPlayerArray().len() < 2)
	{
		enteredwaitingidk = true

		while( GetPlayerArray_Alive().len() < 2 )
		{
			foreach(player in GetPlayerArray())
			{
				if(!IsValid(player)) continue
				
				Message(player, "DUCKHUNT", "Waiting another player to start", 2, "")
			}
			
			wait 5
		}
	}

	if(enteredwaitingidk)
	{
		foreach(player in GetPlayerArray())
		{
			if(!IsValid(player)) continue
			
			Message(player, "DUCKHUNT", "STARTING", 3, "")
		}
		
		wait 5
	}

	if(IsOdd(FS_DUCKHUNT.currentRound))
	{
		FS_DUCKHUNT.spawnedmap = 1
		thread SpawnDuckHuntMap()
	}else
	{
		FS_DUCKHUNT.spawnedmap = 2
		thread SpawnDuckHuntMap2()
	}
	
	wait 15
	
	_HandleTeamForAllPlayers()
}

void function DUCKHUNT_GameLoop()
{
	foreach(player in GetPlayerArrayOfTeam(TEAM_IMC))
	{
		if(!IsValid(player)) continue
		
		ScreenCoverTransition_Player(player, Time() + 1)
		Remote_CallFunction_NonReplay(player, "Minimap_DisableDraw_Internal")
	}
	wait 0.5
	
	SetGameState(eGameState.Playing)
	SurvivalCommentary_ResetAllData()
	
	float starttime = Time()
	
	foreach(player in GetPlayerArray())
	{
		if(!IsValid(player)) continue
		
		//Remote_CallFunction_NonReplay(player, "ToggleSetHunterClient", false)
		
		if(player.GetTeam() == TEAM_IMC)
			Remote_CallFunction_NonReplay( player, "DUCKHUNT_CustomHint", 4, 0)
		if(player.GetTeam() == TEAM_MILITIA)
			Remote_CallFunction_NonReplay( player, "DUCKHUNT_CustomHint", 6, 0)
	}
	
	foreach(player in GetPlayerArrayOfTeam(TEAM_IMC)) //tpin hunters
	{
		if(!IsValid(player)) continue
		
		Signal(player, "EndLobbyDistanceThread")
		
		thread CheckDistanceForHuntersOnPlatform(player)
		
		StartParticleEffectInWorld( GetParticleSystemIndex( $"P_impact_shieldbreaker_sparks" ), player.GetOrigin(), Vector(0,0,0) )
		EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
		EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )

		player.SetVelocity(Vector(0,0,0))
		player.SetOrigin(FS_DUCKHUNT.huntersStartLocation)
		player.SetAngles(FS_DUCKHUNT.huntersStartAngles)
		
		TakeLoadoutRelatedWeapons(player)
		
		player.GiveWeapon( "mp_weapon_bolo_sword_primary", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
		player.GiveOffhandWeapon( "melee_bolo_sword", OFFHAND_MELEE, [] )
		
		DeployAndEnableWeapons(player)
		Survival_SetInventoryEnabled( player, true )
		Highlight_SetFriendlyHighlight( player, "prophunt_teammate" )
		ClearInvincible(player)
		player.SetThirdPersonShoulderModeOff()
		
		SetPlayerInventory( player, [] )
		Inventory_SetPlayerEquipment(player, "backpack_pickup_lv3", "backpack")
		array<string> optics = ["optic_cq_hcog_classic", "optic_cq_hcog_bruiser", "optic_cq_holosight", "optic_cq_threat", "optic_cq_holosight_variable", "optic_ranged_hcog", "optic_ranged_aog_variable", "optic_sniper_variable", "optic_sniper_threat"]
		foreach(optic in optics)
			SURVIVAL_AddToPlayerInventory(player, optic)
		Inventory_SetPlayerEquipment(player, "armor_pickup_lv2", "armor")
		player.SetShieldHealth( 75 )
		GivePassive(player, ePassives.PAS_PILOT_BLOOD)
		player.p.askedForHunter = false
	}
	
	wait 14.5
	
	foreach(player in GetPlayerArrayOfTeam(TEAM_MILITIA))
	{
		if(!IsValid(player)) continue
		
		ScreenCoverTransition_Player(player, Time() + 1)
		Remote_CallFunction_NonReplay(player, "Minimap_DisableDraw_Internal")
	}	
	
	wait 0.5

	foreach(player in GetPlayerArrayOfTeam(TEAM_MILITIA)) //tpin ducks
	{
		if(!IsValid(player)) continue
		
		Signal(player, "EndLobbyDistanceThread")

		StartParticleEffectInWorld( GetParticleSystemIndex( $"P_impact_shieldbreaker_sparks" ), player.GetOrigin(), Vector(0,0,0) )
		EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
		EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )	
		
		player.SetVelocity(Vector(0,0,0))
		if(FS_DUCKHUNT.spawnedmap == 2)
		{
			player.SetOrigin(FS_DUCKHUNT.ducksStartLocation2)
			player.SetAngles(FS_DUCKHUNT.ducksStartAngles2)
		}
		else if(FS_DUCKHUNT.spawnedmap == 1)
		{
			player.SetOrigin(FS_DUCKHUNT.ducksStartLocation)
			player.SetAngles(FS_DUCKHUNT.ducksStartAngles)
		}
		TakeLoadoutRelatedWeapons(player)
		
		player.GiveWeapon( "mp_weapon_bolo_sword_primary", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
		player.GiveOffhandWeapon( "melee_bolo_sword", OFFHAND_MELEE, [] )
		
		DeployAndEnableWeapons(player)
		Survival_SetInventoryEnabled( player, false )
		Highlight_SetFriendlyHighlight( player, "prophunt_teammate" )
		ClearInvincible(player)
		player.SetThirdPersonShoulderModeOff()
		// Inventory_SetPlayerEquipment(player, "armor_pickup_lv1", "armor")
		// player.SetShieldHealth( 50 )
		GivePassive(player, ePassives.PAS_PILOT_BLOOD)
		player.p.askedForHunter = false
	}
	
	CreateTriggerBelowZone(<-247.428192, 5708.75488, -1729.73718>, 5000)
	
	if(FS_DUCKHUNT.spawnedmap == 2)
		CreateDucksWinTrigger(FS_DUCKHUNT.ducksWinTriggerPos2)
	else if(FS_DUCKHUNT.spawnedmap == 1)
		CreateDucksWinTrigger(FS_DUCKHUNT.ducksWinTriggerPos)

	if(FS_DUCKHUNT.spawnedmap == 2)
		CreateLastFloorCheckpointTrigger( FS_DUCKHUNT.lastFloorTrigger2 )
	
	FS_DUCKHUNT.winnerTeam = TEAM_IMC
	FS_DUCKHUNT.InProgress = true
	FS_DUCKHUNT.endTime = Time() + GetCurrentPlaylistVarFloat("DuckHunt_Round_LimitTime", 300 )

	foreach ( player in GetPlayerArray() )
	{
		if(!IsValid(player)) continue
		
		if(player.GetTeam() == TEAM_IMC)
			Remote_CallFunction_NonReplay( player, "DUCKHUNT_CustomHint", 0, 0)
		
		Remote_CallFunction_NonReplay(player, "DUCKHUNT_Timer", true, FS_DUCKHUNT.endTime)
		Remote_CallFunction_NonReplay( player, "DUCKHUNT_CustomHint", 5, 0)
	}
	
	while( Time() <= FS_DUCKHUNT.endTime )
	{
		// if(Time() == FS_DUCKHUNT.endTime-GetCurrentPlaylistVarFloat("DuckHunt_Round_LimitTime", 300 )/2)
		// {
			// foreach(player in GetPlayerArray())
			// {
				// if(!IsValid(player)) continue
				
				// Remote_CallFunction_NonReplay( player, "DUCKHUNT_CustomHint", 5, 0)
			// }
		// }
		
		if(GetGameState() == eGameState.MapVoting)
			break
		
		WaitFrame()	
	}
	
	bool isThereAnyBleedingOutPlayer = false
	
	foreach ( player in GetPlayerArray() )
	{
		if(!IsValid(player)) continue
		
		if(Bleedout_IsBleedingOut(player))
		{
			player.TakeDamage(player.GetMaxHealth() + 1, player.e.lastAttacker, null, { damageSourceId=eDamageSourceId.invalid, scriptType=DF_BYPASS_SHIELD })
			isThereAnyBleedingOutPlayer = true
		}
	}
	
	if(isThereAnyBleedingOutPlayer)
		wait DEATHCAM_TIME_SHORT + 1
	
	
	foreach ( player in GetPlayerArray() )
	{
		if(!IsValid(player)) continue
		Remote_CallFunction_NonReplay(player, "DUCKHUNT_Timer", false, 0)
		MakeInvincible( player )
		AddCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
		AddCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD )
		Remote_CallFunction_NonReplay( player, "ServerCallback_PlayMatchEndMusic" )
		Remote_CallFunction_NonReplay( player, "ServerCallback_MatchEndAnnouncement", player.GetTeam() == FS_DUCKHUNT.winnerTeam, FS_DUCKHUNT.winnerTeam )
	}
	
	thread SurvivalCommentary_HostAnnounce( eSurvivalCommentaryBucket.WINNER, 3.0 )

	wait 4.9
	
	foreach(player in GetPlayerArray() )
	{
		if(!IsValid(player)) continue
		
		ScreenCoverTransition_Player(player, Time() + 1)
	}
	
	wait 0.2
	
	foreach ( player in GetPlayerArray() )
	{
		if(!IsValid(player)) continue
		
		RemoveCinematicFlag( player, CE_FLAG_HIDE_MAIN_HUD_INSTANT )
		RemoveCinematicFlag( player, CE_FLAG_HIDE_PERMANENT_HUD )
		
		Remote_CallFunction_NonReplay( player, "ServerCallback_DestroyEndAnnouncement")
	}
	
	wait 0.8
	
	FS_DUCKHUNT.currentRound++
	
	UpdatePlayerCounts()
}

void function CheckDistanceWhileInLobby(entity player)
{
	EndSignal(player, "EndLobbyDistanceThread")
	
	while(IsValid(player))
	{
		if(Distance(player.GetOrigin(),FS_DUCKHUNT.lobbyLocation)>2000)
		{
			player.SetVelocity(Vector(0,0,0))
			player.SetOrigin(FS_DUCKHUNT.lobbyLocation)
		}
		WaitFrame()
	}	
}

void function CheckDistanceForHuntersOnPlatform(entity player)
{
	while(IsValid(player) && player.GetTeam() == TEAM_IMC && GetGameState() == eGameState.Playing)
	{
		if(Distance(player.GetOrigin(),FS_DUCKHUNT.huntersStartLocation)>1250)
		{
			player.SetVelocity(Vector(0,0,0))
			player.SetOrigin(FS_DUCKHUNT.huntersStartLocation)
			
			StartParticleEffectInWorld( GetParticleSystemIndex( $"P_impact_shieldbreaker_sparks" ), player.GetOrigin(), Vector(0,0,0) )
			EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
			EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )	
			
		}
		WaitFrame()
	}
}

entity function CreateTriggerBelowZone( vector origin , float radius = 1000)
{
	entity trigger = CreateEntity( "trigger_cylinder" )
	trigger.SetRadius( radius )
	trigger.SetAboveHeight( 2000 )
	trigger.SetBelowHeight( 50 )
	trigger.SetOrigin( origin )
	trigger.SetEnterCallback(  DucksTriggerEnter )
	trigger.SetAboveHeight( 350 )
	DispatchSpawn( trigger )
	trigger.SearchForNewTouchingEntity()
	FS_DUCKHUNT.serverSpawnedProps.append(trigger)
	
	//DebugDrawCylinder( trigger.GetOrigin() , < -90, 0, 0 >, radius, trigger.GetAboveHeight(), 0, 165, 255, true, 9999.9 )
	//DebugDrawCylinder( trigger.GetOrigin() , < -90, 0, 0 >, radius, -trigger.GetBelowHeight(), 255, 90, 0, true, 9999.9 )
    return trigger
}

void function DucksTriggerEnter( entity trigger , entity player )
{
	if( !IsValid(player) || IsValid(player) && player.GetTeam() != TEAM_MILITIA || IsValid(player) && !player.IsPlayer() || GetGameState() != eGameState.Playing) return

	if (!player.p.wasTeleported)
		player.TakeDamage(player.GetMaxHealth() + 1, null, null, { damageSourceId=eDamageSourceId.fall, scriptType=DF_BYPASS_SHIELD })
	else
	{	
		player.SetVelocity(Vector(0,0,0))
		player.SetOrigin(FS_DUCKHUNT.ducksPostWinLocation)
		player.SetAngles(FS_DUCKHUNT.ducksPostWinAngles)
		
		StartParticleEffectInWorld( GetParticleSystemIndex( $"P_impact_shieldbreaker_sparks" ), player.GetOrigin(), Vector(0,0,0) )
		EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
		EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )
	}
}

entity function CreateDucksWinTrigger( vector origin )
{
	float radius = 150
	entity trigger = CreateEntity( "trigger_cylinder" )
	trigger.SetRadius( radius )
	trigger.SetAboveHeight( 50 )
	trigger.SetBelowHeight( 50 )
	trigger.SetOrigin( origin + Vector(0,0,50) )
	trigger.SetEnterCallback(  DucksWinTriggerEnter )
	trigger.SetAboveHeight( 50 )
	DispatchSpawn( trigger )
	trigger.SearchForNewTouchingEntity()
	FS_DUCKHUNT.serverSpawnedProps.append(trigger)
	
	// DebugDrawCylinder( trigger.GetOrigin() , < -90, 0, 0 >, radius, trigger.GetAboveHeight(), 0, 165, 255, true, 9999.9 )
	// DebugDrawCylinder( trigger.GetOrigin() , < -90, 0, 0 >, radius, -trigger.GetBelowHeight(), 255, 90, 0, true, 9999.9 )
    return trigger
}
void function DucksWinTriggerEnter( entity trigger , entity player )
{
	if( !IsValid(player) ) return

	if (player.IsPlayer() && player.GetTeam() == TEAM_MILITIA)
	{
		player.SetVelocity(Vector(0,0,0))
		player.SetOrigin(FS_DUCKHUNT.ducksPostWinLocation)
		player.SetAngles(FS_DUCKHUNT.ducksPostWinAngles)
		
		StartParticleEffectInWorld( GetParticleSystemIndex( $"P_impact_shieldbreaker_sparks" ), player.GetOrigin(), Vector(0,0,0) )
		EmitSoundOnEntityOnlyToPlayer( player, player, "PhaseGate_Enter_1p" )
		EmitSoundOnEntityExceptToPlayer( player, player, "PhaseGate_Enter_3p" )
		
		Message(player, "KILL THE HUNTERS", "", 1)
		
		player.p.wasTeleported = true //to change trigger behavior
		
		// if(FS_DUCKHUNT.winnerTeam == TEAM_IMC)
			// FS_DUCKHUNT.winnerTeam = TEAM_MILITIA
	}
}

entity function CreateLastFloorCheckpointTrigger( vector origin )
{
	float radius = 300
	entity trigger = CreateEntity( "trigger_cylinder" )
	trigger.SetRadius( radius )
	trigger.SetAboveHeight( 50 )
	trigger.SetBelowHeight( 50 )
	trigger.SetOrigin( origin + Vector(0,0,50) )
	trigger.SetEnterCallback( LastFloorEnter )
	trigger.SetAboveHeight( 50 )
	DispatchSpawn( trigger )
	trigger.SearchForNewTouchingEntity()
	FS_DUCKHUNT.serverSpawnedProps.append(trigger)
	
	// DebugDrawCylinder( trigger.GetOrigin() , < -90, 0, 0 >, radius, trigger.GetAboveHeight(), 0, 165, 255, true, 9999.9 )
	// DebugDrawCylinder( trigger.GetOrigin() , < -90, 0, 0 >, radius, -trigger.GetBelowHeight(), 255, 90, 0, true, 9999.9 )
    return trigger
}

void function LastFloorEnter( entity trigger , entity player )
{
	if( !IsValid(player) ) return

	if (player.IsPlayer() && player.GetTeam() == TEAM_MILITIA && !player.p.lastFloorCheckPoint)
	{
		StartParticleEffectInWorld( GetParticleSystemIndex( $"P_impact_shieldbreaker_sparks" ), player.GetOrigin(), Vector(0,0,0) )

		Message(player, "Last floor checkpoint", "", 1)
		
		foreach( sPlayer in GetPlayerArray() )
		{
			if(!IsValid(sPlayer) || IsValid(sPlayer) && sPlayer == player ) continue
			
			Remote_CallFunction_NonReplay( sPlayer, "DUCKHUNT_CustomHint", 3, 0)
		}	
		player.p.lastFloorCheckPoint = true
	}
}

void function CreateFanPusher(vector origin, vector angles2)
{
	EndSignal(svGlobal.levelEnt, "EndScriptedPropsThread")
	
	entity rotator = CreateEntity( "script_mover_lightweight" )
	rotator.kv.solid = SOLID_VPHYSICS
	rotator.SetValueForModelKey( $"mdl/dev/empty_model.rmdl" )
	rotator.kv.fadedist = -1
	rotator.kv.SpawnAsPhysicsMover = 0
	rotator.e.isDoorBlocker = true
	rotator.SetOrigin(origin)
	rotator.SetAngles(angles2)
	rotator.SetScriptName("FanPusher")
	DispatchSpawn( rotator )
	FS_DUCKHUNT.serverSpawnedProps.append(rotator)
	
	//Wind column effect, two so we complete a cylinder-like shape
	entity fx = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_s2s_flap_wind" ), origin, angles2 )
	EmitSoundOnEntity(fx, "HoverTank_Emit_EdgeWind")
	fx.SetParent(rotator)
	entity fx2 = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_s2s_flap_wind" ), origin, angles2 )
	fx2.SetParent(rotator)
	
	if(GameRules_GetGameMode() == "flowstate_infection") return
	
	thread function() : (rotator, origin, angles2)
	{
		EndSignal(svGlobal.levelEnt, "EndScriptedPropsThread")
		
		wait 3
		rotator.Destroy()
		wait 2
		CreateFanPusher(origin, angles2)
	}()	
}

void function SpawnKillerWalls(vector origin)
{
	EndSignal(svGlobal.levelEnt, "EndScriptedPropsThread")
	
	vector angles1 = Vector(0,90,0)
	
	entity rotator = CreateEntity( "script_mover_lightweight" )
	rotator.kv.solid = SOLID_VPHYSICS
	rotator.kv.fadedist = -1
	rotator.SetValueForModelKey( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl" )
	rotator.kv.SpawnAsPhysicsMover = 0
	rotator.e.isDoorBlocker = true
	DispatchSpawn( rotator )
	rotator.SetPusher( true )
	rotator.SetAngles(Vector(angles1.x, (angles1.y + 90)  % 360, angles1.z))
	FS_DUCKHUNT.serverSpawnedProps.append(rotator)
	
	entity rotator2 = CreateEntity( "script_mover_lightweight" )
	rotator2.kv.solid = SOLID_VPHYSICS
	rotator2.kv.fadedist = -1
	rotator2.SetValueForModelKey( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl" )
	rotator2.kv.SpawnAsPhysicsMover = 0
	rotator2.e.isDoorBlocker = true
	DispatchSpawn( rotator2 )
	rotator2.SetPusher( true )
	rotator2.SetAngles(Vector(angles1.x, (angles1.y + 90)  % 360, angles1.z))
	rotator2.SetOrigin(origin)
	FS_DUCKHUNT.serverSpawnedProps.append(rotator2)
	
	entity visual1 = CreatePropDynamic($"mdl/thunderdome/thunderdome_spike_traps_large_128_01.rmdl", rotator.GetOrigin(), < 90, 90, 0 >, SOLID_VPHYSICS, -1)
	visual1.kv.fadedist = -1
	visual1.kv.rendermode = 0
	visual1.kv.renderamt = 1
	visual1.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER	
	visual1.SetParent(rotator2)
	
	entity visual1_2 = CreatePropDynamic($"mdl/thunderdome/thunderdome_spike_traps_large_128_01.rmdl", rotator.GetOrigin()+Vector(0,0,128), < 90, 90, 0 >, SOLID_VPHYSICS, -1)
	visual1_2.kv.fadedist = -1
	visual1_2.kv.rendermode = 0
	visual1_2.kv.renderamt = 1
	visual1_2.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER	
	visual1_2.SetParent(rotator2)
	
	entity visual2 = CreatePropDynamic($"mdl/thunderdome/thunderdome_spike_traps_large_128_01.rmdl", rotator.GetOrigin(), < 90, -90, 0 >, SOLID_VPHYSICS, -1)
	visual2.kv.fadedist = -1
	visual2.kv.rendermode = 0
	visual2.kv.renderamt = 1
	visual2.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER	
	visual2.SetParent(rotator)

	entity visual2_2 = CreatePropDynamic($"mdl/thunderdome/thunderdome_spike_traps_large_128_01.rmdl", rotator.GetOrigin()+Vector(0,0,128), < 90, -90, 0 >, SOLID_VPHYSICS, -1)
	visual2_2.kv.fadedist = -1
	visual2_2.kv.rendermode = 0
	visual2_2.kv.renderamt = 1
	visual2_2.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER	
	visual2_2.SetParent(rotator)
	
	thread function() : (rotator, rotator2, origin)
	{
		EndSignal(svGlobal.levelEnt, "EndScriptedPropsThread")
		
		float timemoving = 2
		vector startpos = origin
		
		while(IsValid(rotator))
		{
			rotator.NonPhysicsMoveTo( startpos+AnglesToRight(rotator.GetAngles())*128, timemoving, 0, 0.5 )
			rotator2.NonPhysicsMoveTo( startpos+AnglesToRight(rotator.GetAngles())*-128, timemoving, 0, 0.5 )
			
			wait timemoving-0.01
			
			rotator.NonPhysicsMoveTo( startpos, 0.3, 0, 0 )
			rotator2.NonPhysicsMoveTo( startpos, 0.3, 0, 0 )
			
			wait 0.3-0.01
		}
	}()
}

void function SpawnMovingPlatform(vector origin)
{
	EndSignal(svGlobal.levelEnt, "EndScriptedPropsThread")
	
	vector angles1 = Vector(0,0,0)

	for(int i = 0; i < 7; i++)
	{
		entity rotator = CreateEntity( "script_mover_lightweight" )
		rotator.kv.solid = 0
		rotator.kv.fadedist = -1
		rotator.SetValueForModelKey( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl" )
		rotator.kv.SpawnAsPhysicsMover = 0
		rotator.e.isDoorBlocker = true
		DispatchSpawn( rotator )
		rotator.SetAngles(angles1)
		rotator.SetOrigin(origin + Vector(256*i,0,0))
		rotator.Hide()		
		rotator.SetPusher( true )
		FS_DUCKHUNT.serverSpawnedProps.append(rotator)
		
		entity visual = CreateEntity( "prop_dynamic" )
		visual.kv.solid = SOLID_VPHYSICS
		visual.kv.fadedist = -1
		visual.SetValueForModelKey( $"mdl/thunderdome/thunderdome_cage_ceiling_256x128_06.rmdl" )
		visual.SetParent(rotator)
		DispatchSpawn( visual )
		visual.SetAngles(rotator.GetAngles())
		visual.SetOrigin(rotator.GetOrigin())
		
		thread function() : (i, rotator)
		{
			EndSignal(svGlobal.levelEnt, "EndScriptedPropsThread")
			
			float timemoving = 5.0
			vector startpos = rotator.GetOrigin()
			
			//bad code moment
			vector MoveRight = startpos+AnglesToRight(rotator.GetAngles())*300
			vector MoveLeft = startpos+AnglesToRight(rotator.GetAngles())*-300
			
			vector MoveTo = IsOdd(i) ? MoveLeft : MoveRight
			
			while(IsValid(rotator))
			{
				rotator.NonPhysicsMoveTo( MoveTo , timemoving, 1, 1 )
				wait timemoving
				rotator.NonPhysicsMoveTo( startpos, timemoving, 1, 1 )
				wait timemoving
			
				if(MoveTo == MoveRight)
					MoveTo = MoveLeft
				else if(MoveTo == MoveLeft)
					MoveTo = MoveRight
				
			}
		}()
	}
}

void function SpawnMovingPlatformWithFanPusher(vector origin)
{
	EndSignal(svGlobal.levelEnt, "EndScriptedPropsThread")
	
	entity platform = CreateEntity( "prop_dynamic" )
	platform.kv.solid = SOLID_VPHYSICS
	platform.kv.fadedist = -1
	platform.SetValueForModelKey( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl" )
	DispatchSpawn( platform )

	vector angles1 = Vector(0,0,90)
	platform.SetOrigin(origin)
	platform.SetAngles(angles1)
	platform.SetPusher( true )
	vector angles2 = Vector(-90,0,90)
	PrecacheParticleSystem( $"P_s2s_flap_wind" )
	
	origin = origin + AnglesToUp(angles2) * 128
	entity rotator = CreateEntity( "script_mover_lightweight" )
	rotator.kv.solid = SOLID_VPHYSICS
	rotator.kv.fadedist = -1
	//rotator.SetValueForModelKey( $"mdl/thunderdome/thunderdome_cage_wall_256x256_01.rmdl" )
	rotator.kv.SpawnAsPhysicsMover = 0
	rotator.e.isDoorBlocker = true
	rotator.SetOrigin(origin)
	rotator.SetAngles(angles2)
	rotator.SetScriptName("FanPusher")
	DispatchSpawn( rotator )
	rotator.SetParent(platform)

	//Wind column effect, two so we complete a cylinder-like shape
	entity fx = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_s2s_flap_wind" ), origin, Vector(-90,0,0) )
	EmitSoundOnEntity(fx, "HoverTank_Emit_EdgeWind")
	fx.SetParent(platform)
	entity fx2 = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_s2s_flap_wind" ), origin, Vector(-90,-90,0) )
	fx2.SetParent(platform)
	
	//Circle on ground FX
	entity circle = CreateEntity( "prop_script" )
	circle.SetValueForModelKey( $"mdl/weapons_r5/weapon_tesla_trap/mp_weapon_tesla_trap_ar_trigger_radius.rmdl" )
	circle.kv.fadedist = 30000
	circle.kv.renderamt = 0
	circle.kv.rendercolor = "250, 250, 250"
	circle.kv.modelscale = 0.12
	circle.kv.solid = 0
	circle.SetOrigin( fx.GetOrigin() + <0.0, 0.0, -25>)
	circle.SetAngles( Vector(0,0,0) )
	circle.NotSolid()
	DispatchSpawn(circle)
	circle.SetParent(platform)
	
	// thread function() : (platform)
	// {
		// float timemoving = 5.0
		// vector startpos = platform.GetOrigin()
		
		// while(IsValid(platform))
		// {
			// platform.NonPhysicsMoveTo( startpos+AnglesToForward(platform.GetAngles())*500, timemoving, 1, 1 )
			// wait timemoving
			// platform.NonPhysicsMoveTo( startpos, timemoving, 1, 1 )
			// wait timemoving
		// }
	// }()
}