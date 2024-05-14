
global function GetErray
global function RGBToVector
global function DEV_GetCascadeLight

#if CLIENT
global function CreateBlenderLight
#endif

#if SERVER
global function ErrayDisable
global function ErrayEnable
global function ErraySkinGlobal
global function HighlightDecoy
global function ScaleBoundingBox
global function ClearHighlight
global function CreateParticle
global function CreateParticleOnEntity
global function CreateParticleInSkybox
global function LoopFXOnEntity

global function CreateDoorFromDynamicProp

global function CreateSkyFall
global function CreateResetTeleport
global function CreateBoundsTrigger
global function CreateWater
global function DebugEffectNuke

global function CreateDynamicZipLine
global function CreateDynamicZipLineOnEntities
global function CreateZipRailFromErray
global function CreateGroundMedKit
global function SpawnCustomRacks
global function SpawnEquipment

global function SetUpMapButtons
global function SpawnNessyBomber
global function CreateConstructDummy
global function CreateConstructTreasureTick
global function CreateConstructSpider
global function CreateConstructInfected
global function CreateBird
global function CreateFrProwler
global function CreateFrMarvin
global function CreateFrSpectre
global function CreateFrTurret
global function CreateFrDrone
global function CreateFrGunship
global function CreateConstructPilot
#endif

global struct HoverShipData
{
    entity MainBody = null,
    array<string> PropErrays = [],
    string DecoyErray = "invalid",
    array<string> DecoyAnims = []

    array<asset> Fx_Attach = [],
    array<asset> Fx = [],
}

global enum TagToWeaponClass
{
	pistol = 0,
	assault = 1,
	shotgun = 2,
	lmg = 3,
	sniper = 4,
	smg = 5,
	launcher = 6,
    unused1 = 7,
    unused2 = 8,
    marksman = 9
}


array<entity> function GetErray( string name )
{
   return GetEntArrayByScriptName( name )
}

vector function RGBToVector(vector RGB){ return <(RGB.x/255.0),(RGB.y/255.0),(RGB.z/255.0)> }


entity function DEV_GetCascadeLight()
{
    #if CLIENT
    return GetLightEnvironmentEntity()
    #elseif SERVER
    return GetEnt("env_cascade_light")
    #endif
}

#if SERVER
void function DebugEffectNuke(bool zipline = true)
{
    entity p0 = GetPlayerArray()[0]

    entity ball_zip = CreatePropDynamic( $"mdl/dev/empty_model.rmdl", p0.GetOrigin() + <0, 0, 700>, p0.GetAngles() )

    entity ball = CreateEntity( "prop_physics" )
    {
        WaitFrame()
        ball.SetValueForModelKey( $"mdl/weapons/grenades/m20_f_grenade_projectile.rmdl" )
        //ball.SetModelScale( 4 )
        ball.SetOrigin( p0.GetOrigin() + <0,0,50>)
        //ball.kv.renderamt = 255
        //ball.kv.rendermode = 3
        //ball.kv.rendercolor = "255 255 255 0"
        DispatchSpawn( ball )
        //ball.SetModelScale( 4 )

    }

    if(!zipline)
        return

    array<entity> ziplines = CreateDynamicZipLineOnEntities( ball_zip, ball, false)

    ziplines[0].kv.Material = "cable/zipline.vmt"
    foreach(entity zip in ziplines)
    {
        zip.kv.Collide = 1
        zip.kv.Barbed = 1
        zip.kv.Type = 0
        //zip.kv.MoveSpeed = 64
        zip.kv.Slack = 25
        zip.kv.Subdiv = 100
        //zip.kv.Width = 10
        //zip.kv.TextureScale = 1
        //zip.kv.PositionInterpolator = 2
        //zip.kv.Zipline = 1
        //zip.kv.ZiplineAutoDetachDistance = "150"
        //zip.kv.ZiplineSagEnable = "0"
        //zip.kv.ZiplineSagHeight = "50"
    }

    thread function() : ( ball , ball_zip )
    {
        while( IsValid( ball ) && IsValid( ball_zip ) )
        {
            if(Distance( ball_zip.GetOrigin() , ball.GetOrigin() ) >= 800)
            {
                vector angles = ball_zip.GetAngles() - ball.GetAngles()
                vector velocity = ball_zip.GetOrigin() - ball.GetOrigin()

                velocity = velocity + angles

                ball.SetVelocity( velocity * 1 )
            }

            WaitFrame()
        }
    } ()
}
#endif

#if CLIENT
    entity function CreateBlenderLight(vector origin, vector angles , vector RGB , float brightness, float radius , float distance, float exponent)
    {
        entity e = CreateClientSideDynamicLight( origin, angles , RGBToVector( RGB ), brightness )
        e.SetLightExponent( exponent );e.SetLightRadius(radius)
        e.kv.distance = distance
        return e
    }
#endif

#if SERVER
    void function ErrayDisable( string earray , bool collision = false ,bool remove = false) {
        foreach( e in GetErray(earray) )
        {
            if(remove)
            {
                e.Destroy()
                continue
            }

            e.MakeInvisible()

            if(collision)
                e.SetCollisionAllowed(false)
        }
    }

    void function ErrayEnable( string earray ) {
        foreach( e in GetErray(earray) ) { e.MakeVisible() ; e.SetCollisionAllowed(true) }
    }

    void function ErraySkinGlobal( string earray, int index ) {
        foreach( e in GetErray(earray) )
            e.SetSkin(index)
    }

    void function SpinRotateEntity( entity Ent , float Direction = 4)
    {
        while( IsValid( Ent ) )
        {
            if(Ent.GetAngles().y == -360)
                Ent.SetAngles( <0,0,0> )
            else
                Ent.SetAngles( Ent.GetAngles() + <0,Direction,0> )
            WaitFrame()
        }
    }

    void function MakeObjectUsable(entity ent, string Text)
    {
        ent.SetUsable()
        ent.SetUsableByGroup("pilot")
        ent.SetUsePrompts(Text, Text)
    }

    void function HighlightDecoy( entity ent , vector RGB = ZERO_VECTOR)
    {
        Highlight_SetNeutralHighlight( ent , "decoy_prop" )

        if(RGB != ZERO_VECTOR)
            ent.Highlight_SetParam( 0, 0, RGB / 255 )
    }

    void function ClearHighlight(entity ent)
    {
        Highlight_ClearNeutralHighlight( ent )
    }

    void function ScaleBoundingBox(entity ent,float scale = 1)
    {
        if(scale == 1)
            ent.SetBoundingBox( ent.GetBoundingMins() * ent.GetModelScale(), ent.GetBoundingMaxs() * ent.GetModelScale() )
        else ent.SetBoundingBox( ent.GetBoundingMins() * scale, ent.GetBoundingMaxs() * scale )
    }

    // Other Functions

    entity function CreateParticle( asset FX, vector Origin, vector Angles ) {
        entity trailFXHandle = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex(FX), Origin, Angles)
        trailFXHandle.FXEnableRenderAlways()
        return trailFXHandle
    }

    entity function CreateParticleOnEntity( asset FX, entity ent ) {
        entity trailFXHandle = StartParticleEffectInWorld_ReturnEntity(GetParticleSystemIndex(FX), ent.GetOrigin(), ent.GetAngles())
        trailFXHandle.SetParent(ent)
        trailFXHandle.kv.renderamt = 100; trailFXHandle.kv.rendermode = 3
        return trailFXHandle
    }

    entity function CreateParticleInSkybox( asset FX , vector Origin, vector Angles, float time = -1)
    {
        entity particle = CreateEntity( "info_particle_system" )
        {
            particle.SetValueForEffectNameKey( FX )
            particle.kv.start_active = 1
            particle.kv.VisibilityFlags = 7
            particle.kv.warmup_time = 0
            particle.kv.warmup_and_pause = 0
            particle.kv.in_skybox = 1
            DispatchSpawn( particle )
        }

        particle.SetAngles( Angles )
        particle.SetOrigin( GetEnt("skybox_cam_level").GetOrigin() + Origin )

        if(time != -1)
        {
            thread function() : ( particle, time )
            {
               wait time
               particle.Destroy()
            } ()
        }

        return particle
    }

    void function LoopFXOnEntity( entity ent , asset fxname , float loop_speed , vector offset = ZERO_VECTOR , int loop_count = -1)
    {
       Assert( !IsNewThread(), "Must be threaded" )

       int looped = 0
       while (IsValid(ent))
       {
            if( loop_count != -1 && looped > loop_count)
                break

            entity fx = PlayFXOnEntity( fxname, ent )
            fx.SetOrigin(fx.GetOrigin() + offset)
            wait loop_speed

            if( loop_count != -1 )
              looped++

            if(IsValid(fx))
                fx.Destroy()
       }
    }

    entity function CreateDoorFromDynamicProp( entity prop )
    {
        string doortype = "survival_door_model"
        switch ( prop.GetModelName() )
        {
            case "mdl/door/door_104x64x8_generic_left_animated.rmdl":
            case "mdl/door/door_108x60x4_generic_right_animated.rmdl":
            case "mdl/door/door_104x64x8_generic_both_animated.rmdl":
            case "mdl/door/door_256x256x8_elevatorstyle02_animated.rmdl":
            case "mdl/door/door_canyonlands_large_01_animated.rmdl":
                doortype = "survival_door_sliding"
            case "mdl/door/canyonlands_door_single_02.rmdl":
                doortype = "survival_door_plain"
                break

            default:
                return prop
        }

	    entity door = CreateEntity( "prop_dynamic" )
        {
            door.SetValueForModelKey( prop.GetModelName() )
            door.SetOrigin( prop.GetOrigin() )
            door.SetAngles( prop.GetAngles() )
            door.SetScriptName( doortype )

            DispatchSpawn( door )
        }

        prop.Destroy()

        return door
    }
