//APEX INFECTED
//Made by @CafeFPS (@CafeFPS)

// Julefox - Mystery box scripts
// @KralRindo - Shadowfall gamemode initial implementation
// everyone else - advice

global function Cl_GamemodeInfection_Init
global function ApplyInfectedHUD
global function CleanUpInfectedClientEffects
global function INFECTION_QuickHint
global function CreateCoolCameraForCoolDropship
global function SignalToDestroyDropshipCamera
global function Infection_AddMinimapIcon
global function Infection_AddFullmapIcon
global function ShowInfectedNearUI
global function FlowstateInfection_CreateKillStreakAnnouncement

struct
{
	var activeQuickHint = null
	var activeKillStreakHint = null
	var countdownRui
	UIPos& diyRuiOriginalPos
	UIPos& diyRuiOriginalPos2
	bool oldbool
} file

struct {
    entity e
    entity m
} dropshipcam

void function Cl_GamemodeInfection_Init()
{
	Obituary_SetIndexOffset( 2 )
	SetConVarInt("cl_quota_stringCmdsPerSecond", 100)
	//I don't want these things in user screen even if they launch in debug
	SetConVarBool( "cl_showpos", false )
	SetConVarBool( "cl_showfps", false )
	SetConVarBool( "cl_showgpustats", false )
	SetConVarBool( "cl_showsimstats", false )
	SetConVarBool( "host_speeds", false )
	SetConVarBool( "con_drawnotify", false )
	SetConVarBool( "enable_debug_overlays", false )
	
	RegisterSignal("ChallengeStartRemoveCameras")
	RegisterSignal("ChangeCameraToSelectedLocation")
	RegisterSignal("RemoveDropshipCamera")
	RegisterSignal("NewKillChangeRui")
}

void function ApplyInfectedHUD()
{
	SetCommsDialogueEnabled( false )
	entity player = GetLocalClientPlayer()

	SetCustomPlayerInfoCharacterIcon( player, $"rui/gamemodes/shadow_squad/generic_shadow_character" )
	SetCustomPlayerInfoTreatment( player, $"rui/gamemodes/shadow_squad/player_info_custom_treatment" )
	SetCustomPlayerInfoColor( player, <245, 81, 35 > )
}

void function CleanUpInfectedClientEffects()
{
	entity player = GetLocalClientPlayer()
	
	SetCommsDialogueEnabled( true )
	foreach( fxHandle in player.p.shadowFxHandles )
		if ( EffectDoesExist( fxHandle ) )
			EffectStop( fxHandle, true, true )
	
	player.p.shadowFxHandles.clear()
	
	ClearCustomPlayerInfoColor(player)
	ClearCustomPlayerInfoTreatment(player)
	ClearCustomPlayerInfoCharacterIcon(player)
}

array< string > InfectedQuoteCatalog = [ //this is so bad maybe change it to datatable?
	$"",
	$"",
	"Double Kill!",
	"Triple Kill!",
	"Deadly Aim",
	"Unstoppable Killing",
	$"",
	"Infected Massacre",
	$"",
	$"",
	"Fury Unbridled",
	$"",
	"Decimating Onslaught",
	$"",
	$"",
	"Bloodlust Unleashed",
	$"",
	$"",
	$"",
	$"",
	"Total Annihilation"
]

array< string > SurvivorQuoteCatalog = [ //this is so bad maybe change it to datatable?
	$"",
	$"",
	"Double Kill!",
	"Triple Kill!",
	"Deadly Aim",
	"Unstoppable Killing",
	$"",
	"Infected Massacre",
	$"",
	$"",
	"Fury Unbridled",
	$"",
	"Decimating Onslaught",
	$"",
	$"",
	"Bloodlust Unleashed",
	$"",
	$"",
	$"",
	$"",
	"Total Annihilation"
]

array< asset > SurvivorAssetCatalog = [ //this is so bad maybe change it to datatable?
	$"",
	$"",
	$"rui/flowstatecustom/2",
	$"rui/flowstatecustom/3",
	$"rui/flowstatecustom/4",
	$"rui/flowstatecustom/5",
	$"",
	$"rui/flowstatecustom/7",
	$"",
	$"",
	$"rui/flowstatecustom/10",
	$"",
	$"rui/flowstatecustom/12",
	$"",
	$"",
	$"rui/flowstatecustom/15",
	$"",
	$"",
	$"",
	$"",
	$"rui/flowstatecustom/20"
]

