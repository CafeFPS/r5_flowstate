untyped

globalize_all_functions

//  +-++-+-  -+-++-++-+++++-+  +-+- -+-+
//  ���� �++++�� ����� ��� �   � -+-+���
//  - -+-+ ++ +-+- -+-++++ -   +-+ - - -
//  
//  Client Script
//  
//  Made by DEAFPS
//
//  With help from:
//  Caf�FPS - General help
//  
 

//Basic settings
bool kmh
float speedometer_hz
float petHz
string time = ""
bool s4lighting

string lastKeysState = ""

//Classic Movement
bool Classic_Movement = false

//Stylemeter
float stylepoints = 0

// Cool client saves
int lasttime_m1 = MG_SAVED_LT_M1
int lasttime_m2 = MG_SAVED_LT_M2
int lasttime_m3 = MG_SAVED_LT_M3
int lasttime_m4 = MG_SAVED_LT_M4

int pb_time_m1 = MG_SAVED_PB_M1
int pb_time_m2 = MG_SAVED_PB_M2
int pb_time_m3 = MG_SAVED_PB_M3
int pb_time_m4 = MG_SAVED_PB_M4

bool isKeysOn = MG_SAVED_ISKEYSON
bool isSpeedoOn = MG_SAVED_ISSPEEDOON
bool isStyleOn = MG_SAVED_ISSTYLEON
bool isIntroOn = MG_SAVED_ISINTROON

//Info Pannels
struct {
  table<int,array<var> > infoPanels
  table<int,array<var> > personalBest
  table<int,array<var> > lastTimer
  table<int,array<var> > hintPanels
  table<int,array<var> > basicImagePanels
}
file

// Cool intro
bool isInIntro
bool isInFreeCam
entity freecam
entity freecamMover
bool isInSpecCam
entity speccam
float coolcam_timeheld_use
float userVolume

float lastTimeSpectateUsed

// pets
entity pet
string activePet = ""

//Race Ghosts
asset ghostmodel
entity ghost
var PBGhostAnim
vector PBGhostAnimPos
vector PBGhostAnimAng
float PBGhostStartTime
float PBGhostDurationTime


//  -+++-+-+-+-++-++-+
//  ����� � �+-� � +� 
//  -+++- - -- - - +-+
void function Cl_MovementGym_Init()
{
	entity player = GetLocalClientPlayer()
	
	RequestPakFile( "ui_dea" )
	
	// Register Signals
	RegisterSignal("StopStopWatch")
	RegisterSignal("StopSpeedometer")
	RegisterSignal("StopStylemeter")
	RegisterSignal("StopS4")
	RegisterSignal("StopMGCamera")
	RegisterSignal("IntroSkipped")
	RegisterSignal("FreecamExit")
	RegisterSignal("SpeccamExit")
	RegisterSignal("StopPet")
	RegisterSignal("StopGhost")
	
	// Get Movement Gym User Settings
	speedometer_hz = 0.05
	petHz = 0.1
	kmh = true
	s4lighting = false
	
	SetConVarToDefault("Player_extraairaccelleration")
	SetConVarToDefault("jump_keyboardgrace_strength")
	GetLocalClientPlayer().ClientCommand("-jump")
	GetLocalClientPlayer().ClientCommand("-forward")
	GetLocalClientPlayer().ClientCommand("-moveleft")
	GetLocalClientPlayer().ClientCommand("-moveright")
	GetLocalClientPlayer().ClientCommand("-backward")
	
	//Classic Movement
	if(Flowstate_MovementGym_ClassicMovement()){
		Classic_Movement = true
		thread Cl_Classic_Movement()
	}
	
	if (GetCurrentPlaylistName() == "fs_movementgym"){
		//Very Cool Cam
		if(isIntroOn == true)
			thread MG_CoolCamera()
	
		//Button Imgs
		MG_ButtonImgs()
		
		//World PB Timers
		MG_Spawn_PB_Timers()
	}
	
	if(isIntroOn == false || GetCurrentPlaylistName() != "fs_movementgym"){
		if(isSpeedoOn == true)
			MG_Speedometer_toggle(true)
		
		if(isKeysOn == true)
			MG_MovementOverlay_toggle(true)
		
		if(isStyleOn == true)
			MG_Ultrakill_styleemeter_toggle(true)
	}
}

//
// server/ui callbacks
//
void function MG_Settings_UI(){
	RunUIScript( "OpenMGSettings")
}

void function MG_ServerCallback_Invis(){
	entity player = GetLocalClientPlayer()
	player.ClientCommand("invis")
}

//  +-++-++-++-+- -+-++-++-+- -
//  +-+ � � �+-+���+-� � �  +-�
//  +-+ - +-+-  +-+- - - +-+- -
void function MG_StopWatch_toggle(bool visible){
	if(visible == true){
		thread MG_StopWatch()
	} else {
		MG_StopWatch_destroy()
	}
}

void function MG_StopWatch(){
	int startTime = floor( Time() ).tointeger()
	entity player = GetLocalClientPlayer()
	EndSignal(player, "StopStopWatch")
	
	Hud_SetVisible(HudElement( "MG_StopWatch_Frame" ), true)
	Hud_SetVisible(HudElement( "MG_StopWatch_Icon" ), true)
	Hud_SetVisible(HudElement( "MG_StopWatch_Label" ), true)
	Hud_SetVisible(HudElement( "MG_StopWatch" ), true)
	
	while(true)
	{
		int currentTime = floor( Time() ).tointeger() - startTime
		
		Hud_SetText( HudElement( "MG_StopWatch" ), MG_Convert_Sec_to_Time(currentTime))
		
		wait 1
	}
	
}

void function MG_StopWatch_Obituary(int seconds, entity name, int map){
	if ( !GetLocalViewPlayer() )
		return
	
	Obituary_Print_Localized( "%$rui/menu/store/feature_timer% " + name.GetPlayerName() + " has finished" + " Map " + map + " in " + MG_Convert_Sec_to_Time(seconds), GetChatTitleColorForPlayer( GetLocalViewPlayer() ), BURN_COLOR )
	
	MG_StopWatch_PersonalBest(seconds, map)

}

void function MG_StopWatch_PersonalBest(int seconds, int map){
		
	switch(map) {
	case 1:
		if(seconds < lasttime_m1 || lasttime_m1 == 0){			
			foreach ( rui in file.personalBest[ 1 ] ){
				RuiSetGameTime( rui, "startTime", Time() )
				RuiSetFloat( rui, "duration", 99999999 )
				RuiSetString( rui, "messageText", MG_Convert_Sec_to_Time(seconds))
				pb_time_m1 = seconds
			}
			
			
			
		}
		
		foreach ( rui in file.lastTimer[ 1 ] ){
			RuiSetGameTime( rui, "startTime", Time() )
			RuiSetFloat( rui, "duration", 99999999 )
			RuiSetString( rui, "messageText", MG_Convert_Sec_to_Time(seconds))
		}
		
		lasttime_m1 = seconds
		break
	case 2:
		if(seconds < lasttime_m2 || lasttime_m2 == 0){
			foreach ( rui in file.personalBest[ 2 ] ){
				RuiSetGameTime( rui, "startTime", Time() )
				RuiSetFloat( rui, "duration", 99999999 )
				RuiSetString( rui, "messageText", MG_Convert_Sec_to_Time(seconds))
				pb_time_m2 = seconds
			}
		}
		
		foreach ( rui in file.lastTimer[ 2 ] ){
			RuiSetGameTime( rui, "startTime", Time() )
			RuiSetFloat( rui, "duration", 99999999 )
			RuiSetString( rui, "messageText", MG_Convert_Sec_to_Time(seconds))
		}
		
		lasttime_m2 = seconds
		break
	case 3:
		if(seconds < lasttime_m3 || lasttime_m3 == 0){
			foreach ( rui in file.personalBest[ 3 ] ){
				RuiSetGameTime( rui, "startTime", Time() )
				RuiSetFloat( rui, "duration", 99999999 )
				RuiSetString( rui, "messageText", MG_Convert_Sec_to_Time(seconds))
				pb_time_m3 = seconds
			}
		}
		
		foreach ( rui in file.lastTimer[ 3 ] ){
			RuiSetGameTime( rui, "startTime", Time() )
			RuiSetFloat( rui, "duration", 99999999 )
			RuiSetString( rui, "messageText", MG_Convert_Sec_to_Time(seconds))
		}
		
		lasttime_m3 = seconds
		break
	case 4:
		if(seconds < lasttime_m4 || lasttime_m4 == 0){
			foreach ( rui in file.personalBest[ 4 ] ){
				RuiSetGameTime( rui, "startTime", Time() )
				RuiSetFloat( rui, "duration", 99999999 )
				RuiSetString( rui, "messageText", MG_Convert_Sec_to_Time(seconds))
				pb_time_m4 = seconds
			}
		}
		
		foreach ( rui in file.lastTimer[ 4 ] ){
			RuiSetGameTime( rui, "startTime", Time() )
			RuiSetFloat( rui, "duration", 99999999 )
			RuiSetString( rui, "messageText", MG_Convert_Sec_to_Time(seconds))
		}
		
		lasttime_m4 = seconds
		break
	}
	
	MovementGymSavePBToFile()
}