#endif


// C8888D C8888D C8888D C8888D C8888D C8888D C8888D
//
// d888888b d8888b. d888888b  d888b   d888b  d88888b d8888b. .d8888.
// `~~88~~' 88  `8D   `88'   88' Y8b 88' Y8b 88'     88  `8D 88'  YP
//    88    88oobY'    88    88      88      88ooooo 88oobY' `8bo.
//    88    88`8b      88    88  ooo 88  ooo 88~~~~~ 88`8b     `Y8b.
//    88    88 `88.   .88.   88. ~8~ 88. ~8~ 88.     88 `88. db   8D
//    YP    88   YD Y888888P  Y888P   Y888P  Y88888P 88   YD `8888Y'
//
//
// C8888D C8888D C8888D C8888D C8888D C8888D C8888D
#if SERVER
void function CreateSkyFall( entity ent, float radius = 80, bool debugdraw = false)
    {
        // Create Trigger
        entity trigger = CreateEntity("trigger_cylinder")
        {
            trigger.SetRadius( radius )
            trigger.SetAboveHeight( 0 )
            trigger.SetBelowHeight( 600 )
            trigger.SetOrigin( ent.GetOrigin() )
            trigger.SetParent( ent )
            trigger.SetEnterCallback( SkyfallTriggerEnter )

            // Deploy Trigger
            DispatchSpawn(trigger)
        }

        if (debugdraw)
        {
            DebugDrawCylinder( trigger.GetOrigin() , < -90, 0, 0 >, radius, trigger.GetAboveHeight(), 0, 165, 255, true, 9999.9 )
            DebugDrawCylinder( trigger.GetOrigin() , < -90, 0, 0 >, radius, -trigger.GetBelowHeight(), 255, 90, 0, true, 9999.9 )
        }
    }

    void function SkyfallTriggerEnter( entity trigger, entity ent )
    {
        if( !IsValid(ent) || !ent.IsPlayer() || ent.GetPhysics() == MOVETYPE_NOCLIP )
            return

        if( ent.Player_IsFreefalling() )
            return

        thread PlayerSkydiveFromCurrentPosition( ent )
    }

    entity function CreateResetTeleport( vector origin , vector angles = ZERO_VECTOR, float radius = 400, bool debugdraw = false)
    {
        entity trigger = CreateEntity("trigger_cylinder")
        {
            trigger.SetRadius( radius )
            trigger.SetAboveHeight( 0 )
            trigger.SetBelowHeight( 600 )
            trigger.SetOrigin( origin )
            trigger.SetAngles( angles )

            trigger.SetEnterCallback( void function ( entity trigger, entity ent )
            {
                if( !IsValid(ent) || !ent.IsPlayer() || ent.GetPhysics() == MOVETYPE_NOCLIP)
                    return

                entity start = GetEnt("info_player_start")

                ent.SetOrigin( start.GetOrigin()  + <0,0,80>)
                ent.SetAngles( start.GetAngles())
            } )

            // Deploy Trigger
            DispatchSpawn( trigger )
        }

        if ( debugdraw )
        {
            DebugDrawCylinder( trigger.GetOrigin() , < -90, 0, 0 >, radius, trigger.GetAboveHeight(), 0, 165, 255, true, 9999.9 )
            DebugDrawCylinder( trigger.GetOrigin() , < -90, 0, 0 >, radius, -trigger.GetBelowHeight(), 255, 90, 0, true, 9999.9 )
        }

        return trigger
    }

    entity function CreateBoundsTrigger( vector origin , float radius = 30000 , float Height = 2000, int type = 0, bool debugdraw = false)
    {
        // Set up the trigger
        entity trigger = CreateEntity( "trigger_cylinder" )
        {
            trigger.SetRadius( radius )
            trigger.SetAboveHeight( 0 )
            trigger.SetBelowHeight( Height )
            trigger.SetOrigin( origin )
            trigger.SetEnterCallback(  BoundsTriggerEnter )
        }

        switch(type)
        {
            case 1: // kill zone
            trigger.SetScriptName("WallTrigger_Killzone")
            trigger.SetAboveHeight( 350 )
            break
            case 2: // out of bounds
            trigger.SetScriptName("WallTrigger_oob_timer")
            trigger.SetAboveHeight( 2350 )
            break
            case 3: // skyfall
            trigger.SetScriptName("WallTrigger_skyfall")
            trigger.SetEnterCallback( SkyfallTriggerEnter )
            break
        }

        if (debugdraw) // draw trigger bounds if needed
        {
            DebugDrawCylinder( trigger.GetOrigin() , < -90, 0, 0 >, radius, trigger.GetAboveHeight(), 0, 165, 255, true, 9999.9 )
            DebugDrawCylinder( trigger.GetOrigin() , < -90, 0, 0 >, radius, -trigger.GetBelowHeight(), 255, 90, 0, true, 9999.9 )
        }

        // deploy the trigger
        DispatchSpawn( trigger )

        return trigger
    }

    void function BoundsTriggerEnter( entity trigger , entity ent )
    {
        if ( IsValid(ent) && ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP) // ensure the entity is valid
        {
            ent.Zipline_Stop()

            switch( trigger.GetScriptName() )
            {
                case "WallTrigger_Killzone":
                    ent.TakeDamage(ent.GetMaxHealth() + 1, null, null, { damageSourceId=damagedef_suicide, scriptType=DF_BYPASS_SHIELD })
                break

                case "WallTrigger_oob_timer":
                    EntityOutOfBounds( trigger, ent, null, null )
                break

                default:
                    vector lookDir = ent.GetSmoothedVelocity()
                    vector pushBackVel = lookDir * 2.5

                    printl( LengthSqr( lookDir ) + " / " + ent.GetSmoothedVelocity() )
                    if( LengthSqr( lookDir ) >= 320000)
                        pushBackVel = lookDir / 1.5

                    vector targetDir = ent.GetWorldSpaceCenter() - trigger.GetWorldSpaceCenter()
                    if ( DotProduct( lookDir, targetDir ) < 0 )
                        pushBackVel = -pushBackVel

                    ent.KnockBack( pushBackVel, 0.3 )
                    return
                break
            }

            ent.DisableWeapon()

            StatusEffect_AddEndless( ent, eStatusEffect.hunt_mode_visuals, 100 )
            StatusEffect_AddEndless( ent, eStatusEffect.move_slow, 0.2 )

            thread function() : ( trigger, ent )
            {
                while( IsValid(ent) && trigger.IsTouching( ent ) )
                    WaitFrame()

                if( IsValid(ent) )
                {
                    EntityBackInBounds( trigger, ent, null, null )
                    ent.EnableWeapon()

                    StatusEffect_StopAllOfType( ent, eStatusEffect.hunt_mode_visuals)
                    StatusEffect_StopAllOfType( ent, eStatusEffect.minimap_jammed)
                    StatusEffect_StopAllOfType( ent, eStatusEffect.move_slow)
                }
            }()

        }
    }
#endif

