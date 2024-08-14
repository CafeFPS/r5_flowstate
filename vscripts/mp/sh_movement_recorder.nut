// Made by @CafeFPS
// mkos - multiplayer compatibility overhaul, code improvements

#if SERVER
	global function ClientCommand_DestroyDummys
#endif

#if CLIENT
	global function FS_MovementRecorder_UpdateHints
	global function FS_MovementRecorder_CreateInputHintsRUI
#endif

global function Sh_FS_MovementRecorder_Init

struct RecordingAnimation
{
	vector origin
	vector angles
	var anim
}

const int MAX_SLOT = 10
const int MAX_NPC_BUDGET = 120

struct
{
	#if SERVER
	//movido a la estructura de server player
	#endif

	#if CLIENT
	array<var> inputHintLines
	#endif
	
	int playbackLimit = -1	
	table<int, table<int, array<entity> > > playerDummyMaps //[ehandle][slot] = dummy
	table<int, table<int,int> > playerPlaybackAmounts = {} //[ehandle][slot] = amount
	
	table<int, array<entity> > _dummyMaps__Template = {
		[ 0 ] = [ null ],
		[ 1 ] = [ null ],
		[ 2 ] = [ null ],
		[ 3 ] = [ null ],
		[ 4 ] = [ null ],
		[ 5 ] = [ null ],
		[ 6 ] = [ null ],
		[ 7 ] = [ null ],
		[ 8 ] = [ null ],
		[ 9 ] = [ null ]	
	}
	
	table <int, int> _playbackAmounts__Template = {
		[ 0 ] = 0,
		[ 1 ] = 0,
		[ 2 ] = 0,
		[ 3 ] = 0,
		[ 4 ] = 0,
		[ 5 ] = 0,
		[ 6 ] = 0,
		[ 7 ] = 0,
		[ 8 ] = 0,
		[ 9 ] = 0
	}
	
	float helmet_lv4 = 0.65
	
} file

void function Sh_FS_MovementRecorder_Init()
{
	#if CLIENT
		AddCallback_OnClientScriptInit( FS_MovementRecorder_SetBindings )
		AddClientCallback_OnResolutionChanged( FS_MovementRecorder_OnResolutionChanged )
	#endif
	
	#if SERVER
		disableoverwrite( file._playbackAmounts__Template ) //prevent modifying template ~mkos
		disableoverwrite( file._dummyMaps__Template )
		
		AddCallback_OnClientDisconnected( _HandlePlayerDisconnect )
		
		AddClientCommandCallback( "toggleMovementRecorder", ClientCommand_ToggleMovementRecorder )
		AddClientCommandCallback( "PlayAnimInSlot", ClientCommand_PlayAnimInSlot )
		AddClientCommandCallback( "PlayAllAnims", ClientCommand_PlayAllAnims )
		AddClientCommandCallback( "recorder_switchCharacter", ClientCommand_SwitchCharacter )
		AddClientCommandCallback( "recorder_recorderHideHud", ClientCommand_HideHud )
		AddClientCommandCallback( "recorder_toggleContinueLoop", ClientCommand_ToggleContinueLoop )	
		AddClientCommandCallbackNew( "DestroyDummys", ClientCommand_DestroyDummys )
		AddCallback_OnClientConnected( FS_MovementRecorder_OnPlayerConnected )
		
		RegisterSignal( "EndDummyThread" )
		RegisterSignal( "FinishedRecording" )
		RegisterSignal( "PlayRandomAnimation" )
		
		foreach( k,v in file._playbackAmounts__Template )
		{
			RegisterSignal( "EndDummyThread_Slot_" + k.tostring() )
		}
		
		file.playbackLimit = GetCurrentPlaylistVarInt( "flowstate_limit_playback_per_slot_amount", -1 )
		file.helmet_lv4 = GetCurrentPlaylistVarFloat( "helmet_lv4", 0.65 )
		
		if( !FlowState_AdminTgive() )
			INIT_WeaponsMenu()
		else
			INIT_WeaponsMenu_Disabled()
	#endif
}

#if SERVER
void function INIT_WeaponsMenu()
{
	AddClientCommandCallback("CC_MenuGiveAimTrainerWeapon", CC_MenuGiveAimTrainerWeapon ) 
	AddClientCommandCallback("CC_AimTrainer_SelectWeaponSlot", CC_AimTrainer_SelectWeaponSlot )
	AddClientCommandCallback("CC_AimTrainer_WeaponSelectorClose", CC_AimTrainer_CloseWeaponSelector )
	AddClientCommandCallbackNew("CC_AimTrainer_WeaponSelectorClose", MovementRecorder_SetupWeapons )
}

void function INIT_WeaponsMenu_Disabled()
{
	AddClientCommandCallback("CC_MenuGiveAimTrainerWeapon", MessagePlayer_Disabled ) 
	AddClientCommandCallback("CC_AimTrainer_SelectWeaponSlot", MessagePlayer_Disabled )
	AddClientCommandCallback("CC_AimTrainer_WeaponSelectorClose", MessagePlayer_Disabled )
}

bool function MessagePlayer_Disabled( entity player, array<string> args )
{
	LocalEventMsg( player, "#FS_DisabledTDMWeps" )
	return true
}

void function MovementRecorder_SetupWeapons( entity player, array<string> args )
{	
	if( !IsValid( player ) )
		return 
		
	if( Playlist() == ePlaylists.fs_movementrecorder && !FlowState_AdminTgive() )
	{
		entity primary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_0 )
		entity secondary = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_1 )
		
		player.RefillAllAmmo()
		
		if( IsValid( primary ) )
			SetupInfiniteAmmoForWeapon( player, primary )
			
		if( IsValid( secondary ) )
			SetupInfiniteAmmoForWeapon( player, secondary )
	}
}
#endif

string function slotname( int slot )
{
	switch( slot )
	{
		case 1: return "[F3]";
		case 2: return "[F4]";
		case 3: return "[F5]";
		case 4: return "[F6]";
		case 5: return "[F7]";
		
		case 6: return "[6]";
		case 7: return "[7]";
		case 8: return "[8]";
		case 9: return "[9]";
		case 10: return "[0]";
		default: return "";
	}
	
	unreachable
}