void function MG_StopWatch_destroy(){
	entity player = GetLocalClientPlayer()
	player.Signal("StopStopWatch")
	Hud_SetVisible(HudElement( "MG_StopWatch" ), false)
	Hud_SetVisible(HudElement( "MG_StopWatch_Frame" ), false)
	Hud_SetVisible(HudElement( "MG_StopWatch_Icon" ), false)
	Hud_SetVisible(HudElement( "MG_StopWatch_Label" ), false)
}



//  +-++-++-++-++-++-++-++-++-++-+--+
//  +-++-++� +�  ��� ����+�  � +� +-+
//  +-+-  +-++-+--++-+- -+-+ - +-+-+-
void function MG_Speedometer_toggle(bool visible){
	if(visible == true){
		thread MG_Speedometer()
		isSpeedoOn = true
		MovementGymSavePBToFile()
	}
	else{
		MG_Speedometer_destroy()
		isSpeedoOn = false
		MovementGymSavePBToFile()
	}
}

void function MG_Speedometer(){
	entity player = GetLocalClientPlayer()
	EndSignal(player, "StopSpeedometer")
	Hud_SetVisible(HudElement( "MG_Speedometer_Icon" ), true)
	Hud_SetVisible(HudElement( "MG_Speedometer_kmh" ), true)
	Hud_SetVisible(HudElement( "MG_Speedometer_mph" ), true)
	
	
	switch (kmh) {
	case true:
		while(true){
			// Refresh every .2s
			wait speedometer_hz
			entity playerr = GetLocalClientPlayer()
			if( !playerr.IsObserver()){
				if (IsValid(playerr)){
					//Speedometer	
					float playerVel
					vector playerVelV = playerr.GetVelocity()
					
					playerVel = playerVelV.Length()
					
					float playerVelNormal = playerVel * (0.06858) //KM/H
					
					int playerVelNormalInt = playerVelNormal.tointeger()
					
					//Display Speed
					Hud_SetText( HudElement( "MG_Speedometer_kmh" ), playerVelNormalInt.tostring() + " km/h")
				}
			} else if( playerr.IsObserver()){
				if (IsValid(playerr)){
					entity spectarget = playerr.GetObserverTarget()
					if (IsValid(spectarget)){
						//Speedometer	
						float playerVel
						vector playerVelV = spectarget.GetVelocity()
						
						playerVel = playerVelV.Length()
						
						float playerVelNormal = playerVel * (0.06858) //KM/H
						
						int playerVelNormalInt = playerVelNormal.tointeger()
						
						//Display Speed
						Hud_SetText( HudElement( "MG_Speedometer_kmh" ), playerVelNormalInt.tostring() + " km/h")
					}
				}
			}
		}
	break
	case false:
		while(true){
			// Refresh every .2s
			wait speedometer_hz
			entity playerr = GetLocalClientPlayer()
			if( !playerr.IsObserver()){
				if (IsValid(playerr)){
					//Speedometer	
					float playerVel
					vector playerVelV = playerr.GetVelocity()
					
					playerVel = playerVelV.Length()
					
					float playerVelNormal = playerVel * (0.06858) //KM/H
					float playerVelBigMac = playerVelNormal * (0.621371) //MPH
					
					int playerVelNormalInt = playerVelNormal.tointeger()
					int playerVelBigMacInt = playerVelBigMac.tointeger()
					
					//Display Speed
					Hud_SetText( HudElement( "MG_Speedometer_kmh" ), playerVelBigMacInt.tostring() + " mph")
				}
			} else if( playerr.IsObserver()){
				if (IsValid(playerr)){
					entity spectarget = playerr.GetObserverTarget()
					if (IsValid(spectarget)){
						//Speedometer	
						float playerVel
						vector playerVelV = spectarget.GetVelocity()
						
						playerVel = playerVelV.Length()
						
						float playerVelNormal = playerVel * (0.06858) //KM/H
						float playerVelBigMac = playerVelNormal * (0.621371) //MPH
						
						int playerVelNormalInt = playerVelNormal.tointeger()
						int playerVelBigMacInt = playerVelBigMac.tointeger()
						
						//Display Speed
						Hud_SetText( HudElement( "MG_Speedometer_kmh" ), playerVelBigMacInt.tostring() + " mph")
					}
				}
			}
		}
	}	
}

void function MG_Speedometer_destroy(){
	entity player = GetLocalClientPlayer()
	player.Signal("StopSpeedometer")
	
	Hud_SetVisible(HudElement( "MG_Speedometer_Icon" ), false)
	Hud_SetVisible(HudElement( "MG_Speedometer_kmh" ), false)
	Hud_SetVisible(HudElement( "MG_Speedometer_mph" ), false)
}



//  +-++-+++++-+  +-+- -+-++-+-+-+-++-+-++++-+  +-++-++-++-++-++-++-+
//  +-++� ��� ��  �  +-�+� �  +-++-+� ����� �   ���+� +-++-++-�� -+� 
//  +-++-++++--+  +-+- -+-++-+- --  +-+-+++ -   - -+-++-++-+- -+-++-+
void function MG_Checkpoint_Msg(){
	
	entity player = GetLocalClientPlayer()
	AnnouncementData announcement = Announcement_Create( "Checkpoint!" )
	Announcement_SetHideOnDeath( announcement, false )
	Announcement_SetDuration( announcement, 3 )
	Announcement_SetPurge( announcement, true )
	
	Announcement_SetStyle(announcement, ANNOUNCEMENT_STYLE_QUICK)
	Announcement_SetTitleColor( announcement, Vector(0,0,1) )
	
	AnnouncementFromClass( player, announcement )	
}

//
// force s4 lighting
//
void function MG_ForceLighting(){
	entity player = GetLocalClientPlayer()
	EndSignal(player, "StopS4")
	
	if(s4lighting){
		while(true){
			if(GetConVarFloat( "mat_sky_scale") != 0.5 || GetConVarFloat( "mat_sun_scale") != 2.5 || GetConVarString( "mat_sun_color") != "2.0 1.2 0.5 1.0"){
				// Force Client settings
				SetConVarFloat( "mat_sky_scale", 0.5 )
				SetConVarFloat( "mat_sun_scale", 2.5 )
				SetConVarString( "mat_sun_color", "2.0 1.2 0.5 1.0" )
			}
		WaitFrame()
		}
	}
}



