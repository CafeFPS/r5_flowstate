// Credits
// AyeZee#6969 -- ctf gamemode and ui
// CafeFPS -- Rework and code fixes
// Rexx and IcePixelx -- Help with code improvments
// sal#3261 -- base custom_tdm mode to work off
// everyone else -- advice

global function _CustomCTF_Init
global function _CTFRegisterLocation
global function _CTFRegisterCTFClass

enum eCTFState
{
    IN_PROGRESS = 0
    WINNER_DECIDED = 1
}

struct {
    int ctfState = eCTFState.IN_PROGRESS
    LocationSettingsCTF& selectedLocation
    array<LocationSettingsCTF> locationSettings
    array<CTFClasses> ctfclasses
    entity ringBoundary
	array<entity> playerSpawnedProps
	int currentRound = 1
	array< int > haloModAvailableColors = [ 0, 1, 2, 3, 4, 5, 6, 7 ]
} file;

struct CTFPoint
{
    entity pole
    entity pointfx
    entity beamfx
    entity trigger
    entity returntrigger
    entity trailfx
    bool pickedup = false
    bool dropped = false
    bool flagatbase = true
    entity holdingplayer
    int teamnum
    vector spawn = <0,0,0>
    bool isbeingreturned = false
    entity beingreturnedby
}

CTFPoint IMCPoint
CTFPoint MILITIAPoint

struct
{
    // Base
    int IMCPoints = 0
    int MILITIAPoints = 0
    vector ringCenter
    float ringRadius
    float roundstarttime

    // Voting
    array<entity> votedPlayers // array of players that have already voted (bad var name idc)
    bool votingtime = false
    bool votestied = false
    array<int> mapVotes
    array<int> mapIds
    int mappicked = 0
    entity ringfx
} CTF;

struct
{
    int seconds
    int endtime
    bool roundover
} ServerTimer;

void function _CustomCTF_Init()
{
	PrecacheParticleSystem($"P_survival_radius_CP_1x100")
    PrecacheModel($"mdl/props/pathfinder_zipline/pathfinder_zipline.rmdl")
	RegisterSignal( "FS_WaitForBlackScreen" )

    AddCallback_OnClientConnected( void function(entity player) { thread _OnPlayerConnected(player) } )
    AddCallback_OnClientDisconnected( void function(entity player) { thread _OnPlayerDisconnected(player) } )
    AddCallback_OnPlayerKilled(void function(entity victim, entity attacker, var damageInfo) {thread _OnPlayerDied(victim, attacker, damageInfo)})

	#if DEVELOPER
    AddClientCommandCallback("next_round", ClientCommand_NextRound)
	#endif

    if( !GetCurrentPlaylistVarBool( "is_halo_gamemode", false ) )
    {
        // Used for sending votes from client to server
        AddClientCommandCallback("VoteForMap", ClientCommand_VoteForMap)
        // Used for setting players class
        AddClientCommandCallback("SetPlayerClass", ClientCommand_SetPlayerClass)
    }
    // Used for telling the server the player wants to drop the flag
    AddClientCommandCallback("DropFlag", ClientCommand_DropFlag)

	if( GetCurrentPlaylistVarBool( "is_halo_gamemode", false ) )
	{
		PrecacheCyberdyne()
		PrecacheLockout()
		PrecacheChill()
	}

    thread RUNCTF()
}

// Register location settings from sh_ file
void function _CTFRegisterLocation(LocationSettingsCTF locationSettings)
{
    file.locationSettings.append(locationSettings)
}

// Register classes from sh_ file
void function _CTFRegisterCTFClass(CTFClasses ctfclass)
{
    file.ctfclasses.append(ctfclass)
}

/////////////////////////////////////////////
//                                         //
//             Client Commands             //
//                                         //
/////////////////////////////////////////////

bool function ClientCommand_DropFlag(entity player, array<string> args)
{
    if( !IsValid( player ) )
        return false

    CheckPlayerForFlag(player)

    return true
}

#if DEVELOPER
bool function ClientCommand_NextRound(entity player, array<string> args)
{
    file.ctfState = eCTFState.WINNER_DECIDED
	SetGlobalNetInt( "FSDM_GameState", file.ctfState )
    return true
}
#endif

bool function ClientCommand_VoteForMap(entity player, array<string> args)
{
    // don't allow multiple votes
    if ( CTF.votedPlayers.contains( player ) )
        return false

    // dont allow votes if its not voting time
    if ( !CTF.votingtime )
        return false

    // get map id from args
    int mapid = args[0].tointeger()

    // reject map ids that are outside of the range
    if ( mapid >= NUMBER_OF_MAP_SLOTS || mapid < 0 )
        return false

    // add a vote for selected maps
    CTF.mapVotes[mapid]++

    // update current amount of votes for each map
    foreach( p in GetPlayerArray() )
    {
        if( !IsValid( p ) )
            continue

        Remote_CallFunction_Replay(p, "ServerCallback_CTF_UpdateMapVotesClient", CTF.mapVotes[0], CTF.mapVotes[1], CTF.mapVotes[2], CTF.mapVotes[3])
    }

    // append player to the list of players the voted so they cant vote again
    CTF.votedPlayers.append(player)

    return true
}

bool function ClientCommand_SetPlayerClass(entity player, array<string> args)
{
    if ( !IsValid( player ) )
        return false

    // get class id from args
    int classid = args[0].tointeger()

    // reject class ids that are outside of the range
    if (classid >= NUMBER_OF_CLASS_SLOTS || classid < 0) return false

    // set players classid for next spawn and every spawn after that
    player.p.CTFClassID = classid
    player.SetPersistentVar( "gen", classid )

    return true
}
// End of client commands

void function ResetMapVotes()
{
    CTF.mapVotes.clear()
    CTF.mapVotes.resize( NUMBER_OF_MAP_SLOTS )
}

void function _OnPropDynamicSpawned(entity prop)
{
    file.playerSpawnedProps.append(prop)
}

void function DestroyPlayerProps()
{
    foreach(prop in file.playerSpawnedProps)
    {
        if(IsValid(prop))
            prop.Destroy()
    }
    file.playerSpawnedProps.clear()

    foreach(prop in GetServerPropsInDmFile())
    {
        if(IsValid(prop))
            prop.Destroy()
    }
    GetServerPropsInDmFile().clear()
}

void function RUNCTF()
{
    WaitForGameState(eGameState.Playing)
    AddSpawnCallback("prop_dynamic", _OnPropDynamicSpawned)

    for( ; ; )
    {
        VotingPhase();
        StartRound();
    }
    WaitForever()
}

// purpose: handle map voting phase
void function VotingPhase()
{
    SetGameState(eGameState.MapVoting)

    // Reset scores
	GameRules_SetTeamScore( TEAM_IMC, 0 )
	GameRules_SetTeamScore( TEAM_MILITIA, 0 )
    
    // Reset score RUI
    foreach( player in GetPlayerArray() )
    {
        if( !IsValid( player ) )
            continue

        // Reset client rui score
        // Remote_CallFunction_Replay(player, "ServerCallback_CTF_PointCaptured", CTF.IMCPoints, CTF.MILITIAPoints)

        // Reset Player Stats
        Remote_CallFunction_NonReplay(player, "ServerCallback_CTF_UpdatePlayerStats", eCTFStats.Clear)
    }

    file.selectedLocation = file.locationSettings[CTF.mappicked]

    // Set the next location client side for each player
    foreach( player in GetPlayerArray() )
    {
        if( !IsValid( player ) )
            continue

        Remote_CallFunction_NonReplay(player, "ServerCallback_CTF_SetSelectedLocation", CTF.mappicked)
    }

	if( file.currentRound > 1 )
	{
		foreach( entity player in GetPlayerArray() )
		{
			if(IsValid(player))
			{
				thread function () : ( player ) 
				{
					ScreenFade( player, 0, 0, 0, 255, 0, 5, FFADE_IN | FFADE_PURGE ) //let's do this before destroy player props so it looks good in custom maps
				}()
			}
		}

		thread function () : ()
		{
			wait 4
			Signal( svGlobal.levelEnt, "FS_WaitForBlackScreen" )
		}()
	}

	if( file.playerSpawnedProps.len() > 0 || GetServerPropsInDmFile().len() > 0 )
	{
		DestroyPlayerProps()
		wait 1
	}

	switch(file.selectedLocation.name)
	{	
		case "Narrows":
		thread SpawnChill()
		break
	}

	if( file.currentRound > 1 )
		WaitSignal( svGlobal.levelEnt, "FS_WaitForBlackScreen" )

    // Voting phase so disable weapons and make invincible
    foreach( player in GetPlayerArray() )
    {
        if( !IsValid( player ) )
            continue

        MakeInvincible(player)
		player.HolsterWeapon()
		player.Server_TurnOffhandWeaponsDisabledOn()
        player.ForceStand()
        TpPlayerToSpawnPoint(player)
        player.UnfreezeControlsOnServer()
        player.SetPlayerNetInt("kills", 0) // Reset for kills
        player.SetPlayerNetInt("deaths", 0) // Reset for deaths
    }
}