#if CLIENT
void function FS_MovementRecorder_SetBindings( entity player )
{
	// no puedo bindear argumentos? Xd
	//mkos~ :D
	player.ClientCommand( "bind_US_standard F2 toggleMovementRecorder" )
	player.ClientCommand( "bind_US_standard F3 \"PlayAnimInSlot 0\"" )
	player.ClientCommand( "bind_US_standard F4 \"PlayAnimInSlot 1\"" )
	player.ClientCommand( "bind_US_standard F5 \"PlayAnimInSlot 2\"" )
	player.ClientCommand( "bind_US_standard F6 \"PlayAnimInSlot 3\"" )
	player.ClientCommand( "bind_US_standard F7 \"PlayAnimInSlot 4\"" )

	player.ClientCommand( "bind_US_standard 6 \"PlayAnimInSlot 5\"" )
	player.ClientCommand( "bind_US_standard 7 \"PlayAnimInSlot 6\"" )
	player.ClientCommand( "bind_US_standard 8 \"PlayAnimInSlot 7\"" )
	player.ClientCommand( "bind_US_standard 9 \"PlayAnimInSlot 8\"" )
	player.ClientCommand( "bind_US_standard 0 \"PlayAnimInSlot 9\"" )

	player.ClientCommand( "bind_US_standard F8 PlayAllAnims" )
	
	player.ClientCommand( "unbind_US_standard F11" )
	player.ClientCommand( "unbind_US_standard F12" )

	player.ClientCommand( "bind_US_standard F11 recorder_switchCharacter" )
	player.ClientCommand( "bind_US_standard F12 recorder_toggleContinueLoop" )

	FS_MovementRecorder_CreateInputHintsRUI( false )
}

void function FS_MovementRecorder_CreateInputHintsRUI( bool state )
{
	foreach( line in file.inputHintLines )
		if( line != null )
		{
			RuiDestroyIfAlive( line )
		}

	file.inputHintLines.clear()

	if( state )
		return

	//I hate this. Cafe
	UISize screenSize = GetScreenSize()
	var topo = RuiTopology_CreatePlane( <( screenSize.width * 0.140),( screenSize.height * -0.065 ), 0>, <float( screenSize.width ) * 0.9, 0, 0>, <0, float( screenSize.height ) * 0.9, 0>, false )
	var hintRui = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui, "buttonText", "%F2%" )
	RuiSetString( hintRui, "gamepadButtonText", "%F2%" )
	RuiSetString( hintRui, "hintText", "Start Recording" )
	RuiSetString( hintRui, "altHintText", "" )
	RuiSetInt( hintRui, "hintOffset", 0 )
	RuiSetBool( hintRui, "hideWithMenus", false )
	file.inputHintLines.append( hintRui )

	var hintRui2 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui2, "buttonText", "%F3%" )
	RuiSetString( hintRui2, "gamepadButtonText", "%F3%" )
	RuiSetString( hintRui2, "hintText", "Slot [F3] - Empty" )
	RuiSetString( hintRui2, "altHintText", "" )
	RuiSetInt( hintRui2, "hintOffset", 1 )
	RuiSetBool( hintRui2, "hideWithMenus", false )
	file.inputHintLines.append( hintRui2 )

	var hintRui3 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui3, "buttonText", "%F4%" )
	RuiSetString( hintRui3, "gamepadButtonText", "%F4%" )
	RuiSetString( hintRui3, "hintText", "Slot [F4] - Empty" )
	RuiSetString( hintRui3, "altHintText", "" )
	RuiSetInt( hintRui3, "hintOffset", 2 )
	RuiSetBool( hintRui3, "hideWithMenus", false )
	file.inputHintLines.append( hintRui3 )

	var hintRui4 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui4, "buttonText", "%F5%" )
	RuiSetString( hintRui4, "gamepadButtonText", "%F5%" )
	RuiSetString( hintRui4, "hintText", "Slot [F5] - Empty" )
	RuiSetString( hintRui4, "altHintText", "" )
	RuiSetInt( hintRui4, "hintOffset", 3 )
	RuiSetBool( hintRui4, "hideWithMenus", false )
	file.inputHintLines.append( hintRui4 )

	var hintRui5 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui5, "buttonText", "%F6%" )
	RuiSetString( hintRui5, "gamepadButtonText", "%F6%" )
	RuiSetString( hintRui5, "hintText", "Slot [F6] - Empty" )
	RuiSetString( hintRui5, "altHintText", "" )
	RuiSetInt( hintRui5, "hintOffset", 4 )
	RuiSetBool( hintRui5, "hideWithMenus", false )
	file.inputHintLines.append( hintRui5 )

	var hintRui6 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui6, "buttonText", "%F7%" )
	RuiSetString( hintRui6, "gamepadButtonText", "%F7%" )
	RuiSetString( hintRui6, "hintText", "Slot [F7] - Empty" )
	RuiSetString( hintRui6, "altHintText", "" )
	RuiSetInt( hintRui6, "hintOffset", 5 )
	RuiSetBool( hintRui6, "hideWithMenus", false )
	file.inputHintLines.append( hintRui6 )

// __
	var hintRui13 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui13, "buttonText", "%6%" )
	RuiSetString( hintRui13, "gamepadButtonText", "%6%" )
	RuiSetString( hintRui13, "hintText", "Slot [6] - Empty" )
	RuiSetString( hintRui13, "altHintText", "" )
	RuiSetInt( hintRui13, "hintOffset", 6 )
	RuiSetBool( hintRui13, "hideWithMenus", false )
	file.inputHintLines.append( hintRui13 )

	var hintRui14 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui14, "buttonText", "%7%" )
	RuiSetString( hintRui14, "gamepadButtonText", "%7%" )
	RuiSetString( hintRui14, "hintText", "Slot [7] - Empty" )
	RuiSetString( hintRui14, "altHintText", "" )
	RuiSetInt( hintRui14, "hintOffset", 7 )
	RuiSetBool( hintRui14, "hideWithMenus", false )
	file.inputHintLines.append( hintRui14 )

	var hintRui15 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui15, "buttonText", "%8%" )
	RuiSetString( hintRui15, "gamepadButtonText", "%8%" )
	RuiSetString( hintRui15, "hintText", "Slot [8] - Empty" )
	RuiSetString( hintRui15, "altHintText", "" )
	RuiSetInt( hintRui15, "hintOffset", 8 )
	RuiSetBool( hintRui15, "hideWithMenus", false )
	file.inputHintLines.append( hintRui15 )

	var hintRui16 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui16, "buttonText", "%9%" )
	RuiSetString( hintRui16, "gamepadButtonText", "%9%" )
	RuiSetString( hintRui16, "hintText", "Slot [9] - Empty" )
	RuiSetString( hintRui16, "altHintText", "" )
	RuiSetInt( hintRui16, "hintOffset", 9 )
	RuiSetBool( hintRui16, "hideWithMenus", false )
	file.inputHintLines.append( hintRui16 )

	var hintRui17 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui17, "buttonText", "%0%" )
	RuiSetString( hintRui17, "gamepadButtonText", "%0%" )
	RuiSetString( hintRui17, "hintText", "Slot [0] - Empty" )
	RuiSetString( hintRui17, "altHintText", "" )
	RuiSetInt( hintRui17, "hintOffset", 10 )
	RuiSetBool( hintRui17, "hideWithMenus", false )
	file.inputHintLines.append( hintRui17 )