//  +-++-+-  -+-++-++-+++++-+  - -+-++-++-+  +-+-  -+-+--+-  +-+- -
//  ���� �+++++� ���+� ��� �   ����-�+-+ ��  � �+++++� +-+�  +-�+-+
//  - -+-+ ++ +-+- -+-++++ -   +-+- -+-+--+  +-+ ++ +-+-+---+- - - 
void function MG_MovementOverlay_toggle(bool visible){
	
	switch(visible){
		case true:
			if(lastKeysState == "" || lastKeysState == "keysoff"){
				
				isKeysOn = true
				
				Hud_SetVisible(HudElement( "MG_MO_W" ), true)
				Hud_SetVisible(HudElement( "MG_MO_A" ), true)
				Hud_SetVisible(HudElement( "MG_MO_S" ), true)
				Hud_SetVisible(HudElement( "MG_MO_D" ), true)
				Hud_SetVisible(HudElement( "MG_MO_CTRL" ), true)
				Hud_SetVisible(HudElement( "MG_MO_SPACE" ), true)
				
				// W
				RegisterConCommandTriggeredCallback("+forward", MG_MovementOverlay_W_Pressed)
				RegisterConCommandTriggeredCallback("-forward", MG_MovementOverlay_W_Released)
				// A
				RegisterConCommandTriggeredCallback("+moveleft", MG_MovementOverlay_A_Pressed)
				RegisterConCommandTriggeredCallback("-moveleft", MG_MovementOverlay_A_Released)
				// S
				RegisterConCommandTriggeredCallback("+backward", MG_MovementOverlay_S_Pressed)
				RegisterConCommandTriggeredCallback("-backward", MG_MovementOverlay_S_Released)
				// D
				RegisterConCommandTriggeredCallback("+moveright", MG_MovementOverlay_D_Pressed)
				RegisterConCommandTriggeredCallback("-moveright", MG_MovementOverlay_D_Released)
				// CTRL
				RegisterConCommandTriggeredCallback("+duck", MG_MovementOverlay_CTRL_Pressed)
				RegisterConCommandTriggeredCallback("-duck", MG_MovementOverlay_CTRL_Released)
				// SPACE
				RegisterConCommandTriggeredCallback("+jump", MG_MovementOverlay_SPACE_Pressed)
				RegisterConCommandTriggeredCallback("-jump", MG_MovementOverlay_SPACE_Released)
				
				lastKeysState = "keyson"
				MovementGymSavePBToFile()
				
			}
			break
		case false:	
			if(lastKeysState == "keyson"){
				
				isKeysOn = false
				
				Hud_SetVisible(HudElement( "MG_MO_W" ), false)
				Hud_SetVisible(HudElement( "MG_MO_A" ), false)
				Hud_SetVisible(HudElement( "MG_MO_S" ), false)
				Hud_SetVisible(HudElement( "MG_MO_D" ), false)
				Hud_SetVisible(HudElement( "MG_MO_CTRL" ), false)
				Hud_SetVisible(HudElement( "MG_MO_SPACE" ), false)
				
				// W
				DeregisterConCommandTriggeredCallback("+forward", MG_MovementOverlay_W_Pressed)
				DeregisterConCommandTriggeredCallback("-forward", MG_MovementOverlay_W_Released)
				// A
				DeregisterConCommandTriggeredCallback("+moveleft", MG_MovementOverlay_A_Pressed)
				DeregisterConCommandTriggeredCallback("-moveleft", MG_MovementOverlay_A_Released)
				// S
				DeregisterConCommandTriggeredCallback("+backward", MG_MovementOverlay_S_Pressed)
				DeregisterConCommandTriggeredCallback("-backward", MG_MovementOverlay_S_Released)
				// D
				DeregisterConCommandTriggeredCallback("+moveright", MG_MovementOverlay_D_Pressed)
				DeregisterConCommandTriggeredCallback("-moveright", MG_MovementOverlay_D_Released)
				// CTRL
				DeregisterConCommandTriggeredCallback("+duck", MG_MovementOverlay_CTRL_Pressed)
				DeregisterConCommandTriggeredCallback("-duck", MG_MovementOverlay_CTRL_Released)
				// SPACE
				DeregisterConCommandTriggeredCallback("+jump", MG_MovementOverlay_SPACE_Pressed)
				DeregisterConCommandTriggeredCallback("-jump", MG_MovementOverlay_SPACE_Released)
				
				lastKeysState = "keysoff"
				MovementGymSavePBToFile()
			}
		}
}

void function MG_MovementOverlay_W_Pressed(var button){
  Hud_SetText(HudElement( "MG_MO_W" ), "%forward%")
}

void function MG_MovementOverlay_W_Released(var button){
  Hud_SetText(HudElement( "MG_MO_W" ), "%$vgui/fonts/buttons/icon_unbound%")
}

void function MG_MovementOverlay_A_Pressed(var button){
  Hud_SetText(HudElement( "MG_MO_A" ), "%moveleft%")
}

void function MG_MovementOverlay_A_Released(var button){
  Hud_SetText(HudElement( "MG_MO_A" ), "%$vgui/fonts/buttons/icon_unbound%")
}

void function MG_MovementOverlay_S_Pressed(var button){
  Hud_SetText(HudElement( "MG_MO_S" ), "%backward%")
}

void function MG_MovementOverlay_S_Released(var button){
  Hud_SetText(HudElement( "MG_MO_S" ), "%$vgui/fonts/buttons/icon_unbound%")
}

void function MG_MovementOverlay_D_Pressed(var button){
  Hud_SetText(HudElement( "MG_MO_D" ), "%moveright%")
}

void function MG_MovementOverlay_D_Released(var button){
  Hud_SetText(HudElement( "MG_MO_D" ), "%$vgui/fonts/buttons/icon_unbound%")
}

void function MG_MovementOverlay_CTRL_Pressed(var button){
  Hud_SetText(HudElement( "MG_MO_CTRL" ), "%duck%")
}

void function MG_MovementOverlay_CTRL_Released(var button){
  Hud_SetText(HudElement( "MG_MO_CTRL" ), " ")
}

void function MG_MovementOverlay_SPACE_Pressed(var button){
  Hud_SetText(HudElement( "MG_MO_SPACE" ), "%jump%")
}

void function MG_MovementOverlay_SPACE_Released(var button){
  Hud_SetText(HudElement( "MG_MO_SPACE" ), " ")
}



//  - -- +-+--++-+-+---  -    +-++-+- --  +-++-++-++-++-+--+
//  � ��  � +-++-�+-+��  �    +-+ � +-+�  +� ���+�  � +� +-+
//  +-+--+- -+-- -- ----+--+  +-+ -  - --++-+- -+-+ - +-+-+-
void function MG_Ultrakill_styleemeter_toggle(bool visible){
	if(visible == true){
		thread MG_Ultrakill_styleemeter()
		isStyleOn = true
		MovementGymSavePBToFile()
	} else {
		MG_Ultrakill_styleemeter_destroy()
		isStyleOn = false
		MovementGymSavePBToFile()
	}
}

