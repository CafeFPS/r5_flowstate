//APEX DUCKHUNT
//Made by @CafeFPS (@CafeFPS)

// Darkes#8647 - duckhunt maps
// everyone else - advice

global function Cl_GamemodeDuckhunt_Init
global function DUCKHUNT_CustomHint
global function DUCKHUNT_Timer
global function ToggleSetHunterClient

struct {
	var activeQuickHint = null
	float endtime = 0
} file

void function Cl_GamemodeDuckhunt_Init()
{
	SetConVarInt("cl_quota_stringCmdsPerSecond", 100)
	//I don't want these things in user screen even if they launch in debug
	SetConVarBool( "cl_showpos", false )
	SetConVarBool( "cl_showfps", false )
	SetConVarBool( "cl_showgpustats", false )
	SetConVarBool( "cl_showsimstats", false )
	SetConVarBool( "host_speeds", false )
	SetConVarBool( "con_drawnotify", false )
	SetConVarBool( "enable_debug_overlays", false )
	
	RegisterSignal("DUCKHUNT_EndTimer")
	AddClientCallback_OnResolutionChanged( ReloadCustomRUI )
}

void function ReloadCustomRUI()
{
	Signal(GetLocalClientPlayer(), "DUCKHUNT_EndTimer")
	
	if(file.endtime != 0)
	{
		Hud_SetEnabled( HudElement( "DuckHuntRoundTimerFrame" ), true )
		Hud_SetVisible( HudElement( "DuckHuntRoundTimerFrame" ), true )
		Hud_SetEnabled( HudElement( "DuckHuntRoundTimer" ), true )
		Hud_SetVisible( HudElement( "DuckHuntRoundTimer" ), true )
		
		thread Thread_DUCKHUNT_Timer(file.endtime)
	}
}

void function ToggleSetHunterClient(bool enable)
{
	RunUIScript("ToggleSetHunter", enable)
}

void function DUCKHUNT_CustomHint(int index, int eHandle)
{
	if(!IsValid(GetLocalViewPlayer())) return

	switch(index)
	{
		case 0:
		QuickHint("", "Kill the ducks!", true, 6)
		EmitSoundOnEntity(GetLocalViewPlayer(), "ui_ingame_switchingsides")
		break
		
		case 1:
		QuickHint("", "Lives remaining: " + eHandle, false, 4)
		EmitSoundOnEntity(GetLocalViewPlayer(), "UI_PostGame_TitanSlideIn")
		break
		
		case 2:
		Obituary_Print_Localized( EHI_GetName(eHandle) + " has selected hunter team.", GetChatTitleColorForPlayer( GetLocalViewPlayer() ), BURN_COLOR )
		EmitSoundOnEntity(GetLocalViewPlayer(), "vdu_on")
		break
		
		case 3:
		QuickHint("", "A duck has reached last floor checkpoint.", false, 5)
		EmitSoundOnEntity(GetLocalViewPlayer(), "vdu_on")
		break

		case 4:
		QuickHint("", "Teleporting ducks in 15 seconds.", false, 5)
		EmitSoundOnEntity(GetLocalViewPlayer(), "vdu_on")
		break

		case 6:
		QuickHint("", "Hunters were decided. \n Teleporting ducks in 15 seconds.", false, 5)
		EmitSoundOnEntity(GetLocalViewPlayer(), "vdu_on")
		break
		
		case 5:
		Obituary_Print_Localized( "%$rui/flowstate_custom/colombia_flag_papa% Made in Colombia with love by @CafeFPS and Darkes65.", GetChatTitleColorForPlayer( GetLocalViewPlayer() ), BURN_COLOR )
		break
	}
}

void function DUCKHUNT_Timer(bool enable, float endtime)
{
	Signal(GetLocalClientPlayer(), "DUCKHUNT_EndTimer")
	
	file.endtime = endtime
	
	Hud_SetEnabled( HudElement( "DuckHuntRoundTimerFrame" ), enable )
	Hud_SetVisible( HudElement( "DuckHuntRoundTimerFrame" ), enable )

	Hud_SetEnabled( HudElement( "DuckHuntRoundTimer" ), enable )
	Hud_SetVisible( HudElement( "DuckHuntRoundTimer" ), enable )
	
	if(enable)
		thread Thread_DUCKHUNT_Timer(endtime)
}

void function Thread_DUCKHUNT_Timer(float endtime)
{
	entity player = GetLocalClientPlayer()
	EndSignal( player, "DUCKHUNT_EndTimer")

	while ( Time() <= endtime )
	{
		if(file.endtime == 0) break
		
        int elapsedtime = int(endtime) - Time().tointeger()

		DisplayTime dt = SecondsToDHMS( elapsedtime )
		Hud_SetText( HudElement( "DuckHuntRoundTimer"), format( "%.2d:%.2d", dt.minutes, dt.seconds ))
		
		wait 1
	}
}

void function QuickHint( string buttonText, string hintText, bool blueText = false, int duration = 2)
{
	if(file.activeQuickHint != null)
	{
		RuiDestroyIfAlive( file.activeQuickHint )
		file.activeQuickHint = null
	}
	file.activeQuickHint = CreateFullscreenRui( $"ui/announcement_quick_right.rpak" )
	
	RuiSetGameTime( file.activeQuickHint, "startTime", Time() )
	RuiSetString( file.activeQuickHint, "messageText", buttonText + " " + hintText )
	RuiSetFloat( file.activeQuickHint, "duration", duration.tofloat() )
	
	if(blueText)
		RuiSetFloat3( file.activeQuickHint, "eventColor", SrgbToLinear( <48, 107, 255> / 255.0 ) )
	else
		RuiSetFloat3( file.activeQuickHint, "eventColor", SrgbToLinear( <255, 0, 119> / 255.0 ) )
}