// purpose: for sending correct time to client after resolution change
void function StartServerRoundTimer()
{
    while ( !ServerTimer.roundover )
    {
        if( ServerTimer.seconds < 1 )
            ServerTimer.seconds = 60

        // Calculate Elapsed Time
        wait 1
        
        ServerTimer.seconds--
    }
}

// purpose: Check IMC pole entity to make sure its not null or not valid and remakes it if it is.
void function StartIMCFlagChecking()
{
    while(ServerTimer.roundover == false)
    {
        if(IMCPoint.pole == null || !IsValid(IMCPoint.pole))
            ResetFlagOnDisconnect(0)

        WaitFrame()
    }
}

// purpose: Check MIL pole entity to make sure its not null or not valid and remakes it if it is.
void function StartMILFlagChecking()
{
    while(ServerTimer.roundover == false)
    {
        if(MILITIAPoint.pole == null || !IsValid(MILITIAPoint.pole))
            ResetFlagOnDisconnect(1)

        WaitFrame()
    }
}

// purpose: handle the start of a new round for players and props
void function StartRound()
{
    // set
    SetGameState(eGameState.Playing)

    // create the ring based on location
	if( GetMapName() != "mp_flowstate" )
		file.ringBoundary = CreateRingBoundary(file.selectedLocation)

    CTF.roundstarttime = Time()

    ServerTimer.roundover = false
    ServerTimer.seconds = 60
    thread StartServerRoundTimer()

    // reset map votes
    ResetMapVotes()

    // spawn CTF flags based on location
    SpawnCTFPoints()

    thread StartIMCFlagChecking()
    thread StartMILFlagChecking()

	SetGlobalNetTime( "flowstate_DMStartTime", Time() + 10 )

    foreach(player in GetPlayerArray())
    {
        if( !IsValid( player ) )
            continue

        if( !IsAlive( player ) )
            _HandleRespawn(player)

        ClearInvincible(player)
		player.DeployWeapon()
		player.Server_TurnOffhandWeaponsDisabledOff()
        player.UnforceStand()
        player.UnfreezeControlsOnServer()
        TpPlayerToSpawnPoint(player)
        GiveBackWeapons(player)
		
		if( IsValid( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 ) ) )
			player.SetActiveWeaponBySlot( eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_1 )

		player.MovementDisable()
		player.LockWeaponChange()
		player.FreezeControlsOnServer()
				
		wait 10
		
		if( !IsValid( player ) || !IsAlive( player ) )
			return
		
		if( GetMapName() == "mp_flowstate" )
			Remote_CallFunction_NonReplay(player, "Minimap_DisableDraw_Internal")
		else
			Remote_CallFunction_NonReplay(player, "Minimap_EnableDraw_Internal")

		player.MovementEnable()
		player.UnlockWeaponChange()
		EnableOffhandWeapons( player )
		player.UnfreezeControlsOnServer()

		player.Server_TurnOffhandWeaponsDisabledOff()

		entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
		entity secondary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
		entity tactical = player.GetOffhandWeapon( OFFHAND_INVENTORY )
		entity ultimate = player.GetOffhandWeapon( OFFHAND_LEFT )

		if(IsValid(primary) && primary.UsesClipsForAmmo())
			primary.SetWeaponPrimaryClipCount(primary.GetWeaponPrimaryClipCountMax())
		if(IsValid(secondary) && secondary.UsesClipsForAmmo())
			secondary.SetWeaponPrimaryClipCount( secondary.GetWeaponPrimaryClipCountMax())
		if(IsValid(tactical) && tactical.UsesClipsForAmmo())
			tactical.SetWeaponPrimaryClipCount( tactical.GetWeaponPrimaryClipCountMax() )
		if(IsValid(ultimate) && ultimate.UsesClipsForAmmo())
			ultimate.SetWeaponPrimaryClipCount( ultimate.GetWeaponPrimaryClipCountMax() )
		
        Remote_CallFunction_NonReplay(player, "ServerCallback_CTF_DoAnnouncement", 5, eCTFAnnounce.ROUND_START, CTF.roundstarttime)
        Remote_CallFunction_NonReplay(player, "ServerCallback_CTF_SetObjectiveText", CTF_SCORE_GOAL_TO_WIN)
        // Remote_CallFunction_Replay(player, "ServerCallback_CTF_TeamText", player.GetTeam())
    }
	if( file.selectedLocation.name == "Lockout" )
	{
		file.playerSpawnedProps.append( AddDeathTriggerWithParams( Vector(42000, -10000, -19900) - <0,0,2800>, 5000 ) )
	} else if( file.selectedLocation.name == "Narrows" )
	{
		file.playerSpawnedProps.append( AddDeathTriggerWithParams( <42099.9922, -9965.91016, -21099.1738>, 7000 ) )
	}
    //EffectSetControlPointVector( CTF.ringfx, 1, <CTF.ringRadius, 0, 0> )

    float endTime = Time() + CTF_ROUNDTIME
	
	SetGlobalNetTime( "flowstate_DMRoundEndTime", endTime )
	file.ctfState = eCTFState.IN_PROGRESS
	SetGlobalNetInt( "FSDM_GameState", file.ctfState )

    while( Time() <= endTime )
    {
        if( Time() > endTime - 1 )
		{
            file.ctfState = eCTFState.WINNER_DECIDED
			if( GetGlobalNetInt( "FSDM_GameState" ) != eCTFState.WINNER_DECIDED )
				SetGlobalNetInt( "FSDM_GameState", file.ctfState )
		}

        if( file.ctfState == eCTFState.WINNER_DECIDED )
        {
            ServerTimer.roundover = true

            // for each player, if the player is holding the flag on round end. make them drop it so it dosnt cause a crash
            foreach(player in GetPlayerArray())
            {
                if( !IsValid( player ) )
                    continue
				
				CheckPlayerForFlag(player)
                if (player == IMCPoint.holdingplayer)
                {
                    IMCPoint.pole.ClearParent()
                    IMCPoint.dropped = false
                    IMCPoint.holdingplayer = null
                    IMCPoint.pickedup = false
                    IMCPoint.flagatbase = true
                }

                if (player == MILITIAPoint.holdingplayer)
                {
                    MILITIAPoint.pole.ClearParent()
                    MILITIAPoint.dropped = false
                    MILITIAPoint.holdingplayer = null
                    MILITIAPoint.pickedup = false
                    MILITIAPoint.flagatbase = true
                }
            }

			SetGlobalNetEnt( "milFlag", null )
			SetGlobalNetEnt( "imcFlag", null )

            // remove trail fx from players
            if( IsValid( IMCPoint.trailfx ) )
                IMCPoint.trailfx.Destroy()

            if( IsValid( MILITIAPoint.trailfx ) )
                MILITIAPoint.trailfx.Destroy()

            int TeamWon = 69;

            // Destroy ring
			if( IsValid( file.ringBoundary ) )
				file.ringBoundary.Destroy()

            // See what team has more points to decide on the winner
            if ( GameRules_GetTeamScore( TEAM_IMC ) > GameRules_GetTeamScore( TEAM_MILITIA ) )
                TeamWon = TEAM_IMC
            else if ( GameRules_GetTeamScore( TEAM_MILITIA ) > GameRules_GetTeamScore( TEAM_IMC ) )
                TeamWon = TEAM_MILITIA

            foreach( player in GetPlayerArray() )
            {
                if( !IsValid( player ) )
                    continue

                // if player is dead, respawn
                if( !IsAlive( player ) )
                    _HandleRespawn( player )
				else
					TpPlayerToSpawnPoint( player )

				player.HolsterWeapon()
				player.Server_TurnOffhandWeaponsDisabledOn()
				player.FreezeControlsOnServer()

                // round is over so make the player invinvible
                MakeInvincible(player)
            }
			
			wait 2

            // Only do voting for maps with multi locations
            if ( file.locationSettings.len() >= NUMBER_OF_MAP_SLOTS )
            {
                for( int i = 0; i < NUMBER_OF_MAP_SLOTS; ++i )
                {
                    while( true )
                    {
                        // Get a random location id from the available locations
                        int randomId = RandomIntRange(0, file.locationSettings.len())

                        // If the map already isnt picked for voting then append it to the array, otherwise keep looping till it finds one that isnt picked yet
                        if( !CTF.mapIds.contains( randomId ) )
                        {
                            CTF.mapIds.append( randomId )
                            break
                        }
                    }
                }

                // Set voting to be allowed
                CTF.votingtime = true

                // for each player, open the vote menu and set it to the winning team screen
                foreach( player in GetPlayerArray() )
                {
                    if( !IsValid( player ) )
                        continue

                    Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetVoteMenuOpen", true, TeamWon)
                    Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetScreen", eCTFScreen.WinnerScreen, TeamWon, eCTFScreen.NotUsed, eCTFScreen.NotUsed)
                }

                // Wait for timing
                wait 8

                // For each player, set voting screen and update maps that are picked for voting
                foreach( player in GetPlayerArray() )
                {
                    if( !IsValid( player ) )
                        continue

                    Remote_CallFunction_Replay(player, "ServerCallback_CTF_UpdateVotingMaps", CTF.mapIds[0], CTF.mapIds[1], CTF.mapIds[2], CTF.mapIds[3])
                    Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetScreen", eCTFScreen.VoteScreen, eCTFScreen.NotUsed, eCTFScreen.NotUsed, eCTFScreen.NotUsed)
                }

                // Wait for voting time to be over
                wait 16

                CTF.votestied = false
                bool anyVotes = false

                // Make voting not allowed
                CTF.votingtime = false

                // See if there was any votes in the first place
                foreach( int votes in CTF.mapVotes )
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


                    for(int i = 0; i < NUMBER_OF_MAP_SLOTS; ++i)
                    {
                        int votes = CTF.mapVotes[i]
                        if( votes > highestVoteCount )
                        {
                            highestVoteCount = votes
                            highestVoteId = CTF.mapIds[i]

                            // we have a new highest, so clear the array
                            mapsWithHighestVoteCount.clear()
                            mapsWithHighestVoteCount.append(CTF.mapIds[i])
                        }
                        else if( votes == highestVoteCount ) // if this map also has the highest vote count, add it to the array
                        {
                            mapsWithHighestVoteCount.append(CTF.mapIds[i])
                        }
                    }

                    // if there are multiple maps with the highest vote count then it's a tie
                    if( mapsWithHighestVoteCount.len() > 1 )
                    {
                        CTF.votestied = true
                    }
                    else // else pick the map with the highest vote count
                    {
                        // Set the vote screen for each player to show the chosen location
                        foreach( player in GetPlayerArray() )
                        {
                            if( !IsValid( player ) )
                                continue

                            Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetScreen", eCTFScreen.SelectedScreen, eCTFScreen.NotUsed, highestVoteId, eCTFScreen.NotUsed)
                        }

                        // Set the location to the location that won
                        CTF.mappicked = highestVoteId
                    }

                    if ( CTF.votestied )
                    {
                        foreach( player in GetPlayerArray() )
                        {
                            if( !IsValid( player ) )
                                continue

                            Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetScreen", eCTFScreen.TiedScreen, eCTFScreen.NotUsed, 254, eCTFScreen.NotUsed)
                        }

                        mapsWithHighestVoteCount.randomize()
                        waitthread RandomizeTiedLocations(mapsWithHighestVoteCount)
                    }
                }
                else // No one voted so pick random map
                {
                    // Pick a random location id from the aviable locations
                    CTF.mappicked = RandomIntRange(0, file.locationSettings.len() - 1)

                    // Set the vote screen for each player to show the chosen location
                    foreach( player in GetPlayerArray() )
                    {
                        if( !IsValid( player ) )
                            continue

                        Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetScreen", eCTFScreen.SelectedScreen, eCTFScreen.NotUsed, CTF.mappicked, eCTFScreen.NotUsed)
                    }
                }

                //wait for timing
                wait 5

                // Close the votemenu for each player
                foreach( player in GetPlayerArray() )
                {
                    if( !IsValid( player ) )
                        continue

                    Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetVoteMenuOpen", false, TeamWon)
                }
            }
            else
            {
                // Open the vote menu for each player and set it to the winners screen
                foreach( player in GetPlayerArray() )
                {
                    if( !IsValid( player ) )
                        continue

					if( GetCurrentPlaylistVarBool( "is_halo_gamemode", false ) )
					{
						Remote_CallFunction_NonReplay( player, "ForceScoreboardLoseFocus" )
						Remote_CallFunction_NonReplay( player, "FS_ForceDestroyCustomAdsOverlay" )
					}
                    Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetVoteMenuOpen", true, TeamWon)
                    Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetScreen", eCTFScreen.WinnerScreen, TeamWon, eCTFScreen.NotUsed, eCTFScreen.NotUsed)
                }

                ServerTimer.roundover = true

                // Wait 10 seconds so the winning team can be shown
                wait 10

                // Set the votemenu screen to show next round text
                foreach( player in GetPlayerArray() )
                {
                    if( !IsValid( player ) )
                        continue

                    Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetScreen", eCTFScreen.NextRoundScreen, eCTFScreen.NotUsed, eCTFScreen.NotUsed, eCTFScreen.NotUsed)
                }

                // Just a wait for timing
                wait 3

                // Close the votemenu for each player
                foreach( player in GetPlayerArray() )
                {
                    if( !IsValid( player ) )
                        continue

                    Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetVoteMenuOpen", false, TeamWon)
                }
            }

            // Clear players the voted for next voting
            CTF.votedPlayers.clear()

            // Clear mapids for next voting
            CTF.mapIds.clear()

            break
        }
        WaitFrame()
    }
	
	SetGlobalNetTime( "flowstate_DMRoundEndTime", -1 )
	file.ctfState = eCTFState.WINNER_DECIDED
	SetGlobalNetInt( "FSDM_GameState", file.ctfState )
	
    // Reset flag icons for each player
    foreach( player in GetPlayerArray() )
    {
        if( !IsValid( player ) )
            continue

        // ClearInvincible(player)
        // Remote_CallFunction_Replay(player, "ServerCallback_CTF_ResetFlagIcons")
    }
	
	file.currentRound++
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

            Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetScreen", eCTFScreen.TiedScreen, 69, maps[currentmapindex], 0)
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

        Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetScreen", eCTFScreen.TiedScreen, 69, maps[selectedamp], 1)
    }

    // Pause on selected map for a sec for visuals
    wait 0.5

    // Procede to final location picked screen
    foreach( player in GetPlayerArray() )
    {
        if( !IsValid( player ) )
            continue

        Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetScreen", eCTFScreen.SelectedScreen, 69, maps[selectedamp], eCTFScreen.NotUsed)
    }

    // Set selected location on server
    CTF.mappicked = maps[selectedamp]
}