void function MG_Ultrakill_styleemeter(){
	
	int timesUsedSlide
	float slidetime
	float lastslide
	
	int timesUsedWR
	float wallruntime
	float lastwallrun
	
	float lastmantle
	bool wasmantle
	
	float sprinttime
	float airtime
	
	int timesUsedSG
	float lastSG
	float lastSG_sound = 0
	
	float ziptime
	float lastzip
	
	int timesUsedSJ
	float lastSJ
	
	float laststyletime
	
	float StyleBarWidth
	
	entity player = GetLocalClientPlayer()
	EndSignal(player, "StopStylemeter")
	
	
	Hud_SetVisible(HudElement( "MG_Style_Bar" ), true)
	
	Hud_SetVisible(HudElement( "MG_Style_Label" ), true)
	
	Hud_SetVisible(HudElement( "MG_Style_History_Wallrun" ), true)
	Hud_SetVisible(HudElement( "MG_Style_History_Superglide" ), true)
	Hud_SetVisible(HudElement( "MG_Style_History_Slide" ), true)
	Hud_SetVisible(HudElement( "MG_Style_History_Speed" ), true)
	

	
	
	while(true){
		
		entity playerr = GetLocalClientPlayer()
		if( !playerr.IsObserver()){
			if (IsValid(playerr) && IsValid(player)){
				
				float TimeNow = Time()
				float playerVel
				vector playerVelV = playerr.GetVelocity()
			
				playerVel = playerVelV.Length()
				
				
				//airtime---------------------------------------------------------
				if(!player.IsOnGround() && !player.ContextAction_IsZipline()){
					airtime += 0.025
					//if(airtime > 0.2 && airtime < 1){
					//	stylepoints += 3.0
					//}
				}else if(player.IsOnGround()){
					airtime = 0.0
				}
				
				
				//slidetime---------------------------------------------------------
				if(player.IsSliding() && player.IsOnGround()){
					slidetime += 0.025
					//if(slidetime > 0.2 && slidetime < 1){
					//	stylepoints += 3.0
					//}
				}else if(!player.IsOnGround()){
					slidetime = 0.0
				}
				
				//slide
				if(player.IsSliding() && player.IsOnGround() && TimeNow - slidetime > 1){
					float reward = 2.0
					stylepoints += reward
					laststyletime = TimeNow
					lastslide = TimeNow
					timesUsedSlide++
					string msg = "%$rui/bullet_point% Slide ^002FFF00+" + (reward*timesUsedSlide).tostring()
					Hud_SetText( HudElement( "MG_Style_History_Slide" ), msg)
					Hud_FadeOverTime( HudElement( "MG_Style_History_Slide" ), 255, 0, 1 )
					EmitSoundOnEntity( player, RESPAWN_BEACON_LOOP_SOUND )
					StopSoundOnEntity( player, RESPAWN_BEACON_LOOP_SOUND )
					
				}
				
				//walltime---------------------------------------------------------
				if(player.IsWallRunning() && !player.IsOnGround()){
					wallruntime += 0.025
					//if(wallruntime > 0.2 && wallruntime < 1){
					//	stylepoints += 3.0
					//}
				}else if(player.IsOnGround()){
					wallruntime = 0.0
				}
				
				//wallrun
				if(player.IsWallRunning() && TimeNow - wallruntime > 5){
					float reward = 5.0
					stylepoints += reward
					laststyletime = TimeNow
					lastwallrun = TimeNow
					timesUsedWR++
					string msg = "%$rui/bullet_point% Wallrun/Climb ^002FFF00+" + (reward*timesUsedWR).tostring()
					Hud_SetText( HudElement( "MG_Style_History_Wallrun" ), msg)
					Hud_FadeOverTime( HudElement( "MG_Style_History_Wallrun" ), 255, 0, 1 )
					EmitSoundOnEntity( player, RESPAWN_BEACON_LOOP_SOUND )
					StopSoundOnEntity( player, RESPAWN_BEACON_LOOP_SOUND )
				}
				
				
				//SuperGlide------------------------------------------------------
				if(player.IsMantling()){
					wasmantle = true
					lastmantle = TimeNow
				}
				
				if(wasmantle == true && !player.IsOnGround() && playerVel > 480 &&  player.IsSliding() && airtime <= 0.5){
					float reward = 20
					stylepoints += reward
					laststyletime = TimeNow
					lastSG = TimeNow
					timesUsedSG++
					string msg = "%$rui/bullet_point% Superglide ^002FFF00+" + (reward*timesUsedSG).tostring()
					Hud_SetText( HudElement( "MG_Style_History_Superglide" ), msg)
					Hud_FadeOverTime( HudElement( "MG_Style_History_Superglide" ), 255, 0, 1 )
					
					if(TimeNow - lastSG_sound > 2){
						EmitSoundOnEntity( player, PING_SOUND_DEFAULT )
						lastSG_sound = TimeNow
					}
				}
				
				if (TimeNow - lastmantle > 0.25){
					lastmantle = 0.0
					wasmantle = false
				}
				
				//SuperJump------------------------------------------------------
				if(player.ContextAction_IsZipline() && !player.IsOnGround()){
					ziptime += 0.025
					lastzip = TimeNow
				}else if(player.IsOnGround()){
					ziptime = 0.0
				}
				
				if(!player.IsOnGround() && !player.ContextAction_IsZipline() && TimeNow - lastzip <= 0.05 && ziptime <= 0.2){
					float reward = 50.0
					stylepoints += reward
					laststyletime = TimeNow
					lastSJ = TimeNow
					timesUsedSJ++
					string msg = "%$rui/bullet_point% Superjump ^002FFF00+" + (reward*timesUsedSJ).tostring()
					Hud_SetText( HudElement( "MG_Style_History_Superglide" ), msg)
					Hud_FadeOverTime( HudElement( "MG_Style_History_Superglide" ), 255, 0, 1 )
					EmitSoundOnEntity( player, PING_SOUND_DEFAULT )
				}
				
				if (TimeNow - lastmantle > 0.25){
					lastmantle = 0.0
					wasmantle = false
				}

				
				//reset if inactive-------------------------------------------------
				if(TimeNow - laststyletime > 5.0 && stylepoints > 0.0){
					stylepoints = 0.0
				}
				
				//constantly loose points
				if(stylepoints >= 1.0){
					stylepoints -= 0.5
				}
								
				//reset times used-------------------------------------------------
				if(TimeNow - lastSJ > 1.5 && timesUsedSJ != 0 ){
					timesUsedSJ = 0
					Hud_FadeOverTime( HudElement( "MG_Style_History_Superglide" ), 0, 0.1, 1 )
				}
				
				if(TimeNow - lastSG > 1.5 && timesUsedSG != 0){
					timesUsedSG = 0
					Hud_FadeOverTime( HudElement( "MG_Style_History_Superglide" ), 0, 0.1, 1 )
				}
				
				if(TimeNow - lastwallrun > 1.5){
					timesUsedWR = 0
					//Hud_SetText( HudElement( "MG_Style_History_Wallrun" ), " ")
					Hud_FadeOverTime( HudElement( "MG_Style_History_Wallrun" ), 0, 0.1, 1 )
				}
				
				if(TimeNow - lastslide > 1.5){
					timesUsedSlide = 0
					//Hud_SetText( HudElement( "MG_Style_History_Slide" ), " ")
					Hud_FadeOverTime( HudElement( "MG_Style_History_Slide" ), 0, 0.1, 1 )
				}
								
				//prevent negative-------------------------------------------------
				if(stylepoints < 0.0 || TimeNow - laststyletime > 5.0){
					stylepoints = 0.0
				}
				
				//update points-----------------------------------------------------
				StyleBarWidth = (stylepoints/4.0)
				if(StyleBarWidth > 500.0)
					StyleBarWidth = 500.0
				
				Hud_SetText( HudElement( "MG_Style_Label" ), "Stylepoints ^FFC83200" + stylepoints.tointeger())
				Hud_SetWidth( HudElement( "MG_Style_Bar" ), StyleBarWidth)
				
			}
		}
		
		wait 0.025
	}
	
}

void function MG_Ultrakill_styleemeter_destroy(){
	entity player = GetLocalClientPlayer()
	Signal(player, "StopStylemeter")
	
	Hud_SetVisible(HudElement( "MG_Style_Bar" ), false)
	Hud_SetVisible(HudElement( "MG_Style_Label" ), false)
	Hud_SetVisible(HudElement( "MG_Style_History_Wallrun" ), false)
	Hud_SetVisible(HudElement( "MG_Style_History_Superglide" ), false)
	Hud_SetVisible(HudElement( "MG_Style_History_Slide" ), false)
	Hud_SetVisible(HudElement( "MG_Style_History_Speed" ), false)
}



// pets
void function MG_Pet_Summoner(){
	thread MG_Pet_Follower()
}