// C8888D C8888D C8888D C8888D C8888D C8888D C8888D
//
// db   d8b   db  .d8b.  d888888b d88888b d8888b.
// 88   I8I   88 d8' `8b `~~88~~' 88'     88  `8D
// 88   I8I   88 88ooo88    88    88ooooo 88oobY'
// Y8   I8I   88 88~~~88    88    88~~~~~ 88`8b
// `8b d8'8b d8' 88   88    88    88.     88 `88.
//  `8b8' `8d8'  YP   YP    YP    Y88888P 88   YD
//
//  Params: vector origin, float radius, float BelowHeight, float AboveHeight, bool debugdraw
//  Usage : CreateWater( <35210,9000,-19050> , 3000 , 800 , 0 ,false )
//
#if SERVER
    void function CreateWater(vector origin = <0,0,0>, float radius = 3000, float BelowHeight = 0, float AboveHeight = 800, bool debugdraw = true)
    {
        entity water_trigger = CreateEntity("trigger_cylinder")
        water_trigger.SetRadius(radius)
        water_trigger.SetAboveHeight(AboveHeight)
        water_trigger.SetBelowHeight(BelowHeight)
        water_trigger.SetOrigin(origin)

        // Trigger Callbacks
        water_trigger.SetEnterCallback( WaterTriggerEnter )
        water_trigger.SetLeaveCallback( WaterTriggerLeave )

        // Debug Draw
        if (debugdraw)
        {
            DebugDrawCylinder( water_trigger.GetOrigin() , < -90, 0, 0 >, radius, water_trigger.GetAboveHeight(), 0, 0, 255, true, 9999.9 )
            DebugDrawCylinder( water_trigger.GetOrigin() , < -90, 0, 0 >, radius, -water_trigger.GetBelowHeight(), 0, 0, 255, true, 9999.9 )
        }

        // deploy
        DispatchSpawn(water_trigger)
        printl("[Construct] Water created at " + origin)
    }

    void function WaterTriggerEnter(entity trigger, entity ent)
    {
        EmitSoundOnEntity( ent, "player_enter_water" )

        if( ent.IsPlayer() )
        {
            ent.DisableWeapon()
            ent.SetPlayerNetInt("tutorialContext", 1)
        }
        else if( ent.IsNPC() )
        {
            //GetAllActiveWeapons()[0].AllowUse(false)
        }

        StatusEffect_AddEndless( ent, eStatusEffect.speed_boost, 0.1 )

        thread function() : ( trigger, ent )
        {
           //int		i;
           //vector	wishvel;
           //float	wishspeed;
           //vector	wishdir;
           //vector	start, dest;
           //vector  temp;
           //// trace_t	pm;
           //float speed, newspeed, addspeed, accelspeed;
           //vector forward, right, up;

           //const float m_flClientMaxSpeed = 300;

           //while( IsValid(ent) && trigger.IsTouching( ent ) && ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP)
           //{
           //    vector angles = FlattenAngles( VectorToAngles(  ent.GetViewVector() ) )
           //    forward = AnglesToForward( angles )
           //    right = AnglesToRight( angles )
           //    up = AnglesToUp( angles )

	       //    // if we have the jump key down, move us up as well
	       //    if (ent.IsInputCommandHeld( IN_JUMP ))
	       //    	wishvel.z += m_flClientMaxSpeed;

           //    else if (forward != ZERO_VECTOR && right != ZERO_VECTOR && up != ZERO_VECTOR)
           //    {
           //        wishvel.z -= 60;		// drift towards bottom
           //    }
           //    else  // Go straight up by upmove amount.
           //    {
           //        // exaggerate upward movement along forward as well
           //        float upwardMovememnt = forward * <0,0,forward.z *forward.z> * 2;
           //        upwardMovememnt = clamp( upwardMovememnt, 0, m_flClientMaxSpeed );
           //        wishvel.z += up + upwardMovememnt;
           //    }

           //    ent.SetVelocity(wishvel)
           //    WaitFrame()
           //   // vector wishvel = forward + right[i]*mv->m_flSideMove;
           //}

            while( IsValid(ent) && trigger.IsTouching( ent ) )
            {
                if(ent.IsPlayer() && ent.GetPhysics() != MOVETYPE_NOCLIP)
                {
                    if(ent.IsCrouched())
                        ent.kv.gravity = -0.1
                    else
                        ent.kv.gravity = -0.35
//
                } else ent.kv.gravity = -0.35
//
                wait 0.01
            }
        }()

    }

    void function WaterTriggerLeave(entity trigger, entity ent)
    {
        // water leave sound
        EmitSoundOnEntity( ent, "player_leave_water" )

        StopSoundOnEntity( ent, "Canyonlands_Generic_Emit_WaterLaps_Calm_A" )

        if( ent.IsPlayer() )
        {
            ent.EnableWeapon()
            ent.SetPlayerNetInt("tutorialContext", -1)
        }
        else if( ent.IsNPC() )
        {
            //GetAllActiveWeapons()[0].AllowUse(false)
        }

        ent.kv.gravity = 1

        StatusEffect_StopAllOfType( ent, eStatusEffect.speed_boost )
    }
#endif

//
// C8888D C8888D C8888D C8888D C8888D C8888D C8888D

//C8888D C8888D C8888D C8888D C8888D C8888D C8888D
//
// d88888D d888888b d8888b. db      d888888b d8b   db d88888b .d8888.
// YP  d8'   `88'   88  `8D 88        `88'   888o  88 88'     88'  YP
//    d8'     88    88oodD' 88         88    88V8o 88 88ooooo `8bo.
//   d8'      88    88~~~   88         88    88 V8o88 88~~~~~   `Y8b.
//  d8' db   .88.   88      88booo.   .88.   88  V888 88.     db   8D
// d88888P Y888888P 88      Y88888P Y888888P VP   V8P Y88888P `8888Y'
//
// Params: vector StartOrigin, vector EndOrigin, bool LifelineCable
// Usage : CreateDynamicZipLine( <0,0,0> , <0,0,-500>, false)
//
// Params: entity PrimaryEnt, entity SecondaryEnt, bool LifelineCable
// Usage : CreateDynamicZipLineOnEntities( PrimaryEnt, SecondaryEnt, false)
//
#if SERVER
    array <entity> function CreateDynamicZipLine( vector StartOrigin, vector EndOrigin, bool LifelineCable = false )
    {
        // Create Entities
        entity zip_start = CreateEntity("zipline")
        entity zip_end = CreateEntity("zipline_end")

        // Set Positions
        zip_start.SetOrigin(StartOrigin)
        zip_end.SetOrigin(EndOrigin)

        // Set Properties
        zip_start.kv.ZiplineAutoDetachDistance = "160"
        zip_end.kv.ZiplineAutoDetachDistance = "160"

        // Create Line
        zip_start.LinkToEnt(zip_end)

        // Set Choosen Rope Material
        if (!LifelineCable)
            zip_start.kv.Material = "cable/zipline.vmt"
        else
            zip_start.kv.Material = "models/cable/drone_medic_cable"

        // Deploy
        DispatchSpawn(zip_start);
        DispatchSpawn(zip_end)

        return [zip_start, zip_end]
    }

    array <entity> function CreateDynamicZipLineOnEntities(entity PrimaryEnt, entity SecondaryEnt, bool LifelineCable = false) {

        array<entity> Ziplines = CreateDynamicZipLine( PrimaryEnt.GetOrigin(), SecondaryEnt.GetOrigin(), LifelineCable )

        // Parent ZipLines to Entities
        Ziplines[0].SetParent( PrimaryEnt )
        Ziplines[1].SetParent( SecondaryEnt )

        return Ziplines
    }


    array <entity> function CreateZipRailFromErray(string Erray , float forward = 0.0, bool LifelineCable = true)
    {
        array<entity> Nodes = GetErray(Erray)
        array<vector> NodePos = []

        foreach(node in Nodes)
        {
            NodePos.append( node.GetOrigin() + (node.GetForwardVector() * forward) )
            //node.Destroy()
        }

        Nodes.clear()
        //Nodes = MapEditor_CreateLinkedZipline(NodePos)

       //if(!LifelineCable)
       //    return Nodes

        foreach(node in Nodes)
            node.kv.Material = "models/cable/drone_medic_cable"

        return Nodes
    }


#endif
//
//C8888D C8888D C8888D C8888D C8888D C8888D C8888D

