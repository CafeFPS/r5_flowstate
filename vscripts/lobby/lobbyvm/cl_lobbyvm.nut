global function Cl_LobbyVM_Init

//Mods Panel
global function ModsPanelShown
global function DefaultToBrowseMods
global function BrowseModsToDefault
global function DefaultToInstalledMods
global function InstalledModsToDefault

const int CAMERA_SMOOTH_STEPS = 50

struct {
    array<vector> MAIN_TO_MODS = [ < 8020, -7607, -8080 >, < 8082, -7524.8000, -8080 >, < 8058.7000, -7452.4100, -8080 >, < 8010.9100, -7377.7300, -8080 > ]
    array<vector> MODS_TO_MAIN = [ < 8010.9100, -7377.7300, -8080 >, < 8058.7000, -7452.4100, -8080 >, < 8082, -7524.8000, -8080 >, < 8020, -7607, -8080 > ]
    array<vector> MAIN_TO_INSTALLED = [ < 8020, -7607, -8080 >, < 8086.9400, -7490.3000, -8080 >, < 8093.8900, -7461.2900, -8080 >, < 8093.4000, -7460.4700, -8108.8000 > ]
    array<vector> INSTALLED_TO_MAIN = [ < 8093.4000, -7460.4700, -8108.8000 >, < 8093.8900, -7461.2900, -8080 >, < 8086.9400, -7490.3000, -8080 >, < 8020, -7607, -8080 > ]
} CameraMovementArrays

entity loottick
entity dummyEnt
entity modsdropship
entity loot_drone
entity loot_sphere
entity cam_mover

global bool IsLootTickRunning = false
bool loot_drone_moving = false
entity menucamera = null

void function Cl_LobbyVM_Init()
{
    AddCallback_EntitiesDidLoad( LobbyVM_EntitiesDidLoad )
}