void function MG_Pet_Follower(){
    entity player = GetLocalClientPlayer()
    vector petOffsetAngle = <0, 0, 0>
	vector petOffsetOrigin = <0, 0, 0>
    EndSignal(player, "StopPet")
    
    switch(activePet){
	case "nessy":
		pet = CreateClientSidePropDynamic(player.GetLocalOrigin(), player.GetLocalAngles(), $"mdl/props/charm/charm_nessy.rmdl")
		petOffsetAngle = <0, 180, -30>
		petOffsetOrigin = <0, 0, 12>
		pet.SetModelScale(10)
		break
	case "corgi":
		pet = CreateClientSidePropDynamic(player.GetLocalOrigin(), player.GetLocalAngles(), $"mdl/vehicle/hovership/hovership_platform_mp.rmdl")
		petOffsetOrigin = <0, 0, 40>
		pet.SetModelScale(0.01)
		break
	case "controllerplayer":
		pet = CreateClientSidePropDynamic(player.GetLocalOrigin(), player.GetLocalAngles(), $"mdl/garbage/garbage_bag_plastic_a.rmdl")
		break
	case "error":
		pet = CreateClientSidePropDynamic(player.GetLocalOrigin(), player.GetLocalAngles(), $"mdl/error.rmdl")
		break
	default:
		pet = CreateClientSidePropDynamic(player.GetLocalOrigin(), player.GetLocalAngles(), $"mdl/props/charm/charm_nessy.rmdl")
		petOffsetAngle = <0, 180, -30>
		petOffsetOrigin = <0, 0, 12>
		pet.SetModelScale(10)
		break
    }
    
    float yaw
    float pitch
    array<vector> positions
    
    if(!IsValid(player) || !IsValid(pet)) return
   
    entity petMover = CreateClientsideScriptMover($"mdl/dev/empty_model.rmdl", pet.GetLocalOrigin(), pet.GetLocalAngles())
    pet.SetParent(petMover)
    
    while (true)
    {
        if(!IsValid(player) || !IsValid(pet)) return
	
	vector playerPosition = player.GetLocalOrigin()
        positions.append(playerPosition)
        wait petHz
	
        if (positions.len() >= 10 && MG_Distance3D(pet.GetOrigin(), playerPosition) >= 40.0 && IsValid(pet))
        {
		vector targetPosition = positions[positions.len() - 10]
		vector direction = playerPosition - targetPosition

		petMover.NonPhysicsMoveTo(targetPosition + petOffsetOrigin, petHz, 0, 0)
		
		yaw = atan2(direction.y, direction.x) * (180.0 / 3.1415)
		pitch = atan2(direction.z, sqrt(direction.x * direction.x + direction.y * direction.y)) * (180.0 / 3.1415)
		petMover.NonPhysicsRotateTo(<pitch, yaw, 0> + petOffsetAngle, petHz, 0, 0)
		positions = positions.slice(1);
        }
    }
}

void function MG_Pet_Destroy(){
	entity player = GetLocalClientPlayer()
	
	if(!IsValid(player) || !IsValid(pet)) return
	
	Signal(player, "StopPet")
	
	pet.Destroy()
	
	pet = null
}

void function MG_Pet_setActive(string petname){
	activePet = petname
}

//  -  -+-+--+- -  +-++-++-+-    -++++-+--++-+  +-++-++-++-+--++-+
//  +++++� +-++-+  �  � �� ��    ���� � +-+� �  �  +-����+� +-++-�
//   ++ +-+-+- -   +-++-++-+--+  -+++ - -+-+-+  +-+- -- -+-+-+-- -
void function MG_CoolCamera(){
	
	userVolume = GetConVarFloat("sound_volume")
	entity player = GetLocalClientPlayer()
	
	if(!IsValid(player) || isInSpecCam == true || isInFreeCam == true || isInIntro == true) return
	
	EndSignal(player, "IntroSkipped")
	
	isInIntro = true
	
	SetConVarFloat("sound_volume", 0.0)
	player.ClientCommand("ToggleHUD")
	DoF_SetFarDepth( 6000, 10000 )	
	
	
	waitthread MG_CoolCamera_Seq1()
	
	RegisterConCommandTriggeredCallback("+use", MG_CoolCamera_Skip_Pressed) //only allow skip after all maps loaded
	Hud_SetVisible( HudElement( "ChallengesAccuracyValue" ), true) // temp. using aimtrainer hud
	Hud_SetText( HudElement( "ChallengesAccuracyValue" ), "^002FFF00 PRESS ^FFFFFFFF %use% ^002FFF00 TO SKIP")
	
	
	waitthread MG_CoolCamera_Seq2()
	waitthread MG_CoolCamera_Seq3()
	waitthread MG_CoolCamera_Seq4()
	
	isInIntro = false
	
	MG_Speedometer_toggle(true)
	MG_MovementOverlay_toggle(true)
	MG_Ultrakill_styleemeter_toggle(true)
	player.ClientCommand("ToggleHUD")
	DoF_SetNearDepthToDefault()
	DoF_SetFarDepthToDefault()
	SetConVarFloat("sound_volume", userVolume)
	Hud_SetVisible( HudElement( "ChallengesAccuracyValue" ), false)
		
	foreach ( rui in file.infoPanels[ 0 ] )
		RuiDestroyIfAlive( rui )
}

void function MG_CoolCamera_Change_Setting(bool onoff){
	isIntroOn = onoff
	MovementGymSavePBToFile()
}

void function MG_CoolCamera_Seq1()
{
    if ( !IsValid( GetLocalClientPlayer() ) ) return

    Warning("cool cam seq1")	
    entity camera = CreateClientSidePointCamera(<-18945, 2412, 6314>, <-15, -31, 0>, 17)
    camera.SetFOV(65)
    entity cutsceneMover = CreateClientsideScriptMover($"mdl/dev/empty_model.rmdl", <-18945, 2412, 6314>, <0, 180, 0>)
    camera.SetParent(cutsceneMover)
    GetLocalClientPlayer().SetMenuCameraEntity( camera )
    
    
    cutsceneMover.NonPhysicsMoveTo( <-19060,2222,6314>, 15, 0, 0)
    
    MG_CreateTextInfoPanel( "FLOWSTATE\nPRESENTS", "", <-18965, 2452, 6354>, <-15, -31, 0>, 20, 0, 0)
    wait 7
    
    if ( IsValid( GetLocalClientPlayer() ) ) GetLocalClientPlayer().ClearMenuCameraEntity()
    if ( IsValid( cutsceneMover ) ) cutsceneMover.Destroy()
    if ( IsValid( camera ) ) camera.Destroy()


}

void function MG_CoolCamera_Seq2()
{
    if ( !IsValid( GetLocalClientPlayer() ) ) return
    
    Warning("cool cam seq2")
    
    float fov_00 = 40
    float speed_00 = 8
    vector origin_00 = < 3289.5, 2606.5, 22447.6 >
    vector angles_00 = < -10.1731, 92.4154, 0 >

    entity camera_00 = CreateClientSidePointCamera( origin_00, angles_00, fov_00 )
    entity scriptMover_00 = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", origin_00, angles_00 )
    camera_00.SetParent( scriptMover_00 )
    if ( IsValid( GetLocalClientPlayer() ) ) GetLocalClientPlayer().SetMenuCameraEntity( camera_00 )

    scriptMover_00.NonPhysicsMoveTo( < 3148.3, 2698.3, 22465.9 >, speed_00, 0, 0)
    scriptMover_00.NonPhysicsRotateTo( < -9.6192, 74.9548, 0 >, speed_00, 0, 0)
    MG_CreateTextInfoPanel( "MADE BY DEAFPS", "", < 3194.2, 3011.28, 22359.7 >, < 0, 90, 0 >, 10, 0, 0)
    wait 3

    if ( IsValid( GetLocalClientPlayer() ) ) GetLocalClientPlayer().ClearMenuCameraEntity()
    if ( IsValid( scriptMover_00 ) ) scriptMover_00.Destroy()
    if ( IsValid( camera_00 ) ) camera_00.Destroy()


}

void function MG_CoolCamera_Seq3()
{
    if ( !IsValid( GetLocalClientPlayer() ) ) return
    
    Warning("cool cam seq3")
    
    float fov_00 = 40
    float speed_00 = 15
    vector origin_00 = < 24844.1, -20737, 23044.41 >
    vector angles_00 = < 1.9298, 1.4173, 0 >

    entity camera_00 = CreateClientSidePointCamera( origin_00, angles_00, fov_00 )
    entity scriptMover_00 = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", origin_00, angles_00 )
    camera_00.SetParent( scriptMover_00 )
    if ( IsValid( GetLocalClientPlayer() ) ) GetLocalClientPlayer().SetMenuCameraEntity( camera_00 )

    scriptMover_00.NonPhysicsMoveTo( < 25031.6, -20508, 23023.71 >, speed_00, 0, 0)
    scriptMover_00.NonPhysicsRotateTo( < -2.6935, -67.6314, 0 >, speed_00, 0, 0)
    MG_CreateTextInfoPanel( "WITH HELP FROM:\n - CafeFPS my beloved\n - Julefox\n - AyeZee\n And others :)", "", < 25222.88, -20742.5, 22888.9 >, < 0, 0, 0 >, 10, 0, 0)
    wait 3

    if ( IsValid( GetLocalClientPlayer() ) ) GetLocalClientPlayer().ClearMenuCameraEntity()
    if ( IsValid( scriptMover_00 ) ) scriptMover_00.Destroy()
    if ( IsValid( camera_00 ) ) camera_00.Destroy()


}