array< asset > InfectedAssetCatalog = [ //this is so bad maybe change it to datatable?
	$"",
	$"",
	$"rui/flowstatecustom/2I",
	$"rui/flowstatecustom/3I",
	$"rui/flowstatecustom/4I",
	$"rui/flowstatecustom/5I",
	$"",
	$"rui/flowstatecustom/7I",
	$"",
	$"",
	$"rui/flowstatecustom/10I",
	$"",
	$"rui/flowstatecustom/12I",
	$"",
	$"",
	$"rui/flowstatecustom/15I",
	$"",
	$"",
	$"",
	$"",
	$"rui/flowstatecustom/20I"
]

void function INFECTION_QuickHint(int index, bool isInfectedPlayer, int eHandle)
{
	if(!IsValid(GetLocalClientPlayer())) return
	
	int team = GetLocalClientPlayer().GetTeam()

	switch(index)
	{
		case -1:
		Obituary_Print_Localized( "%$rui/flowstate_custom/colombia_flag_papa% Made in Colombia with love by @CafeFPS.", BURN_COLOR, BURN_COLOR )
		break

		case -2:
		QuickHint("", "Last Survivor Standing", true, 3)
		EmitSoundOnEntity(GetLocalViewPlayer(), "ui_ingame_switchingsides")
		break

		case -3:
		//QuickHint("", "Alpha Infected Killed", true, 3)
		Obituary_Print_Localized( "Alpha Infected Killed", BURN_COLOR, BURN_COLOR )
		EmitSoundOnEntity(GetLocalViewPlayer(), "ui_ingame_switchingsides")
		break

		case -4:
		Obituary_Print_Localized( EHI_GetName(eHandle) + " took the Evac Ship.", BURN_COLOR, BURN_COLOR )
		EmitSoundOnEntity(GetLocalViewPlayer(), "vdu_on")
		break

		case -5:
		Obituary_Print_Localized( EHI_GetName(eHandle) + " obtained Secondary Weapon Perk.", BURN_COLOR, BURN_COLOR )
		//EmitSoundOnEntity(GetLocalViewPlayer(), "vdu_on")
		break

		case -6:
		Obituary_Print_Localized( EHI_GetName(eHandle) + " obtained Better Mags Perk.", BURN_COLOR, BURN_COLOR )
		//EmitSoundOnEntity(GetLocalViewPlayer(), "vdu_on")
		break
		
		case -7:
		Obituary_Print_Localized( EHI_GetName(eHandle) + " obtained Quick Reload Perk.", BURN_COLOR, BURN_COLOR )
		//EmitSoundOnEntity(GetLocalViewPlayer(), "vdu_on")
		break
	
		case -8:
		Obituary_Print_Localized( EHI_GetName(eHandle) + " obtained Scan Ability Perk.", BURN_COLOR, BURN_COLOR )
		//EmitSoundOnEntity(GetLocalViewPlayer(), "vdu_on")
		break
		
		case -9:
		Obituary_Print_Localized( EHI_GetName(eHandle) + " obtained Extra Speed Perk.", BURN_COLOR, BURN_COLOR )
		//EmitSoundOnEntity(GetLocalViewPlayer(), "vdu_on")
		break
		
		case -10:
		Obituary_Print_Localized( EHI_GetName(eHandle) + " obtained 3Dash Ability Perk.", BURN_COLOR, BURN_COLOR )
		//EmitSoundOnEntity(GetLocalViewPlayer(), "vdu_on")
		break
		
		case -11:
		Obituary_Print_Localized( EHI_GetName(eHandle) + " obtained Hard To Kill Perk.", BURN_COLOR, BURN_COLOR )
		//EmitSoundOnEntity(GetLocalViewPlayer(), "vdu_on")
		break
		
		case -12:
		Obituary_Print_Localized( EHI_GetName(eHandle) + " obtained Health Regen Perk.", BURN_COLOR, BURN_COLOR )
		//EmitSoundOnEntity(GetLocalViewPlayer(), "vdu_on")
		break
		
		case -13:
		Obituary_Print_Localized( EHI_GetName(eHandle) + " obtained Satchel Ability Perk.", BURN_COLOR, BURN_COLOR )
		//EmitSoundOnEntity(GetLocalViewPlayer(), "vdu_on")
		break
		
		case -14:
		QuickHint("", "You got Secondary Weapon Perk", false, 3)
		EmitSoundOnEntity(GetLocalViewPlayer(), "ui_ingame_switchingsides")
		break		

		case -15:
		QuickHint("", "You got Better Mags Perk", false, 3)
		EmitSoundOnEntity(GetLocalViewPlayer(), "ui_ingame_switchingsides")
		break	

		case -16:
		QuickHint("", "You got Quick Reload Perk", false, 3)
		EmitSoundOnEntity(GetLocalViewPlayer(), "ui_ingame_switchingsides")
		break	

		case -17:
		QuickHint("", "You got Scan Ability Perk", false, 3)
		EmitSoundOnEntity(GetLocalViewPlayer(), "ui_ingame_switchingsides")
		break	

		case -18:
		QuickHint("", "You got Extra Speed Perk", false, 3)
		EmitSoundOnEntity(GetLocalViewPlayer(), "ui_ingame_switchingsides")
		break	

		case -19:
		QuickHint("", "You got 3Dash Ability Perk", false, 3)
		EmitSoundOnEntity(GetLocalViewPlayer(), "ui_ingame_switchingsides")
		break	

		case -20:
		QuickHint("", "You got Hard To Kill Perk", false, 3)
		EmitSoundOnEntity(GetLocalViewPlayer(), "ui_ingame_switchingsides")
		break	

		case -21:
		QuickHint("", "You got Health Regen Perk", false, 3)
		EmitSoundOnEntity(GetLocalViewPlayer(), "ui_ingame_switchingsides")
		break	

		case -22:
		QuickHint("", "You got Satchel Ability Perk", false, 3)
		EmitSoundOnEntity(GetLocalViewPlayer(), "ui_ingame_switchingsides")
		break

		case -23:
		QuickHint("", "Choosing Alpha Infected in 5 seconds.", false, 3)
		EmitSoundOnEntity(GetLocalViewPlayer(), "ui_ingame_switchingsides")
		break		
	}
	
	if(index < 0) return
	//Si el index deseado no está en el switch case anterior, crear Kill Streak RUI
	FlowstateInfection_CreateKillStreakAnnouncement( index, isInfectedPlayer )
}

