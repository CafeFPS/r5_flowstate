// Credits
// AyeZee#6969 -- ctf gamemode and ui
// Rexx and IcePixelx -- Help with code improvments
// sal#3261 -- base custom_tdm mode to work off
// CaféDeColombiaFPS -- ctf sounds, custom ring implementation
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

    AddCallback_OnClientConnected( void function(entity player) { thread _OnPlayerConnected(player) } )
    AddCallback_OnClientDisconnected( void function(entity player) { thread _OnPlayerDisconnected(player) } )
    AddCallback_OnPlayerKilled(void function(entity victim, entity attacker, var damageInfo) {thread _OnPlayerDied(victim, attacker, damageInfo)})

    AddClientCommandCallback("next_round", ClientCommand_NextRound)

    // Used for sending votes from client to server
    AddClientCommandCallback("VoteForMap", ClientCommand_VoteForMap)
    // Used for setting players class
    AddClientCommandCallback("SetPlayerClass", ClientCommand_SetPlayerClass)
    // Used for sync remaining time on resolution change
    AddClientCommandCallback("GetTimeFromServer", ClientCommand_GetCorrectTimeFromServer)
    // Used for telling the server the player wants to drop the flag
    AddClientCommandCallback("DropFlag", ClientCommand_DropFlag)
    // All chat via console
    if(GLOBAL_CHAT_ENABLED)
        AddClientCommandCallback("say", ClientCommand_Say)

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

bool function ClientCommand_Say(entity player, array<string> args)
{
    if( !IsValid( player ) )
        return false
    
    string sendMessage

    foreach(arg in args)
    {
        sendMessage += " " + arg
    }

    string team;
    if(player.GetTeam() == TEAM_IMC)
        team = "IMC"
    else
        team = "MIL"

    sendMessage = team + " >> " + player.GetPlayerName() + ": " + sendMessage

    foreach( p in GetPlayerArray() )
    {
        if( !IsValid( p ) )
            continue

        for ( int i = 0; i < sendMessage.len(); i++ )
        {
            Remote_CallFunction_NonReplay( p, "ServerCallback_CTF_BuildClientMessage", sendMessage[i] )
        }

        Remote_CallFunction_NonReplay( p, "ServerCallback_CTF_PrintClientMessage" )
    }

    return true
}

bool function ClientCommand_GetCorrectTimeFromServer(entity player, array<string> args)
{
    if( !IsValid( player ) )
        return false

    Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetCorrectTime", ServerTimer.seconds)
    return true
}

bool function ClientCommand_NextRound(entity player, array<string> args)
{
    file.ctfState = eCTFState.WINNER_DECIDED
    return true
}

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