void function MG_CoolCamera_Seq4()
{
    if ( !IsValid( GetLocalClientPlayer() ) ) return
    
    Warning("cool cam seq4")
    
    float fov_00 = 80
    float speed_00 = 5
    vector origin_00 = < 10735.77, 10333.63, -3922.788 >
    vector angles_00 = < 82.9019, -91.2875, 0 >

    entity camera_00 = CreateClientSidePointCamera( origin_00, angles_00, fov_00 )
    entity scriptMover_00 = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", origin_00, angles_00 )
    camera_00.SetParent( scriptMover_00 )
    if ( IsValid( GetLocalClientPlayer() ) ) GetLocalClientPlayer().SetMenuCameraEntity( camera_00 )

    scriptMover_00.NonPhysicsMoveTo( < 10735.17, 10302.63, -4233.188 >, speed_00, 0, 0)
    scriptMover_00.NonPhysicsRotateTo( < -0.7512, -92.0159, 0 >, speed_00, 0, 0)
    wait 2.5
    MG_CreateTextInfoPanel( "MOVEMENT\n        GYM", "", < 10800.6, 9954.601, -3950.2 >, < 0, -90, 0 >, 30, 0, 0) 
    wait 2.5

    if ( IsValid( GetLocalClientPlayer() ) ) GetLocalClientPlayer().ClearMenuCameraEntity()
    if ( IsValid( scriptMover_00 ) ) scriptMover_00.Destroy()
    if ( IsValid( camera_00 ) ) camera_00.Destroy()
    DeregisterConCommandTriggeredCallback("+use", MG_CoolCamera_Skip_Pressed)
}

void function MG_CoolCamera_destroy()
{
	entity player = GetLocalClientPlayer()
	if(!IsValid(player)) return
	
	Signal(player, "IntroSkipped")
	DeregisterConCommandTriggeredCallback("+use", MG_CoolCamera_Skip_Pressed)
	
	isInIntro = false
	
	if ( IsValid( player ) ) player.ClearMenuCameraEntity()
	
	if(isSpeedoOn == true)
		MG_Speedometer_toggle(true)
	
	if(isKeysOn == true)
		MG_MovementOverlay_toggle(true)
	
	if(isStyleOn == true)
		MG_Ultrakill_styleemeter_toggle(true)
	
	player.ClientCommand("ToggleHUD")
	DoF_SetNearDepthToDefault()
	DoF_SetFarDepthToDefault()
	SetConVarFloat("sound_volume", userVolume)
	Hud_SetVisible( HudElement( "ChallengesAccuracyValue" ), false)
		
	foreach ( rui in file.infoPanels[ 0 ] )
		RuiDestroyIfAlive( rui )
		
	Warning("cool cam destroyed")	
}

void function MG_CoolCamera_Skip_Pressed(var button)
{
	if(isInIntro)
		MG_CoolCamera_destroy()
	
	if(isInFreeCam)
		MG_FreeCam_Destroy()
		
	if(isInSpecCam){
		if( Time() - lastTimeSpectateUsed < 3 ) return
		MG_SpecCam_Destroy()
	}
	
}

void function MG_FreeCam_init()
{
	thread MG_FreeCam()
}
void function MG_FreeCam()
{
	if ( !IsValid( GetLocalClientPlayer() ) || isInSpecCam == true || isInFreeCam == true || isInIntro == true) return
    
	EndSignal(GetLocalClientPlayer(), "FreecamExit")
    
	isInFreeCam = true
	
	RegisterConCommandTriggeredCallback("+use", MG_CoolCamera_Skip_Pressed)
	Hud_SetVisible( HudElement( "ChallengesAccuracyValue" ), true) // temp. using aimtrainer hud
	Hud_SetText( HudElement( "ChallengesAccuracyValue" ), "^002FFF00 PRESS ^FFFFFFFF %use% ^002FFF00 TO EXIT")	

	freecam = CreateClientSidePointCamera(GetLocalClientPlayer().GetLocalOrigin() + <0, 0, 56>, GetLocalClientPlayer().GetLocalAngles(), 110)
	freecamMover = CreateClientsideScriptMover($"mdl/dev/empty_model.rmdl", GetLocalClientPlayer().GetLocalOrigin() + <0, 0, 56>, GetLocalClientPlayer().GetLocalAngles())
	freecam.SetParent(freecamMover)
	GetLocalClientPlayer().SetMenuCameraEntity( freecam )
	GetLocalClientPlayer().SetMenuCameraEntityWithAudio(freecam)
	
	// workaround for freezing player movement but not cam
	GetLocalClientPlayer().ClientCommand("+jump")
	GetLocalClientPlayer().ClientCommand("+forward")
	GetLocalClientPlayer().ClientCommand("+moveleft")
	GetLocalClientPlayer().ClientCommand("+moveright")
	GetLocalClientPlayer().ClientCommand("+backward")
    
	while (true) {
		if (IsValid(GetLocalClientPlayer())) {
			vector forward = freecamMover.GetForwardVector();
			vector right = freecamMover.GetRightVector();
			vector movement = <0, 0, 0>
			
			if (InputIsButtonDown(KEY_W)) {
				movement += forward * 10
			}
			if (InputIsButtonDown(KEY_S)) {
				movement -= forward * 10
			}
			if (InputIsButtonDown(KEY_A)) {
				movement -= right * 10
			}
			if (InputIsButtonDown(KEY_D)) {
				movement += right * 10
			}

			freecamMover.SetLocalAngles(GetLocalClientPlayer().CameraAngles())
			freecamMover.SetOrigin(freecamMover.GetOrigin() + movement)
			//freecamMover.SetOrigin(GetLocalClientPlayer().GetOrigin() + <0, 0, 56>)

		}

		WaitFrame();
	}
}

void function MG_FreeCam_Destroy()
{
	isInFreeCam = false
	
	if ( IsValid( GetLocalClientPlayer() ) ) GetLocalClientPlayer().ClearMenuCameraEntity()
	
	Signal(GetLocalClientPlayer(), "FreecamExit")
	
	freecam.Destroy()
	freecamMover.Destroy()
	
	DeregisterConCommandTriggeredCallback("+use", MG_CoolCamera_Skip_Pressed)
	Hud_SetVisible( HudElement( "ChallengesAccuracyValue" ), false)
	
	// workaround for freezing player movement but not cam
	GetLocalClientPlayer().ClientCommand("-jump")
	GetLocalClientPlayer().ClientCommand("-forward")
	GetLocalClientPlayer().ClientCommand("-moveleft")
	GetLocalClientPlayer().ClientCommand("-moveright")
	GetLocalClientPlayer().ClientCommand("-backward")
}


void function MG_SpecCam_getTarget(string targetName)
{
	entity player = GetLocalClientPlayer()
	
	if( targetName == "" || !IsValid( player ) || isInSpecCam == true ) return

	if( Time() - lastTimeSpectateUsed < 3 ) return
	
	if( isInSpecCam == false && isInFreeCam == false && isInIntro == false ){
		foreach(target in GetPlayerArray_Alive()) {
		
			if( target.GetPlayerName() == targetName ){
				
				if(IsValid(target)){
					string command = "spectate " + targetName
					
					isInSpecCam = true
					RegisterConCommandTriggeredCallback("+use", MG_CoolCamera_Skip_Pressed)
					Hud_SetVisible( HudElement( "ChallengesAccuracyValue" ), true) // temp. using aimtrainer hud
					Hud_SetText( HudElement( "ChallengesAccuracyValue" ), "^002FFF00 PRESS ^FFFFFFFF %use% ^002FFF00 TO EXIT")
					lastTimeSpectateUsed = Time()
					player.ClientCommand(command)
				}
			} 
		
		}
	
	}

}