void function FlowstateInfection_CreateKillStreakAnnouncement( int index, bool isInfectedPlayer )
{
	thread function () : ( index, isInfectedPlayer )
	{
		array< string > quotesCatalogToUse
		
		if(isInfectedPlayer) quotesCatalogToUse = InfectedQuoteCatalog
		else quotesCatalogToUse = SurvivorQuoteCatalog

		array< asset > assetsCatalogToUse
		
		if(isInfectedPlayer) assetsCatalogToUse = InfectedAssetCatalog
		else assetsCatalogToUse = SurvivorAssetCatalog
			
		asset badge = assetsCatalogToUse[index]
		string quote = quotesCatalogToUse[index]
		int duration = 2
		
		if( badge == $"" ) return
		
		Signal(GetLocalClientPlayer(), "NewKillChangeRui")
		EndSignal(GetLocalClientPlayer(), "NewKillChangeRui")

		var KillStreakRuiBadge = HudElement( "KillStreakBadge1")
		var KillStreakRuiText = HudElement( "KillStreakText1")
		
		OnThreadEnd(
			function() : ( KillStreakRuiBadge, KillStreakRuiText )
			{
				Hud_SetEnabled( KillStreakRuiBadge, false )
				Hud_SetVisible( KillStreakRuiBadge, false )
				
				Hud_SetEnabled( KillStreakRuiText, false )
				Hud_SetVisible( KillStreakRuiText, false )
			}
		)
		
		RuiSetImage( Hud_GetRui( KillStreakRuiBadge ), "basicImage", badge )
		
		Hud_ReturnToBasePos(KillStreakRuiBadge)
		Hud_ReturnToBasePos(KillStreakRuiText)

		Hud_SetText( KillStreakRuiText, quote )

		Hud_SetSize( KillStreakRuiBadge, 0, 0 )
		Hud_ScaleOverTime( KillStreakRuiBadge, 1.3, 1.3, 0.2, INTERPOLATOR_SIMPLESPLINE)

		Hud_SetSize( KillStreakRuiText, 0, 0 )
		Hud_ScaleOverTime( KillStreakRuiText, 1, 1, 0.15, INTERPOLATOR_ACCEL)
		
		Hud_SetAlpha( KillStreakRuiBadge, 255 )
		Hud_SetAlpha( KillStreakRuiText, 255 )

		Hud_SetEnabled( KillStreakRuiBadge, true )
		Hud_SetVisible( KillStreakRuiBadge, true )
		
		Hud_SetEnabled( KillStreakRuiText, true )
		Hud_SetVisible( KillStreakRuiText, true )
		
		wait 0.2
		
		Hud_ScaleOverTime( KillStreakRuiBadge, 1, 1, 0.25, INTERPOLATOR_SIMPLESPLINE)
		
		wait 3.5
		
		waitthread FlowstateInfectionKillStreak_FadeOut(KillStreakRuiBadge, KillStreakRuiText)
	}()
}

