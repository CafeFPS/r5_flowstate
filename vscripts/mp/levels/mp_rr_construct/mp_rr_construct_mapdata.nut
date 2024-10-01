global function Construct_MAPDATA
global function RequestErrayCollection

global struct ErrayObject
{
   string type
   string collection
   asset  mdl
   vector origin
   vector angles
   float  scale
   float  fade
   bool mantle
   bool visible
   entity instance
}

array<ErrayObject> function RequestErrayCollection( string collection = "all" , bool instance = true)
{
   var DP_DTBL = GetDataTable( $"datatable/mp_rr_construct_props.rpak" )
   int numRows = GetDatatableRowCount( DP_DTBL )

   array<ErrayObject> Erray = []
   for(int i = 0; i < numRows; i++)
   {
      ErrayObject EOBJ
      EOBJ.type       = GetDataTableString( DP_DTBL, i, GetDataTableColumnByName( DP_DTBL , "type"       ) )
      EOBJ.collection = GetDataTableString( DP_DTBL, i, GetDataTableColumnByName( DP_DTBL , "collection" ) )
      EOBJ.mdl        = GetDataTableAsset(  DP_DTBL, i, GetDataTableColumnByName( DP_DTBL , "mdl"        ) )
      EOBJ.origin     = GetDataTableVector( DP_DTBL, i, GetDataTableColumnByName( DP_DTBL , "origin"     ) )
      EOBJ.angles     = GetDataTableVector( DP_DTBL, i, GetDataTableColumnByName( DP_DTBL , "angles"     ) )
      EOBJ.scale      = GetDataTableFloat(  DP_DTBL, i, GetDataTableColumnByName( DP_DTBL , "scale"      ) )
      EOBJ.fade       = GetDataTableFloat(  DP_DTBL, i, GetDataTableColumnByName( DP_DTBL , "fade"       ) )
      EOBJ.mantle     = GetDataTableBool(   DP_DTBL, i, GetDataTableColumnByName( DP_DTBL , "mantle"     ) )
      EOBJ.visible    = GetDataTableBool(   DP_DTBL, i, GetDataTableColumnByName( DP_DTBL , "visible"    ) )

      if(collection != "all" && EOBJ.collection != collection)
         continue

      if(instance)
      {
         switch(EOBJ.type)
         {
            #if SERVER
            case "dynamic_prop":
            EOBJ.instance = CreatePropDynamic( EOBJ.mdl, EOBJ.origin, EOBJ.angles, SOLID_VPHYSICS, 15000 )
            break
            case "dynamic_scriptmover":
            EOBJ.instance = CreateScriptMover( EOBJ.origin, EOBJ.angles )
            EOBJ.instance.SetModel( EOBJ.mdl )
            break
            case "prop_script":
            EOBJ.instance = CreatePropScript( EOBJ.mdl, EOBJ.origin , EOBJ.angles , SOLID_VPHYSICS , 15000 )
            break
            #elseif CLIENT
            case "clientside_dynamic_prop":
            EOBJ.instance = CreatePropDynamic( EOBJ.mdl, EOBJ.origin, EOBJ.angles )
            break
            #endif
         }

         if( IsValid( EOBJ.instance ) )
         {
            EOBJ.instance.kv.fadedist = EOBJ.fade
            EOBJ.instance.SetScriptName( EOBJ.collection )
            EOBJ.instance.SetModelScale( EOBJ.scale )

            if( !EOBJ.visible )
            {
               #if SERVER
               EOBJ.instance.MakeInvisible()
               #elseif CLIENT
               EOBJ.instance.kv.renderamt = 255
               EOBJ.instance.kv.rendermode = 3
               EOBJ.instance.kv.rendercolor = "255 255 255 0"
               #endif
            }

            #if SERVER
            if (EOBJ.mantle)
               EOBJ.instance.AllowMantle()

            EOBJ.instance.SetCollisionDetailHigh()

            // check if the model is a door model and create a working door
            CreateDoorFromDynamicProp( EOBJ.instance )
            #endif
         }
      }

      Erray.append(EOBJ)
   }

   return Erray
}