// __
	var hintRui7 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui7, "buttonText", "%F8%" )
	RuiSetString( hintRui7, "gamepadButtonText", "%F8%" )
	RuiSetString( hintRui7, "hintText", "Play All Anims" )
	RuiSetString( hintRui7, "altHintText", "" )
	RuiSetInt( hintRui7, "hintOffset", 11 )
	RuiSetBool( hintRui7, "hideWithMenus", false )
	file.inputHintLines.append( hintRui7 )

	var hintRui8 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui8, "buttonText", "%F11%" )
	RuiSetString( hintRui8, "gamepadButtonText", "%F11%" )
	RuiSetString( hintRui8, "hintText", "Character: Bangalore" )
	RuiSetString( hintRui8, "altHintText", "" )
	RuiSetInt( hintRui8, "hintOffset", 12 )
	RuiSetBool( hintRui8, "hideWithMenus", false )
	file.inputHintLines.append( hintRui8 )

	var hintRui9 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui9, "buttonText", "%F12%" )
	RuiSetString( hintRui9, "gamepadButtonText", "%F12%" )
	RuiSetString( hintRui9, "hintText", "Loop Anim: ON" )
	RuiSetString( hintRui9, "altHintText", "" )
	RuiSetInt( hintRui9, "hintOffset", 13 )
	RuiSetBool( hintRui9, "hideWithMenus", false )
	file.inputHintLines.append( hintRui9 )

	var hintRui10 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui10, "buttonText", "%$rui/menu/buttons/tip%" )
	RuiSetString( hintRui10, "gamepadButtonText", "%$rui/menu/buttons/tip%" )
	RuiSetString( hintRui10, "hintText", "Crouch + Slot to clear" )
	RuiSetString( hintRui10, "altHintText", "" )
	RuiSetInt( hintRui10, "hintOffset", 14 )
	RuiSetBool( hintRui10, "hideWithMenus", false )
	file.inputHintLines.append( hintRui10 )
	
	var hintRui11 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui11, "buttonText", "%$rui/menu/buttons/tip%" )
	RuiSetString( hintRui11, "gamepadButtonText", "%$rui/menu/buttons/tip%" )
	RuiSetString( hintRui11, "hintText", "Crouch + %F8% = clearall" )
	RuiSetString( hintRui11, "altHintText", "" )
	RuiSetInt( hintRui11, "hintOffset", 15 )
	RuiSetBool( hintRui11, "hideWithMenus", false )
	file.inputHintLines.append( hintRui11 )
	
	var hintRui12 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui12, "buttonText", "%$rui/menu/buttons/tip%" )
	RuiSetString( hintRui12, "gamepadButtonText", "%$rui/menu/buttons/tip%" )
	RuiSetString( hintRui12, "hintText", "Crouch + %F2% = random" )
	RuiSetString( hintRui12, "altHintText", "" )
	RuiSetInt( hintRui12, "hintOffset", 16 )
	RuiSetBool( hintRui12, "hideWithMenus", false )
	file.inputHintLines.append( hintRui12 )
}

void function FS_MovementRecorder_UpdateHints( int hint, bool state, float duration )
{
	if( file.inputHintLines[ hint ] == null )
		return

	if( hint == 0 && state )
	{
		RuiSetString( file.inputHintLines[0], "hintText", "Stop Recording" )
		return
	} else if( hint == 0 && !state )
	{
		RuiSetString( file.inputHintLines[0], "hintText", "Start Recording" )
		return
	}
	//// 0 Bang// 1 Bloodhound// 2 Caustic// 3 Gibby// 4 Lifeline// 5 Mirage// 6 Octane// 7 Pathy// 8 Wraith// 9 Watty// 10 Crypto
	if( hint == 12 )
	{
		string characterToUse
		switch( duration.tointeger() )
		{
			case 0:
			characterToUse = "Bangalore"
			break
			
			case 1:
			characterToUse = "Bloodhound"
			break
			
			case 2:
			characterToUse = "Caustic"
			break
			
			case 3:
			characterToUse = "Gibby"
			break

			case 4:
			characterToUse = "Lifeline"
			break

			case 5:
			characterToUse = "Mirage"
			break

			case 6:
			characterToUse = "Octane"
			break

			case 7:
			characterToUse = "Pathfinder"
			break

			case 8:
			characterToUse = "Wraith"
			break

			case 9:
			characterToUse = "Wattson"
			break

			case 10:
			characterToUse = "Crypto"
			break

			case 11:
			characterToUse = "Loba"
			break

			case 12:
			characterToUse = "Ballistic"
			break

			case 13:
			characterToUse = "Ash"
			break

			case 14:
			characterToUse = "Catalyst"
			break

			case 15:
			characterToUse = "Valk"
			break

			case 16:
			characterToUse = "Horizon"
			break

			case 17:
			characterToUse = "Rampart"
			break

			default:
			characterToUse = "Lifeline"
			break
		}
		RuiSetString( file.inputHintLines[hint], "hintText", "Character: " + characterToUse )
		return
	}

	if( hint == 13 && state )
	{
		RuiSetString( file.inputHintLines[hint], "hintText", "Loop Anim: ON" )
		return
	}
	else if( hint == 13 && !state )
	{
		RuiSetString( file.inputHintLines[hint], "hintText", "Loop Anim: OFF" )
		return
	}

	if( state )	
	{
		DisplayTime dt = SecondsToDHMS( duration.tointeger() )
		RuiSetString( file.inputHintLines[hint], "hintText", "Slot " + slotname(hint) + " - Play " + format( "%.2d:%.2d", dt.minutes, dt.seconds ) )
		return
	} else if( !state )
	{
		RuiSetString( file.inputHintLines[hint], "hintText", "Slot " + slotname(hint) + " - Empty" )
		return
	}
}