void function DestroyFlagAndRemanents()
{
	// Destroy old flags, triggers, and fx
	if( IsValid( IMCPoint.pole ) )
		IMCPoint.pole.Destroy()

	if( IsValid( IMCPoint.trigger ) )
		IMCPoint.trigger.Destroy()

	if( IsValid( IMCPoint.pointfx ) )
		IMCPoint.pointfx.Destroy()

	if( IsValid( IMCPoint.beamfx ) )
		IMCPoint.beamfx.Destroy()

	if( IsValid( MILITIAPoint.pole ) )
		MILITIAPoint.pole.Destroy()

	if( IsValid( MILITIAPoint.trigger ) )
		MILITIAPoint.trigger.Destroy()

	if( IsValid( MILITIAPoint.pointfx ) )
		MILITIAPoint.pointfx.Destroy()

	if( IsValid( MILITIAPoint.beamfx ) )
		MILITIAPoint.beamfx.Destroy()
	
	if( IsValid( MILITIAPoint.returntrigger ) )
		IMCPoint.returntrigger.Destroy()

	if( IsValid( IMCPoint.returntrigger ) )
		IMCPoint.returntrigger.Destroy()
}

void function SpawnCTFPoints()
{
	DestroyFlagAndRemanents()

    // Get ground pos below spawn points
    IMCPoint.spawn = OriginToGroundCTF( file.selectedLocation.imcflagspawn )
    MILITIAPoint.spawn = OriginToGroundCTF( file.selectedLocation.milflagspawn )

    // Point 1
    IMCPoint.pole = CreateEntity( "prop_dynamic" )
    IMCPoint.pole.SetValueForModelKey( $"mdl/props/wattson_electric_fence/wattson_electric_fence.rmdl" )
    IMCPoint.pole.SetOrigin(IMCPoint.spawn)
    SetTargetName( IMCPoint.pole, "ctf_flag_imc" )
	SetTeam( IMCPoint.pole, TEAM_IMC )
    DispatchSpawn( IMCPoint.pole )

    thread PlayAnim( IMCPoint.pole, "prop_fence_expand", IMCPoint.pole.GetOrigin(), IMCPoint.pole.GetAngles() )
	IMCPoint.pole.SetCycle( 1.0 )

    IMCPoint.trigger = CreateEntity( "trigger_cylinder" )
    IMCPoint.trigger.SetRadius( 35 )
    IMCPoint.trigger.SetAboveHeight( 100 ) // Still not quite a sphere, will see if close enough
    IMCPoint.trigger.SetBelowHeight( 0 )
    IMCPoint.trigger.SetOrigin( IMCPoint.spawn )
    IMCPoint.trigger.SetEnterCallback( IMCPoint_Trigger )
    DispatchSpawn( IMCPoint.trigger )

    IMCPoint.pointfx = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_ar_loot_drop_point" ), IMCPoint.pole.GetOrigin(), <0, 0, 0> )
    IMCPoint.beamfx = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_ar_loot_drop_point_far" ), IMCPoint.pole.GetOrigin(), <0, 0, 0> )

    IMCPoint.teamnum = TEAM_IMC
	
	IMCPoint.pickedup = false
    IMCPoint.flagatbase = true

	SetGlobalNetEnt( "imcFlag", IMCPoint.pole )

    // Point 2
    MILITIAPoint.pole = CreateEntity( "prop_dynamic" )
    MILITIAPoint.pole.SetValueForModelKey( $"mdl/props/wattson_electric_fence/wattson_electric_fence.rmdl" )
    MILITIAPoint.pole.SetOrigin(MILITIAPoint.spawn)
    SetTargetName( MILITIAPoint.pole, "ctf_flag_mil" )
	SetTeam( MILITIAPoint.pole, TEAM_MILITIA )
    DispatchSpawn( MILITIAPoint.pole )

    thread PlayAnim( MILITIAPoint.pole, "prop_fence_expand", MILITIAPoint.pole.GetOrigin(), MILITIAPoint.pole.GetAngles() )
	MILITIAPoint.pole.SetCycle( 1.0 )

    MILITIAPoint.trigger = CreateEntity( "trigger_cylinder" )
    MILITIAPoint.trigger.SetRadius( 35 )
    MILITIAPoint.trigger.SetAboveHeight( 100 ) // Still not quite a sphere, will see if close enough
    MILITIAPoint.trigger.SetBelowHeight( 0 )
    MILITIAPoint.trigger.SetOrigin( MILITIAPoint.spawn )
    MILITIAPoint.trigger.SetEnterCallback( MILITIA_Point_Trigger )
    DispatchSpawn( MILITIAPoint.trigger )

    MILITIAPoint.pointfx = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_ar_loot_drop_point" ), MILITIAPoint.pole.GetOrigin(), <0, 0, 0> )
    MILITIAPoint.beamfx = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_ar_loot_drop_point_far" ), MILITIAPoint.pole.GetOrigin(), <0, 0, 0> )

    // DrawBox( IMCPoint.spawn, <-32,-32,-32>, <32,32,32>, 255, 0, 0, true, 0.2 )

    MILITIAPoint.teamnum = TEAM_IMC

	MILITIAPoint.pickedup = false
    MILITIAPoint.flagatbase = true
	
	SetGlobalNetEnt( "milFlag", MILITIAPoint.pole )
}