// C8888D C8888D C8888D C8888D C8888D C8888D C8888D
//
// .88b  d88. d88888b d8888b. db   dD d888888b d888888b
// 88'YbdP`88 88'     88  `8D 88 ,8P'   `88'   `~~88~~'
// 88  88  88 88ooooo 88   88 88,8P      88       88
// 88  88  88 88~~~~~ 88   88 88`8b      88       88
// 88  88  88 88.     88  .8D 88 `88.   .88.      88
// YP  YP  YP Y88888P Y8888D' YP   YD Y888888P    YP
//
//
//
//
//
// C8888D C8888D C8888D C8888D C8888D C8888D C8888D
#if SERVER
    const asset  MEDKITMDL = $"mdl/weapons_r5/loot/w_loot_wep_iso_health_main_large.rmdl"
    const asset  MEDKITFX  = $"survival_loot_pickup_Medkit_3P"
    const string MEDKITSFX  = "Lifeline_Drone_Healing_1P"

    struct MedkitData
    {
       float healh_time
       float respawn_time
    }
    table< entity, MedkitData > MedkitObjects

    void function CreateGroundMedKit( vector Origin , vector Angles = ZERO_VECTOR , float healh_time = 3, float respawn_time = 10) {

        entity proxy = CreatePropDynamic( MEDKITMDL , Origin, Angles , SOLID_VPHYSICS, 15000)
        {
            proxy.SetModel( MEDKITMDL )
            proxy.kv.renderamt = 255
            proxy.kv.rendermode = 3
            proxy.kv.rendercolor = "255 255 255 200"
            proxy.NotSolid()
        }

        MedkitData structdata // init struct
        MedkitObjects[proxy] <- structdata
        MedkitObjects[proxy].healh_time = healh_time
        MedkitObjects[proxy].respawn_time = respawn_time

        for (int i = 0; i < 4; i++) {
            entity trailFXHandle = PlayLoopFXOnEntity( $"P_LL_med_drone_jet_ctr_loop" , proxy , "" )
            trailFXHandle.SetAngles( < 0, 0 + i * 90, 0 > )
            trailFXHandle.SetParent( proxy )
        }

        EmitSoundOnEntity( proxy , $"survival_loot_pickup_Medkit_3P")

        entity trigger = CreateEntity("trigger_cylinder")
        {
            trigger.SetOrigin( Origin )
            trigger.SetRadius(50)
            trigger.SetAboveHeight(60)
            trigger.SetBelowHeight(10)
            trigger.SetEnterCallback( MedkitTriggerEnter )
            DispatchSpawn( trigger )
        }

        trigger.SetParent( proxy )

        proxy.SetScriptName( "MedKit_Active" )

        float turnspeed = -4
        while( IsValid( proxy ) )
        {
            if(proxy.GetAngles().y == -360)
                proxy.SetAngles( <0,0,0> )
            else
                proxy.SetAngles( proxy.GetAngles() + <0,turnspeed,0> )
            WaitFrame()
        }
    }

    void function MedkitTriggerEnter(entity trigger, entity ent)
    {
        if(IsValid( ent ) && ent.IsPlayer() && trigger.GetParent().GetScriptName() != "MedKit_Disabled")
            thread __InternalMedkit( trigger , ent )
    }

    void function __InternalMedkit( entity trigger , entity ent )
    {
        entity medkit = trigger.GetParent()

        StatusEffect_AddTimed( ent , eStatusEffect.drone_healing, 1, 3, 5)
        EmitSoundOnEntity( ent , "Lifeline_Drone_Healing_1P")

        medkit.kv.rendercolor = "255 255 255 50"

        medkit.SetScriptName( "MedKit_Disabled" )

        wait MedkitObjects[medkit].healh_time

        ent.SetHealth( ent.GetMaxHealth() )

        if (EquipmentSlot_GetLootRefForSlot( ent , "armor") != "")
            ent.SetShieldHealth( ent.GetShieldHealthMax() )

        StopSoundOnEntity( ent , "Lifeline_Drone_Healing_1P")

        wait MedkitObjects[medkit].respawn_time

        array<vector> SpawnData = [ medkit.GetOrigin() , medkit.GetAngles() ]
        medkit.Destroy()

        CreateGroundMedKit( SpawnData[0] , SpawnData[1] )
    }

#endif
//
//C8888D C8888D C8888D C8888D C8888D C8888D C8888D

// C8888D C8888D C8888D C8888D C8888D C8888D C8888D
//
// db   d8b   db d88888b  .d8b.  d8888b.  .d88b.  d8b   db      d8888b.  .d8b.   .o88b. db   dD .d8888.
// 88   I8I   88 88'     d8' `8b 88  `8D .8P  Y8. 888o  88      88  `8D d8' `8b d8P  Y8 88 ,8P' 88'  YP
// 88   I8I   88 88ooooo 88ooo88 88oodD' 88    88 88V8o 88      88oobY' 88ooo88 8P      88,8P   `8bo.
// Y8   I8I   88 88~~~~~ 88~~~88 88~~~   88    88 88 V8o88      88`8b   88~~~88 8b      88`8b     `Y8b.
// `8b d8'8b d8' 88.     88   88 88      `8b  d8' 88  V888      88 `88. 88   88 Y8b  d8 88 `88. db   8D
//  `8b8' `8d8'  Y88888P YP   YP 88       `Y88P'  VP   V8P      88   YD YP   YP  `Y88P' YP   YD `8888Y'
//
// C8888D C8888D C8888D C8888D C8888D C8888D C8888D
#if SERVER
    const array <string> m_VanillaWeapons = [
        "mp_weapon_energy_ar", "mp_weapon_rspn101", "mp_weapon_hemlok", "mp_weapon_vinson", "mp_weapon_rspn101_og", // AR
        "mp_weapon_r97", "mp_weapon_alternator_smg", "mp_weapon_pdw" , "mp_weapon_volt_smg", "mp_weapon_car", // SMG
        "mp_weapon_esaw", "mp_weapon_lstar", "mp_weapon_lmg" , // "mp_weapon_mobile_hmg", // LMG
        "mp_weapon_sniper", "mp_weapon_g2", "mp_weapon_defender", "mp_weapon_dmr", "mp_weapon_doubletake", "mp_weapon_sentinel", // SNIPER
        "mp_weapon_3030", "mp_weapon_bow", // MARKSMAN
        "mp_weapon_energy_shotgun", "mp_weapon_mastiff", "mp_weapon_shotgun", "mp_weapon_shotgun_pistol", // SHOTGUN
        "mp_weapon_wingman", "mp_weapon_autopistol", "mp_weapon_semipistol" , "mp_weapon_smart_pistol", "mp_weapon_wingman_n" // PISTOL
        "mp_weapon_sniper", "mp_weapon_lstar", "mp_weapon_mastiff", "sp_weapon_arc_tool",  // SPECIAL
        "mp_weapon_softball", "mp_weapon_smr", "mp_weapon_epg", "mp_weapon_rocket_launcher",  // LAUNCHER
    ]

    array<string> SpawnedWeapons = []

    int function SpawnCustomRacks( vector Origin, vector Angles, vector direction, int weapontypeclass , bool gold_only = false) {

        array<LootData> CleanWeaponData = []

        foreach( LootData WeaponData in SURVIVAL_Loot_GetByType( eLootType.MAINWEAPON ) )
        {
            string WeaponClass = WeaponData.ref
            string WeaponTypeClass = WeaponData.lootTags[0]
            array<string> WeaponMods = WeaponData.baseMods

            bool IsVanilla = m_VanillaWeapons.find( WeaponClass ) > 0 || WeaponClass.find("_gold") != -1
            bool IsWeaponTypeCorrect = WeaponTypeClass == GetEnumString( "TagToWeaponClass", weapontypeclass )
            bool IsAlreadySpawned = SpawnedWeapons.find( WeaponClass ) != -1

            if( !IsVanilla || !IsWeaponTypeCorrect || IsAlreadySpawned)
                continue

            if( gold_only )
            {
                if( WeaponClass.find("_gold") == -1  || WeaponData.tier != 4 || WeaponMods.len() == 0 )
                    continue
            }
            else if (!gold_only && WeaponClass.find("_gold") != -1)
                continue

            SpawnedWeapons.append( WeaponClass ); CleanWeaponData.append( WeaponData )
        }

        for (int i = 0; i < CleanWeaponData.len(); i++)
        {
            vector Gen_Origin = Origin + < direction.x, direction.y + i * 16, direction.z >

            string ref = CleanWeaponData[i].ref

            entity rack = CreateWeaponRack( Gen_Origin , Angles , ref )
            thread OnPickupFromRackThread( GetWeaponFromRack( rack ), ref )

            {
                string ammoType = CleanWeaponData[i].ammoType
                if (ammoType == "")
                    continue

                int ammoStack = SURVIVAL_Loot_GetLootDataByRef(ammoType).countPerDrop * 4
                entity ammo = SpawnGenericLoot(ammoType, Gen_Origin + < 32, 0, 0 > , < 0, 90, 0 > , ammoStack)
                thread OnPickupGenericThread(ammo, ammoType, ammoStack)
            }
        }

        return CleanWeaponData.len()
    }

    void function SpawnAdvancedRack( vector Origin, vector Angles, vector direction, int ammotype , bool gold_only = false) {

        array<LootData> CleanWeaponData = []

        foreach( LootData WeaponData in SURVIVAL_Loot_GetByType( eLootType.MAINWEAPON ) )
        {
            string WeaponClass = WeaponData.ref
            string WeaponType = WeaponData.lootTags[0]
            array<string> WeaponMods = WeaponData.baseMods

            bool IsVanilla = m_VanillaWeapons.find( WeaponClass ) > 0 || WeaponClass.find("_gold") != -1
            bool IsWeaponTypeCorrect = weaponClassToTag[WeaponType] == ammotype
            bool IsAlreadySpawned = SpawnedWeapons.find( WeaponClass ) != -1

            if( !IsVanilla || !IsWeaponTypeCorrect || IsAlreadySpawned)
                continue

            if( gold_only )
            {
                if( WeaponClass.find("_gold") == -1 )
                    continue

                if( WeaponData.tier != 4 )
                    continue

                if( WeaponMods.len() == 0 )
                    continue
            }
            else if (!gold_only && WeaponClass.find("_gold") != -1)
                continue

            SpawnedWeapons.append( WeaponClass ); CleanWeaponData.append( WeaponData )
        }



        //for (int i = 0; i < CleanWeaponData.len(); i++) {
//
        //    vector Gen_Origin = Origin + < direction.x, direction.y + i * 10, direction.z >
//
        //    entity rack = CreateWeaponRack( Gen_Origin , Angles , CleanWeaponData[i].ref )
        //    thread OnPickupFromRackThread( GetWeaponFromRack( rack ), CleanWeaponData[i].ref )
//
        //    {
        //        string ammoType = CleanWeaponData[i].ammoType
        //        if (ammoType == "")
        //            continue
//
        //        int ammoStack = SURVIVAL_Loot_GetLootDataByRef(ammoType).countPerDrop * 4
        //        entity ammo = SpawnGenericLoot(ammoType, Gen_Origin + < 32, 0, 0 > , < 0, 90, 0 > , ammoStack)
        //        thread OnPickupGenericThread(ammo, ammoType, ammoStack)
        //    }
        //}
    }

    int function SpawnEquipment(vector Origin , int maxsteps = 5 , vector stepdir = <0,0,0> , int EquipmentType = eLootType.ARMOR , int tier = -1)
    {
        array<LootData> Data; array<string> Spawned;
        foreach(LootData LootData in SURVIVAL_Loot_GetByType( EquipmentType ))
        {
            if(Spawned.find(LootData.ref) != -1)
                continue

            if( tier != -1 )
                if( LootData.tier != tier )
                    continue

            Spawned.append( LootData.ref )
            Data.append( LootData )
        }

        int stepcount = 0
        for (int i = 0; i < Data.len(); i++) {
            if (stepcount > maxsteps)
            {
                Origin = Origin + stepdir
                stepcount = 0
            }
            LootData item = Data[i]
            vector pos = Origin + (stepcount * <0,30,0>)

            entity loot = SpawnGenericLoot(item.ref, pos, <0,0,0>, 1)
            thread OnPickupGenericThread(loot, item.ref)
            stepcount++
        }

        return Data.len()
    }

    // When the weapon is grabbed from the rack -> respawn it
    void function  OnPickupFromRackThread(entity item, string ref) {
        entity rack = item.GetParent()
        item.WaitSignal("OnItemPickup")

        wait FIRINGRANGE_RACK_RESPAWN_TIME

        entity newWeapon = SpawnWeaponOnRack(rack, ref)
        StartParticleEffectInWorld(GetParticleSystemIndex(FIRINGRANGE_ITEM_RESPAWN_PARTICLE), newWeapon.GetOrigin(), newWeapon.GetAngles())
        thread OnPickupFromRackThread(newWeapon, ref)

    }

    // When the item is grabbed -> respawn it
    void function  OnPickupGenericThread(entity item, string ref, int amount = 1) {
        vector pos = item.GetOrigin()
        vector angles = item.GetAngles()
        item.WaitSignal("OnItemPickup")

        wait FIRINGRANGE_RACK_RESPAWN_TIME

        StartParticleEffectInWorld(GetParticleSystemIndex(FIRINGRANGE_ITEM_RESPAWN_PARTICLE), pos, angles)
        thread OnPickupGenericThread(SpawnGenericLoot(ref, pos, angles, amount), ref, amount)
    }