void function Construct_MAPDATA()
{

   printl("______________________________________________________________")
   array<ErrayObject> ConstructData = RequestErrayCollection()
   printl("[Construct] Found " + ConstructData.len() + " Props")
   printl("[Construct] Props Loaded")
   printl("______________________________________________________________")

   OnThreadEnd( function() : ( ConstructData )
	{

      #if SERVER
      { // skybox

         array<entity> skyboxprops = GetErray("mp_rr_construct_skybox")

         entity skycam = GetEnt("skybox_cam_level")
         skycam.SetOrigin(<10578, 29104, -25851> + < -5.0, 4.30, 0.9 >)

         if( MapName() == eMaps.mp_rr_construct_night ) // if night set to night vista
         {
            skyboxprops[0].SetModel($"mdl/vistas/canyonlands_night_se.rmdl")
            skyboxprops[0].SetAngles(<0,90,0>)

         } else {
            entity sun = CreateParticleInSkybox( $"P_sun_canyonlands" , <350,-200,350> , <0,90,0> )
         }
      }

      if( MapName() == eMaps.mp_rr_construct_night )
      {
         foreach(entity fxent in GetErray("night_fx_bugs"))
            thread LoopFXOnEntity( fxent , $"bugs_gnats_grass_tall" , 20)
      }

      foreach(entity sand in GetErray("gm_construct_sand"))
      {
         if(sand.GetModelName() == "mdl/rocks/rock_white_chalk_modular_01_half_01.rmdl")
            sand.SetSkin(2)

         if(sand.GetModelName() == "mdl/rocks/rock_white_chalk_modular_01_half_02.rmdl")
            sand.SetSkin(1)
      }

      foreach(entity zip in GetErray("gm_construct_houses"))
      {
         if(zip.GetModelName() == $"mdl/props/pathfinder_zipline/pathfinder_zipline.rmdl")
            zip.SetAngles(zip.GetAngles() + <-90,90,0>)
      }


      foreach(entity visual in GetErray("gm_construct_visual_colliders"))
      {
         switch (visual.GetModelName()) {
            case "mdl/rocks/rock_lava_moss_desertlands_03.rmdl":
               visual.SetSkin(5)
               break;
            case 2:
               break;
            default:
               break;
         }
      }

      //ErrayEnable( "gm_construct_collidersv3")
      CreateWater( <35210,9000,-18940> , 3400 ,900 , 0 , false)
      CreateDynamicZipLineOnEntities( GetErray("gm_construct_skyfall")[0], GetErray("gm_construct_skyfall")[1] , false)
      CreateSkyFall( GetErray("gm_construct_skyfall")[0] , 200 , false)

      CreateBoundsTrigger( GetErray("gm_construct_outofbounds")[0].GetOrigin() , 10000 , 1000, 3, false)

      array<vector> zipline_nodes = [
         <29932.7207, 9883.24707, -18727.6387>,
         <30069.0762, 10773.6465, -18367.9883>,
         <31551.7129, 11195.501, -18093.9277>,
         <31201.627, 9380.42773, -17807.9844>,
         <30061.8516, 9845.00098, -17660.1992>,
         <29235.7207, 9274.16895, -17458.3574>,
         <29232.3652, 8491.45898, -17093.127>
      ]

      // prowler nests
      /*
      thread function () : ()
      {
         array<entity> prowler_nests = [
            GetErray("npcspawn")[5],
            GetErray("npcspawn")[6],
         ]

         array<entity> prowlers = []

         while(true)
         {
            foreach ( entity nest in prowler_nests )
            {
               vector ornull clampedOrigin = NavMesh_ClampPointForHullWithExtents( nest.GetOrigin(), HULL_PROWLER, < 100, 100, 200 > )
               if ( clampedOrigin == null )
                  continue

               expect vector( clampedOrigin )

               array<vector> originArray = NavMesh_RandomPositions( clampedOrigin + <0,0,200>, HULL_PROWLER, 3, 400, 650 )

               foreach( perchOrigin in originArray )
               {
                  if(prowlers.len() > 5)
                     continue

                  TraceResults result = TraceLineHighDetail( perchOrigin + <0,0,-35>, perchOrigin + <0,0,300>, null, TRACE_MASK_PLAYERSOLID | TRACE_MASK_TITANSOLID | TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_PLAYER )
                  if ( !IsValid( result.hitEnt )  )
                     continue


                  entity prowler = CreateProwler( 99, result.endPos + <0,0,50> , <0,RandomFloatRange(-180,180),0> )
                  prowlers.append( prowler )
                  DispatchSpawn( prowler )

                  printl("Created Random Prowler at : " + prowler.GetOrigin() )
               }
            }

            while(prowlers.len() > 0)
            {
               foreach( prowler in prowlers )
               {
                  if( !IsValid( prowler ) || !IsAlive( prowler ) )
                     prowlers.removebyvalue(prowler)
               }

               WaitFrame()
            }
            printl("All Prowler killed respawning...")

            wait 10
            prowlers.clear()
         }
      }()
      */
      #endif

      if(IsDevGamemode())
      {
         vector RackOrigin = < 28820, 9380, -18820 >

         int size = 0

         for (int i = 0; i < TagToWeaponClass.len(); i++) {
            #if SERVER
            size = SpawnCustomRacks( RackOrigin , <0,0,0>, <0,10,0>, i , false)
            RackOrigin.y = RackOrigin.y + float(size * 18)
            #endif
            //#elseif CLIENT
            //CL_CreateWorldText( EndRackOrigin + <0,45,120>, <0,180,0>, 1.0, "", GetEnumString( "weaponClassToTag", i ) )
            //#endif
         }

         #if SERVER
         SpawnEquipment( RackOrigin + < 0, 20,               2 >, 0, <30,0,0>, eLootType.ORDNANCE)
         SpawnEquipment( RackOrigin + < 0, 20 + ( 32 * 1  ), 0 >, 0, <30,0,0>, eLootType.HEALTH)
         SpawnEquipment( RackOrigin + < 0, 20 + ( 32 * 2  ), 0 >, 0, <30,0,0>, eLootType.ARMOR)
         SpawnEquipment( RackOrigin + < 0, 20 + ( 32 * 3  ), 0 >, 0, <30,0,0>, eLootType.HELMET)
         SpawnEquipment( RackOrigin + < 0, 20 + ( 32 * 4  ), 0 >, 0, <30,0,0>, eLootType.BACKPACK)
         SpawnEquipment( RackOrigin + < 0, 20 + ( 32 * 5  ), 0 >, 1, <30,0,0>, eLootType.ATTACHMENT, eLootTier.COMMON)
         SpawnEquipment( RackOrigin + < 0, 20 + ( 32 * 7  ), 0 >, 1, <30,0,0>, eLootType.ATTACHMENT, eLootTier.RARE)
         SpawnEquipment( RackOrigin + < 0, 20 + ( 32 * 9  ), 0 >, 1, <30,0,0>, eLootType.ATTACHMENT, eLootTier.EPIC)
         SpawnEquipment( RackOrigin + < 0, 20 + ( 32 * 11 ), 0 >, 0, <30,0,0>, eLootType.ATTACHMENT, eLootTier.LEGENDARY)

         SetUpMapButtons()
         thread CreateGroundMedKit( GetErray("spawn_utility")[8].GetOrigin() + <0,0,50> , ZERO_VECTOR , 3 , 2)

         array<vector> nodes = [ <0,0,0>]

         MapEditor_CreateLinkedZipline( nodes )

         CreateConstructDummy(
            GetErray("npcspawn")[0].GetOrigin(),
            GetErray("npcspawn")[0].GetAngles())

		//FIXME
         // CreateConstructTreasureTick(
            // GetErray("npcspawn")[1].GetOrigin(),
            // GetErray("npcspawn")[1].GetAngles(),
            // 5,
         // [
            // "ammo",
            // "ammo",
            // "ammo",
            // "ammo",
            // "ammo",
            // "ammo",
            // "ammo",
            // "ammo",
            // "ammo"
         // ])

         CreateConstructSpider(
            GetErray("npcspawn")[2].GetOrigin(),
            GetErray("npcspawn")[2].GetAngles() )

         CreateConstructInfected(
            GetErray("npcspawn")[3].GetOrigin(),
            GetErray("npcspawn")[3].GetAngles() )

         //CreateConstructPilot(
         //   GetErray("npcspawn")[4].GetOrigin(),
         //   GetErray("npcspawn")[4].GetAngles())
         #endif
      }

   /////////////
   // General
   /////////////

   #if CLIENT
   thread( void function() // water
   {
      while( IsValid( GetLocalViewPlayer() ) )
      {
         // cant register custom netvar using 'tutorialContext' instead
         switch(GetLocalViewPlayer().GetPlayerNetInt("tutorialContext"))
         {
            case 1: // water
            SetConVarInt( "dof_overrideParams", 1 )
            SetConVarFloat( "dof_farDepthStart", 0 )
            SetConVarFloat( "dof_farDepthEnd", 1000 )
            break

            case 2: // indoors
            break

            case -1: // all
            SetConVarToDefault( "dof_overrideParams" )
   		   SetConVarToDefault( "dof_farDepthStart" )
   		   SetConVarToDefault( "dof_farDepthEnd" )
            break
         }
         wait 0.05
      }
   } ())
   #endif

   #if CLIENT
   CreateSounds()

   { // client side grass
      int grass_count = 0
      int grass_max = 900
      for(int i = 0; i < ConstructData.len(); i++)
      {
         int random       = RandomIntRange(0,3)
         float scalebig   = RandomFloatRange(0.6,0.9)
         float scalesmall = RandomFloatRange(0.4,0.5)
         vector deviation = <RandomFloat(10),RandomFloat(10),20>

         if(random == 2 && grass_count < grass_max && ConstructData[i].collection == "gm_construct_grass_v2")
         {
            entity visual_grass = CreatePropDynamic($"mdl/foliage/grass_02_desert_large.rmdl", ConstructData[i].origin + deviation, ConstructData[i].angles)
            visual_grass.SetFadeDistance(-1)

            if(ConstructData[i].angles.x >= 75 || ConstructData[i].angles.x <= -75)
               visual_grass.SetModelScale(scalesmall)

            visual_grass.SetModelScale(scalebig)
            grass_count++
         }
      }

      printl("[Construct] Grass Generated (" + grass_count + " / " + grass_max + ")")
      printl("______________________________________________________________")
   }
   #endif
	})
}

void function CreateSounds()
{
#if CLIENT
   foreach(entity ent in GetErray("CL_gm_construct_sounds_water"))
   {
      EmitSoundAtPosition( TEAM_UNASSIGNED, ent.GetOrigin(), "Canyonlands_Wetlands_Emit_SluiceRiver_Active_A" )
      ent.Destroy()
   }
#endif
}