void function PlayerPickedUpFlag(entity ent)
{
    if( ent.GetTeam() == TEAM_IMC )
    {
        Highlight_SetEnemyHighlightWithParam0( ent, "bloodhound_sonar", <0,0,1> )
        int AttachID = ent.LookupAttachment( "CHESTFOCUS" )
        IMCPoint.trailfx = StartParticleEffectOnEntity_ReturnEntity( ent, GetParticleSystemIndex( $"P_ar_holopilot_trail" ), FX_PATTACH_ABSORIGIN_FOLLOW, AttachID )

		if( IsValid( IMCPoint.trailfx ) )
		{
			IMCPoint.trailfx.SetOwner( ent )
			IMCPoint.trailfx.kv.VisibilityFlags = ( ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY ) //owner cant see
		}
    }
    else
    {
        Highlight_SetEnemyHighlightWithParam0( ent, "bloodhound_sonar", <1,0,0> )
        int AttachID = ent.LookupAttachment( "CHESTFOCUS" )
        MILITIAPoint.trailfx = StartParticleEffectOnEntity_ReturnEntity( ent, GetParticleSystemIndex( $"P_ar_holopilot_trail" ), FX_PATTACH_ABSORIGIN_FOLLOW, AttachID )

		if( IsValid( MILITIAPoint.trailfx ) )
		{
			MILITIAPoint.trailfx.SetOwner( ent )
			MILITIAPoint.trailfx.kv.VisibilityFlags = ( ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY ) //owner cant see
		}
    }

    StorePilotWeapons( ent )
	TakeWeaponsForFlagCarrier( ent)
    Remote_CallFunction_Replay(ent, "ServerCallback_CTF_PickedUpFlag", ent, true)
    Remote_CallFunction_Replay(ent, "ServerCallback_CTF_CustomMessages", ent, eCTFMessage.PickedUpFlag)
}

void function PlayerDroppedFlag(entity ent)
{
    RetrievePilotWeapons( ent )

	//restore movement
	StatusEffect_StopAllOfType( ent, eStatusEffect.move_slow)
	ent.SetMoveSpeedScale( 1 )

    Remote_CallFunction_Replay(ent, "ServerCallback_CTF_PickedUpFlag", ent, false)

    if( ent.GetTeam() == TEAM_IMC )
    {
        if( IsValid( IMCPoint.trailfx ) )
            IMCPoint.trailfx.Destroy()
    }
    else // TEAM_MILITIA
    {
        if( IsValid( MILITIAPoint.trailfx ) )
            MILITIAPoint.trailfx.Destroy()
    }
}

int function GetCTFEnemyTeam(int team)
{
    int enemyteam
    switch( team )
    {
        case TEAM_IMC:
            enemyteam = TEAM_MILITIA
            break
        case TEAM_MILITIA:
            enemyteam = TEAM_IMC
            break
    }
    return enemyteam
}

void function PickUpFlag(entity ent, int team, CTFPoint teamflagpoint)
{
	printt(" player trying to pickup flag" )
	if( !IsValid( ent ) )
		return
	
	if( team == TEAM_IMC )
		SetGlobalNetEnt( "milFlag", ent )
	else if( team == TEAM_MILITIA )
		SetGlobalNetEnt( "imcFlag", ent )

    int enemyteam = GetCTFEnemyTeam(team)
	
	if( IsValid( teamflagpoint.pole ) )
	{
		teamflagpoint.pole.SetParent(ent)
		teamflagpoint.pole.SetOrigin(ent.GetOrigin())
		teamflagpoint.pole.MakeInvisible()
	}

    teamflagpoint.holdingplayer = ent
    teamflagpoint.pickedup = true
    teamflagpoint.flagatbase = false

    PlayerPickedUpFlag(ent)

    // array<entity> teamplayers = GetPlayerArrayOfTeam( team )
    // foreach ( player in teamplayers )
    // {
        // if( !IsValid( player ) )
            // continue

        // Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetPointIconHint", enemyteam, eCTFFlag.Escort)
    // }

    array<entity> enemyplayers = GetPlayerArrayOfTeam( enemyteam )
    foreach ( player in enemyplayers )
    {
        if( !IsValid( player ) )
            continue

        Remote_CallFunction_Replay(player, "ServerCallback_CTF_CustomMessages", player, eCTFMessage.EnemyPickedUpFlag)
        // Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetPointIconHint", enemyteam, eCTFFlag.Attack)
    }

    EmitSoundToTeamPlayers("UI_CTF_3P_TeamGrabFlag", team)
    EmitSoundToTeamPlayers("UI_CTF_3P_EnemyGrabFlag", enemyteam)

    PlayBattleChatterLineToSpeakerAndTeam( ent, "bc_podLeaderLaunch" )
}