void function RUNCTF()
{
    WaitForGameState(eGameState.Playing)

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
    CTF.MILITIAPoints = 0
    CTF.IMCPoints = 0
    
    // Reset score RUI
    foreach( player in GetPlayerArray() )
    {
        if( !IsValid( player ) )
            continue

        // Reset client rui score
        Remote_CallFunction_Replay(player, "ServerCallback_CTF_PointCaptured", CTF.IMCPoints, CTF.MILITIAPoints)

        // Reset Player Stats
        Remote_CallFunction_NonReplay(player, "ServerCallback_CTF_UpdatePlayerStats", eCTFStats.Clear)
    }

    // Voting phase so disable weapons and make invincible
    foreach( player in GetPlayerArray() )
    {
        if( !IsValid( player ) )
            continue

        MakeInvincible(player)
        HolsterAndDisableWeapons( player )
        player.ForceStand()
        TpPlayerToSpawnPoint(player)
        player.UnfreezeControlsOnServer();
        player.SetPlayerNetInt("kills", 0) // Reset for kills
        player.SetPlayerNetInt("assists", 0) // Reset for deaths
    }

    file.selectedLocation = file.locationSettings[CTF.mappicked]

    // Set the next location client side for each player
    foreach( player in GetPlayerArray() )
    {
        if( !IsValid( player ) )
            continue

        Remote_CallFunction_NonReplay(player, "ServerCallback_CTF_SetSelectedLocation", CTF.mappicked)
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

    foreach(player in GetPlayerArray())
    {
        if( !IsValid( player ) )
            continue

        if( !IsAlive( player ) )
            _HandleRespawn(player)

        Remote_CallFunction_NonReplay(player, "ServerCallback_CTF_DoAnnouncement", 5, eCTFAnnounce.ROUND_START, CTF.roundstarttime)
        Remote_CallFunction_NonReplay(player, "ServerCallback_CTF_SetObjectiveText", CTF_SCORE_GOAL_TO_WIN)
        Remote_CallFunction_Replay(player, "ServerCallback_CTF_TeamText", player.GetTeam())
        ClearInvincible(player)
        DeployAndEnableWeapons(player)
        player.UnforceStand()
        player.UnfreezeControlsOnServer()
        TpPlayerToSpawnPoint(player)
        GiveBackWeapons(player)
    }

    //EffectSetControlPointVector( CTF.ringfx, 1, <CTF.ringRadius, 0, 0> )

    float endTime = Time() + CTF_ROUNDTIME
    while( Time() <= endTime )
    {
        if( Time() > endTime - 1 )
            file.ctfState = eCTFState.WINNER_DECIDED

        if( file.ctfState == eCTFState.WINNER_DECIDED )
        {
            ServerTimer.roundover = true

            // for each player, if the player is holding the flag on round end. make them drop it so it dosnt cause a crash
            foreach(player in GetPlayerArray())
            {
                if( !IsValid( player ) )
                    continue

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

            // remove trail fx from players
            if( IsValid( IMCPoint.trailfx ) )
                IMCPoint.trailfx.Destroy()

            if( IsValid( MILITIAPoint.trailfx ) )
                MILITIAPoint.trailfx.Destroy()

            // Destroy old flags, triggers, and fx
            IMCPoint.pole.Destroy()
            IMCPoint.trigger.Destroy()
            IMCPoint.pointfx.Destroy()
            IMCPoint.beamfx.Destroy()
            MILITIAPoint.pole.Destroy()
            MILITIAPoint.trigger.Destroy()
            MILITIAPoint.pointfx.Destroy()
            MILITIAPoint.beamfx.Destroy()

            int TeamWon = 69;

            // Destory ring
            file.ringBoundary.Destroy()

            // See what team has more points to decide on the winner
            if (CTF.IMCPoints > CTF.MILITIAPoints)
                TeamWon = TEAM_IMC
            else if (CTF.MILITIAPoints > CTF.IMCPoints)
                TeamWon = TEAM_MILITIA

            foreach( player in GetPlayerArray() )
            {
                if( !IsValid( player ) )
                    continue

                // if player is dead, respawn
                if( !IsAlive( player ) )
                    _HandleRespawn(player)

                // round is over so make the player invinvible
                MakeInvincible(player)
            }

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
                wait 5

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

    file.ctfState = eCTFState.IN_PROGRESS

    // Reset flag icons for each player
    foreach( player in GetPlayerArray() )
    {
        if( !IsValid( player ) )
            continue

        ClearInvincible(player)
        Remote_CallFunction_Replay(player, "ServerCallback_CTF_ResetFlagIcons")
    }
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

void function SpawnCTFPoints()
{
    // Get ground pos below spawn points
    IMCPoint.spawn = OriginToGround( file.selectedLocation.imcflagspawn )
    MILITIAPoint.spawn = OriginToGround( file.selectedLocation.milflagspawn )

    // Point 1
    IMCPoint.pole = CreateEntity( "prop_dynamic" )
    IMCPoint.pole.SetValueForModelKey( $"mdl/props/wattson_electric_fence/wattson_electric_fence.rmdl" )
    IMCPoint.pole.SetOrigin(IMCPoint.spawn)
    SetTargetName( IMCPoint.pole, "ctf_flag_imc" )
    DispatchSpawn( IMCPoint.pole )

    thread PlayAnim( IMCPoint.pole, "prop_fence_expand", IMCPoint.pole.GetOrigin(), IMCPoint.pole.GetAngles() )

    IMCPoint.trigger = CreateEntity( "trigger_cylinder" )
    IMCPoint.trigger.SetRadius( 75 )
    IMCPoint.trigger.SetAboveHeight( 100 ) // Still not quite a sphere, will see if close enough
    IMCPoint.trigger.SetBelowHeight( 0 )
    IMCPoint.trigger.SetOrigin( IMCPoint.spawn )
    IMCPoint.trigger.SetEnterCallback( IMCPoint_Trigger )
    DispatchSpawn( IMCPoint.trigger )

    IMCPoint.pointfx = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_ar_loot_drop_point" ), IMCPoint.pole.GetOrigin(), <0, 0, 0> )
    IMCPoint.beamfx = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_ar_loot_drop_point_far" ), IMCPoint.pole.GetOrigin(), <0, 0, 0> )

    CustomHighlight(IMCPoint.pole, 0, 0, 1)

    IMCPoint.teamnum = TEAM_IMC

    IMCPoint.flagatbase = true

    // Point 2
    MILITIAPoint.pole = CreateEntity( "prop_dynamic" )
    MILITIAPoint.pole.SetValueForModelKey( $"mdl/props/wattson_electric_fence/wattson_electric_fence.rmdl" )
    MILITIAPoint.pole.SetOrigin(MILITIAPoint.spawn)
    SetTargetName( MILITIAPoint.pole, "ctf_flag_mil" )
    DispatchSpawn( MILITIAPoint.pole )

    thread PlayAnim( MILITIAPoint.pole, "prop_fence_expand", MILITIAPoint.pole.GetOrigin(), MILITIAPoint.pole.GetAngles() )

    MILITIAPoint.trigger = CreateEntity( "trigger_cylinder" )
    MILITIAPoint.trigger.SetRadius( 75 )
    MILITIAPoint.trigger.SetAboveHeight( 100 ) // Still not quite a sphere, will see if close enough
    MILITIAPoint.trigger.SetBelowHeight( 0 )
    MILITIAPoint.trigger.SetOrigin( MILITIAPoint.spawn )
    MILITIAPoint.trigger.SetEnterCallback( MILITIA_Point_Trigger )
    DispatchSpawn( MILITIAPoint.trigger )

    MILITIAPoint.pointfx = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_ar_loot_drop_point" ), MILITIAPoint.pole.GetOrigin(), <0, 0, 0> )
    MILITIAPoint.beamfx = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex( $"P_ar_loot_drop_point_far" ), MILITIAPoint.pole.GetOrigin(), <0, 0, 0> )

    DrawBox( IMCPoint.spawn, <-32,-32,-32>, <32,32,32>, 255, 0, 0, true, 0.2 )

    CustomHighlight(MILITIAPoint.pole, 1, 0, 0)

    MILITIAPoint.teamnum = TEAM_IMC

    MILITIAPoint.flagatbase = true

    foreach( player in GetPlayerArray() )
    {
        if( !IsValid( player ) )
            continue

        Remote_CallFunction_Replay( player, "ServerCallback_CTF_AddPointIcon", IMCPoint.pole, MILITIAPoint.pole, player.GetTeam() )
    }
}

void function CustomHighlight(entity e, int r, int g, int b)
{
    e.Highlight_ShowInside( 1.0 )
    e.Highlight_ShowOutline( 1.0 )
    e.Highlight_SetFunctions( 0, 114, true, 125, 2.0, 2, false )
    e.Highlight_SetParam( 0, 0, <r, g, b> )
}

void function ClearCustomHighlight(entity e)
{
    e.Highlight_SetFunctions( 0, 0, true, 0, 2, 0, false )
}

void function PlayerPickedUpFlag(entity ent)
{
    if( ent.GetTeam() == TEAM_IMC )
    {
        CustomHighlight(ent, 0, 0, 1)
        Highlight_SetEnemyHighlightWithParam0( ent, "bloodhound_sonar", <0,0,1> )
        int AttachID = ent.LookupAttachment( "CHESTFOCUS" )
        IMCPoint.trailfx = StartParticleEffectOnEntity_ReturnEntity( ent, GetParticleSystemIndex( $"P_ar_holopilot_trail" ), FX_PATTACH_ABSORIGIN_FOLLOW, AttachID )
    }
    else
    {
        CustomHighlight(ent, 1, 0, 0)
        Highlight_SetEnemyHighlightWithParam0( ent, "bloodhound_sonar", <1,0,0> )
        int AttachID = ent.LookupAttachment( "CHESTFOCUS" )
        MILITIAPoint.trailfx = StartParticleEffectOnEntity_ReturnEntity( ent, GetParticleSystemIndex( $"P_ar_holopilot_trail" ), FX_PATTACH_ABSORIGIN_FOLLOW, AttachID )
    }

    if( TAKE_WEAPONS_FROM_FLAG_CARRIER )
        TakeWeaponsForFlagCarrier( ent )

    if( GIVE_FLAG_CARRIER_SPEED_BOOST )
        StatusEffect_AddEndless( ent, eStatusEffect.speed_boost, 0.1 )

    Remote_CallFunction_Replay(ent, "ServerCallback_CTF_PickedUpFlag", ent, true)

    Remote_CallFunction_Replay(ent, "ServerCallback_CTF_CustomMessages", ent, eCTFMessage.PickedUpFlag)
}

void function PlayerDroppedFlag(entity ent)
{
    ClearCustomHighlight( ent )
    Highlight_ClearEnemyHighlight( ent )

    if( TAKE_WEAPONS_FROM_FLAG_CARRIER )
        thread GiveBackWeapons( ent )

    if( GIVE_FLAG_CARRIER_SPEED_BOOST )
        StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )

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
    int enemyteam = GetCTFEnemyTeam(team)

    teamflagpoint.pole.SetParent(ent)
    teamflagpoint.pole.SetOrigin(ent.GetOrigin())
    teamflagpoint.pole.MakeInvisible()

    teamflagpoint.holdingplayer = ent
    teamflagpoint.pickedup = true
    teamflagpoint.flagatbase = false

    PlayerPickedUpFlag(ent)

    array<entity> teamplayers = GetPlayerArrayOfTeam( team )
    foreach ( player in teamplayers )
    {
        if( !IsValid( player ) )
            continue

        Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetPointIconHint", enemyteam, eCTFFlag.Escort)
    }

    array<entity> enemyplayers = GetPlayerArrayOfTeam( enemyteam )
    foreach ( player in enemyplayers )
    {
        if( !IsValid( player ) )
            continue

        Remote_CallFunction_Replay(player, "ServerCallback_CTF_CustomMessages", player, eCTFMessage.EnemyPickedUpFlag)
        Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetPointIconHint", enemyteam, eCTFFlag.Attack)
    }

    EmitSoundToTeamPlayers("UI_CTF_3P_TeamGrabFlag", team)
    EmitSoundToTeamPlayers("UI_CTF_3P_EnemyGrabFlag", enemyteam)

    PlayBattleChatterLineToSpeakerAndTeam( ent, "bc_podLeaderLaunch" )
}

void function CaptureFlag(entity ent, int team, CTFPoint teamflagpoint)
{
    int enemyteam = GetCTFEnemyTeam(team)

    PlayerDroppedFlag(ent)

    wait 0.2

    if( team == TEAM_IMC )
        CTF.IMCPoints++
    else
        CTF.MILITIAPoints++

    Remote_CallFunction_NonReplay(ent, "ServerCallback_CTF_UpdatePlayerStats", eCTFStats.Captures)

    foreach(player in GetPlayerArray())
    {
        if( !IsValid( player ) )
            continue

        Remote_CallFunction_Replay(player, "ServerCallback_CTF_PointCaptured", CTF.IMCPoints, CTF.MILITIAPoints)
    }

    array<entity> teamplayers = GetPlayerArrayOfTeam( team )
    foreach ( player in teamplayers )
    {
        if( !IsValid( player ) )
            continue

        Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetPointIconHint", enemyteam, eCTFFlag.Capture)
        Remote_CallFunction_Replay(player, "ServerCallback_CTF_FlagCaptured", teamflagpoint.holdingplayer, eCTFMessage.PickedUpFlag)
    }

    array<entity> enemyplayers = GetPlayerArrayOfTeam( enemyteam )
    foreach ( player in enemyplayers )
    {
        if( !IsValid( player ) )
            continue

        Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetPointIconHint", enemyteam, eCTFFlag.Defend)
        Remote_CallFunction_Replay(player, "ServerCallback_CTF_FlagCaptured", teamflagpoint.holdingplayer, eCTFMessage.EnemyPickedUpFlag)
    }

    teamflagpoint.holdingplayer = null
    teamflagpoint.pickedup = false
    teamflagpoint.dropped = false
    teamflagpoint.flagatbase = true
    teamflagpoint.pole.ClearParent()
    teamflagpoint.pole.SetOrigin(teamflagpoint.spawn)
    teamflagpoint.pole.MakeVisible()

    EmitSoundToTeamPlayers("ui_ctf_enemy_score", enemyteam)
    EmitSoundToTeamPlayers("ui_ctf_team_score", team)
    thread PlayAnim( teamflagpoint.pole, "prop_fence_expand", teamflagpoint.pole.GetOrigin(), teamflagpoint.pole.GetAngles() )

    if(GIVE_ALT_AFTER_CAPTURE)
        ent.GetOffhandWeapon( OFFHAND_INVENTORY ).SetWeaponPrimaryClipCount( ent.GetOffhandWeapon( OFFHAND_INVENTORY ).GetWeaponPrimaryClipCountMax() )

    if(CTF.IMCPoints >= CTF_SCORE_GOAL_TO_WIN || CTF.MILITIAPoints >= CTF_SCORE_GOAL_TO_WIN)
    {
        foreach( entity player in GetPlayerArray() )
        {
            if( !IsValid( player ) )
                continue

            thread EmitSoundOnEntityOnlyToPlayer( player, player, "diag_ap_aiNotify_winnerFound" )
        }
        file.ctfState = eCTFState.WINNER_DECIDED
    }
}

void function IMCPoint_Trigger( entity trigger, entity ent )
{
    if(!IsValid(ent))
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
    if(!IsValid(ent))
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

// purpose: Take weapons from player and give ctf dataknife
void function TakeWeaponsForFlagCarrier(entity player)
{
    if( !IsValid( player ) )
        return

    TakeAllWeapons(player)
    player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
    player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, ["ctf_knife"] )
    player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_2)
}

// purpose: Give player their weapons back
void function GiveBackWeapons(entity player)
{
    if( !IsValid( player ) )
        return

    // Needs to check and set legend change before taking weapons
    Remote_CallFunction_NonReplay(player, "ServerCallback_CTF_CheckUpdatePlayerLegend")

    wait 0.5

    //Needed another check after the wait just incase they leave within that wait time
    if( !IsValid( player ) )
        return

    TakeAllWeapons(player)

    player.GiveWeapon(file.ctfclasses[player.p.CTFClassID].primary, WEAPON_INVENTORY_SLOT_PRIMARY_0, file.ctfclasses[player.p.CTFClassID].primaryattachments)
    player.GiveWeapon(file.ctfclasses[player.p.CTFClassID].secondary, WEAPON_INVENTORY_SLOT_PRIMARY_1, file.ctfclasses[player.p.CTFClassID].secondaryattachments)

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

    player.TakeOffhandWeapon(OFFHAND_MELEE)
    player.GiveWeapon( "mp_weapon_melee_survival", WEAPON_INVENTORY_SLOT_PRIMARY_2, [] )
    player.GiveOffhandWeapon( "melee_data_knife", OFFHAND_MELEE, [] )
    player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
}

// purpose: OnPlayerConnected Callback
void function _OnPlayerConnected(entity player)
{
    if( !IsValid( player ) )
        return

    // Give passive regen (pilot blood)
    GivePassive(player, ePassives.PAS_PILOT_BLOOD)

    Remote_CallFunction_NonReplay(player, "ServerCallback_CTF_SetObjectiveText", CTF_SCORE_GOAL_TO_WIN)

    // why gen
    int SavedPlayerClass = player.GetPersistentVarAsInt( "gen" )
    if (SavedPlayerClass > NUMBER_OF_CLASS_SLOTS || SavedPlayerClass < 0)
        SavedPlayerClass = 0

    player.p.CTFClassID = SavedPlayerClass

    if( !IsAlive(player) )
        _HandleRespawn(player)

    switch ( GetGameState() )
    {
    case eGameState.WaitingForPlayers:
        player.FreezeControlsOnServer()
        Remote_CallFunction_NonReplay(player, "ServerCallback_CTF_DoAnnouncement", 2, eCTFAnnounce.VOTING_PHASE, CTF.roundstarttime)
        break
    case eGameState.Playing:
        player.UnfreezeControlsOnServer();
        Remote_CallFunction_NonReplay(player, "ServerCallback_CTF_DoAnnouncement", 5, eCTFAnnounce.ROUND_START, CTF.roundstarttime)
        Remote_CallFunction_Replay(player, "ServerCallback_CTF_AddPointIcon", IMCPoint.pole, MILITIAPoint.pole, player.GetTeam())
        Remote_CallFunction_Replay(player, "ServerCallback_CTF_TeamText", player.GetTeam())
        Remote_CallFunction_NonReplay(player, "ServerCallback_CTF_SetSelectedLocation", CTF.mappicked)
        Remote_CallFunction_Replay(player, "ServerCallback_CTF_PointCaptured", CTF.IMCPoints, CTF.MILITIAPoints)
        Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetCorrectTime", ServerTimer.seconds)
        break
    default:
        break
    }
}

// purpose: OnPlayerDisconnected Callback
void function _OnPlayerDisconnected(entity player)
{
    // Only if the flag is picked up
    /*if ( IMCPoint.pickedup )
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
    }*/
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
        DispatchSpawn( IMCPoint.pole )

        thread PlayAnim( IMCPoint.pole, "prop_fence_expand", IMCPoint.pole.GetOrigin(), IMCPoint.pole.GetAngles() )

        CustomHighlight(IMCPoint.pole, 0, 0, 1)

        IMCPoint.pickedup = false
        IMCPoint.dropped = false
        IMCPoint.flagatbase = true
    }
    else if(num == 1)
    {
        if( IsValid( MILITIAPoint.pole ) )
            MILITIAPoint.pole.Destroy()

        if( IsValid( MILITIAPoint.trailfx ) )
            MILITIAPoint.trailfx.Destroy()

        MILITIAPoint.spawn = OriginToGround( file.selectedLocation.milflagspawn )
        MILITIAPoint.pole = CreateEntity( "prop_dynamic" )
        MILITIAPoint.pole.SetValueForModelKey( $"mdl/props/wattson_electric_fence/wattson_electric_fence.rmdl" )
        MILITIAPoint.pole.SetOrigin(MILITIAPoint.spawn)
        DispatchSpawn( MILITIAPoint.pole )

        thread PlayAnim( MILITIAPoint.pole, "prop_fence_expand", MILITIAPoint.pole.GetOrigin(), MILITIAPoint.pole.GetAngles() )

        CustomHighlight(MILITIAPoint.pole, 1, 0, 0)

        MILITIAPoint.pickedup = false
        MILITIAPoint.dropped = false
        MILITIAPoint.flagatbase = true
    }

    foreach( player in GetPlayerArray() )
    {
        if( !IsValid( player ) )
            continue

        Remote_CallFunction_Replay( player, "ServerCallback_CTF_AddPointIcon", IMCPoint.pole, MILITIAPoint.pole, player.GetTeam() )
    }
}

void function MILITIA_PoleReturn_Trigger( entity trigger, entity ent )
{
    if(!IsValid(ent))
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
    if(!IsValid(ent))
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

            PlayerPickedUpFlag(ent)

            IMCPoint.holdingplayer = ent
            IMCPoint.pickedup = true
            IMCPoint.dropped = false

            array<entity> teamplayers = GetPlayerArrayOfTeam( TEAM_MILITIA )
            foreach ( player in teamplayers )
            {
                if( !IsValid( player ) )
                    continue

                Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetPointIconHint", TEAM_IMC, eCTFFlag.Escort)
            }

            array<entity> enemyplayers = GetPlayerArrayOfTeam( TEAM_IMC )
            foreach ( player in enemyplayers )
            {
                if( !IsValid( player ) )
                    continue

                Remote_CallFunction_Replay(player, "ServerCallback_CTF_CustomMessages", player, eCTFMessage.EnemyPickedUpFlag)
                Remote_CallFunction_Replay(player, "ServerCallback_CTF_SetPointIconHint", TEAM_IMC, eCTFFlag.Attack)
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
        while( Distance( player.GetOrigin(), teamflagpoint.pole.GetOrigin() ) < 150 && IsAlive( player ) && returnsuccess == false || playerpickedupflag || playerleftarea )
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
        if(IsValid(teamflagpoint.pole))
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
            thread PlayAnim( teamflagpoint.pole, "prop_fence_expand", teamflagpoint.pole.GetOrigin(), teamflagpoint.pole.GetAngles() )

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
    int enemyteam = GetCTFEnemyTeam(team)

    teamflagpoint.pole.ClearParent()
    bool foundSafeSpot = false

    PlayerDroppedFlag(victim)

    // Clear parent and set the flag to current death location
    teamflagpoint.holdingplayer = null
    teamflagpoint.pole.MakeVisible()

    teamflagpoint.pole.SetOrigin( OriginToGround( teamflagpoint.pole.GetOrigin() ) )

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

    // Check for if the flag ends up under the map
    if( teamflagpoint.pole.GetOrigin().z > file.selectedLocation.undermap )
    {
        if( Distance( teamflagpoint.pole.GetOrigin(), CTF.ringCenter ) > CTF.ringRadius )
        {
            teamflagpoint.flagatbase = true
            teamflagpoint.pole.SetOrigin(OriginToGround( teamflagpoint.spawn ))
        }
        else
        {
            foundSafeSpot = true
        }
    }
    else
    {
        teamflagpoint.flagatbase = true
        teamflagpoint.pole.SetOrigin(OriginToGround( teamflagpoint.spawn ))
    }

    // Play expand anim
    thread PlayAnim( teamflagpoint.pole, "prop_fence_expand", teamflagpoint.pole.GetOrigin(), teamflagpoint.pole.GetAngles() )

    wait 1.2

    teamflagpoint.pickedup = false
    teamflagpoint.dropped = true

    if ( foundSafeSpot )
    {
        // Create the recapture trigger
        teamflagpoint.returntrigger = CreateEntity( "trigger_cylinder" )
        teamflagpoint.returntrigger.SetRadius( 100 )
        teamflagpoint.returntrigger.SetAboveHeight( 200 )
        teamflagpoint.returntrigger.SetBelowHeight( 200 )
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

    if( victim.GetObserverTarget() != null )
		victim.SetObserverTarget( null )

	victim.StartObserverMode( OBS_MODE_DEATHCAM )

    switch(GetGameState())
    {
    case eGameState.Playing:

        // What happens to victim
        void functionref() victimHandleFunc = void function() : (victim, attacker, damageInfo) {

            if( !IsValid( victim ) )
                return

            if (!CTF.votingtime)
            {
                // Add a death to the victim
                int invscore = victim.GetPlayerNetInt( "assists" )
                invscore++;
                victim.SetPlayerNetInt( "assists", invscore )

                Remote_CallFunction_NonReplay(victim, "ServerCallback_CTF_HideCustomUI")

                wait 4 // so we dont go straight to respawn menu

                if( !IsValid( victim ) )
                    return

                // Open respawn menu
                Remote_CallFunction_NonReplay(victim, "ServerCallback_CTF_OpenCTFRespawnMenu", CTF.ringCenter, CTF.IMCPoints, CTF.MILITIAPoints, attacker, victim.p.CTFClassID)

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
                int invscore = attacker.GetPlayerNetInt( "kills" )
                invscore++;
                attacker.SetPlayerNetInt( "kills", invscore )

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

    SetPlayerSettings(player, CTF_PLAYER_SETTINGS)
    PlayerRestoreHP(player, 100, CTF_Equipment_GetDefaultShieldHP())

    TpPlayerToSpawnPoint(player)
    thread GrantSpawnImmunity(player, 3)

    // Point icons disappear on death, so this fixes that.
    Remote_CallFunction_Replay(player, "ServerCallback_CTF_ResetFlagIcons")

    foreach( players in GetPlayerArray() )
    {
        if( IsValid( players ) && IsValid( IMCPoint.pole ) && IsValid( MILITIAPoint.pole ) )
        {
            if (players.GetTeam() == TEAM_IMC)
            {
                Remote_CallFunction_Replay(players, "ServerCallback_CTF_AddPointIcon", IMCPoint.pole, MILITIAPoint.pole, TEAM_IMC)
            }
            else if (players.GetTeam() == TEAM_MILITIA)
            {
                Remote_CallFunction_Replay(players, "ServerCallback_CTF_AddPointIcon", IMCPoint.pole, MILITIAPoint.pole, TEAM_MILITIA)
            }
        }
    }

    player.SetActiveWeaponBySlot(eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
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

    /*array<LocPairCTF> spawns = location.ringspots

    vector ringCenter
    foreach( spawn in spawns )
    {
        ringCenter += spawn.origin
    }

    ringCenter /= spawns.len()

    float ringRadius = 0

    foreach( LocPairCTF spawn in spawns )
    {
        if( Distance( spawn.origin, ringCenter ) > ringRadius )
            ringRadius = Distance(spawn.origin, ringCenter)
    }

    ringRadius += GetCurrentPlaylistVarFloat("ring_radius_padding", 800)

    CTF.ringCenter = ringCenter
    CTF.ringRadius = ringRadius

	//We watch the ring fx with this entity in the threads
	entity circle = CreateEntity( "prop_script" )
	circle.SetValueForModelKey( $"mdl/dev/empty_model.rmdl" )
	circle.kv.fadedist = -1
	circle.kv.renderamt = 255
	circle.kv.rendercolor = "255, 255, 255"
	circle.kv.solid = 0
	circle.SetOrigin( CTF.ringCenter )
	circle.SetAngles( <0, 0, 0> )
	circle.NotSolid()
	circle.DisableHibernation()
    circle.Minimap_SetObjectScale( CTF.ringRadius / SURVIVAL_MINIMAP_RING_SCALE )
    circle.Minimap_SetAlignUpright( true )
    circle.Minimap_SetZOrder( 2 )
    circle.Minimap_SetClampToEdge( true )
    circle.Minimap_SetCustomState( eMinimapObject_prop_script.OBJECTIVE_AREA )
	SetTargetName( circle, "safeZone" )
	DispatchSpawn(circle)
    

    foreach ( player in GetPlayerArray() )
    {
        circle.Minimap_AlwaysShow( 0, player )
    }
	
	SetDeathFieldParams( CTF.ringCenter, CTF.ringRadius, CTF.ringRadius, Time(), Time() + 2137483647 ) // This function from the API allows client to read ringRadius from server so we can use visual effects in shared function. Colombia

    if(IsValid(CTF.ringfx))
        CTF.ringfx.Destroy()

	//Actual deathfield fx
	CTF.ringfx = StartParticleEffectOnEntity_ReturnEntity(circle, GetParticleSystemIndex( $"P_survival_radius_CP_1x100" ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	CTF.ringfx.SetParent(circle)

    //StatsHook_SetSafeZone( CTF.ringCenter, CTF.ringRadius )
	
	//Audio thread for ring
	foreach(sPlayer in GetPlayerArray())
		thread CTFAudioThread(circle, sPlayer, CTF.ringRadius)
	
	//Damage thread for ring
	thread CTFRingDamage(circle, CTF.ringRadius)
	
    return circle*/
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

void function CTFAudioThread(entity circle, entity player, float radius)
{
	WaitFrame()
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
	
	while(IsValid(circle) && IsValid( player )){
            if( !IsValid( player ) )
                continue

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

void function CTFRingDamage( entity circle, float currentRadius)
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
				dummy.TakeDamage( int( CTF_GetOOBDamagePercent() / 100 * float( dummy.GetMaxHealth() ) ), null, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )
			}
		}
		
		foreach ( player in GetPlayerArray_Alive() )
		{
			if ( player.IsPhaseShifted() )
				continue

			float playerDist = Distance2D( player.GetOrigin(), circle.GetOrigin() )
			if ( playerDist > currentRadius )
			{
				Remote_CallFunction_Replay( player, "ServerCallback_PlayerTookDamage", 0, 0, 0, 0, DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, eDamageSourceId.deathField, null )
				player.TakeDamage( int( CTF_GetOOBDamagePercent() / 100 * float( player.GetMaxHealth() ) ), null, null, { scriptType = DF_BYPASS_SHIELD | DF_DOOMED_HEALTH_LOSS, damageSourceId = eDamageSourceId.deathField } )
			}
		}
		wait DAMAGE_CHECK_STEP_TIME
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

void function GrantSpawnImmunity(entity player, float duration)
{
    if( !IsValid( player ) )
        return
    
    MakeInvincible(player)

    wait duration

    if( !IsValid( player ) )
        return
    
    ClearInvincible(player)
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