#endif

// C8888D C8888D C8888D C8888D C8888D C8888D C8888D
//
// d8888b. db    db d888888b d888888b  .d88b.  d8b   db .d8888.
// 88  `8D 88    88 `~~88~~' `~~88~~' .8P  Y8. 888o  88 88'  YP
// 88oooY' 88    88    88       88    88    88 88V8o 88 `8bo.
// 88~~~b. 88    88    88       88    88    88 88 V8o88   `Y8b.
// 88   8D 88b  d88    88       88    `8b  d8' 88  V888 db   8D
// Y8888P' ~Y8888P'    YP       YP     `Y88P'  VP   V8P `8888Y'
//
// C8888D C8888D C8888D C8888D C8888D C8888D C8888D
#if SERVER
    int CollectedNessy = 0
    int CollectedNessyMax = 0
    int CurMusic = 0

    const array<string> SongData = [
       /*  0 */ "None | None",
       /*  1 */ "mainmenu_music | Default (Main Menu)",
       /*  2 */ "MUSIC_Lobby | Default (Lobby)",
       /*  3 */ "mainmenu_music_Event1 | Event1 (Main Menu)",
       /*  4 */ "Music_Lobby_Event1 | Event1 (Lobby)",
       /*  5 */ "mainmenu_music_Event2 | Event2 (Main Menu)",
       /*  6 */ "Music_Lobby_Event2 | Event2 (Lobby)",
       /*  7 */ "mainmenu_music_Event3 | Shadow Fall (Main Menu)",
       /*  8 */ "Music_Lobby_Event3 | Shadow Fall (Lobby)",
       /*  9 */ "mainmenu_music_Event4 | Holo-Day (Main Menu)",
       /* 10 */ "Music_Lobby_Event4 | Holo-Day (Lobby)",
       /* 11 */ "mainmenu_music_Bangalore | Bangalore (Main Menu)",
       /* 12 */ "Music_Lobby_Bangalore | Bangalore (Lobby)",
       /* 13 */ "mainmenu_music_Bloodhound | Bloodhound (Main Menu)",
       /* 14 */ "Music_Lobby_Bloodhound | Bloodhound (Lobby)",
       /* 15 */ "mainmenu_music_Caustic | Caustic (Main Menu)",
       /* 16 */ "Music_Lobby_Caustic | Caustic (Lobby)",
       /* 17 */ "mainmenu_music_Crypto | Crypto (Main Menu)",
       /* 18 */ "Music_Lobby_Crypto | Crypto (Lobby)",
       /* 19 */ "mainmenu_music_Gibraltar | Gibraltar (Main Menu)",
       /* 20 */ "Music_Lobby_Gibraltar | Gibraltar (Lobby)",
       /* 21 */ "mainmenu_music_Lifeline | Lifeline (Main Menu)",
       /* 22 */ "Music_Lobby_Lifeline | Lifeline (Lobby)",
       /* 23 */ "mainmenu_music_Mirage | Mirage (Main Menu)",
       /* 24 */ "Music_Lobby_Mirage | Mirage (Lobby)",
       /* 25 */ "Music_TT_Mirage_PartyTrack | Mirage (Town Takeover)",
       /* 26 */ "mainmenu_music_Octane | Octane (Main Menu)",
       /* 27 */ "Music_Lobby_Octane | Octane (Lobby)",
       /* 28 */ "mainmenu_music_Pathfinder | Pathfinder (Main Menu)",
       /* 29 */ "Music_Lobby_Pathfinder | Pathfinder (Lobby)",
       /* 30 */ "mainmenu_music_Wattson | Wattson (Main Menu)",
       /* 31 */ "Music_Lobby_Wattson | Wattson (Lobby)",
       /* 32 */ "mainmenu_music_Wraith | Wraith (Main Menu)",
       /* 33 */ "Music_Lobby_Wraith | Wraith (Lobby)",
    ]

    const array<asset> Models = [
        $"mdl/humans/class/medium/pilot_medium_generic.rmdl", // 0
        $"mdl/Humans/class/medium/pilot_medium_bangalore.rmdl", // 1
        $"mdl/humans/class/medium/pilot_medium_bloodhound.rmdl", // 2
        $"mdl/humans/class/heavy/pilot_heavy_caustic.rmdl", // 3
        $"mdl/Humans/class/medium/pilot_medium_crypto.rmdl", // 4
        $"mdl/humans/class/heavy/pilot_heavy_gibraltar.rmdl", // 5
        $"mdl/humans/class/light/pilot_light_support.rmdl", // 6
        $"mdl/humans/class/medium/pilot_medium_holo.rmdl", // 7
        $"mdl/Humans/class/medium/pilot_medium_stim.rmdl", // 8
        $"mdl/humans/class/heavy/pilot_heavy_pathfinder.rmdl", // 9
        $"mdl/Humans/class/light/pilot_light_wattson.rmdl", // 10
        $"mdl/humans/class/light/pilot_light_wraith.rmdl", // 11
        $"mdl/humans/class/medium/pilot_medium_holo.rmdl", // 12
        $"mdl/humans/class/medium/pilot_medium_holo.rmdl", // 13
    ]

    const array<string> Anims = [
        "mp_pt_dummy_training_idle",
        "bangalore_menu_lobby_center_readyup",
        "bloodhound_menu_lobby_center_pet",
        "caustic_menu_lobby_center_recorder",
        "crypto_menu_lobby_center_twitch",
        "gibraltar_menu_lobby_center_readyup",
        "lifeline_idle_UA_danceALT",
        "mirage_menu_lobby_center_magic",
        "octane_menu_lobby_center_epic",
        "pathfinder_menu_lobby_center_screen_thumbs_up",
        "wattson_menu_lobby_center_idle",
        "wraith_menu_lobby_center_voices",
        "TMP_mirage_walk_forward_ORD",
        "mirage_menu_lobby_center_beard",
    ]

    void function SetUpMapButtons()
    {
        foreach(entity util in GetErray("spawn_utility"))
            ScaleBoundingBox( util )

//////////
////////// ABILITY RECHARGE
//////////
        entity AbilityReCharger = GetErray("spawn_utility")[0]
        {
            thread LoopFXOnEntity( AbilityReCharger , $"P_mines_Elec_tube_ON" , 5 , <0,0,80>)
            MakeObjectUsable( AbilityReCharger , "%&use% Recharge Ablities")

            AddCallback_OnUseEntity( AbilityReCharger , void
            function(entity panel, entity user, int input) {
                user.GetOffhandWeapon( OFFHAND_INVENTORY )
                    .SetWeaponPrimaryClipCount( user.GetOffhandWeapon( OFFHAND_INVENTORY ).GetWeaponPrimaryClipCountMax() )
                user.GetOffhandWeapon( OFFHAND_LEFT )
                    .SetWeaponPrimaryClipCount( user.GetOffhandWeapon( OFFHAND_LEFT ).GetWeaponPrimaryClipCountMax() )
            })
        }
//////////
////////// TRASH WEAPONS
//////////
        {
            entity trashbin = GetErray("spawn_utility")[4]

            string prompt = "%&use% Trash Weapons"
            MakeObjectUsable(trashbin, prompt)

            AddCallback_OnUseEntity( trashbin , void
                function(entity panel, entity user, int input) {

                StopSoundOnEntity( panel, "LootBin_TrainStation_Lower" )
                StopSoundOnEntity( panel, "LootBin_TrainStation_Raise" )

                entity primary = user.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
                entity secondary = user.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )

                if(IsValid( primary ) || IsValid( secondary ))
                {
                    thread LoopFXOnEntity( panel , $"P_impact_sparks_predator_ALT" , 1 , ZERO_VECTOR , 0)
                    EmitSoundOnEntity( panel, "LootBin_TrainStation_Raise" )

                    if(IsValid( primary ))
                        user.TakeWeaponByEntNow( primary )

                    if(IsValid( secondary ))
                        user.TakeWeaponByEntNow( secondary )
                }
                else
                {
                    thread LoopFXOnEntity( panel , $"P_impact_sparks_predator_PS" , 1 , ZERO_VECTOR , 0)
                    EmitSoundOnEntity( panel, "LootBin_TrainStation_Lower" )
                }

                SetPlayerHeirloom(user,0)
                user.SetActiveWeaponBySlot( eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_2)


            })
        }