void function CaptureFlag(entity ent, int team, CTFPoint teamflagpoint)
{
	printt(" player trying to capture flag" )
    int enemyteam = GetCTFEnemyTeam(team)

    if( team == TEAM_IMC )
        GameRules_SetTeamScore( TEAM_IMC, GameRules_GetTeamScore( TEAM_IMC ) + 1 )
    else
        GameRules_SetTeamScore( TEAM_MILITIA, GameRules_GetTeamScore( TEAM_MILITIA ) + 1 )

    PlayerDroppedFlag(ent)

    wait 0.2

	if( IsValid( ent ) )
		Remote_CallFunction_NonReplay(ent, "ServerCallback_CTF_UpdatePlayerStats", eCTFStats.Captures)

    foreach(player in GetPlayerArray())
    {
        if( !IsValid( player ) )
            continue

        // Remote_CallFunction_Replay(player, "ServerCallback_CTF_PointCaptured", CTF.IMCPoints, CTF.MILITIAPoints)
    }

    array<entity> teamplayers = GetPlayerArrayOfTeam( team )
    foreach ( player in teamplayers )
    {
        if( !IsValid( player ) )
            continue

        // Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetPointIconHint", enemyteam, eCTFFlag.Capture)
        Remote_CallFunction_Replay(player, "ServerCallback_CTF_FlagCaptured", teamflagpoint.holdingplayer, eCTFMessage.PickedUpFlag)
    }

    array<entity> enemyplayers = GetPlayerArrayOfTeam( enemyteam )
    foreach ( player in enemyplayers )
    {
        if( !IsValid( player ) )
            continue

        // Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetPointIconHint", enemyteam, eCTFFlag.Defend)
        Remote_CallFunction_Replay(player, "ServerCallback_CTF_FlagCaptured", teamflagpoint.holdingplayer, eCTFMessage.EnemyPickedUpFlag)
    }

    teamflagpoint.holdingplayer = null
    teamflagpoint.pickedup = false
    teamflagpoint.dropped = false
    teamflagpoint.flagatbase = true
	if( IsValid( teamflagpoint.pole ) )
	{
		teamflagpoint.pole.ClearParent()
		teamflagpoint.pole.SetOrigin(teamflagpoint.spawn)

		if( team == TEAM_IMC )
			SetGlobalNetEnt( "milFlag", teamflagpoint.pole )
		else if( team == TEAM_MILITIA )
			SetGlobalNetEnt( "imcFlag", teamflagpoint.pole )

		teamflagpoint.pole.MakeVisible()
		thread PlayAnim( teamflagpoint.pole, "prop_fence_expand", teamflagpoint.pole.GetOrigin(), teamflagpoint.pole.GetAngles() )
		teamflagpoint.pole.SetCycle( 1.0 )
	}

    EmitSoundToTeamPlayers("ui_ctf_enemy_score", enemyteam)
    EmitSoundToTeamPlayers("ui_ctf_team_score", team)
    

    if( GameRules_GetTeamScore( TEAM_IMC ) >= CTF_SCORE_GOAL_TO_WIN || GameRules_GetTeamScore( TEAM_MILITIA ) >= CTF_SCORE_GOAL_TO_WIN)
    {
        foreach( entity player in GetPlayerArray() )
        {
            if( !IsValid( player ) )
                continue

            thread EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_winnerFound" )
        }
        file.ctfState = eCTFState.WINNER_DECIDED
		SetGlobalNetInt( "FSDM_GameState", file.ctfState )
    }
}

void function IMCPoint_Trigger( entity trigger, entity ent )
{
	printt( "player entered imc point trigger: ", ent, IMCPoint.pickedup, MILITIAPoint.pickedup )
    if(!IsValid(ent) || file.ctfState != eCTFState.IN_PROGRESS )
        return

    if ( ent.IsPlayer() )
    {
        if ( ent.GetTeam() != TEAM_IMC )
        {
            if ( !IMCPoint.pickedup )
            {
                thread PickUpFlag(ent, TEAM_MILITIA, IMCPoint)
            }
        }

        if ( MILITIAPoint.pickedup )
        {
            if( MILITIAPoint.holdingplayer == ent )
            {
                if ( IMCPoint.flagatbase )
                {
                    thread CaptureFlag(ent, TEAM_IMC, MILITIAPoint)
                }
            }
        }
    }
}

void function MILITIA_Point_Trigger( entity trigger, entity ent )
{
	printt( "player entered militia point trigger: ", ent, IMCPoint.pickedup, MILITIAPoint.pickedup )
    if(!IsValid(ent) || file.ctfState != eCTFState.IN_PROGRESS )
        return
        
    if( ent.IsPlayer() )
    {
        if( ent.GetTeam() != TEAM_MILITIA )
        {
            if (!MILITIAPoint.pickedup)
            {
                thread PickUpFlag(ent, TEAM_IMC, MILITIAPoint)
            }
        }

        if( IMCPoint.pickedup )
        {
            if( IMCPoint.holdingplayer == ent )
            {
                if (MILITIAPoint.flagatbase)
                {
                    thread CaptureFlag(ent, TEAM_MILITIA, IMCPoint)
                }
            }
        }
    }
}

// purpose: Take weapons from player and give ctf flag melee
void function TakeWeaponsForFlagCarrier(entity player)
{
    if( !IsValid( player ) )
        return

    TakeAllWeapons(player)
	
	//ball carrier can't run
	StatusEffect_AddEndless(player, eStatusEffect.move_slow, 0.1)
	player.SetMoveSpeedScale( 1.11 )

    player.GiveWeapon( "mp_weapon_flagpole_primary", WEAPON_INVENTORY_SLOT_PRIMARY_2 )
    player.GiveOffhandWeapon( "melee_flagpole", OFFHAND_MELEE )
    player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_2)
}

// purpose: Give player their weapons back
void function GiveBackWeapons(entity player)
{
    if( !IsValid( player ) )
        return

    // Needs to check and set legend change before taking weapons
    Remote_CallFunction_NonReplay(player, "ServerCallback_CTF_CheckUpdatePlayerLegend")

	TakeAllWeapons(player)
	
    wait 0.5

    //Needed another check after the wait just incase they leave within that wait time
    if( !IsValid( player ) ) // || file.ctfState != eCTFState.IN_PROGRESS )
        return
	
	TakeAllWeapons(player)

	if( GetCurrentPlaylistVarBool( "is_halo_gamemode", false ) )
	{
		GiveRandomPrimaryWeaponHalo(player)
		GiveRandomSecondaryWeaponHalo(player)
	} else 
	{
		entity primary = player.GiveWeapon(file.ctfclasses[player.p.CTFClassID].primary, WEAPON_INVENTORY_SLOT_PRIMARY_0, file.ctfclasses[player.p.CTFClassID].primaryattachments)
		SetupInfiniteAmmoForWeapon( player, primary )

		entity secondary = player.GiveWeapon(file.ctfclasses[player.p.CTFClassID].secondary, WEAPON_INVENTORY_SLOT_PRIMARY_1, file.ctfclasses[player.p.CTFClassID].secondaryattachments)
		SetupInfiniteAmmoForWeapon( player, secondary )
	}

	if( GetCurrentPlaylistVarBool( "is_halo_gamemode", false ) )
	{
		player.GiveOffhandWeapon( "mp_ability_grapple_master_chief", OFFHAND_TACTICAL )
		player.GiveOffhandWeapon( "mp_weapon_bubble_bunker_master_chief", OFFHAND_ULTIMATE )
	}
	else
	{
		if( !USE_LEGEND_ABILITYS )
		{
			player.GiveOffhandWeapon( file.ctfclasses[player.p.CTFClassID].tactical, OFFHAND_TACTICAL )
			player.GiveOffhandWeapon( file.ctfclasses[player.p.CTFClassID].ult, OFFHAND_ULTIMATE )
		}
		else
		{
			ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
			ItemFlavor ultiamteAbility = CharacterClass_GetUltimateAbility( character )
			ItemFlavor tacticalAbility = CharacterClass_GetTacticalAbility( character )
			player.GiveOffhandWeapon(CharacterAbility_GetWeaponClassname(tacticalAbility), OFFHAND_TACTICAL, [] )
			player.GiveOffhandWeapon( CharacterAbility_GetWeaponClassname( ultiamteAbility ), OFFHAND_ULTIMATE, [] )
		}
	}

    player.TakeOffhandWeapon(OFFHAND_MELEE)
    player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
    player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )
    player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)

	//give flowstate holo sprays
	player.TakeOffhandWeapon( OFFHAND_EQUIPMENT )
	player.GiveOffhandWeapon( "mp_ability_emote_projector", OFFHAND_EQUIPMENT )

	//restore movement
	StatusEffect_StopAllOfType( player, eStatusEffect.move_slow)
	player.SetMoveSpeedScale( 1 )
}

