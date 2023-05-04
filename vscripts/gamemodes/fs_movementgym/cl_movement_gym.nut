untyped

globalize_all_functions

bool kmh
float speedometer_hz
string time = ""

// init
void function Cl_MovementGym_Init()
{
	entity player = GetLocalClientPlayer()
	
	// Get Movement Gym User Settings
	speedometer_hz = 0.05
	kmh = true
	
	// Register Signals
	RegisterSignal("StopStopWatch")
	RegisterSignal("StopSpeedometer")
	
	// Hud 
	MG_Speedometer_toggle(true)
	MG_MovementOverlay_toggle(true)
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
		} else {
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
					
					float playerVelNormal = playerVel * (0.091392) //KM/H
					
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
						
						float playerVelNormal = playerVel * (0.091392) //KM/H
						
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
					
					float playerVelNormal = playerVel * (0.091392) //KM/H
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
						
						float playerVelNormal = playerVel * (0.091392) //KM/H
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
		RegisterButtonPressedCallback(KEY_W, MG_MovementOverlay_W_Pressed)
		RegisterButtonReleasedCallback(KEY_W, MG_MovementOverlay_W_Released)
		// A
		RegisterButtonPressedCallback(KEY_A, MG_MovementOverlay_A_Pressed)
		RegisterButtonReleasedCallback(KEY_A, MG_MovementOverlay_A_Released)
		// S
		RegisterButtonPressedCallback(KEY_S, MG_MovementOverlay_S_Pressed)
		RegisterButtonReleasedCallback(KEY_S, MG_MovementOverlay_S_Released)
		// D
		RegisterButtonPressedCallback(KEY_D, MG_MovementOverlay_D_Pressed)
		RegisterButtonReleasedCallback(KEY_D, MG_MovementOverlay_D_Released)
		// CTRL
		RegisterButtonPressedCallback(KEY_LCONTROL, MG_MovementOverlay_CTRL_Pressed)
		RegisterButtonReleasedCallback(KEY_LCONTROL, MG_MovementOverlay_CTRL_Released)
		// SPACE
		RegisterButtonPressedCallback(KEY_SPACE, MG_MovementOverlay_SPACE_Pressed)
		RegisterButtonReleasedCallback(KEY_SPACE, MG_MovementOverlay_SPACE_Released)
	} else {
		Hud_SetVisible(HudElement( "MG_MO_W" ), false)
		Hud_SetVisible(HudElement( "MG_MO_A" ), false)
		Hud_SetVisible(HudElement( "MG_MO_S" ), false)
		Hud_SetVisible(HudElement( "MG_MO_D" ), false)
		Hud_SetVisible(HudElement( "MG_MO_CTRL" ), false)
		Hud_SetVisible(HudElement( "MG_MO_SPACE" ), false)
		
		// W
		DeregisterButtonPressedCallback(KEY_W, MG_MovementOverlay_W_Pressed)
		DeregisterButtonReleasedCallback(KEY_W, MG_MovementOverlay_W_Released)
		// A
		DeregisterButtonPressedCallback(KEY_A, MG_MovementOverlay_A_Pressed)
		DeregisterButtonReleasedCallback(KEY_A, MG_MovementOverlay_A_Released)
		// S
		DeregisterButtonPressedCallback(KEY_S, MG_MovementOverlay_S_Pressed)
		DeregisterButtonReleasedCallback(KEY_S, MG_MovementOverlay_S_Released)
		// D
		DeregisterButtonPressedCallback(KEY_D, MG_MovementOverlay_D_Pressed)
		DeregisterButtonReleasedCallback(KEY_D, MG_MovementOverlay_D_Released)
		// CTRL
		DeregisterButtonPressedCallback(KEY_LCONTROL, MG_MovementOverlay_CTRL_Pressed)
		DeregisterButtonReleasedCallback(KEY_LCONTROL, MG_MovementOverlay_CTRL_Released)
		// SPACE
		DeregisterButtonPressedCallback(KEY_SPACE, MG_MovementOverlay_SPACE_Pressed)
		DeregisterButtonReleasedCallback(KEY_SPACE, MG_MovementOverlay_SPACE_Released)
	}
}

void function MG_MovementOverlay_W_Pressed(var button){
  Hud_SetText(HudElement( "MG_MO_W" ), "%W%")
}

void function MG_MovementOverlay_W_Released(var button){
  Hud_SetText(HudElement( "MG_MO_W" ), "%$vgui/fonts/buttons/icon_unbound%")
}

void function MG_MovementOverlay_A_Pressed(var button){
  Hud_SetText(HudElement( "MG_MO_A" ), "%A%")
}

void function MG_MovementOverlay_A_Released(var button){
  Hud_SetText(HudElement( "MG_MO_A" ), "%$vgui/fonts/buttons/icon_unbound%")
}

void function MG_MovementOverlay_S_Pressed(var button){
  Hud_SetText(HudElement( "MG_MO_S" ), "%S%")
}

void function MG_MovementOverlay_S_Released(var button){
  Hud_SetText(HudElement( "MG_MO_S" ), "%$vgui/fonts/buttons/icon_unbound%")
}

void function MG_MovementOverlay_D_Pressed(var button){
  Hud_SetText(HudElement( "MG_MO_D" ), "%D%")
}

void function MG_MovementOverlay_D_Released(var button){
  Hud_SetText(HudElement( "MG_MO_D" ), "%$vgui/fonts/buttons/icon_unbound%")
}

void function MG_MovementOverlay_CTRL_Pressed(var button){
  Hud_SetText(HudElement( "MG_MO_CTRL" ), "%LCTRL%")
}

void function MG_MovementOverlay_CTRL_Released(var button){
  Hud_SetText(HudElement( "MG_MO_CTRL" ), " ")
}

void function MG_MovementOverlay_SPACE_Pressed(var button){
  Hud_SetText(HudElement( "MG_MO_SPACE" ), "%SPACE%")
}

void function MG_MovementOverlay_SPACE_Released(var button){
  Hud_SetText(HudElement( "MG_MO_SPACE" ), " ")
}


//Ultrakill stylemeter
void function MG_Ultrakill_styleemeter_toggle(bool visible){
	if(visible == true){
		//placeholder
	} else {
		//placeholder
	}
}