void function MG_SpecCam(entity target)
{
	if ( !IsValid(GetLocalClientPlayer()) || !IsValid(target) || isInSpecCam == true || isInFreeCam == true || isInIntro == true ) return

	EndSignal(GetLocalClientPlayer(), "SpeccamExit")
    
	isInSpecCam = true
	
	RegisterConCommandTriggeredCallback("+use", MG_CoolCamera_Skip_Pressed)
	Hud_SetVisible( HudElement( "ChallengesAccuracyValue" ), true) // temp. using aimtrainer hud
	Hud_SetText( HudElement( "ChallengesAccuracyValue" ), "^002FFF00 PRESS ^FFFFFFFF %use% ^002FFF00 TO EXIT")	

	speccam = CreateClientSidePointCamera(target.GetLocalOrigin() + <0, 0, 56>, target.GetLocalAngles(), 110)
	speccam.SetParent(target)
	
	GetLocalClientPlayer().SetMenuCameraEntity( speccam )
	GetLocalClientPlayer().SetMenuCameraEntityWithAudio(speccam)
	GetLocalClientPlayer().SetMenuCameraNearZ(17)
	
	
	
	//GetLocalClientPlayer().FreezeControlsOnClient()
		    
	while (true) {
		if (!IsValid(target)) {
			MG_SpecCam_Destroy()
			return
		}

		WaitFrame();
	}
}

void function MG_SpecCam_Destroy()
{
	
	
	
	isInSpecCam = false
	
	//if ( IsValid( GetLocalClientPlayer() ) ) GetLocalClientPlayer().ClearMenuCameraEntity()
	
	entity player = GetLocalClientPlayer()
	
	string command = "spectate stop"
	player.ClientCommand(command)
	
	
	//Signal(GetLocalClientPlayer(), "SpeccamExit")
	//
	//speccam.Destroy()
	//
	DeregisterConCommandTriggeredCallback("+use", MG_CoolCamera_Skip_Pressed)
	//
	Hud_SetVisible( HudElement( "ChallengesAccuracyValue" ), false)
	//
	//GetLocalClientPlayer().UnfreezeControlsOnClient()
	//
}



//  +-++-++-+- -+++  +-+++   +-+-+-++-+--++-+
//  +-++-++-�������  �-+�-+   � ����+� +-++-+
//  +-+-  - -+-++++  -  +-+   - -- -+-+-+-+-+
void function MG_Spawn_PB_Timers()
{
	//Hub Board--------------------------------------------------------------------------------------------------
	MG_Spawn_World_Image(< 10523, 9695, -4010.2 >, < 0, 180, 0 >, " ", false, 250, 250, 0.3, < 0, 0, 175 >) // dark background
	MG_Spawn_World_Image(< 10525, 9695, -4010.2 >, < 0, 180, 0 >, "rui/flowstatecustom/dea/saved_times", true, 250, 250, 1) // actual img
	
	MG_CreateTextInfoPanel( MG_Convert_Sec_to_Time(pb_time_m1), "", < 10450, 9710, -4209 >, < 0, 180, 0 >, 15, 1, 1) //PB
	MG_CreateTextInfoPanel( MG_Convert_Sec_to_Time(lasttime_m1), "", < 10450, 9637, -4209 >, < 0, 180, 0 >, 15, 1, 2) //LAST TIME
	
	MG_CreateTextInfoPanel( MG_Convert_Sec_to_Time(pb_time_m2), "", < 10450, 9710, -4245 >, < 0, 180, 0 >, 15, 2, 1) //PB
	MG_CreateTextInfoPanel( MG_Convert_Sec_to_Time(lasttime_m2), "", < 10450, 9637, -4245 >, < 0, 180, 0 >, 15, 2, 2) //LAST TIME
	
	MG_CreateTextInfoPanel( MG_Convert_Sec_to_Time(pb_time_m3), "", < 10450, 9710, -4281 >, < 0, 180, 0 >, 15, 3, 1) //PB
	MG_CreateTextInfoPanel( MG_Convert_Sec_to_Time(lasttime_m3), "", < 10450, 9637, -4281 >, < 0, 180, 0 >, 15, 3, 2) //LAST TIME
	
	MG_CreateTextInfoPanel( MG_Convert_Sec_to_Time(pb_time_m4), "", < 10450, 9710, -4317 >, < 0, 180, 0 >, 15, 4, 1) //PB
	MG_CreateTextInfoPanel( MG_Convert_Sec_to_Time(lasttime_m4), "", < 10450, 9637, -4317 >, < 0, 180, 0 >, 15, 4, 2) //LAST TIME
}

void function MG_ButtonImgs()
{
	MG_Spawn_World_Image(< 10947, 10011.12, -4200 >, < 0, 0, 0 >, "rui/flowstatecustom/dea/button_m1", true, 50, 50, 1)
	MG_Spawn_World_Image(< 10947, 9923.115, -4200 >, < 0, 0, 0 >, "rui/flowstatecustom/dea/button_m2", true, 50, 50, 1)
	MG_Spawn_World_Image(< 10947, 9832.81, -4200 >, < 0, 0, 0 >, "rui/flowstatecustom/dea/button_m3", true, 50, 50, 1)
	//MG_Spawn_World_Image(< 10947, 9742.457, -4200 >, < 0, 0, 0 >, "rui/flowstatecustom/dea/button_m4", true, 50, 50, 1)
	MG_Spawn_World_Image(< 10517, 10158.35, -4200 >, < 0, 180, 0 >, "rui/flowstatecustom/dea/button_e1", true, 50, 50, 1)
	MG_Spawn_World_Image(< 10517, 10077.86, -4200 >, < 0, 180, 0 >, "rui/flowstatecustom/dea/button_e2", true, 50, 50, 1)
	MG_Spawn_World_Image(< 10517, 9994.362, -4200 >, < 0, 180, 0 >, "rui/flowstatecustom/dea/button_e3", true, 50, 50, 1)
	MG_Spawn_World_Image(< 10517, 9907.363, -4200 >, < 0, 180, 0 >, "rui/flowstatecustom/dea/button_e4", true, 50, 50, 1)
	MG_Spawn_World_Image(< 10896.9, 9490, -4200 >, < 0, -90, 0 >, "rui/flowstatecustom/dea/button_e5", true, 50, 50, 1)
	MG_Spawn_World_Image(< 10814.41, 9490, -4200 >, < 0, -90, 0 >, "rui/flowstatecustom/dea/button_e6", true, 50, 50, 1)
	MG_Spawn_World_Image(< 10730, 9490, -4200 >, < 0, -90, 0 >, "rui/flowstatecustom/dea/button_e7", true, 50, 50, 1)
	MG_Spawn_World_Image(< 10649, 9490, -4200 >, < 0, -90, 0 >, "rui/flowstatecustom/dea/button_e8", true, 50, 50, 1)
	MG_Spawn_World_Image(< 10569, 9490, -4200 >, < 0, -90, 0 >, "rui/flowstatecustom/dea/button_e9", true, 50, 50, 1)
	MG_Spawn_World_Image(< 10947, 9648.403, -4200 >, < 0, 0, 0 >, "rui/flowstatecustom/dea/button_freeroam", true, 50, 50, 1)
	
}

//  +-++-+-  -+-+  +-++-+   +++- -+-+
//  +-++-�+++++�    � � �   ���� � � 
//  +-+- - ++ +-+   - +-+  o++++-+ - 
void
function MovementGymSavePBToFile() {
	DevTextBufferClear()
	DevTextBufferWrite("untyped\n\n")
	DevTextBufferWrite("global const int MG_SAVED_PB_M1 = " + pb_time_m1 +"\n")
	DevTextBufferWrite("global const int MG_SAVED_PB_M2 = " + pb_time_m2 +"\n")
	DevTextBufferWrite("global const int MG_SAVED_PB_M3 = " + pb_time_m3 +"\n")
	DevTextBufferWrite("global const int MG_SAVED_PB_M4 = " + pb_time_m4 +"\n\n")
	
	DevTextBufferWrite("global const int MG_SAVED_LT_M1 = " + lasttime_m1 +"\n")
	DevTextBufferWrite("global const int MG_SAVED_LT_M2 = " + lasttime_m2 +"\n")
	DevTextBufferWrite("global const int MG_SAVED_LT_M3 = " + lasttime_m3 +"\n")
	DevTextBufferWrite("global const int MG_SAVED_LT_M4 = " + lasttime_m4 +"\n\n")
	
	DevTextBufferWrite("global const bool MG_SAVED_ISKEYSON = " + isKeysOn +"\n")
	DevTextBufferWrite("global const bool MG_SAVED_ISSPEEDOON = " + isSpeedoOn +"\n")
	DevTextBufferWrite("global const bool MG_SAVED_ISSTYLEON = " + isStyleOn +"\n")
	DevTextBufferWrite("global const bool MG_SAVED_ISINTROON = " + isIntroOn +"\n")

	DevP4Add("cl_movement_gym_personalbest.nut")
	DevTextBufferDumpToFile("scripts/vscripts/gamemodes/fs_movementgym/cl_movement_gym_personalbest.nut")
	
	Warning("[!] PERSONAL BEST TIMES AND SETTINGS SAVED")
}