void function FS_MovementRecorder_OnResolutionChanged()
{
	FS_MovementRecorder_CreateInputHintsRUI( false )
}
#endif //CLIENT

#if SERVER

void function _HandlePlayerDisconnect( entity player )
{
	int playerHandle = player.p.handle 
	
	foreach ( slot, dummies in file.playerDummyMaps[playerHandle] )
			DestroyDummyForSlot( player, slot, playerHandle )
}

void function FS_MovementRecorder_OnPlayerConnected( entity player )
{
	for( int i = 0; i < MAX_SLOT; i++ )
	{
		player.p.recordingAnims[i] <- []
	}

	for( int i = 0; i < MAX_SLOT; i++ )
	{
		player.p.recordingAnimsCoordinates[i] <- []
	}

	player.p.recordingAnimsChosenCharacters.resize( MAX_SLOT )
	
	FS_MovementRecorder_PlayerInit( player )
	SetTeam( player, 2 )
}

void function FS_MovementRecorder_PlayerInit( entity player )
{
	if ( !IsValid( player ) )
		return 
		
	int playerHandle = player.p.handle
	
	table<int, array<entity> > init_playerDummyMap 	= clone file._dummyMaps__Template
	table<int,int> init_playerPlaybackAmounts 		= clone file._playbackAmounts__Template
	
	file.playerPlaybackAmounts[ playerHandle ] <- init_playerPlaybackAmounts
	file.playerDummyMaps[ playerHandle ] <- init_playerDummyMap
	
	//PrintMovementRecorderTable( file.playerPlaybackAmounts )
}

bool function ClientCommand_ToggleMovementRecorder( entity player, array<string> args )
{
	if( !IsValid( player ) )
		return false

	bool bPlayRandom = player.IsInputCommandHeld( IN_DUCK )

	if( bPlayRandom )
	{
		if( !bDoesAnyAnimationExist( player ) )
		{
			if( !player.p.recorderHideHud )
				LocalEventMsg( player, "#FS_NO_ANIMS", "", 3 )
				
			return true
		}
		
		if( !IsOverBudget( player ) )	
			thread PlayRandomAnimation( player )
			
		return true
	}

	if( player.p.isRecording )
	{
		player.Signal( "FinishedRecording" )
		player.p.isRecording = false
	} 
	else
	{
		int slot = FS_MovementRecorder_GetEmptySlotForPlayer( player )
	
		if( slot == -1 )
		{
			if( !player.p.recorderHideHud )
				LocalEventMsg( player, "#FS_NO_SLOTS" )
				
			return true
		}
	
		if( !IsAlive( player ) )
			DecideRespawnPlayer( player, true )

		thread StartRecordingAnimation( player )
	}
	
	return true
}

bool function ClientCommand_PlayAnimInSlot( entity player, array<string> args )
{
	if( !IsValid( player ) )
		return false
		
	if( args.len() == 0)
		return false
	
	int slot = 0
	
	if( IsNumeric( args[ 0 ] ) )
	{
		slot = args[ 0 ].tointeger()
	}
	else 
	{
		#if DEVELOPER
			printt( "Invalid commmand sent" )
		#endif
		return false
	}
	
	bool remove = player.IsInputCommandHeld( IN_DUCK )
	
	if( !remove && !HasSlotAllocation( player, slot ) )
	{
		return true
	}

	thread PlayAnimInSlot( player, slot, remove )
		return true
}

bool function ClientCommand_PlayAllAnims( entity player, array<string> args )
{
	if( !IsValid( player ) )
		return false

	bool remove = player.IsInputCommandHeld( IN_DUCK )

	if( !player.p.recorderHideHud )
	{	
		string token = remove ? "#FS_REMOVING_ALL_ANIMS" : "#FS_PLAYING_ALL_ANIMS";
		LocalEventMsg( player, token )
	}
	
	bool removeAll = false
	
	if( remove )
	{
		removeAll = true
	}
	

	for(int i = 0; i < MAX_SLOT ; i++ )
		thread PlayAnimInSlot( player, 	i, remove, removeAll )

	return true
}

bool function ClientCommand_SwitchCharacter( entity player, array<string> args )
{
	if( !IsValid( player ) )
		return false

	if( player.p.isRecording )
	{
		if( !player.p.recorderHideHud )
			LocalEventMsg( player, "#FS_CANT_SWITCH_LEGEND", "", 3 )
			
		return false
	}

	if( player.p.movementRecorderCharacter + 1 > 17 )
	{ 
		player.p.movementRecorderCharacter = 0
	} 
	else 
	{
		player.p.movementRecorderCharacter++
	}

	Remote_CallFunction_NonReplay( player, "FS_MovementRecorder_UpdateHints", 12, true, player.p.movementRecorderCharacter )
	
	if( player.p.movementRecorderCharacter <= 10 )
		AssignCharacter( player, player.p.movementRecorderCharacter )
	
	return true
}

bool function ClientCommand_HideHud(entity player, array<string> args)
{
	if( !IsValid( player ) )
		return false

	if( player.p.recorderHideHud )
	{
		player.p.recorderHideHud = false
		Remote_CallFunction_NonReplay( player, "FS_MovementRecorder_CreateInputHintsRUI", false )
	}
	else if( !player.p.recorderHideHud )
	{
		player.p.recorderHideHud = true
		Remote_CallFunction_NonReplay( player, "FS_MovementRecorder_CreateInputHintsRUI", true )
	}
	return true
}

bool function ClientCommand_ToggleContinueLoop(entity player, array<string> args)
{
	if( !IsValid( player ) )
		return false

	if( player.p.continueLoop )
	{
		player.p.continueLoop = false
		Remote_CallFunction_NonReplay( player, "FS_MovementRecorder_UpdateHints", 13, false, -1 )
	} 
	else if( !player.p.continueLoop )
	{
		player.p.continueLoop = true
		Remote_CallFunction_NonReplay( player, "FS_MovementRecorder_UpdateHints", 13, true, -1 )
	}
	return true
}

