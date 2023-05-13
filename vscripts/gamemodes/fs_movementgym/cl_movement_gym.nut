untyped

globalize_all_functions

bool kmh
float speedometer_hz
string time = ""
bool s4lighting

float stylepoints = 0

// init
void function Cl_MovementGym_Init()
{
	entity player = GetLocalClientPlayer()
	
	// Get Movement Gym User Settings
	speedometer_hz = 0.05
	kmh = true
	s4lighting = false
	thread MG_Settings_listener()
	
	// Register Signals
	RegisterSignal("StopStopWatch")
	RegisterSignal("StopSpeedometer")
	RegisterSignal("StopStylemeter")
	RegisterSignal("StopS4")
	
	// Hud 
	MG_Speedometer_toggle(true)
	MG_MovementOverlay_toggle(true)
	MG_Ultrakill_styleemeter_toggle(false)
}

void function MG_Settings_listener(){
	string setting
	entity player = GetLocalClientPlayer()
	string playername = player.GetPlayerName()
	
	while(true){
		setting = GetConVarString("name")
		
		switch (setting) {
			case "mph":
				kmh = false
				MG_Speedometer_destroy()
				WaitFrame()
				thread MG_Speedometer()
				SetConVarString("name", playername)
				break
			case "kmh":
				kmh = true
				MG_Speedometer_destroy()
				WaitFrame()
				thread MG_Speedometer()
				SetConVarString("name", playername)
				break
			case "s4":
				s4lighting = true
				thread MG_ForceLighting()
				SetConVarString("name", playername)
				break
		}
		WaitFrame()
	}		
}



// StopWatch
void function MG_StopWatch_toggle(bool visible){
	if(visible == true)
		thread MG_StopWatch()	
	else
		MG_StopWatch_destroy()
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
		int seconds = currentTime
		if (seconds > 59){
			int minutes = seconds / 60
			int realseconds = seconds - (minutes * 60)
			if(realseconds > 9){
			time = minutes + ":" + realseconds
			Hud_SetText( HudElement( "MG_StopWatch" ), time)
			} else {
			time = minutes + ":0" + realseconds
			Hud_SetText( HudElement( "MG_StopWatch" ), time)
			}
		} else if (seconds > 9) {
			time = "0:" + seconds
			Hud_SetText( HudElement( "MG_StopWatch" ), time)
		} else {
			time = "0:0" + seconds
			Hud_SetText( HudElement( "MG_StopWatch" ), time)
		}
		
		wait 1
	}
	
}

void function MG_StopWatch_Obituary(int seconds, entity name, int map){
	if ( !GetLocalViewPlayer() )
		return
	
	int usertime = seconds
	if (usertime > 59){
		int minutes = usertime / 60
		int realseconds = usertime - (minutes * 60)
			if(realseconds > 9){
				time = minutes + ":" + realseconds
				Obituary_Print_Localized( "%$rui/menu/store/feature_timer% " + name.GetPlayerName() + " has finished" + " Map " + map + " in " + time, GetChatTitleColorForPlayer( GetLocalViewPlayer() ), BURN_COLOR )
			} else {
				time = minutes + ":0" + realseconds
				Obituary_Print_Localized( "%$rui/menu/store/feature_timer% " + name.GetPlayerName() + " has finished" + " Map " + map + " in " + time, GetChatTitleColorForPlayer( GetLocalViewPlayer() ), BURN_COLOR )
			}
		} else if (usertime > 9) {
			time = "0:" + usertime
			Obituary_Print_Localized( "%$rui/menu/store/feature_timer% " + name.GetPlayerName() + " has finished" + " Map " + map + " in " + time, GetChatTitleColorForPlayer( GetLocalViewPlayer() ), BURN_COLOR )
		} else if (usertime > 0) {
			time = "0:0" + usertime
			Obituary_Print_Localized( "%$rui/menu/store/feature_timer% " + name.GetPlayerName() + " has finished" + " Map " + map + " in " + time, GetChatTitleColorForPlayer( GetLocalViewPlayer() ), BURN_COLOR )
		}
	

}

void function MG_StopWatch_destroy(){
	entity player = GetLocalClientPlayer()
	player.Signal("StopStopWatch")
	Hud_SetVisible(HudElement( "MG_StopWatch" ), false)
	Hud_SetVisible(HudElement( "MG_StopWatch_Frame" ), false)
	Hud_SetVisible(HudElement( "MG_StopWatch_Icon" ), false)
	Hud_SetVisible(HudElement( "MG_StopWatch_Label" ), false)
}


// Speedometer
void function MG_Speedometer_toggle(bool visible){
	if(visible == true)
		thread MG_Speedometer()	
	else
		MG_Speedometer_destroy()
}

void function MG_Speedometer(){
	wait 5
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
					
					playerVel = sqrt(playerVelV.x * playerVelV.x + playerVelV.y * playerVelV.y + playerVelV.z * playerVelV.z)
					
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
						
						playerVel = sqrt(playerVelV.x * playerVelV.x + playerVelV.y * playerVelV.y + playerVelV.z * playerVelV.z)
						
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
					
					playerVel = sqrt(playerVelV.x * playerVelV.x + playerVelV.y * playerVelV.y + playerVelV.z * playerVelV.z)
					
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
						
						playerVel = sqrt(playerVelV.x * playerVelV.x + playerVelV.y * playerVelV.y + playerVelV.z * playerVelV.z)
						
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



// Send Checkpoint Set message
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

//Movement WASD overlay
void function MG_MovementOverlay_toggle(bool visible){
	if(visible == true){
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
		
	} else {
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

//Ultrakill stylemeter
void function MG_Ultrakill_styleemeter_toggle(bool visible){
	if(visible == true){
		thread MG_Ultrakill_styleemeter()
	} else {
		MG_Ultrakill_styleemeter_destroy()
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
	
	float laststyletime
	
	float StyleBarWidth
	
	entity player = GetLocalClientPlayer()
	EndSignal(player, "StopStylemeter")
	
	Hud_SetVisible(HudElement( "MG_Style_Bar" ), true)
	
	Hud_SetVisible(HudElement( "MG_Style_Label" ), true)
	Hud_SetY( HudElement( "MG_Style_Label" ), -40 )
	
	Hud_SetVisible(HudElement( "MG_Style_History_Wallrun" ), true)
	Hud_SetVisible(HudElement( "MG_Style_History_Superglide" ), true)
	Hud_SetVisible(HudElement( "MG_Style_History_Slide" ), true)
	Hud_SetVisible(HudElement( "MG_Style_History_Speed" ), true)
	

	
	
	while(true){
		
		entity playerr = GetLocalClientPlayer()
		if( !playerr.IsObserver()){
			if (IsValid(playerr)){
				
				float TimeNow = Time()
				float playerVel
				vector playerVelV = playerr.GetVelocity()
			
				playerVel = sqrt(playerVelV.x * playerVelV.x + playerVelV.y * playerVelV.y + playerVelV.z * playerVelV.z)
				
				
				//airtime---------------------------------------------------------
				if(!player.IsOnGround()){
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
				
				if(wasmantle == true && !player.IsOnGround() && playerVel > 500 &&  player.IsSliding() && airtime <= 0.05){
					float reward = 50.0
					stylepoints += reward
					laststyletime = TimeNow
					lastSG = TimeNow
					timesUsedSG++
					string msg = "%$rui/bullet_point% Superglide ^002FFF00+" + (reward*timesUsedSG).tostring()
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
				if(TimeNow - lastSG > 1.5){
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