//  
//  util
//  
void function MG_Spawn_World_Image(vector origin, vector angles, string imgpath, bool useImgpath, float width, float height, float opacity, vector rgb = < 0, 0, 0 >) {
	
	origin += (AnglesToUp( angles )*-1) * (height*0.5)
	var topo = CreateRUITopology_Worldspace( origin, angles, width, height )
	
	var rui = RuiCreate( $"ui/basic_image.rpak", topo, RUI_DRAW_WORLD, RUI_SORT_SCREENFADE + 1 )
	
	RuiSetFloat( rui, "basicImageAlpha", opacity)
	
	if(useImgpath)
		RuiSetString( rui, "basicImage", imgpath)
	
	if(!useImgpath)
		RuiSetFloat3( rui, "basicImageColor", SrgbToLinear( rgb / 255 ))
}

void function MG_CreateTextInfoPanel( string text, string subText, vector origin, vector angles, float textScale, int ID, int type = 0){
	float width = 40 * textScale
	float height = 40 * textScale


	origin += (AnglesToUp( angles )*-1) * (height*0.5)
	origin.z += 400
	origin.x += 75
	
	var topo = CreateRUITopology_Worldspace( origin, angles, width, height )
	
	//Cool Cam Text
	if(type == 0){
		var rui = RuiCreate( $"ui/announcement_quick_right.rpak", topo, RUI_DRAW_WORLD, RUI_SORT_SCREENFADE + 1 )
		RuiSetGameTime( rui, "startTime", Time() )
		RuiSetFloat( rui, "duration", 99999999 )
		RuiSetString( rui, "messageText", text)
		
		if ( !( ID in file.infoPanels ) )
		file.infoPanels[ ID ] <- []
	
		file.infoPanels[ ID ].append( rui )
	}
	
	//Personal Best Time
	if(type == 1){
		var rui = RuiCreate( $"ui/announcement_quick_right.rpak", topo, RUI_DRAW_WORLD, RUI_SORT_SCREENFADE + 1 )
		RuiSetGameTime( rui, "startTime", Time() )
		RuiSetFloat( rui, "duration", 99999999 )
		RuiSetString( rui, "messageText", text)
		
		if ( !( ID in file.personalBest ) )
		file.personalBest[ ID ] <- []
	
		file.personalBest[ ID ].append( rui )
	}
	
	//Personal Best Time
	if(type == 2){
		var rui = RuiCreate( $"ui/announcement_quick_right.rpak", topo, RUI_DRAW_WORLD, RUI_SORT_SCREENFADE + 1 )
		RuiSetGameTime( rui, "startTime", Time() )
		RuiSetFloat( rui, "duration", 99999999 )
		RuiSetString( rui, "messageText", text)
		
		if ( !( ID in file.lastTimer ) )
		file.lastTimer[ ID ] <- []
	
		file.lastTimer[ ID ].append( rui )
	}
	//Thick Text
	if(type == 3){
		var rui = RuiCreate( $"ui/wave_announcement.rpak", topo, RUI_DRAW_WORLD, RUI_SORT_SCREENFADE + 1 )
		RuiSetGameTime( rui, "startTime", Time() )
		RuiSetGameTime( rui, "endTime", 99999999 )
		RuiSetString( rui, "waveTitle", text)
		RuiSetString( rui, "subTitle", subText)
		
		// ui asset missing for pips
			RuiSetInt( rui, "numPips", 0 )
			RuiSetInt( rui, "numFilledPips", 1 )
		
		if ( !( ID in file.hintPanels ) )
		file.hintPanels[ ID ] <- []
	
		file.hintPanels[ ID ].append( rui )
	}
}

float function MG_Distance3D(v1,v2){ // yoinked from csgo, thx underpayed valve employee
	local a = (v2.x-v1.x)
	local b = (v2.y-v1.y)
	local c = (v2.z-v1.z)
	
	return sqrt((a*a)+(b*b)+(c*c))
}

string function MG_GetDateString() {

    local unixTime = GetUnixTimestamp()

    local seconds = unixTime % 60
    unixTime = unixTime / 60
    local minutes = unixTime % 60
    unixTime = unixTime / 60
    local hours = unixTime % 24
    unixTime = unixTime / 24
    local days = unixTime % 31 + 1
    unixTime = unixTime / 31
    local months = unixTime % 12 + 1
    local years = unixTime / 12 + 1970

    // Format the date string
    string formattedDate = format("%04d-%02d-%02d %02d:%02d:%02d",
        years,
        months,
        days,
        hours,
        minutes,
        seconds
    )
    
    return formattedDate
}

string function MG_Convert_Sec_to_Time(int totalSeconds, bool showH = false) {
    string formattedTime
    local hours = totalSeconds / 3600
    local minutes = (totalSeconds % 3600) / 60
    local seconds = totalSeconds % 60

    switch (showH){
	case true:
		formattedTime = format("%02d:%02d:%02d",
			hours,
			minutes,
			seconds
		)
		break
	case false:
		formattedTime = format("%02d:%02d",
			minutes,
			seconds
		)
		break
    }
    
    return formattedTime
}


//
//  custom pilot rui
//

void function MG_CustomPilotRUI( entity player, var rui ) {
	
	RuiSetInt( rui, "micStatus", 0 )
	RuiSetColorAlpha( rui, "customCharacterColor", SrgbToLinear( <0, 0, 255> / 255.0 ), 1.0 )
	RuiSetBool( rui, "useCustomCharacterColor", true )
	
	switch(player.GetPlayerName()) {
		case "DEAFPS":
			RuiSetImage( rui, "playerIcon", $"rui/flowstatecustom/dea/dea_pfp" )
			RuiSetString( rui, "name", "DEAFPS" )
			break
		case "DEAR5R":
			RuiSetImage( rui, "playerIcon", $"rui/flowstatecustom/dea/dea_pfp" )
			RuiSetString( rui, "name", "DEAFPS" )
		case "LoyTakian":
			RuiSetImage( rui, "playerIcon", $"rui/flowstatecustom/dea/loy_pfp" )
			RuiSetString( rui, "name", "Loy" )
			break
	}
	
}

//  +-+-  +-++-++-+-+-+  +-++-+-  -+-++-++-+++++-+
//  �  �  +-�+-++-+��    ���� �+++++� ���+� ��� � 
//  +-+--+- -+-++-+-+-+  - -+-+ ++ +-+- -+-++++ - 
void function Cl_Classic_Movement(){
	
	if(Flowstate_MovementGym_ClassicMovement() != true)
		return
	
	//Disable Lurches
	SetConVarFloat("Player_extraairaccelleration", 0.0)
	SetConVarFloat("jump_keyboardgrace_strength", 0.0)
	SetConVarInt("cl_quota_stringCmdsPerSecond", 64)
	
	if(Flowstate_MovementGym_ClassicMovement_AutoBHOP())
		Cl_Classic_Movement_AutoBHOP()
}

void function Cl_Classic_Movement_AutoBHOP(){
	
	if(Flowstate_MovementGym_ClassicMovement() != true) return
	
	while(true){
		
		if(IsValid(GetLocalClientPlayer()) && InputIsButtonDown(KEY_SPACE)){
			GetLocalClientPlayer().ClientCommand("+jump")
			WaitFrame()
			GetLocalClientPlayer().ClientCommand("-jump")
		}
		
		wait 0.005
	}
}