void function StartRecordingAnimation( entity player )
{
	player.p.currentOrigin = player.GetOrigin()
	player.p.currentAngles = player.GetAngles()
	
	string msg1

	//// 0 Bang// 1 Bloodhound// 2 Caustic// 3 Gibby// 4 Lifeline// 5 Mirage// 6 Octane// 7 Pathy// 8 Wraith// 9 Watty// 10 Crypto
	switch( player.p.movementRecorderCharacter )
	{
		case 0:
			msg1 = "RECORDING MOVEMENT AS BANGALORE"
			AssignCharacter(player, 0)
		break
		
		case 1:
			msg1 = "RECORDING MOVEMENT AS BLOODHOUND"
			AssignCharacter(player, 1)
		break
		
		case 2:
			msg1 = "RECORDING MOVEMENT AS CAUSTIC"
			AssignCharacter(player, 2)
		break
		
		case 3:
			msg1 = "RECORDING MOVEMENT AS GIBBY"
			AssignCharacter(player, 3)
		break

		case 4:
			msg1 = "RECORDING MOVEMENT AS LIFELINE"
			AssignCharacter(player, 4)
		break

		case 5:
			msg1 = "RECORDING MOVEMENT AS MIRAGE"
			AssignCharacter(player, 5)
		break

		case 6:
			msg1 = "RECORDING MOVEMENT AS OCTANE"
			AssignCharacter(player, 6)
		break

		case 7:
			msg1 = "RECORDING MOVEMENT AS PATHFINDER"
			AssignCharacter(player, 7)
		break

		case 8:
			msg1 = "RECORDING MOVEMENT AS WRAITH"
			AssignCharacter(player, 8)
		break

		case 9:
			msg1 = "RECORDING MOVEMENT AS WATTSON"
			AssignCharacter(player, 9)
		break

		case 10:
			msg1 = "RECORDING MOVEMENT AS CRYPTO"
			AssignCharacter(player, 10)
		break

		case 11:
			msg1 = "RECORDING MOVEMENT AS LOBA"
			AssignCharacter(player, 5)
			player.SetBodyModelOverride( $"mdl/Humans/pilots/pilot_medium_loba.rmdl" )
			player.SetArmsModelOverride( $"mdl/Humans/pilots/pov_pilot_medium_loba.rmdl" )
		break

		case 12:
			msg1 = "RECORDING MOVEMENT AS BALLISTIC"
			AssignCharacter(player, 5)
			player.SetBodyModelOverride( $"mdl/Humans/pilots/ballistic_base_w.rmdl" )
			player.SetArmsModelOverride( $"mdl/Humans/pilots/ballistic_base_v.rmdl" )
		break

		case 13:
			msg1 = "RECORDING MOVEMENT AS ASH"
			AssignCharacter(player, 5)
			player.SetBodyModelOverride( $"mdl/techart/mshop/characters/legends/ash/ash_base_w.rmdl" )
			player.SetArmsModelOverride( $"mdl/techart/mshop/characters/legends/ash/ash_base_v.rmdl" )
		break

		case 14:
			msg1 = "RECORDING MOVEMENT AS CATALYST"
			AssignCharacter(player, 5)
			player.SetBodyModelOverride( $"mdl/techart/mshop/characters/legends/catalyst/catalyst_base_w.rmdl" )
			player.SetArmsModelOverride( $"mdl/techart/mshop/characters/legends/catalyst/catalyst_base_v.rmdl" )
		break

		case 15:
			msg1 = "RECORDING MOVEMENT AS VALK"
			AssignCharacter(player, 5)
			player.SetBodyModelOverride( $"mdl/Humans/class/medium/pilot_medium_valkyrie.rmdl" )
			player.SetArmsModelOverride( $"mdl/Weapons/arms/pov_pilot_medium_valkyrie.rmdl" )
		break

		case 16:
			msg1 = "RECORDING MOVEMENT AS HORIZON"
			AssignCharacter(player, 5)
			player.SetBodyModelOverride( $"mdl/Humans/class/medium/pilot_medium_nova_01.rmdl" )
			player.SetArmsModelOverride( $"mdl/Weapons/arms/pov_pilot_medium_nova_base_01.rmdl" )
		break
		
		case 17:
			msg1 = "RECORDING MOVEMENT AS RAMPART"
			AssignCharacter(player, 5)
			player.SetBodyModelOverride( $"mdl/Humans/class/medium/pilot_medium_rampart.rmdl" )
			player.SetArmsModelOverride( $"mdl/Weapons/arms/pov_pilot_medium_rampart.rmdl" )
		break

		default:
			msg1 = "RECORDING MOVEMENT"
			AssignCharacter(player, 0)
		break
	}

	if( !player.p.recorderHideHud )
	{
		LocalEventMsg( player, "#FS_RECORDINGANIM_CUSTOM", msg1, 86400 )
		Remote_CallFunction_NonReplay( player, "FS_MovementRecorder_UpdateHints", 0, true, -1 )
	}
	
	asset playermodel = player.GetModelName() //?
	player.StartRecordingAnimation( player.p.currentOrigin, player.p.currentAngles )
	player.p.isRecording = true

	int slot = FS_MovementRecorder_GetEmptySlotForPlayer( player )
	
	if( slot == -1 )
	{
		if( !player.p.recorderHideHud )
			LocalEventMsg( player, "#FS_NO_SLOTS" )
			
		return
	}
	
	OnThreadEnd
	(
		void function() : ( player, slot )
		{
			if( IsValid( player ) )
			{
				if( player.p.isRecording )
					StopRecordingAnimation( player, slot, true )
			}
		}
	)
	
	float endtime = Time() + 149
	// Recording animations disappear after 2:30, hard-set limit.

	EndSignal( player, "OnDestroy", "OnDisconnected", "FinishedRecording" )

	while( true )
	{
		// printt( Time(), endtime )
		if( Time() > endtime )
		{
			StopRecordingAnimation( player, slot )
			player.p.currentOrigin = player.GetOrigin()
			player.p.currentAngles = player.GetAngles()
			player.StartRecordingAnimation( player.p.currentOrigin, player.p.currentAngles )
			// printt( "started new anim recording internal for same slot", slot )
			endtime = Time() + 149
		}
		WaitFrame()
	}
	
}