//////////
////////// AMMO BOX
//////////
        {
            entity ammobox = GetErray("spawn_utility")[5]

            string prompt = "%&use% Add Ammo Mags"
            MakeObjectUsable(ammobox, prompt)

            AddCallback_OnUseEntity( ammobox , void
                function(entity panel, entity user, int input) {

                StopSoundOnEntity( panel, "weapon_bulletcasings_bounce" )
                StopSoundOnEntity( panel, "survival_loot_pickup_3p_ammo" )

                entity weapon = user.GetNormalWeapon( SURVIVAL_GetActiveWeaponSlot( user ) )

                if( IsValid( weapon ) )
                {
                    thread LoopFXOnEntity( panel , $"P_sparks_short" , 1 , ZERO_VECTOR , 0)

                    EmitSoundOnEntity( panel, "weapon_bulletcasings_bounce" )
                    EmitSoundOnEntity( panel, "survival_loot_pickup_3p_ammo" )

                    const int MAXSTOCKPILE = 420 // 65535

                    weapon.SetWeaponPrimaryAmmoCount( AMMOSOURCE_POOL , MAXSTOCKPILE )
                }
            })
        }
//////////
////////// HeirLooms
//////////
        {
            entity bolo_sword = GetErray("spawn_utility")[6]
            {
                ScaleBoundingBox( bolo_sword )

                string prompt = "%&use% Equip Bolo Sword"
                MakeObjectUsable( bolo_sword, prompt )
                SetSurvivalPropHighlight( bolo_sword, "survival_item_weapon", false )

                AddCallback_OnUseEntity( bolo_sword , void function(entity panel, entity user, int input) {
                    SetPlayerHeirloom( user, 1)
                })
            }

            //entity data_knife = GetErray("spawn_utility")[11]
            //{
            //    ScaleBoundingBox( data_knife )
//
            //    string prompt = "%&use% Equip Data Knife"
            //    MakeObjectUsable( data_knife, prompt )
            //    SetSurvivalPropHighlight( data_knife, "survival_item_weapon", false )
//
            //    AddCallback_OnUseEntity( data_knife , void function(entity panel, entity user, int input) {
            //        SetPlayerHeirloom( user, 2)
            //    })
            //}

            /*
            entity combat_katana = GetErray("spawn_utility")[9]
            {
                ScaleBoundingBox( combat_katana )

                string prompt = "%&use% Equip Combat Katana"
                MakeObjectUsable( combat_katana, prompt )
                SetSurvivalPropHighlight( combat_katana, "survival_item_weapon", false )

                AddCallback_OnUseEntity( combat_katana , void function(entity panel, entity user, int input) {
                    SetPlayerHeirloom( user, 3)
                })
            }
            */

            /*
            { // throwing knife
                entity throwingknife_spawn = GetErray("spawn_utility")[10]
                entity throwing_knife = SpawnGenericLoot( "mp_weapon_throwingknife", throwingknife_spawn.GetOrigin() , throwingknife_spawn.GetAngles() , 1)
                thread OnPickupGenericThread(throwing_knife, "mp_weapon_throwingknife", 1)
                throwingknife_spawn.Destroy()
            }
            */
        }
//////////
////////// NESSY BUTTONS
//////////
        CollectedNessyMax = GetErray("gm_construct_nessie_secret").len()
        ErrayDisable("gm_construct_nessie_secret_spawn")
        foreach(entity nessy in GetErray("gm_construct_nessie_secret"))
        {
            string prompt = "%&use% Collect Nessy " + CollectedNessy + " / " + CollectedNessyMax
            MakeObjectUsable(nessy, prompt)

            HighlightDecoy( nessy , <71,232,65> )

            AddCallback_OnUseEntity( nessy , void
            function(entity panel, entity user, int input) {
                CollectedNessy++

                if(CollectedNessy == CollectedNessyMax)
                {
                    ErrayEnable("gm_construct_nessie_secret_active")
                    foreach(entity nessyspawn in GetErray("gm_construct_nessie_secret_spawn"))
                        SpawnNessyBomber( nessyspawn.GetOrigin() )


                    string prompt = "%&use% Nessy Smg" // unlock nessy r99
                    MakeObjectUsable( GetErray("spawn_utility")[3], prompt)
                    HighlightDecoy( GetErray("spawn_utility")[3] , <71,232,65> )
                }

                if( IsValid(panel) )
                {
                    EmitSoundOnEntity( user, "UI_Menu_Cosmetic_Unlock" )
                    string promptnew = "%&use% Collect Nessy " + CollectedNessy + " / " + CollectedNessyMax
                    foreach(entity nessyspawn in GetErray("gm_construct_nessie_secret"))
                        nessyspawn.SetUsePrompts(promptnew, promptnew)
                }
                panel.Dissolve( ENTITY_DISSOLVE_CORE, <0,0,0>, 1000 )
            })
        }