// purpose: OnPlayerConnected Callback
void function _OnPlayerConnected(entity player)
{
    if( !IsValid( player ) )
        return

    Remote_CallFunction_NonReplay(player, "ServerCallback_CTF_SetObjectiveText", CTF_SCORE_GOAL_TO_WIN)

    // why gen
    int SavedPlayerClass = player.GetPersistentVarAsInt( "gen" )
    if (SavedPlayerClass > NUMBER_OF_CLASS_SLOTS || SavedPlayerClass < 0)
        SavedPlayerClass = 0

    player.p.CTFClassID = SavedPlayerClass

	thread Flowstate_InitAFKThreadForPlayer(player)
	
    switch ( GetGameState() )
    {
    case eGameState.WaitingForPlayers:
        player.FreezeControlsOnServer()
        Remote_CallFunction_NonReplay(player, "ServerCallback_CTF_DoAnnouncement", 2, eCTFAnnounce.VOTING_PHASE, CTF.roundstarttime)
        break
    case eGameState.Playing:

		if( !IsAlive(player) )
			_HandleRespawn(player)
		
        player.UnfreezeControlsOnServer();
        Remote_CallFunction_NonReplay(player, "ServerCallback_CTF_DoAnnouncement", 5, eCTFAnnounce.ROUND_START, CTF.roundstarttime)
        Remote_CallFunction_NonReplay(player, "ServerCallback_CTF_SetSelectedLocation", CTF.mappicked)
        break
    default:
        break
    }
}

// purpose: OnPlayerDisconnected Callback
void function _OnPlayerDisconnected(entity player)
{
    // Only if the flag is picked up
    if ( IMCPoint.pickedup )
    {
        if( IMCPoint.holdingplayer == player )
        {
            ResetFlagOnDisconnect(0)
        }
    }

    // Only if the flag is picked up
    if ( MILITIAPoint.pickedup )
    {
        if( MILITIAPoint.holdingplayer == player )
        {
            ResetFlagOnDisconnect(1)
        }
    }
}

void function ResetFlagOnDisconnect(int num)
{
    if(num == 0)
    {
        if( IsValid( IMCPoint.pole ) )
            IMCPoint.pole.Destroy()

        if( IsValid( IMCPoint.trailfx ) )
            IMCPoint.trailfx.Destroy()

        // Point 1
        IMCPoint.pole = CreateEntity( "prop_dynamic" )
        IMCPoint.pole.SetValueForModelKey( $"mdl/props/wattson_electric_fence/wattson_electric_fence.rmdl" )
        IMCPoint.pole.SetOrigin(IMCPoint.spawn)
		SetTeam( IMCPoint.pole, TEAM_IMC )
        DispatchSpawn( IMCPoint.pole )

        thread PlayAnim( IMCPoint.pole, "prop_fence_expand", IMCPoint.pole.GetOrigin(), IMCPoint.pole.GetAngles() )

        IMCPoint.pickedup = false
        IMCPoint.dropped = false
        IMCPoint.flagatbase = true
		
		SetGlobalNetEnt( "imcFlag", IMCPoint.pole )
    }
    else if(num == 1)
    {
        if( IsValid( MILITIAPoint.pole ) )
            MILITIAPoint.pole.Destroy()

        if( IsValid( MILITIAPoint.trailfx ) )
            MILITIAPoint.trailfx.Destroy()

        MILITIAPoint.pole = CreateEntity( "prop_dynamic" )
        MILITIAPoint.pole.SetValueForModelKey( $"mdl/props/wattson_electric_fence/wattson_electric_fence.rmdl" )
        MILITIAPoint.pole.SetOrigin(MILITIAPoint.spawn)
		SetTeam( MILITIAPoint.pole, TEAM_MILITIA )
        DispatchSpawn( MILITIAPoint.pole )
		
        thread PlayAnim( MILITIAPoint.pole, "prop_fence_expand", MILITIAPoint.pole.GetOrigin(), MILITIAPoint.pole.GetAngles() )

        MILITIAPoint.pickedup = false
        MILITIAPoint.dropped = false
        MILITIAPoint.flagatbase = true
		
		SetGlobalNetEnt( "milFlag", MILITIAPoint.pole )
    }
}

void function MILITIA_PoleReturn_Trigger( entity trigger, entity ent )
{
	printt( "player entered return trigger: ", ent )
    if(!IsValid(ent) || file.ctfState != eCTFState.IN_PROGRESS )
        return

    if ( ent.IsPlayer() )
    {
        // If is on team IMC pick back up
        if ( ent.GetTeam() == TEAM_IMC )
        {
            if(IsValid(MILITIAPoint.returntrigger))
                MILITIAPoint.returntrigger.Destroy()

            MILITIAPoint.pole.SetParent(ent)
            MILITIAPoint.pole.SetOrigin(ent.GetOrigin())
            MILITIAPoint.pole.MakeInvisible()

			SetGlobalNetEnt( "milFlag", ent )

            PlayerPickedUpFlag(ent)

            MILITIAPoint.holdingplayer = ent
            MILITIAPoint.pickedup = true
            MILITIAPoint.dropped = false

            array<entity> teamplayers = GetPlayerArrayOfTeam( TEAM_IMC )
            foreach ( player in teamplayers )
            {
                if( !IsValid( player ) )
                    continue

                Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetPointIconHint", TEAM_MILITIA, eCTFFlag.Escort)
            }

            array<entity> enemyplayers = GetPlayerArrayOfTeam( TEAM_MILITIA )
            foreach ( player in enemyplayers )
            {
                if( !IsValid( player ) )
                    continue

                Remote_CallFunction_Replay(player, "ServerCallback_CTF_CustomMessages", player, eCTFMessage.EnemyPickedUpFlag)
                Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetPointIconHint", TEAM_MILITIA, eCTFFlag.Attack)
            }

            EmitSoundToTeamPlayers("UI_CTF_3P_TeamGrabFlag", TEAM_IMC)
            EmitSoundToTeamPlayers("UI_CTF_3P_EnemyGrabFlag", TEAM_MILITIA)
        }

        // If is on team MIL start return countdown
        if ( ent.GetTeam() == TEAM_MILITIA )
        {
            if( !IMCPoint.isbeingreturned )
            {
                MILITIAPoint.isbeingreturned = true
                MILITIAPoint.beingreturnedby = ent
                thread StartFlagReturn(ent, TEAM_MILITIA, MILITIAPoint)
            }
        }
    }
}

void function IMC_PoleReturn_Trigger( entity trigger, entity ent)
{	
	printt( "player entered return trigger: ", ent )
    if(!IsValid(ent) || file.ctfState != eCTFState.IN_PROGRESS )
        return

    if ( ent.IsPlayer() )
    {
        // If is on team MILITIA pick back up
        if ( ent.GetTeam() == TEAM_MILITIA )
        {
            if(IsValid(IMCPoint.returntrigger))
                IMCPoint.returntrigger.Destroy()

            IMCPoint.pole.SetParent(ent)
            IMCPoint.pole.SetOrigin(ent.GetOrigin())
            IMCPoint.pole.MakeInvisible()

			SetGlobalNetEnt( "imcFlag", ent )

            PlayerPickedUpFlag(ent)

            IMCPoint.holdingplayer = ent
            IMCPoint.pickedup = true
            IMCPoint.dropped = false

            // array<entity> teamplayers = GetPlayerArrayOfTeam( TEAM_MILITIA )
            // foreach ( player in teamplayers )
            // {
                // if( !IsValid( player ) )
                    // continue

                // Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetPointIconHint", TEAM_IMC, eCTFFlag.Escort)
            // }

            array<entity> enemyplayers = GetPlayerArrayOfTeam( TEAM_IMC )
            foreach ( player in enemyplayers )
            {
                if( !IsValid( player ) )
                    continue

                Remote_CallFunction_Replay(player, "ServerCallback_CTF_CustomMessages", player, eCTFMessage.EnemyPickedUpFlag)
                // Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetPointIconHint", TEAM_IMC, eCTFFlag.Attack)
            }

            EmitSoundToTeamPlayers("UI_CTF_3P_TeamGrabFlag", TEAM_MILITIA)
            EmitSoundToTeamPlayers("UI_CTF_3P_EnemyGrabFlag", TEAM_IMC)
        }

        // If is on team IMC start return countdown
        if ( ent.GetTeam() == TEAM_IMC )
        {
            if( !IMCPoint.isbeingreturned )
            {
                IMCPoint.isbeingreturned = true
                IMCPoint.beingreturnedby = ent
                thread StartFlagReturn(ent, TEAM_IMC, IMCPoint)
            }
        }
    }
}