int function FS_MovementRecorder_GetEmptySlotForPlayer( entity player )
{
	foreach( int i, array< var > anims in player.p.recordingAnims )
	{
		if( anims.len() == 0 )
			return i
	}
	
	return -1
}
void function StopRecordingAnimation( entity player, int forcedSlot = -1, bool actuallyEnded = false )
{
	if( !player.p.isRecording )
		return
	
	int slot = FS_MovementRecorder_GetEmptySlotForPlayer( player )
	
	if( slot == -1 && forcedSlot == -1 )
	{
		if( !player.p.recorderHideHud )
			LocalEventMsg( player, "#FS_NO_SLOTS" )
			
		return
	}

	if( forcedSlot != -1 )
		slot = forcedSlot 

	LocPair animData
	animData.origin = player.p.currentOrigin
	animData.angles = player.p.currentAngles

	player.p.recordingAnims[ slot ].append( player.StopRecordingAnimation() )
	player.p.recordingAnimsCoordinates[ slot ].append( animData )
	player.p.recordingAnimsChosenCharacters[ slot ] = player.p.movementRecorderCharacter

	Assert( file.recordingAnims.len() == file.recordingAnimsCoordinates.len() )

	if( forcedSlot == -1 && player.p.isRecording )
	{
		player.p.isRecording = false
		player.Signal( "FinishedRecording" )
	}

	if( !player.p.recorderHideHud )
	{
		if( actuallyEnded )
		{
			LocalEventMsg( player, "#FS_MOVEMENT_SAVED", slotname( slot + 1 ) )
			Remote_CallFunction_NonReplay( player, "FS_MovementRecorder_UpdateHints", 0, false, -1 )
		}
		
		float duration
		foreach( anim in player.p.recordingAnims[ slot ] )
		{
			duration += GetRecordedAnimationDuration( anim )
		}
		Remote_CallFunction_NonReplay( player, "FS_MovementRecorder_UpdateHints", slot + 1, true, duration )
	}
}

const array<string> r5rDevs = [
	"CafeFPS",
	"DEAFPS",
	"AyeZee",
	"Makimakima",
	"Endergreen12",
	"Zer0Bytes",
	"Julefox",
	"amos_x64",
	"rexx_x64",
	"IcePixelx", 
	"KralRindo",
	"sal",
	"mkos",
	"fireproof"
]

bool function bDoesAnyAnimationExist( entity player )
{
	if( !IsValid( player ) )
		return false
		
	int playerHandle = player.p.handle
		
	if( !( playerHandle in file.playerDummyMaps ) )
		return false
		
	foreach( slot, dummyArray in file._dummyMaps__Template )
	{
		if ( player.p.recordingAnims[ slot ].len() > 0 )
			return true	
	}
	
	return false
}

void function PlayRandomAnimation( entity player )
{
	if( !IsValid( player ) )
		return 
	
	ClientCommand_DestroyDummys( player, [] )
	player.Signal( "PlayRandomAnimation" )	
	EndSignal( player, "OnDisconnected", "OnDestroy", "PlayRandomAnimation" )
	
	int slot;
	int playerHandle = player.p.handle
	
	if( !player.p.recorderHideHud )
		LocalMsg( player, "#FS_PLAYING_RANDOM", "#FS_PLAYING_RANDOM_DESC" )
	
	OnThreadEnd
	(
		void function() : ( player, slot )
		{
			if( IsValid( player ) )
			{
				DestroyDummyForSlot( player, slot )
			}
		}
	)
	
	while( true )
	{
		WaitFrame()
		
		if( !IsValid( player ) )
			return 
		
		if( !( playerHandle in file.playerDummyMaps ) )
			return 
			
			
		array<int> randomSlots = []
	
		for( int i = 0; i < file._dummyMaps__Template.len(); i++ )
		{
			if( player.p.recordingAnims[i].len() > 0 )
				randomSlots.append( i )
		}
		
		if( randomSlots.len() <= 0 )
		{
			if( !player.p.recorderHideHud )
				LocalEventMsg( player, "#FS_NO_ANIMS" )
			
			return
		}
			
		slot = randomSlots.getrandom()
		var anim = player.p.recordingAnims[slot][0]
		
		if( anim == null )
			continue
			
		if( !HasSlotAllocation( player, slot, true ) )
			continue 
			
		PlayAnimInSlot( player, slot, false, false, true )
		
		float duration
		foreach( anims in player.p.recordingAnims[ slot ] )
		{
			duration += GetRecordedAnimationDuration( anims )
		}

		wait duration + 0.1
		
		if( !IsValid( player ) || !player.p.continueLoop )
			return
			
		wait 0.2
	}
}