//////////
////////// NESSY SMG
//////////
        {
            entity NessySmg = GetErray("spawn_utility")[3]
            NessySmg.SetSkin(4)

            string prompt = "%&use% Collect Nessies To Unlock"
            MakeObjectUsable( NessySmg , prompt)
            HighlightDecoy( NessySmg )
            ClearHighlight( NessySmg )

            AddCallback_OnUseEntity( NessySmg , void
                function(entity panel, entity user, int input) {
                    if(CollectedNessy == CollectedNessyMax)
                    {
                        entity primary = user.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )

                        if(IsValid( primary ))
                            user.TakeWeaponByEntNow( primary )

                        user.GiveWeapon( "mp_weapon_nessy97", WEAPON_INVENTORY_SLOT_PRIMARY_0)
                        user.SetActiveWeaponBySlot( eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_0)
                    }
            })
        }
//////////
////////// MUSIC SELECT
//////////
        {
            // Set Up SongList
            array<string> Songs = []
            array<string> SongTitles = []

            foreach(string data in SongData)
            {
                array<string> split = split(data , "|")
                Songs.append(strip(split[0]))
                SongTitles.append(strip(split[1]))
            }

            entity musicbox = GetErray("spawn_utility")[1]
            {
                string prompt = "%use% " + string(CurMusic) + " / " + string(Songs.len() - 1) + " Music -> " + SongTitles[CurMusic]
                MakeObjectUsable( musicbox, prompt)
            }

            entity holo = GetErray("spawn_utility")[2]
            {
                holo.SetCollisionAllowed(false)
                thread LoopFXOnEntity( holo , $"P_BT_eye_proj_holo" , 10 )
            }

            entity AnimProxy = CreatePropScript( Models[0] , holo.GetOrigin() + <0,0,20>, <0,-90,0>)
            {
                AnimProxy.SetCollisionAllowed(false)
                AnimProxy.Anim_PlayOnly( Anims[0]  )
                AnimProxy.Anim_SetPlaybackRate( 1.0 )
                AnimProxy.SetCycle( RandomFloat(1.0 ) )
                AnimProxy.SetModelScale( 0.3 )

                ScaleBoundingBox( AnimProxy )

                AnimProxy.kv.renderamt = 255
                AnimProxy.kv.rendermode = 3
                AnimProxy.kv.rendercolor = "255 255 255 230"
                HighlightDecoy( AnimProxy )
            }

            thread SpinRotateEntity(AnimProxy , 4.0)

            AddCallback_OnUseEntity( musicbox , void function(entity panel, entity user, int input) : (AnimProxy, Songs, SongTitles) {
                CurMusic++
                if(CurMusic > Songs.len() - 1 )
                    CurMusic = 0

                foreach(string Song in Songs)
                    StopSoundOnEntity( panel, Song )

                EmitSoundOnEntity( panel, Songs[CurMusic] )

                string prompt = "%use% " + string(CurMusic) + " / " + string(Songs.len() - 1)  + " Music -> " + SongTitles[CurMusic]
                panel.SetUsePrompts(prompt, prompt)

                int model = 0
                int skin = 0
                switch(CurMusic) // hell
                {
                    case 1: skin = 1 ; break
                    case 2: skin = 2 ; break
                    case 3: skin = 3 ; break
                    case 4: skin = 4 ; break
                    case 5: skin = 5 ; break
                    case 6: skin = 6 ; break// default
                    case 7:
                    case 8: skin = 11 ; model = 12 ;break // shadow
                    case 9:
                    case 10: model = 13  ;break
                    case 11:
                    case 12: model = 1   ;break
                    case 13:
                    case 14: model = 2   ;break
                    case 15:
                    case 16: model = 3   ;break
                    case 17:
                    case 18: model = 4   ;break
                    case 19:
                    case 20: model = 5   ;break
                    case 21:
                    case 22: model = 6   ;break
                    case 23:
                    case 24:
                    case 25: model = 7   ;break
                    case 26:
                    case 27: model = 8   ;break
                    case 28:
                    case 29: model = 9   ;break
                    case 30:
                    case 31: model = 10  ;break
                    case 32:
                    case 33: model = 11  ;break
                }
                AnimProxy.SetModel( Models[model]  ) ; AnimProxy.SetSkin( skin  ); AnimProxy.Anim_PlayOnly( Anims[model]  )

                if(CurMusic > 8)
                    AnimProxy.SetSkin( RandomIntRange(1,7)  )
            })
        }
    }

    entity function SpawnNessyBomber( vector Origin, int team = 99 )
    {
        entity drone = CreateFragDrone( team , Origin, < 0, 0, 0 > )
        SetSpawnOption_AISettings( drone, "npc_frag_drone" )
        drone.EnableNPCFlag( NPC_ALLOW_PATROL | NPC_ALLOW_INVESTIGATE | NPC_NEW_ENEMY_FROM_SOUND )
        UpdateEnemyMemoryWithinRadius( drone, 2000 )

        drone.SetTitle("NESSY")
        drone.SetMaxHealth(200)
        drone.SetHealth(drone.GetMaxHealth())

        DispatchSpawn( drone )
        drone.SetBehaviorSelector( "behavior_frag_drone" )
        drone.EnableBehavior( "Assault" )

        entity nessy = CreatePropDynamic($"mdl/domestic/nessy_doll.rmdl", drone.GetOrigin(), <0,drone.GetAngles().y + -90,0>, SOLID_VPHYSICS, 15000)
        nessy.SetParent(drone)
        nessy.SetModelScale(7.1)
        nessy.SetCollisionAllowed(false)

        return drone
    }
#endif
//
//C8888D C8888D C8888D C8888D C8888D C8888D C8888D