void function StartFlagReturn(entity player, int team, CTFPoint teamflagpoint)
{
    int enemyteam = GetCTFEnemyTeam(team)

    bool returnsuccess = false
    bool playerpickedupflag = false
    bool playerleftarea = false

    float starttime = Time()
    float endtime = Time() + 5
    Remote_CallFunction_Replay(player, "ServerCallback_CTF_RecaptureFlag", team, starttime, endtime, true)

    try
    {
        while( IsValid( player ) && IsValid( teamflagpoint.pole ) && Distance( player.GetOrigin(), teamflagpoint.pole.GetOrigin() ) < 150 && IsAlive( player ) && returnsuccess == false || playerpickedupflag || playerleftarea )
        {
            if( Time() >= endtime )
            {
                returnsuccess = true
                teamflagpoint.isbeingreturned = false
            }

            if( !teamflagpoint.dropped )
                playerpickedupflag = true

            if( Distance( player.GetOrigin(), teamflagpoint.pole.GetOrigin() ) > 150 )
                playerleftarea = true

            wait 0.01
        }
    } catch(e42) {
        playerleftarea = true
    }

    if( playerpickedupflag )
    {
        teamflagpoint.isbeingreturned = false
        teamflagpoint.beingreturnedby = null

        if(IsValid(player))
            Remote_CallFunction_Replay(player, "ServerCallback_CTF_RecaptureFlag", 0, 0, 0, false)

        if(IsValid(teamflagpoint.returntrigger))
            teamflagpoint.returntrigger.Destroy()

        return
    }

    if( playerleftarea )
    {
        teamflagpoint.isbeingreturned = false
        teamflagpoint.beingreturnedby = null

        if(IsValid(player))
            Remote_CallFunction_Replay(player, "ServerCallback_CTF_RecaptureFlag", 0, 0, 0, false)

        try { teamflagpoint.returntrigger.SearchForNewTouchingEntity() } catch(stop) {}
        return
    }

    if( returnsuccess )
    {
        if( IsValid( teamflagpoint.pole ) )
            teamflagpoint.pole.ClearParent()

        teamflagpoint.dropped = false
        teamflagpoint.holdingplayer = null
        teamflagpoint.pickedup = false
        teamflagpoint.flagatbase = true

        if(IsValid(teamflagpoint.pole))
            teamflagpoint.pole.SetOrigin(teamflagpoint.spawn)

        if(IsValid(teamflagpoint.returntrigger))
            teamflagpoint.returntrigger.Destroy()

        if(IsValid(teamflagpoint.pole))
		{
            thread PlayAnim( teamflagpoint.pole, "prop_fence_expand", teamflagpoint.pole.GetOrigin(), teamflagpoint.pole.GetAngles() )
			teamflagpoint.pole.SetCycle( 1.0 )
		}

        try { teamflagpoint.returntrigger.SearchForNewTouchingEntity() } catch(stop) {}

        array<entity> enemyplayers = GetPlayerArrayOfTeam( enemyteam )
        foreach ( players in enemyplayers )
        {
            if( !IsValid( players ) )
                continue

            Remote_CallFunction_Replay(players, "ServerCallback_CTF_SetPointIconHint", team, eCTFFlag.Capture)
        }

        array<entity> teamplayers = GetPlayerArrayOfTeam( team )
        foreach ( players in teamplayers )
        {
            if( !IsValid( players ) )
                continue

            Remote_CallFunction_Replay(players, "ServerCallback_CTF_CustomMessages", players, eCTFMessage.TeamReturnedFlag)
            Remote_CallFunction_Replay(players, "ServerCallback_CTF_SetPointIconHint", team, eCTFFlag.Defend)
        }
    }
    else
    {
        teamflagpoint.isbeingreturned = false
        teamflagpoint.beingreturnedby = null

        if( IsValid( player ) )
            Remote_CallFunction_Replay(player, "ServerCallback_CTF_RecaptureFlag", 0, 0, 0, false)

        try { teamflagpoint.returntrigger.SearchForNewTouchingEntity() } catch(stop) {}
    }
}

void function PlayerDiedWithFlag(entity victim, int team, CTFPoint teamflagpoint)
{
	printt("player died with flag!" )
    int enemyteam = GetCTFEnemyTeam(team)
	
	if( IsValid( teamflagpoint.pole ) )
		teamflagpoint.pole.ClearParent()
    bool foundSafeSpot = false

    PlayerDroppedFlag(victim)

    // Clear parent and set the flag to current death location
    teamflagpoint.holdingplayer = null
	if( IsValid( teamflagpoint.pole ) )
	{
		teamflagpoint.pole.MakeVisible()
		teamflagpoint.pole.SetOrigin( OriginToGroundCTF( teamflagpoint.pole.GetOrigin() ) )

		if( team == TEAM_MILITIA )
			SetGlobalNetEnt( "milFlag", teamflagpoint.pole )
		else if( team == TEAM_IMC )
			SetGlobalNetEnt( "imcFlag", teamflagpoint.pole )
	}

    array<entity> enemyplayers = GetPlayerArrayOfTeam( enemyteam )
    foreach ( player in enemyplayers )
    {
        if( !IsValid( player ) )
            continue

        Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetPointIconHint", team, eCTFFlag.Capture)
    }

    array<entity> teamplayers = GetPlayerArrayOfTeam( team )
    foreach ( player in teamplayers )
    {
        Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetPointIconHint", team, eCTFFlag.Return)
    }
	
	if( IsValid( teamflagpoint.pole ) )
	{
		// Check for if the flag ends up under the map
		if( GetMapName() == "mp_flowstate" && teamflagpoint.pole.GetOrigin().z > file.selectedLocation.undermap )
		{
			foundSafeSpot = true

			vector endOrigin = teamflagpoint.pole.GetOrigin() - < 0, 0, 200 >
			TraceResults traceResult = TraceLine( teamflagpoint.pole.GetOrigin(), endOrigin, [], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )
			
			if( traceResult.fraction == 1.0 )
			{
				foundSafeSpot = false
				teamflagpoint.flagatbase = true
				teamflagpoint.pole.SetOrigin( teamflagpoint.spawn )
			}
			
		}
		else if( teamflagpoint.pole.GetOrigin().z > file.selectedLocation.undermap )
		{
			if( Distance( teamflagpoint.pole.GetOrigin(), CTF.ringCenter ) > CTF.ringRadius )
			{
				teamflagpoint.flagatbase = true
				teamflagpoint.pole.SetOrigin( teamflagpoint.spawn )
			}
			else
			{
				foundSafeSpot = true
			}
		}
		else
		{
			teamflagpoint.flagatbase = true
			teamflagpoint.pole.SetOrigin( teamflagpoint.spawn )
		}

		// Play expand anim
		thread PlayAnim( teamflagpoint.pole, "prop_fence_expand", teamflagpoint.pole.GetOrigin(), teamflagpoint.pole.GetAngles() )
		teamflagpoint.pole.SetCycle( 1.0 )
	}
    wait 1.2
	
	if( file.ctfState != eCTFState.IN_PROGRESS )
		return

    teamflagpoint.pickedup = false
    teamflagpoint.dropped = true

    if ( foundSafeSpot )
    {
        // Create the recapture trigger
        teamflagpoint.returntrigger = CreateEntity( "trigger_cylinder" )
        teamflagpoint.returntrigger.SetRadius( 35 )
        teamflagpoint.returntrigger.SetAboveHeight( 200 )
        teamflagpoint.returntrigger.SetBelowHeight( 200 )
		if( IsValid( teamflagpoint.pole ) )
			teamflagpoint.returntrigger.SetOrigin( teamflagpoint.pole.GetOrigin() )

        if( team == TEAM_IMC )
            teamflagpoint.returntrigger.SetEnterCallback( IMC_PoleReturn_Trigger )
        else
            teamflagpoint.returntrigger.SetEnterCallback( MILITIA_PoleReturn_Trigger )

        DispatchSpawn( teamflagpoint.returntrigger )
    }
}