void function PlayAnimInSlot( entity player, int slot, bool remove = false, bool removeAll = false, bool bIsPlayingRandomSlot = false )
{
	if( !remove && !HasSlotAllocation( player, slot ) )
	{
		return
	}
	
	if( !remove && IsOverBudget( player ) )
	{
		return
	}
	
	EndSignal( player, "EndDummyThread", "EndDummyThread_Slot_" + slot.tostring() )
	EndSignal( svGlobal.levelEnt, "EndDummyThread" )
	
	int playerHandle = player.p.handle
	
	#if DEVELOPER
		printt( "playaniminslot", slot )
	#endif
	
	int currentAnimFromSlot = 0
	
	var anim
	if( player.p.recordingAnims[slot].len() > 0 )
		anim = player.p.recordingAnims[slot][currentAnimFromSlot]

	if( !remove && anim == null )
	{
		if( !player.p.recorderHideHud )
			LocalEventMsg( player, "#FS_ANIM_NOT_FOUND", "", 3 )
			
		return
	}

	if( remove && anim != null )
	{
		player.p.recordingAnims[ slot ] = []
		player.p.recordingAnimsCoordinates[ slot ] = []
		Remote_CallFunction_NonReplay( player, "FS_MovementRecorder_UpdateHints", slot + 1, false, -1 )

		if( !player.p.recorderHideHud && !removeAll )
			LocalEventMsg( player, "#FS_ANIM_REMOVED_SLOT", slotname( slot + 1 ), 3 )
			
		DestroyDummyForSlot( player, slot )
		
		return
	}
	else if( !remove )
	{
		if( !player.p.recorderHideHud )
			LocalEventMsg( player, "#FS_PLAYING_ANIM", slotname( slot + 1 ), 3 )
	}
	else if ( remove )
	{
		return
	}

	vector initialpos = player.p.recordingAnimsCoordinates[ slot ][currentAnimFromSlot].origin
	vector initialang = player.p.recordingAnimsCoordinates[ slot ][currentAnimFromSlot].angles

	//// 0 Bang// 1 Bloodhound// 2 Caustic// 3 Gibby// 4 Lifeline// 5 Mirage// 6 Octane// 7 Pathy// 8 Wraith// 9 Watty// 10 Crypto
	string aiFileToUse
	switch( player.p.recordingAnimsChosenCharacters[ slot ] )
	{
		case 0:
			aiFileToUse = "npc_dummie_bangalore"
		break
		
		case 1:
			aiFileToUse = "npc_dummie_bloodhound"
		break
		
		case 2:
			aiFileToUse = "npc_dummie_caustic"
		break
		
		case 3:
			aiFileToUse = "npc_dummie_gibby"
		break

		case 4:
			aiFileToUse = "npc_dummie_lifeline"
		break

		case 5:
			aiFileToUse = "npc_dummie_mirage"
		break

		case 6:
			aiFileToUse = "npc_dummie_octane"
		break

		case 7:
			aiFileToUse = "npc_dummie_pathfinder"
		break

		case 8:
			aiFileToUse = "npc_dummie_wraith"
		break

		case 9:
			aiFileToUse = "npc_dummie_wattson"
		break

		case 10:
			aiFileToUse = "npc_dummie_crypto"
		break

		case 11:
			aiFileToUse = "npc_dummie_loba"
		break

		case 12:
			aiFileToUse = "npc_dummie_ballistic"
		break

		case 13:
			aiFileToUse = "npc_dummie_ash"
		break

		case 14:
			aiFileToUse = "npc_dummie_catalyst"
		break

		case 15:
			aiFileToUse = "npc_dummie_valk"
		break

		case 16:
			aiFileToUse = "npc_dummie_horizon"
		break

		case 17:
			aiFileToUse = "npc_dummie_rampart"
		break
		
		default:
			aiFileToUse = "npc_dummie_wraith"
		break
	}

	entity dummy 
	while( true )
	{
		if( !IsValid( dummy ) )
		{
			dummy = CreateDummy( 99, initialpos, initialang )
			file.playerPlaybackAmounts[ player.p.handle ][ slot ]++
			
				// EndSignal( player, "EndDummyThread", "EndDummyThread_Slot_" + slot.tostring() )
				// EndSignal( svGlobal.levelEnt, "EndDummyThread" )

				// OnThreadEnd( function() : ( player, dummy, slot )
				// {
					// if( IsValid( dummy ) )
						// RemoveDummyForPlayer( player, dummy, slot )			
				// })
			
			vector pos = dummy.GetOrigin()
			vector angles = dummy.GetAngles()
			// StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), pos, angles )
			SetSpawnOption_AISettings( dummy, aiFileToUse )

			dummy.Hide()

			// dummy.SetBehaviorSelector( "behavior_dummy_empty" )
			// dummy.EnableNPCFlag( NPC_DISABLE_SENSING )
			// dummy.EnableNPCFlag( NPC_IGNORE_ALL )

			DispatchSpawn( dummy )
			dummy.SetTitle( r5rDevs.getrandom() )
			SetDummyProperties(dummy, 2)
			
			// WaitFrame()
			
			dummy.PlayRecordedAnimation( anim, initialpos, initialang )
			// dummy.SetRecordedAnimationPlaybackRate( 1.0 )
			dummy.Show()

			file.playerDummyMaps[ playerHandle ][ slot ].append(dummy)
		}

		if( !IsValid( player ) || !IsValid( dummy ) )
			return

		dummy.PlayRecordedAnimation( anim, initialpos, initialang )

		wait GetRecordedAnimationDuration( anim )

		if( IsValid( player ) && currentAnimFromSlot + 1 < player.p.recordingAnims[slot].len() )
		{
			currentAnimFromSlot++
			anim = player.p.recordingAnims[slot][currentAnimFromSlot]
			initialpos = player.p.recordingAnimsCoordinates[ slot ][currentAnimFromSlot].origin
			initialang = player.p.recordingAnimsCoordinates[ slot ][currentAnimFromSlot].angles
			continue
		} else if( IsValid( player ) && player.p.continueLoop )
		{
			currentAnimFromSlot = 0
			anim = player.p.recordingAnims[slot][currentAnimFromSlot]
			initialpos = player.p.recordingAnimsCoordinates[ slot ][currentAnimFromSlot].origin
			initialang = player.p.recordingAnimsCoordinates[ slot ][currentAnimFromSlot].angles
			continue
		} else
		{
			RemoveDummyForPlayer( player, dummy, slot )
			break
		}

		if( IsValid( player ) && !player.p.continueLoop || bIsPlayingRandomSlot )
		{	
			break
		}
	}
}

void function RemoveDummyForPlayer( entity player, entity dummy, int slot )
{	
	if( !IsValid( dummy ) ) 
		return
			
	if( IsValid( player ) && file.playerDummyMaps[ player.p.handle ][ slot ].contains( dummy ) )
		file.playerDummyMaps[ player.p.handle ][ slot ].removebyvalue( dummy )
	
	dummy.Destroy()
	
	file.playerPlaybackAmounts[ player.p.handle ][ slot ]--;
}

void function DestroyDummyForSlot( entity player, int slot, int playerHandle = -1 )
{
	if( IsValid( player ) )
	{
		player.Signal( "EndDummyThread_Slot_" + string( slot ) )
		playerHandle = player.p.handle
	}
	
	#if DEVELOPER
		printf( "Destroy %d dummys for slot %d ", file.playerDummyMaps[ playerHandle ][ slot ].len(), slot )
	#endif
	
	if( !( playerHandle in file.playerDummyMaps ) )
		return
	
	if ( slot in file.playerDummyMaps[ playerHandle ] )
	{	
		foreach( k,slotDummy in file.playerDummyMaps[ playerHandle ][ slot ] )
		{		
			if( !IsValid( slotDummy ) )
			{
				continue
			}
					
			slotDummy.Destroy()
			
			#if DEVELOPER
				CheckDummyDestroyed( slotDummy )
			#endif
		}
	}
	else 
	{
		return
	}
	
	file.playerDummyMaps[ playerHandle ][ slot ].resize(0)
	file.playerPlaybackAmounts[ playerHandle ][ slot ] = 0
}

