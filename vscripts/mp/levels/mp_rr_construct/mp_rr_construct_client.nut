global function ClientCodeCallback_MapInit
global function CL_CreateWorldText
global function CL_CreateWorldImage
global function CL_DestroyWorldImage

void function ClientCodeCallback_MapInit()
{
	printl("[Construct] Client : MapInit")
	ClLaserMesh_Init()
	Construct_MapInit_Common()
	AddCallback_EntitiesDidLoad( CL_EntitiesDidLoad )

}

vector function RGBToVector(vector RGB)
{
	return RGB / 255.0
}

string function RGBToString(vector RGB)
{
	RGB = RGBToVector(RGB) ; return string(RGB.x) + " " + string(RGB.y) + " " + string(RGB.z) + " " + string(1.0)
}

void function UpdateLightingConVars()
{
	//SetConVarFloat("mat_sky_scale", 4)
	//SetConVarFloat("mat_sun_scale", 0.7)
	while(true)
	{
        SetConVarFloat("mat_autoexposure_max", 1)
		wait 6
	}
}
//
//
////script_client UpdateBlenderLight(0, TRAINING_BASE + <64.40,330.30,504.12> , <-0.00,0.00,0.00> , <255.00,255.00,255.00> , 20.00 , 2291.84 , 10000.00 , 6.00)
//entity function UpdateBlenderLight(int index , vector pos, vector ang,vector RGB,float brightness, float radius , float distance, float exponent)
//{
//   entity e = MP_LIGHTS[index]
//   e.SetLightExponent( exponent );e.SetLightRadius(radius)
//   e.SetOrigin(pos)
//   e.SetAngles(ang)
//   e.kv.distance = distance
//   MP_LIGHTS_exp[index] = exponent
//   return e
//}

// script DEV_TeleportPlayers( <30486.3145, 8583.26367, -18713.4609> , <0, 137.236221, 0> )


void function CL_EntitiesDidLoad()
{
	vector dlight_color = RGBToVector( <255 ,247, 232> )
	if( MapName() == eMaps.mp_rr_construct_night )
		dlight_color = RGBToVector( <63,91,175> )

    foreach(entity proxy in GetErray("CL_mp_rr_construct_skybox_dlights") )
	{
		entity dlight = CreateClientSideDynamicLight( proxy.GetOrigin() , proxy.GetAngles() , dlight_color , 100 )
		dlight.SetLightExponent( 1.6 )
		dlight.SetLightRadius( 1000 )
	}

}


void function CL_CreateWorldText( vector origin, vector angles, float textScale , string title, string text , int panelID = -1)
{
    string sendPanelText
    for ( int textType = 0 ; textType < 2 ; textType++ )
    {
        sendPanelText = textType == 0 ? title : text

        for ( int i = 0; i < sendPanelText.len(); i++ )
        {
            Dev_BuildTextInfoPanel( textType, sendPanelText[i] )
        }
    }

    Dev_CreateTextInfoPanelWithID( origin.x, origin.y, origin.z, angles.x, angles.y, angles.z, false, textScale , panelID)
}



table<int,array<var> > worldRUIs
array<int> VideoChannels

//script_client CL_DestroyWorldImage($"overviews/mp_rr_construct",GetLocalClientPlayer().GetOrigin(),GetLocalClientPlayer().GetAngles(),4256,4256)
void function CL_CreateWorldImage(asset bikname, vector org, vector ang, float width, float height, int RUIID = -1)
{
	vector origin = org
	vector angles = ang

	origin += (AnglesToUp( angles )*-1) * (height*0.5)  // instead of pinning from center, pin from top center
	var topo = CreateRUITopology_Worldspace( origin, angles, width, height )

	var rui = RuiCreate( $"ui/finisher_video.rpak", topo, RUI_DRAW_WORLD, 32767 )

	int channel = ReserveVideoChannel()
	VideoChannels.append(channel)

	RuiSetBool( rui, "visible", true )
	RuiSetInt( rui, "channel", channel )

	StartVideoOnChannel( channel, bikname, true, 0.0 )

	//RuiSetBool( rui, "hasVideo", true )

	if ( RUIID != -1 )
	{
		if ( !( RUIID in worldRUIs ) )
			worldRUIs[ RUIID ] <- []

		worldRUIs[ RUIID ].append( rui )
	}
}

void function CL_DestroyWorldImage( int RUIID )
{
	if ( !( RUIID in worldRUIs ) )
		return

	foreach ( rui in worldRUIs[ RUIID ] )
		RuiDestroyIfAlive( rui )

	worldRUIs[ RUIID ].clear()
}


//CL_CreateWorldImage($"", GetLocalViewPlayer().GetOrigin(), <0,0,0>, 400, 400, -1)








