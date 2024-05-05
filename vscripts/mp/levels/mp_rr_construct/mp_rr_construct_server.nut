global function CodeCallback_MapInit
global function CloakLoopFunny
global function StartRain
global function TestSlidingDoor

void function CodeCallback_MapInit()
{
	printl("[Construct] Server : MapInit")
    Construct_MapInit_Common()
}

void function TestSlidingDoor()
{
    entity door = CreateEntity( "prop_dynamic" )
    door.SetScriptName( "survival_door_sliding" )
    door.SetValueForModelKey( $"mdl/door/door_canyonlands_large_01_animated.rmdl" )
    door.SetOrigin( gp()[0].GetOrigin() )
    door.SetAngles( <0,180,0> )
    DispatchSpawn( door )
}

void function StartRain()
{
	thread (void function() {

		float offset = 1000
		array<entity> fxarray = []

        foreach(entity fxpoint in GetErray("gm_construct_fx_rain"))
        {
            fxarray.append(PlayLoopFXOnEntity( $"P_weather_rain_old" , fxpoint , "" ))
            DebugDrawCylinder( fxpoint.GetOrigin() , < -90, 0, 0 >, 500, -4000, 0, 165, 255, false, 30 )
        }
        wait 30
        foreach(entity fx in fxarray)
            fx.Destroy()
	}) ()
}

void function CloakLoopFunny()
{
    Assert( !IsNewThread(), "Must be threaded" )
    while( true )
    {
        foreach( entity p in GetPlayerArray() )
        {
            if( !IsCloaked( p ) )
            {
                EnableCloakForever( p )
                wait 4
            }
            if( p.GetVelocity() != <0,0,0> && IsCloaked( p ) )
                p.SetCloakFlicker( 0.5, 0.1 )
        }
        WaitFrame()
    }
}