void function CheckDummyDestroyed( entity dummy )
{
	mAssert( !IsValid(dummy), "Dummy was not destroyed!!" )
}

void function AssignCharacter( entity player, int index )
{
	ItemFlavor PersonajeEscogido = GetAllCharacters()[ index ]
	CharacterSelect_AssignCharacter( ToEHI( player ), PersonajeEscogido )		
	
	ItemFlavor playerCharacter = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
	asset characterSetFile = CharacterClass_GetSetFile( playerCharacter )
	player.SetPlayerSettingsWithMods( characterSetFile, [] )
}

int function ReturnShieldAmountForDesiredLevel( int shield )
{
	switch(shield)
	{
		case 0:
			return 0
		case 1:
			return 50
		case 2:
			return 75
		case 3:
			return 100
		case 4:
			return 125
			
		default:
			return 50
	}
	unreachable
}

void function SetDummyProperties( entity dummy, int shield )
{
	dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel( shield ) )
	dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel( shield ) )
	dummy.SetMaxHealth( 100 )
	dummy.SetHealth( 100 )
	dummy.SetDamageNotifications( true )
	dummy.SetTakeDamageType( DAMAGE_YES )
	dummy.SetCanBeMeleed( true )
	AddEntityCallback_OnDamaged( dummy, RecordingAnimationDummy_OnDamaged )

	dummy.SetForceVisibleInPhaseShift( true )
}

void function RecordingAnimationDummy_OnDamaged( entity dummy, var damageInfo )
{
	entity ent = dummy	
	entity attacker = DamageInfo_GetAttacker(damageInfo)
	
	if( !attacker.IsPlayer() ) 
		return

	float damage = DamageInfo_GetDamage( damageInfo )
	
	//fake helmet
	float headshotMultiplier = GetHeadshotDamageMultiplierFromDamageInfo(damageInfo)
	float basedamage = DamageInfo_GetDamage( damageInfo )/headshotMultiplier
	
	if(IsValidHeadShot( damageInfo, dummy ) )
	{
		int headshot = int(basedamage*(file.helmet_lv4+(1-file.helmet_lv4)*headshotMultiplier))
		DamageInfo_SetDamage( damageInfo, headshot)
	}

	// if(!attacker.IsPlayer() ) return
	// attacker.RefillAllAmmo()
}



void function ClientCommand_DestroyDummys( entity player, array<string> args )
{
	if( !IsValid( player ) )
		return
	
	string param = ""
	int playerHandle = player.p.handle
	
	if( args.len() > 0 )
	{
		param = args[ 0 ]
	}
	
	switch( param )
	{
		case "":
			
			if( !( player.p.handle in file.playerDummyMaps ) )
				return
			
			foreach ( slot, dummies in file.playerDummyMaps[ playerHandle ] )
				DestroyDummyForSlot( player, slot )
			
			if( !player.p.recorderHideHud )
				LocalEventMsg( player, "#FS_RECORDER_ENDALL" )
			
			break
		
		case "Admin":
		
			if( !VerifyAdmin( player.p.name, player.p.UID ) )
				return
	
			if( IsValid( svGlobal.levelEnt ) )
			{
				svGlobal.levelEnt.Signal( "EndDummyThread" )
			}
			
			foreach( pHandle, playbackTable in file.playerPlaybackAmounts )
			{
				foreach( slot, amount in playbackTable )
				{
					amount = 0
				}
			}
			
			array<entity> dummysToRemove = GetEntArrayByClass_Expensive( "npc_dummie" )
			
			foreach( dummy in dummysToRemove )
			{
				if( IsValid(dummy) )
				{
					dummy.Destroy()
				}
			}
			
			foreach( sPlayer in GetPlayerArray() )
			{
				if( !IsValid( sPlayer ) )
					continue 
				
				if( !player.p.recorderHideHud )
					LocalEventMsg( sPlayer, "#FS_ADMIN_RECORDER_ENDALL" )
			}
			
			break
	}
}

//TODO: Preferably we use more performant budget management strategy in the future, for now.. this. ~mkos
bool function IsOverBudget( entity player, int amountToPlay = 1 )
{
	if ( ( GetEntArrayByClass_Expensive( "npc_dummie" ).len() + amountToPlay ) < MAX_NPC_BUDGET )
	{
		return false 
	}
	else 
	{
		if( IsValid( player ) )
		{
			if( !player.p.recorderHideHud )
				LocalEventMsg( player, "#FS_OVER_BUDGET" )
		}
		
		return true
	}
	
	unreachable
}

bool function HasSlotAllocation( entity player, int slot, bool hidehud = false )
{
	if ( file.playbackLimit > -1 && file.playerPlaybackAmounts[ player.p.handle ][ slot ] >= file.playbackLimit )
	{
		if( !hidehud && !player.p.recorderHideHud )
			LocalEventMsg( player, "#FS_PLAYBACK_LIMIT" )
			
		return false
	}
	
	return true
}

//////////////////////
//		  DEV		//
//////////////////////

#if DEVELOPER
	void function PrintMovementRecorderTable( table< int, table< int, int > > tbl )
	{
		PrintTableTyped( 0, 0, 2, tbl )
	}

	void function PrintTableTyped( int indent, int depth, int maxDepth, table< int, table< int, int > > tbl )
	{
		printt("\n\n")
		printt("--- TABLE ---")
		
		if ( depth >= maxDepth )
		{
			printt( "{...}" )
			return
		}

		printt( "{" )
		foreach ( k, v in tbl )
		{
			printt( TableIndent( indent + 2 ) + k + " = " )
			PrintNestedTableTyped( indent + 2, depth + 1, maxDepth, v )
		}
		printt( TableIndent( indent ) + "}" )
		
		printt("\n\n")
	}


	void function PrintNestedTableTyped( int indent, int depth, int maxDepth, table< int, int > tbl )
	{
		if ( depth >= maxDepth )
		{
			printl( "{...}" )
			return
		}

		printt( TableIndent( indent ) + "{" )
		foreach ( k, v in tbl )
		{
			printt( TableIndent( indent + 2 ) + k + " = " + v )
		}
		printt( TableIndent( indent ) + "}" )
	}
#endif //DEVELOPER


#endif //IF SERVER