void function FlowstateInfectionKillStreak_FadeOut( var label, var label2, int xOffset = 200, int yOffset = 0, float duration = 0.3 )
{
	EndSignal(GetLocalClientPlayer(), "NewKillChangeRui")
	
	UIPos currentPos = REPLACEHud_GetPos( label )
	UIPos currentPos2 = REPLACEHud_GetPos( label2 )

	OnThreadEnd(
		function() : ( label, label2, currentPos, xOffset, yOffset )
		{
			Hud_SetEnabled( label, false )
			Hud_SetVisible( label, false )
			
			Hud_SetEnabled( label2, false )
			Hud_SetVisible( label2, false )
		}
	)

	Hud_FadeOverTime( label, 0, duration/2, INTERPOLATOR_ACCEL )
	Hud_FadeOverTime( label2, 0, duration/2, INTERPOLATOR_ACCEL )

	Hud_MoveOverTime( label, currentPos.x + xOffset, currentPos.y + yOffset, duration )
	
	wait duration
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

void function CreateCoolCameraForCoolDropship(entity dropship)
{
	thread function() : (dropship)
	{
		entity localplayer = GetLocalClientPlayer()
		
		EndSignal(localplayer, "RemoveDropshipCamera")
	
		OnThreadEnd(
		function() : ( )
		{
			GetLocalClientPlayer().ClearMenuCameraEntity()
			
			if(IsValid(dropshipcam.m))
			{
				dropshipcam.m.Destroy()
			}
			if(IsValid(dropshipcam.e))
			{
				dropshipcam.e.Destroy()
			}
			
			DoF_SetNearDepthToDefault()
			DoF_SetFarDepthToDefault()			
		})

		if( !IsValid(dropship) || localplayer != GetLocalViewPlayer() ) return 
		
		dropshipcam.m = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", localplayer.EyePosition(), localplayer.CameraAngles() )
		dropshipcam.e = CreateClientSidePointCamera( localplayer.GetOrigin(), localplayer.CameraAngles(), 100 )
		dropshipcam.e.SetParent( dropshipcam.m, "", false )
		localplayer.SetMenuCameraEntityWithAudio( dropshipcam.e )
		dropshipcam.e.SetTargetFOV( 100, true, EASING_CUBIC_INOUT, 0.50 )

		vector moveto = dropship.GetOrigin() + AnglesToForward( dropship.EyeAngles() ) * -1000 + AnglesToRight( dropship.EyeAngles() ) * 600
		moveto.z+= 2000
		dropshipcam.m.NonPhysicsMoveTo( moveto, 2, 0, 2 )
		vector watchto = dropship.GetOrigin() + AnglesToForward( dropship.EyeAngles() ) * 2500 
		vector angles = VectorToAngles( watchto - moveto )
		dropshipcam.m.NonPhysicsRotateTo( angles, 1, 0, 0.1 )
		
		WaitForever()
	}()	
}

var function Infection_AddMinimapIcon( asset icon, float iconSize, vector iconScale )
{
	var rui = Minimap_CommonAdd( MINIMAP_SQUARE_SIMPLE_RUI, MINIMAP_Z_PING )
	if ( rui == null )
	{
		Warning( "Couldn't add ping icon to minimap." )
		return
	}

	RuiSetBool( rui, "scalesWithZoom", false )
	RuiSetFloat( rui, "objectSize", iconSize )
	RuiSetFloat2( rui, "objectScale", iconScale )
	RuiSetImage( rui, "iconImage", icon )
	RuiSetBool( rui, "doAnnounceEffect", true )
	return rui
}

var function Infection_AddFullmapIcon( asset icon, float iconSize, vector objectScale )
{
	var rui = FullMap_CommonAdd( $"ui/in_world_minimap_square_simple.rpak" )
	if ( rui == null )
	{
		Warning( "Couldn't add ping icon to fullmap." )
		return
	}

	RuiSetFloat( rui, "objectSize", iconSize )
	RuiSetFloat2( rui, "objectScale", objectScale )
	RuiSetImage( rui, "iconImage", icon )
	RuiSetBool( rui, "doAnnounceEffect", true )
	return rui
}

void function SignalToDestroyDropshipCamera()
{
	GetLocalClientPlayer().Signal( "RemoveDropshipCamera" )	
}

void function ShowInfectedNearUI(bool toggle)
{
	
	var InfectedNearText = HudElement( "InfectedNearText")
	var InfectedNearFrame = HudElement( "InfectedNearFrame")
	
	Hud_SetEnabled( InfectedNearText, toggle )
	Hud_SetVisible( InfectedNearText, toggle )
	
	Hud_SetEnabled( InfectedNearFrame, toggle )
	Hud_SetVisible( InfectedNearFrame, toggle )
	
	if(toggle && toggle != file.oldbool)
	{
		thread function() : ()
		{
			EmitSoundOnEntity(GetLocalViewPlayer(), "ui_ingame_switchingsides")
			wait 0.25
			EmitSoundOnEntity(GetLocalViewPlayer(), "ui_ingame_switchingsides")
		}()
	}
	
	file.oldbool = toggle
}