void function CheckPlayerForFlag(entity victim)
{
    // Only if the flag is picked up
    if ( IMCPoint.pickedup )
    {
        // Only if the flag is held by said player
        if( IMCPoint.holdingplayer == victim )
        {
            thread PlayerDiedWithFlag(victim, TEAM_IMC, IMCPoint)
        }
    }

    // Only if the flag is picked up
    if ( MILITIAPoint.pickedup )
    {
        // Only if the flag is held by said player
        if( MILITIAPoint.holdingplayer == victim )
        {
            thread PlayerDiedWithFlag(victim, TEAM_MILITIA, MILITIAPoint)
        }
    }
}

// Purpose: OnPlayerDied Callback
void function _OnPlayerDied(entity victim, entity attacker, var damageInfo)
{
    // If player is holding the flag on death try to drop flag at current loaction
    CheckPlayerForFlag(victim)

    switch(GetGameState())
    {
    case eGameState.Playing:

        // What happens to victim
        void functionref() victimHandleFunc = void function() : (victim, attacker, damageInfo) {
			
            if( !IsValid( victim ) )
                return
			
			if( GetCurrentPlaylistVarBool( "is_halo_gamemode", false ) )
			{
				Remote_CallFunction_NonReplay( victim, "ForceScoreboardLoseFocus" )
				Remote_CallFunction_NonReplay( victim, "FS_ForceDestroyCustomAdsOverlay" )
			}

            if (!CTF.votingtime)
            {
				if( !GetCurrentPlaylistVarBool( "is_halo_gamemode", false ) )
				{
					Remote_CallFunction_NonReplay(victim, "ServerCallback_CTF_HideCustomUI")

					wait 4 // so we dont go straight to respawn menu

					if( !IsValid( victim ) )
						return

					// Open respawn menu
					Remote_CallFunction_NonReplay(victim, "ServerCallback_CTF_OpenCTFRespawnMenu", CTF.ringCenter, GameRules_GetTeamScore( TEAM_IMC ), GameRules_GetTeamScore( TEAM_MILITIA ), attacker, victim.p.CTFClassID)
				}
                // Wait Respawn Timer
                wait CTF_RESPAWN_TIMER

                // Respawn Player
                if (IsValid(victim) && !CTF.votingtime)
                {
                    _HandleRespawn( victim )
                }
            }
        }

        // What happens to attacker
        void functionref() attackerHandleFunc = void function() : (victim, attacker, damageInfo)  {
            if(IsValid(attacker) && attacker.IsPlayer() && IsAlive(attacker) && attacker != victim)
            {
                Remote_CallFunction_NonReplay(attacker, "ServerCallback_CTF_UpdatePlayerStats", eCTFStats.Kills)
                attacker.SetPlayerNetInt( "kills", attacker.GetPlayerNetInt( "kills" ) + 1 )

                if(attacker != IMCPoint.holdingplayer && attacker != MILITIAPoint.holdingplayer)
                    PlayerRestoreHP(attacker, 100, CTF_Equipment_GetDefaultShieldHP())
            }
        }

        thread victimHandleFunc()
        thread attackerHandleFunc()
        break
    default:

    }
}

// Purpose: Handle Player Respawn
void function _HandleRespawn(entity player, bool forceGive = false)
{
    if( !IsValid( player ) )
        return

    if( player.IsObserver() )
    {
        player.StopObserverMode()
        Remote_CallFunction_NonReplay(player, "ServerCallback_KillReplayHud_Deactivate")
    }

    if( !IsAlive( player ) || forceGive )
    {
        DecideRespawnPlayer(player, true)

        thread GiveBackWeapons(player)
    }

	if( GetCurrentPlaylistVarBool( "is_halo_gamemode", false ) && !player.GetPlayerNetBool( "hasLockedInCharacter" ) )
	{
		CharSelect(player)
		player.SetPlayerNetBool( "hasLockedInCharacter", true )
	}

    // SetPlayerSettings(player, CTF_PLAYER_SETTINGS)
    PlayerRestoreHP(player, 100, CTF_Equipment_GetDefaultShieldHP())

    TpPlayerToSpawnPoint(player)
    thread Flowstate_GrantSpawnImmunity(player, 2.5)

    player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
	Survival_SetInventoryEnabled( player, false )

    // Give passive regen (pilot blood)
    GivePassive(player, ePassives.PAS_PILOT_BLOOD)
}

// Purpose: Create The RingBoundary
entity function CreateRingBoundary(LocationSettingsCTF location)
{
    array<LocPairCTF> spawns = location.ringspots

    vector bubbleCenter
    foreach(spawn in spawns)
    {
        bubbleCenter += spawn.origin
    }

    bubbleCenter /= spawns.len()

    float bubbleRadius = 0

    foreach(LocPairCTF spawn in spawns)
    {
        if(Distance(spawn.origin, bubbleCenter) > bubbleRadius)
        bubbleRadius = Distance(spawn.origin, bubbleCenter)
    }

    bubbleRadius += GetCurrentPlaylistVarFloat("ring_radius_padding", 800)

    CTF.ringCenter = bubbleCenter
    CTF.ringRadius = bubbleRadius

    entity bubbleShield = CreateEntity( "prop_dynamic" )
    bubbleShield.SetValueForModelKey( BUBBLE_BUNKER_SHIELD_COLLISION_MODEL )
    bubbleShield.SetOrigin(bubbleCenter)
    bubbleShield.SetModelScale(bubbleRadius / 235)
    bubbleShield.kv.CollisionGroup = 0
    bubbleShield.kv.rendercolor = "127 73 37"
    DispatchSpawn( bubbleShield )

    thread MonitorBubbleBoundary(bubbleShield, bubbleCenter, bubbleRadius)

    return bubbleShield
}

void function MonitorBubbleBoundary(entity bubbleShield, vector bubbleCenter, float bubbleRadius)
{
    while(IsValid(bubbleShield))
    {
        foreach(player in GetPlayerArray_Alive())
        {
            if(!IsValid(player)) continue
            if(Distance(player.GetOrigin(), bubbleCenter) > bubbleRadius)
            {
                Remote_CallFunction_Replay( player, "ServerCallback_PlayerTookDamage", 0, 0, 0, 0, DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, eDamageSourceId.deathField, null )
                player.TakeDamage( int( Deathmatch_GetOOBDamagePercent() / 100 * float( player.GetMaxHealth() ) ), null, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )
            }
        }
        wait 1
    }
}

void function PlayerRestoreHP(entity player, float health, float shields)
{
    if( !IsValid( player ) )
        return

    player.SetHealth( health )
    Inventory_SetPlayerEquipment(player, "helmet_pickup_lv4_abilities", "helmet")

    if(shields == 0) return;
    else if(shields <= 50)
        Inventory_SetPlayerEquipment(player, "armor_pickup_lv1", "armor")
    else if(shields <= 75)
        Inventory_SetPlayerEquipment(player, "armor_pickup_lv2", "armor")
    else if(shields <= 100)
        Inventory_SetPlayerEquipment(player, "armor_pickup_lv3", "armor")
    
    player.SetShieldHealth( shields )
}

void function TpPlayerToSpawnPoint(entity player)
{
    if( !IsValid( player ) )
        return

    switch( GetGameState() )
    {
    case eGameState.WaitingForPlayers:
        break
    case eGameState.Playing:
        int ri = RandomIntRange( 0, 4 )

        switch (player.GetTeam())
        {
        case TEAM_IMC:
            player.SetOrigin(file.selectedLocation.imcspawns[ri].origin)
            player.SetAngles(file.selectedLocation.imcspawns[ri].angles)
            break
        case TEAM_MILITIA:
            player.SetOrigin(file.selectedLocation.milspawns[ri].origin)
            player.SetAngles(file.selectedLocation.milspawns[ri].angles)
            break
        }

        break
    default:
        break
    }

    PutEntityInSafeSpot( player, null, null, player.GetOrigin() + <0,0,128>, player.GetOrigin() )
}

vector function OriginToGroundCTF( vector origin )
{
	vector endOrigin = origin - < 0, 0, 200 >
	TraceResults traceResult = TraceLine( origin, endOrigin, [], TRACE_MASK_SOLID, TRACE_COLLISION_GROUP_NONE )

	return traceResult.endPos
}