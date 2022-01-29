#if SERVER
untyped
globalize_all_functions
#endif
globalize_all_functions

enum eTDMState
{
	IN_PROGRESS = 0
	NEXT_ROUND_NOW = 1
}

struct {
int tdmState = eTDMState.IN_PROGRESS
array<entity> playerSpawnedProps
float endTime = 0
array<LocationSettings> locationSettings
LocationSettings& selectedLocation
int nextMapIndex = 0
bool mapIndexChanged = true
	string Hoster
	string admin1
	string admin2
	string admin3
	string admin4
} surf


void function _RegisterLocationSURF(LocationSettings locationSettings)
{
    surf.locationSettings.append(locationSettings)
}

void function _OnPropDynamicSpawnedSURF(entity prop)
{
    surf.playerSpawnedProps.append(prop)
}

void function RunSURF()
{
    WaitForGameState(eGameState.Playing)
	surf.selectedLocation = surf.locationSettings[0]
    AddSpawnCallback("prop_dynamic", _OnPropDynamicSpawnedSURF)
    for(; ;)
    {
	ActualSURFLobby()
	ActualSURFGameLoop()
	}
    WaitForever()
}

void function _OnPlayerConnectedSURF(entity player)
{
    if(!IsValid(player)) return
	if(FlowState_ForceCharacter()){CharSelect(player)}
	DecideRespawnPlayer( player)
	player.SetBodyModelOverride( $"mdl/humans/class/medium/pilot_medium_generic.rmdl" )
	player.SetArmsModelOverride( $"mdl/humans/class/medium/pilot_medium_generic.rmdl" )
	player.SetSkin(RandomInt(6))
	Message(player, "WELCOME TO APEX SURF", "Surf maps by AyeZee - Game mode implementation by Colombia", 10)
    player.TakeOffhandWeapon(OFFHAND_TACTICAL)
    player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
    TakeAllWeapons( player )
    SetPlayerSettings(player, SURF_SETTINGS)
    MakeInvincible(player)
    player.GiveWeapon( "mp_weapon_semipistol", WEAPON_INVENTORY_SLOT_ANY )
	SetTeam(player, TEAM_IMC )
    switch(GetGameState())
    {

    case eGameState.WaitingForPlayers:
        player.UnfreezeControlsOnServer()
		        if (GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx")
					{
					player.SetOrigin(<-19459, 2127, 6404>)}
		else if(GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
					{
					player.SetOrigin(<-19459, 2127, 18404>)}
        break
	case eGameState.MapVoting:
        player.UnfreezeControlsOnServer()
		        if (GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx")
					{
					player.SetOrigin(<-19459, 2127, 6404>)}
		else if(GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
					{
					player.SetOrigin(<-19459, 2127, 18404>)}
        break
    case eGameState.Playing:
        player.UnfreezeControlsOnServer();
		
		if(IsValid(player))
		{	TpPlayerToSpawnPoint(player)
			_HandleRespawnSURF(player)
		}

        break
    default: 
        break
    }
}



void function _OnPlayerDiedSURF(entity victim, entity attacker, var damageInfo) 
{
    switch(GetGameState())
    {
    case eGameState.Playing:

        break
    default:

    }
}

void function _HandleRespawnSURF(entity player, bool forceGive = false)
{
    if(!IsValid(player)) return

    if( player.IsObserver())
    {
        player.StopObserverMode()
    }

    if(!IsAlive(player))
    {

                DecideRespawnPlayer(player, false)
                player.TakeOffhandWeapon(OFFHAND_TACTICAL)
                player.TakeOffhandWeapon(OFFHAND_ULTIMATE)
                TakeAllWeapons( player )
                SetPlayerSettings(player, SURF_SETTINGS)
                MakeInvincible(player)
                player.GiveWeapon( "mp_weapon_semipistol", WEAPON_INVENTORY_SLOT_ANY )
    }
    player.SetHealth( 100 )
	Inventory_SetPlayerEquipment(player, "armor_pickup_lv3", "armor")
	player.SetShieldHealth( 100 )
    TpPlayerToSpawnPoint(player)
	SetTeam(player, TEAM_IMC )
}

void function TpPlayerToSpawnPoint(entity player)
{
    array<LocPair> surfSpawn = surf.selectedLocation.spawns
	player.SetOrigin(surfSpawn[0].origin)
	player.SetAngles(surfSpawn[0].angles)
}

void function DestroyPlayerPropsSURF()
{
    if (surf.playerSpawnedProps.len())
    {
        foreach(prop in surf.playerSpawnedProps)
        {
            if(IsValid(prop))
                prop.Destroy()
        }
        surf.playerSpawnedProps.clear()
    }
}

void function ActualSURFLobby()
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
	SetGameState(eGameState.MapVoting)
	surf.Hoster = FlowState_Hoster()
	surf.admin1 = FlowState_Admin1()
	surf.admin2 = FlowState_Admin2()
	surf.admin3 = FlowState_Admin3()
	surf.admin4 = FlowState_Admin4()
	
	// if (!surf.mapIndexChanged)
	// {
	// surf.nextMapIndex = (surf.nextMapIndex + 1) % surf.locationSettings.len()
	// }
	
	// if(surf.nextMapIndex == surf.locationSettings.len()-1 && surf.mapIndexChanged){
	// surf.nextMapIndex = 0
	// }
	
	// if (FlowState_SURFLockPOI()) {
		// surf.nextMapIndex = FlowState_SURFLockedPOI()
	// }
	if (!surf.mapIndexChanged)
	{
	
	
	if (surf.nextMapIndex == 1)
	{
		surf.nextMapIndex=0
	} else if(surf.nextMapIndex == 0){
		surf.nextMapIndex=1
	}

	}

	int choice = surf.nextMapIndex
	surf.mapIndexChanged = false
	surf.selectedLocation = surf.locationSettings[choice]

    foreach(player in GetPlayerArray()) 
    {
        if(!IsValid(player)) continue;
        		        if (GetMapName() == "mp_rr_desertlands_64k_x_64k" || GetMapName() == "mp_rr_desertlands_64k_x_64k_nx")
					{
					player.SetOrigin(<-19459, 2127, 6404>)}
		else if(GetMapName() == "mp_rr_canyonlands_mu1" || GetMapName() == "mp_rr_canyonlands_mu1_night" || GetMapName() == "mp_rr_canyonlands_64k_x_64k")
					{
					player.SetOrigin(<-19459, 2127, 18404>)}
        MakeInvincible(player)
        player.UnfreezeControlsOnServer();      
    }
    wait 5

    switch( surf.selectedLocation.name )
	{
		case "Surf Purgatory":
            DestroyPlayerPropsSURF()
            wait 2
            SurfPurgatoryLoad()
			break
		case "Surf NoName":
            DestroyPlayerPropsSURF()
            wait 2
            SurfNoNameLoad()
			break
		default:
		break
	}

WaitFrame()
}

void function ActualSURFGameLoop()
///////////////////////////////////////////////////////
//By Retículo Endoplasmático#5955 (CaféDeColombiaFPS)//
///////////////////////////////////////////////////////
{
surf.tdmState = eTDMState.IN_PROGRESS
SetGameState(eGameState.Playing)
float endTime = Time() + FlowState_SURFRoundTime()

    foreach(player in GetPlayerArray())
    {   
        if( IsValid( player ) )
        {
			_HandleRespawnSURF(player)
            player.SetInvulnerable()
            MakeInvincible(player)
            DeployAndEnableWeapons(player)
            player.UnforceStand()  
            TpPlayerToSpawnPoint(player)
            player.UnfreezeControlsOnServer()
        }
        
    }
	
    switch( surf.selectedLocation.name )
	{
		case "Surf Purgatory":
		foreach(player in GetPlayerArray())
			{
			if( IsValid( player ) )
					{
            Message(player, "SURF PURGATORY", "Difficulty: Medium", 10)
				}
			}
			break
		case "Surf NoName":
		foreach(player in GetPlayerArray())
			{
			if( IsValid( player ) )
			{
            Message(player, "SURF NONAME", "Difficulty: Medium+", 10)
				}
			}
			break
		default:
		break
	}
		
	
while( Time() <= endTime )
	{
		if(Time() == endTime-120)
		{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					Message(player,"ATTENTION","Surf map changing in 2 minutes.", 10)
				}
			}
		}
		if(Time() == endTime-15)
		{
			foreach(player in GetPlayerArray())
			{
				if(IsValid(player))
				{
					Message(player,"ATTENTION","Surf map changing in 15 seconds.", 10)
				}
			}
		}
		if(surf.tdmState == eTDMState.NEXT_ROUND_NOW)
		{break}
		WaitFrame()	
	}

WaitFrame()
}

#if SERVER
entity function CreateCustomLight( vector origin, vector angles, string lightcolor, float scale )
{

	entity env_sprite = CreateEntity( "env_sprite" )
	env_sprite.SetScriptName( UniqueString( "molotov_sprite" ) )
	env_sprite.kv.rendermode = 5
	env_sprite.kv.origin = origin
	env_sprite.kv.angles = angles
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

    surf.playerSpawnedProps.append(env_sprite)

	return env_sprite
}

entity function CreateEditorProp(asset a, vector pos, vector ang, bool mantle = false, float fade = 2000)
{
	entity e = CreatePropDynamic(a,pos,ang,SOLID_VPHYSICS,fade)
	e.kv.fadedist = fade
    e.kv.renderamt = 255
	e.kv.rendermode = 3
	e.kv.rendercolor = "255 255 255 255"
	if(mantle) e.AllowMantle()
    surf.playerSpawnedProps.append(e)
	return e
}

void function SurfRampsHighlight( entity e )
{
	float rampr = RandomFloatRange( 0.0, 1.0 )
    float rampg = RandomFloatRange( 0.0, 1.0 )
	float rampb = RandomFloatRange( 0.0, 1.0 )
    e.Highlight_ShowInside( 1.0 )
	e.Highlight_ShowOutline( 1.0 )
    e.Highlight_SetFunctions( 0, 136, false, 136, 8.0, 2, false )
    e.Highlight_SetParam( 0, 0, <rampr, rampg, rampb> )
}

entity function CreateEditorPropRamps(asset a, vector pos, vector ang, bool mantle = false, float fade = 2000)
{
	entity e = CreatePropDynamic(a,pos,ang,SOLID_VPHYSICS,fade)
	e.kv.fadedist = fade
    e.kv.renderamt = 255
	e.kv.rendermode = 3
	e.kv.rendercolor = "255 255 255 255"
        SurfRampsHighlight(e)
	if(mantle) e.AllowMantle()
    surf.playerSpawnedProps.append(e)
	return e
}

#endif

void function TeleportFRPlayerSurf(entity player, vector pos, vector ang)
{
    if(IsValid(player))
    {
	    player.SetOrigin(pos)
	    player.SetAngles(ang)
    }
}

void function SurfPurgatoryLoad()
{

	SurfPurgatory()
    thread SurfPurgatoryTriggerSetup()
}


void function SurfPurgatoryTriggerSetup()
{
	entity fall = CreateEntity( "trigger_cylinder" )
	fall.SetRadius( 100000 )
	fall.SetAboveHeight( 25 )
	fall.SetBelowHeight( 25 )
	fall.SetOrigin( <3299,7941,16384> )
	DispatchSpawn( fall )

	fall.SetEnterCallback( SurfPurgatoryTrigger_OnAreaEnter )

    entity finishdoor = CreateEntity( "trigger_cylinder" )
	finishdoor.SetRadius( 20 )
	finishdoor.SetAboveHeight( 25 )
	finishdoor.SetBelowHeight( 25 )
	finishdoor.SetOrigin( <2439, 20490, 17623> )
	DispatchSpawn( finishdoor )

	finishdoor.SetEnterCallback( SurfPurgatoryFinishDoor_OnAreaEnter )

    entity finish = CreateEntity( "trigger_cylinder" )
	finish.SetRadius( 1000 )
	finish.SetAboveHeight( 300 )
	finish.SetBelowHeight( 1 )
    finish.SetAngles( <0, 90, 0> )
	finish.SetOrigin( <2419, 20559, 17590> )
	DispatchSpawn( finish )

	finish.SetEnterCallback( SurfPurgatoryFinishFinished_OnAreaEnter )

    surf.playerSpawnedProps.append(fall)
    surf.playerSpawnedProps.append(finishdoor)
    surf.playerSpawnedProps.append(finish)

	OnThreadEnd(
		function() : ( fall )
		{
			fall.Destroy()
		} )

	WaitForever()
}

void function SurfPurgatoryTrigger_OnAreaEnter( entity trigger, entity player )
{
    TeleportFRPlayer(player,<3225,9084,21476>,<0,-90,0>)
}

void function SurfPurgatoryFinishDoor_OnAreaEnter( entity trigger, entity player )
{
    TeleportFRPlayer(player,<3225,9084,21476>,<0,-90,0>)
}

void function SurfPurgatoryFinishFinished_OnAreaEnter( entity trigger, entity player )
{
    Message( player, "Map Finished", "Congrats you finished surf_purgatory", 5.0 )
}



bool function ClientCommand_NextRoundSURF(entity player, array<string> args)
//Thanks Archtux#9300
//Modified by Retículo Endoplasmático#5955 and michae\l/#1125
{
if(player.GetPlayerName() == surf.Hoster || player.GetPlayerName() == surf.admin1 || player.GetPlayerName() == surf.admin2 || player.GetPlayerName() == surf.admin3 || player.GetPlayerName() == surf.admin4) {
	
    if (args.len()) {

        try{
            string now = args[0]
            if (now == "now")
            {
               surf.tdmState = eTDMState.NEXT_ROUND_NOW
			   surf.mapIndexChanged = false
			   return true
            }
        } catch(e1) {}

        try{
            int mapIndex = int(args[0])
            surf.nextMapIndex = (((mapIndex >= 0 ) && (mapIndex < surf.locationSettings.len())) ? mapIndex : RandomIntRangeInclusive(0, surf.locationSettings.len() - 1))
            surf.mapIndexChanged = true
        } catch (e) {}

        try{
            string now = args[1]
            if (now == "now")
            {
               surf.tdmState = eTDMState.NEXT_ROUND_NOW
            }
        } catch(e2) {}
    }
	}
	else {
	return false
	}
	return true
}

/////////////////////////////////////////////////
//
//
//
//
//              DOSNT HAVE NAME YET
//
//
//
//
/////////////////////////////////////////////////

void function SurfNoNameLoad()
{
    SurfNoName()
    thread SurfNoNameTriggerSetup()
}

void function SurfNoNameTriggerSetup()
{
	entity fall1 = CreateEntity( "trigger_cylinder" )
	fall1.SetRadius( 5000 )
	fall1.SetAboveHeight( 10 )
	fall1.SetBelowHeight( 0 )
	fall1.SetOrigin( <6040, 10803, 23232> )
	DispatchSpawn( fall1 )

	fall1.SetEnterCallback( SurfNoNameTrigger_OnAreaEnter )

    entity fall2 = CreateEntity( "trigger_cylinder" )
	fall2.SetRadius( 5000 )
	fall2.SetAboveHeight( 10 )
	fall2.SetBelowHeight( 0 )
	fall2.SetOrigin( <12433, 4031, 23478> )
	DispatchSpawn( fall2 )

	fall2.SetEnterCallback( SurfNoName2Trigger_OnAreaEnter )

    entity tp1 = CreateEntity( "trigger_cylinder" )
	tp1.SetRadius( 50 )
	tp1.SetAboveHeight( 50 )
	tp1.SetBelowHeight( 50 )
	tp1.SetOrigin( <5241, 11840, 24328> )
	DispatchSpawn( tp1 )

	tp1.SetEnterCallback( SurfNoNameTeleport1_OnAreaEnter )

    entity tp2 = CreateEntity( "trigger_cylinder" )
	tp2.SetRadius( 50 )
	tp2.SetAboveHeight( 50 )
	tp2.SetBelowHeight( 50 )
	tp2.SetOrigin( <3694, 11077, 24330> )
	DispatchSpawn( tp2 )

	tp2.SetEnterCallback( SurfNoNameTeleport2_OnAreaEnter )

    entity tp3 = CreateEntity( "trigger_cylinder" )
	tp3.SetRadius( 50 )
	tp3.SetAboveHeight( 50 )
	tp3.SetBelowHeight( 50 )
	tp3.SetOrigin( <3702, 10308, 24070> )
	DispatchSpawn( tp3 )

	tp3.SetEnterCallback( SurfNoNameTeleport3_OnAreaEnter )

    entity tp4 = CreateEntity( "trigger_cylinder" )
	tp4.SetRadius( 50 )
	tp4.SetAboveHeight( 50 )
	tp4.SetBelowHeight( 50 )
	tp4.SetOrigin( <11829, 4935, 24116> )
	DispatchSpawn( tp4 )

	tp4.SetEnterCallback( SurfNoNameTeleport4_OnAreaEnter )

    entity tp5 = CreateEntity( "trigger_cylinder" )
	tp5.SetRadius( 50 )
	tp5.SetAboveHeight( 50 )
	tp5.SetBelowHeight( 50 )
	tp5.SetOrigin( <13940, 3909, 24580> )
	DispatchSpawn( tp5 )

	tp5.SetEnterCallback( SurfNoNameTeleport5_OnAreaEnter )

    entity tp6 = CreateEntity( "trigger_cylinder" )
	tp6.SetRadius( 50 )
	tp6.SetAboveHeight( 50 )
	tp6.SetBelowHeight( 50 )
	tp6.SetOrigin( <11796, 2495, 24357> )
	DispatchSpawn( tp6 )

	tp6.SetEnterCallback( SurfNoNameTeleport6_OnAreaEnter )

    entity tp7 = CreateEntity( "trigger_cylinder" )
	tp7.SetRadius( 50 )
	tp7.SetAboveHeight( 50 )
	tp7.SetBelowHeight( 50 )
	tp7.SetOrigin( <12403, 2236, 24130> )
	DispatchSpawn( tp7 )

	tp7.SetEnterCallback( SurfNoNameTeleport7_OnAreaEnter )

    surf.playerSpawnedProps.append(fall1)
    surf.playerSpawnedProps.append(fall2)
    surf.playerSpawnedProps.append(tp1)
    surf.playerSpawnedProps.append(tp2)
    surf.playerSpawnedProps.append(tp3)
    surf.playerSpawnedProps.append(tp4)
    surf.playerSpawnedProps.append(tp5)
    surf.playerSpawnedProps.append(tp6)
    surf.playerSpawnedProps.append(tp7)

	OnThreadEnd(
		function() : ( fall1 )
		{
			fall1.Destroy()
		} )

	WaitForever()
}

void function SurfNoNameTrigger_OnAreaEnter( entity trigger, entity player )
{
    TeleportFRPlayerSurf(player,<7799, 11833, 24585>,<0,180,0>)
}

void function SurfNoName2Trigger_OnAreaEnter( entity trigger, entity player )
{
    TeleportFRPlayerSurf(player,<11850, 5560, 24355>,<0,0,0>)
}

// Door Teleports
void function SurfNoNameTeleport1_OnAreaEnter( entity trigger, entity player )
{
    //Stage 2
    TeleportFRPlayerSurf(player,<7786, 11062, 24340>,<0,180,0>)
}

void function SurfNoNameTeleport2_OnAreaEnter( entity trigger, entity player )
{
    //Stage 3
    TeleportFRPlayerSurf(player,<7815, 10300, 24372>,<0,180,0>)
}

void function SurfNoNameTeleport3_OnAreaEnter( entity trigger, entity player )
{
    //Stage 4
    TeleportFRPlayerSurf(player,<11850, 5560, 24355>,<0,0,0>)
}

void function SurfNoNameTeleport4_OnAreaEnter( entity trigger, entity player )
{
    //Stage 5
    TeleportFRPlayerSurf(player,<13927, 4411, 24643>,<0,180,0>)
}

void function SurfNoNameTeleport5_OnAreaEnter( entity trigger, entity player )
{
    //Stage 6
    TeleportFRPlayerSurf(player,<11809, 3384, 24601>,<0,0,0>)
}

void function SurfNoNameTeleport6_OnAreaEnter( entity trigger, entity player )
{
    //Stage 7
    TeleportFRPlayerSurf(player,<13662, 2881, 24598>,<0,180,0>)
}

void function SurfNoNameTeleport7_OnAreaEnter( entity trigger, entity player )
{
    //Spawn
    TeleportFRPlayerSurf(player,<7799, 11833, 24585>,<0,180,0>)
}

//Map Finish
void function SurfNoNameFinishDoor_OnAreaEnter( entity trigger, entity player )
{
    TeleportFRPlayerSurf(player,<13927, 4411, 24643>,<0,-90,0>)
}

void function SurfNoNameFinishFinished_OnAreaEnter( entity trigger, entity player )
{
    Message( player, "Map Finished", "Congrats you finished surf_purgatory", 5.0 )
}