void function LobbyVM_EntitiesDidLoad()
{
	StartParticleEffectInWorld( GetParticleSystemIndex( $"P_fire_med_FULL" ), < 8488, -7203, -8129 >, <0, 0, 0> )
    MapEditor_CreateProp( $"mdl/menu/coin.rmdl", < 8033.1500, -7369.0700, -8104.0800 >, < 10.4035, 43.3066, 0.8356 >, true, 50000, -1, 0.5 )
    loot_sphere = MapEditor_CreateProp( $"mdl/props/loot_sphere/loot_sphere.rmdl", < 8704.4360, -7228.1640, -8071.3800 >, < 0, 23.6729, -90 >, true, 50000, -1, 0.5 )
    loot_drone = MapEditor_CreateProp( $"mdl/props/loot_drone/loot_drone.rmdl", < 8707.1040, -7230.1200, -8048.7000 >, < 0, 145.2767, 0 >, true, 50000, -1, 0.5 )
    int trailFXHandle = StartParticleEffectOnEntity( loot_drone, GetParticleSystemIndex( LOOT_DRONE_FX_TRAIL ), FX_PATTACH_POINT_FOLLOW, loot_drone.LookupAttachment( LOOT_DRONE_FX_ATTACH_NAME ) )
    loottick = MapEditor_CreateProp( $"mdl/robots/drone_frag/drone_frag_loot.rmdl", < 8115, -7497, -8129 >, < 0, 0, 0 >, true, 50000, -1, 0.5 )
    MapEditor_CreateProp( $"mdl/props/global_access_panel_button/global_access_panel_button_console_w_stand.rmdl", < 7973.2000, -7454.1000, -8129 >, < 0, 40.4603, 0 >, true, 50000, -1, 0.5 )
    MapEditor_CreateProp( $"mdl/props/death_box/death_box_01.rmdl", < 8115, -7457, -8117 >, < 0, 90, 0 >, true, 50000, -1, 0.5 )
    MapEditor_CreateProp( $"mdl/props/death_box/death_box_01.rmdl", < 8125, -7457, -8129 >, < 0, 30, 0 >, true, 50000, -1, 0.5 )
    MapEditor_CreateProp( $"mdl/props/death_box/death_box_01.rmdl", < 8100, -7457, -8129 >, < 0, -60, 0 >, true, 50000, -1, 0.5 )
    dummyEnt = MapEditor_CreateProp( $"mdl/humans/class/medium/pilot_medium_bloodhound.rmdl", < 8090, -7457, -8129 >, < 0, -45, 0 >, true, 50000, -1, 0.5 )
    thread PlayAnim( dummyEnt, "mp_pt_medium_training_blood_intro_idle" )
    modsdropship = MapEditor_CreateProp( $"mdl/vehicle/goblin_dropship/goblin_dropship.rmdl", < 8000, -7357, -8129 >, < 0, 120, 0 >, true, 50000, -1, 0.5 )
    thread PlayAnim( modsdropship, "s2s_rampdown_idle" )

    //hide until common_sdk release
    //entity marvin = MapEditor_CreateProp( $"mdl/robots/marvin/marvin.rmdl", < 7981.4400, -7468.0510, -8128.7000 >, < 0, 120, 0 >, true, 50000, -1, 0.5 )
    //thread PlayAnim( marvin, "mv_idle_unarmed" )

    MapEditor_CreateProp( $"mdl/props/kunai/kunai.rmdl", < 8126.8400, -7466.8300, -8115.9200 >, < 0, 0, 0 >, true, 50000, -1, 0.5 )
    MapEditor_CreateProp( $"mdl/props/tablet/tablet_mini.rmdl", < 8093.8900, -7460.6300, -8115.8200 >, < 0, 0, 0 >, true, 50000, -1, 1 )
    MapEditor_CreateProp( $"mdl/props/skull/skull_gladcard.rmdl", < 8105.6000, -7461.5700, -8101.7400 >, < 0, -137.0601, 0 >, true, 50000, -1, 0.5 )
    MapEditor_CreateProp( $"mdl/props/caustic_flask/caustic_flask.rmdl", < 8122.8400, -7457.3100, -8103.4300 >, < 0, -132.0102, 0 >, true, 50000, -1, 0.5 )
    //MapEditor_CreateProp( $"mdl/props/charm/charm_r5r.rmdl", < 8039.3000, -7462.5800, -8060.5200 >, < 0, 200.3317, -28.5662 >, true, 50000, -1, 10 )
    MapEditor_CreateProp( $"mdl/vehicle/droppod_fireteam/droppod_fireteam.rmdl", < 8488, -7203, -8113 >, < 8.8820, 0, -28.0421 >, true, 50000, -1, 0.5 )
}

void function ModsPanelShown(entity cameraTarget)
{
    if(IsValid(cam_mover)) {
        menucamera.ClearParent()
        cam_mover.Destroy()
    }

    if(IsValid(cameraTarget))
        menucamera = cameraTarget
    
    if(IsLootTickRunning)
        IsLootTickRunning = false
        
    loottick.SetModel( GRXPack_GetTickModel( GetItemFlavorByHumanReadableRef( "pack_cosmetic_rare" ) ) )
	loottick.SetSkin( loottick.GetSkinIndexByName( GRXPack_GetTickModelSkin( GetItemFlavorByHumanReadableRef( "pack_cosmetic_rare" ) ) ) )

    if(IsValid(loottick))
        thread PlayLoottickOpenAnim()

    if(!loot_drone_moving)
        if(IsValid(loot_sphere) && IsValid(loot_drone))
            thread PlayLootDroneAnim()
}

void function PlayLootDroneAnim()
{
    loot_drone_moving = true
    Wait(RandomFloatRange( 0.5, 5.0 ))
    float waittime = RandomFloatRange( 10.0, 20.0 )

    loot_sphere.SetParent( loot_drone )
    loot_drone.SetOrigin(< 8707.1040, -7230.1200, -8048.7000 >)

    entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", < 8707.1040, -7230.1200, -8048.7000 >, < 0, 145.2767, 0 > )
    loot_drone.SetParent( mover )
    mover.NonPhysicsMoveTo( < 7426, -6343, -8049 >, waittime, 0, 0 )

    wait waittime

    //Reset Lootdrone without having trail FX shoot arcross the screen
    loot_drone.SetOrigin( < 7426, -6343, 0 >)
    WaitFrame()
    loot_drone.SetOrigin(< 8707.1040, -7230.1200, 0>)
    WaitFrame()
    loot_drone.SetOrigin(< 8707.1040, -7230.1200, -8048.7000 >)

    loot_drone_moving = false
}