// C8888D C8888D C8888D C8888D C8888D C8888D C8888D
//
// d8b   db d8888b.  .o88b. Cb .d8888.
// 888o  88 88  `8D d8P  Y8 `D 88'  YP
// 88V8o 88 88oodD' 8P       ' `8bo.
// 88 V8o88 88~~~   8b           `Y8b.
// 88  V888 88      Y8b  d8    db   8D
// VP   V8P 88       `Y88P'    `8888Y'
//
//
// C8888D C8888D C8888D C8888D C8888D C8888D C8888D
#if SERVER
    void function CreateConstructDummy( vector origin , vector angles = ZERO_VECTOR , float respawntime = 0.0)
    {
        entity dummy = CreateEntity( "npc_dummie" )
        {
            SetSpawnOption_AISettings( dummy , "npc_training_dummy")
            dummy.SetMaxHealth( 255 ) // Red Shield Value
            dummy.SetHealth( 255 ) // Red Shield Value
            dummy.EnableNPCFlag( NPC_DISABLE_SENSING | NPC_IGNORE_ALL )

            dummy.SetOrigin( origin )
            dummy.SetAngles( angles )
            SetTeam( dummy, 99 )

            DispatchSpawn( dummy )

            dummy.SetOrigin( origin )

            AddEntityCallback_OnKilled( dummy,
            void function (entity ent, var damageInfo) : ( respawntime )
            {
                thread function() : ( ent, respawntime )
                {
                    vector origin = ent.GetOrigin()
                    vector angles = ent.GetAngles()
                    if(IsValid(ent))
                        ent.Destroy()

                    wait respawntime
                    CreateConstructDummy( origin , angles, respawntime)
                }()
            } )

            thread function() : ( dummy , origin)
            {
                int curskin = 0
                while( IsValid(dummy) )
                {
                    if(curskin >= 7)
                        curskin = 0

                    dummy.SetSkin( curskin )
                    wait 0.5
                    curskin++
                }
            }()
        }
    }

    void function CreateConstructTreasureTick( vector origin, vector angles = ZERO_VECTOR, float respawntime = 10, array<string> LootTable = [])
    {
        entity tink = SpawnLootTick( origin, angles , LootTable)

        AddEntityCallback_OnKilled( tink, void function (entity ent, var damageInfo) : ( respawntime, LootTable )
        {
            thread function() : ( ent, respawntime, LootTable )
            {
                vector origin = ent.GetOrigin()
                vector angles = ent.GetAngles()
                if( IsValid( ent ) )
                    ent.Destroy()

                wait respawntime
                CreateConstructTreasureTick( origin , angles, respawntime, LootTable)
            }()
        } )
    }

    entity function CreateConstructSpider( vector origin , vector angles = ZERO_VECTOR , float respawntime = 0.0)
    {
        entity spider = CreateEntity( "npc_spider" )
        {
            SetSpawnOption_AISettings( spider , "npc_spider")
            spider.EnableNPCFlag( NPC_DISABLE_SENSING | NPC_IGNORE_ALL )
            spider.SetOrigin( origin )
            spider.SetAngles( angles )
            SetTeam( spider, 99 )

            DispatchSpawn( spider )
            spider.SetBehaviorSelector( "behavior_dummy_empty" )

            AddEntityCallback_OnKilled( spider,
                void function (entity ent, var damageInfo) : ( respawntime )
                {
                    thread function() : ( ent, respawntime )
                    {
                        vector origin = ent.GetOrigin()
                        vector angles = ent.GetAngles()
                        if(IsValid(ent))
                            ent.Destroy()

                        wait respawntime
                        CreateConstructSpider( origin , angles, respawntime)
                    }()
                } )
        }

        return spider
    }

    void function CreateConstructInfected( vector origin , vector angles = ZERO_VECTOR , float respawntime = 0.0)
    {
        entity infected = CreateEntity( "npc_dummie" )
        {
            SetSpawnOption_AISettings( infected , "npc_soldier_infected")
            infected.EnableNPCFlag( NPC_DISABLE_SENSING | NPC_IGNORE_ALL )

            infected.SetOrigin( origin )
            infected.SetAngles( angles )
            SetTeam( infected, 99 )
            DispatchSpawn( infected )
            infected.SetSkin(2)
            infected.SetBehaviorSelector( "behavior_dummy_empty" )


            AddEntityCallback_OnKilled( infected,
                void function (entity ent, var damageInfo) : ( respawntime )
                {
                    thread function() : ( ent, respawntime )
                    {
                        vector origin = ent.GetOrigin()
                        vector angles = ent.GetAngles()
                        if(IsValid(ent))
                            ent.Destroy()

                        wait respawntime
                        CreateConstructInfected( origin , angles, respawntime)
                    }()
                } )
        }
    }

    void function CreateBird( vector origin , vector angles = ZERO_VECTOR , float respawntime = 0.0)
    {
        entity bird = CreateEntity( "npc_prowler" )
        {
            SetSpawnOption_AISettings( bird , "npc_flyer")
            //bird.EnableNPCFlag( NPC_DISABLE_SENSING | NPC_IGNORE_ALL )

            bird.SetOrigin( origin )
            bird.SetAngles( angles )
            SetTeam( bird, 99 )
            DispatchSpawn( bird )
        }
    }

    void function CreateFrProwler( vector origin , vector angles = ZERO_VECTOR , float respawntime = 0.0)
    {
        entity prowler = CreateEntity( "npc_prowler" )
        {
            SetSpawnOption_AISettings( prowler , "npc_prowler")
            //bird.EnableNPCFlag( NPC_DISABLE_SENSING | NPC_IGNORE_ALL )

            prowler.SetOrigin( origin )
            prowler.SetAngles( angles )
            SetTeam( prowler, 99 )
            DispatchSpawn( prowler )
        }
    }

    void function CreateFrMarvin( vector origin , vector angles = ZERO_VECTOR)
    {
        entity marvin = CreateEntity( "npc_marvin" )
        {
            SetSpawnOption_AISettings( marvin , "npc_marvin")
            //bird.EnableNPCFlag( NPC_DISABLE_SENSING | NPC_IGNORE_ALL )

            marvin.SetOrigin( origin )
            marvin.SetAngles( angles )
            SetTeam( marvin, 99 )

            DispatchSpawn( marvin )
        }
    }

    void function CreateFrSpectre( vector origin , vector angles = ZERO_VECTOR)
    {
        entity spectre = CreateEntity( "npc_spectre" )
        {
            SetSpawnOption_AISettings( spectre , "npc_spectre_outlands")
            //bird.EnableNPCFlag( NPC_DISABLE_SENSING | NPC_IGNORE_ALL )

            spectre.SetOrigin( origin )
            spectre.SetAngles( angles )
            SetTeam( spectre, 99 )

            DispatchSpawn( spectre )

            array<string> weapons = ["npc_weapon_lstar", "npc_weapon_energy_shotgun", "npc_weapon_hemlok"] //We are giving them original firing range weapons, they are shooting better this way
            string randomWeapon = weapons[RandomInt(weapons.len())]
            spectre.GiveWeapon(randomWeapon, WEAPON_INVENTORY_SLOT_ANY)
        }
    }


    // script CreateFrTurret(gp()[0].GetOrigin(), <0,gp()[0].GetAngles().y,0>)
    void function CreateFrTurret( vector origin , vector angles = ZERO_VECTOR)
    {
        entity turret = CreateEntity( "npc_turret_sentry" )
        {
            //SetSpawnOption_AISettings( turret , "npc_turret_sentry")
            //bird.EnableNPCFlag( NPC_DISABLE_SENSING | NPC_IGNORE_ALL )

            turret.DisableNPCFlag( NPC_DISABLE_SENSING | NPC_IGNORE_ALL )
            turret.SetOrigin( origin )
            turret.SetAngles( angles )
            turret.StartDeployed()

          //  SetTeam( turret, 98 )

            DispatchSpawn( turret )

           // turret.EnableTurret()

            thread function() : ( turret )
            {
                while( IsValid(turret) )
                {
                    switch (turret.GetTurretState()) {
                        case TURRET_SEARCHING:
                            printl("TURRET_SEARCHING")
                        break
                        case TURRET_INACTIVE:
                            printl("URRET_INACTIVE")
                        break
                        case TURRET_ACTIVE :
                            printl("TURRET_ACTIVE")
                        break
                        case TURRET_DEPLOYING:
                            printl("TURRET_DEPLOYING")
                        break
                        case TURRET_RETIRING:
                            printl("TURRET_RETIRING")
                        break
                        case TURRET_DEAD:
                            printl("TURRET_DEAD")
                        break
                        case TURRET_SCRIPT:
                            printl("TURRET_SCRIPT")
                        break
                    }
                   wait 0.5
                }
            }()


        }
    }

    void function CreateFrDrone( vector origin , vector angles = ZERO_VECTOR)
    {
        entity drone = CreateEntity( "npc_drone" )
        {
            SetSpawnOption_AISettings( drone , "npc_drone")
            //bird.EnableNPCFlag( NPC_DISABLE_SENSING | NPC_IGNORE_ALL )

            drone.SetOrigin( origin )
            drone.SetAngles( angles )

            SetTeam( drone, 99 )

            DispatchSpawn( drone )
        }
    }

    void function CreateFrGunship( vector origin , vector angles = ZERO_VECTOR)
    {
        entity gunship = CreateEntity( "npc_gunship" )
        {
            SetSpawnOption_AISettings( gunship , "npc_gunship")
            //bird.EnableNPCFlag( NPC_DISABLE_SENSING | NPC_IGNORE_ALL )

            gunship.SetOrigin( origin )
            gunship.SetAngles( angles )

            SetTeam( gunship, 99 )

            DispatchSpawn( gunship )
        }
    }

    void function CreateConstructPilot( vector origin , vector angles = ZERO_VECTOR, float respawntime = 0.0)
    {
        entity pilot = CreateEntity( "npc_pilot_elite" )
        {
            SetSpawnOption_AISettings( pilot , "npc_pilot_elite")
            pilot.EnableNPCFlag( NPC_DISABLE_SENSING | NPC_IGNORE_ALL )

            pilot.SetOrigin( origin )
            pilot.SetAngles( angles )

            SetTeam( pilot, 99 )

            DispatchSpawn( pilot )

            pilot.SetBehaviorSelector( "behavior_dummy_empty" )

            AddEntityCallback_OnKilled( pilot,
                void function (entity ent, var damageInfo) : ( respawntime )
                {
                    thread function() : ( ent, respawntime )
                    {
                        vector origin = ent.GetOrigin()
                        vector angles = ent.GetAngles()
                        if(IsValid(ent))
                            ent.Destroy()

                        wait respawntime
                        CreateConstructPilot( origin , angles, respawntime)
                    }()
                } )
        }
    }


    void function SetPlayerHeirloom( entity player, int index )
    {
        entity w_melee = player.GetOffhandWeapon( OFFHAND_MELEE )
        entity w_primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_2 )

        if( IsValid( w_primary ) && IsValid( w_melee ) )
        {
            string primary = "mp_weapon_melee_survival"
            string melee = "melee_pilot_emptyhanded"

            switch ( index )
            {
                case 1:
                    primary = "mp_weapon_bolo_sword_primary"
                    melee = "melee_bolo_sword"
                    break
                case 2:
                    primary = "mp_weapon_dataknife_kunai_primary"
                    melee = "melee_dataknife_kunai"
                    break
                case 3:
                    primary = "mp_weapon_combat_katana_primary"
                    melee = "melee_combat_katana"
                    break
                default:
                    break
            }

            // take away
            player.TakeWeaponByEntNow( w_primary )
            player.TakeOffhandWeapon( OFFHAND_MELEE )

            // give
            player.GiveWeapon( primary , WEAPON_INVENTORY_SLOT_PRIMARY_2 )
            player.GiveOffhandWeapon( melee, OFFHAND_MELEE )

            player.SetActiveWeaponBySlot( eActiveInventorySlot.mainHand, WEAPON_INVENTORY_SLOT_PRIMARY_2)
        }
    }
#endif