void function PlayLoottickOpenAnim()
{
    waitthread PlayAnim( loottick, "sd_closed_to_open" )
    thread PlayAnim( loottick, "sd_search_idle" )
    
    thread StartLootTickLights()
}

void function StartLootTickLights()
{
    IsLootTickRunning = true
    while(IsLootTickRunning)
    {
        array<string> eyes = ["FX_L_EYE","FX_R_EYE","FX_C_EYE"]
        foreach(string eye in eyes)
        {
            //Code copied from lootticks fx funtion
            int rarity  = 0
            int randInt = RandomInt( 1000 )

            if ( randInt > 995 )
                rarity = 4
            if ( randInt > 970 )
                rarity = 3
            else if ( randInt > 900 )
                rarity = 2
            else if ( randInt > 600 )
                rarity = 1

            int eyenum = RandomIntRange( 0, 2 )
            int attachID = loottick.LookupAttachment( eye )
            int fxIndex = StartParticleEffectOnEntity( loottick, GetParticleSystemIndex( $"P_loot_tick_beam_idle_flash" ), FX_PATTACH_POINT_FOLLOW, attachID )
            EffectSetControlPointVector( fxIndex, 1, GetFXRarityColorForUnlockable( rarity ) )

            wait 0.2
        }
    }
}

entity function MapEditor_CreateProp(asset a, vector pos, vector ang, bool mantle = false, float fade = 5000, int realm = -1, float scale = 1)
{
	entity e = CreateClientSidePropDynamic(pos,ang,a)
	e.SetScriptName("editor_placed_prop")
    e.SetModelScale( scale )
	return e
}

void function DefaultToBrowseMods()
{
    array<vector> nodes = GetAllPointsOnBezier( CameraMovementArrays.MAIN_TO_MODS, CAMERA_SMOOTH_STEPS)
    thread MoveModsCamera( nodes, < 8, 74, 0 >, < 0, 0.90, 0 >, false )
}

void function BrowseModsToDefault()
{
    array<vector> nodes = GetAllPointsOnBezier( CameraMovementArrays.MODS_TO_MAIN, CAMERA_SMOOTH_STEPS)
    thread MoveModsCamera( nodes, <8, 120, 0>, < 0, 0.90, 0 >, true )
}

void function DefaultToInstalledMods()
{
    array<vector> nodes = GetAllPointsOnBezier( CameraMovementArrays.MAIN_TO_INSTALLED, CAMERA_SMOOTH_STEPS )
    thread MoveModsCamera( nodes, < 8, 74, 0 >, < 1.64, 0.32, 0 >, false )
}

void function InstalledModsToDefault()
{
    array<vector> nodes = GetAllPointsOnBezier( CameraMovementArrays.INSTALLED_TO_MAIN, CAMERA_SMOOTH_STEPS )
    thread MoveModsCamera( nodes, < 90, 90, 0 >, < 1.64, 0.32, 0 >, true )
}

void function MoveModsCamera(array<vector> nodes, vector startAngles, vector rotateAngles, bool minus)
{
    if(!IsValid(menucamera))
        return
    
    if(!IsValid(cam_mover)) {
        cam_mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", menucamera.GetOrigin(), menucamera.GetAngles() )
        menucamera.SetParent( cam_mover )
    }

    vector angles = startAngles
    foreach(vector node in nodes)
    {
        switch(minus) {
            case true:
                angles -= rotateAngles
                break;
            case false:
                angles += rotateAngles
                break;
        }

        cam_mover.NonPhysicsMoveTo( node, 0.3, 0.0, 0.3 )
        cam_mover.NonPhysicsRotateTo( angles, 0.3, 0.0, 0.3 )
        wait 0.005
    }
}
