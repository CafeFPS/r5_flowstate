// Made by @CafeFPS
// el límite es bastante pequeño para npcs, como 128 o algo así, hacer un check para eso

#if SERVER
global function DestroyDummys
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

const int MAX_SLOT = 5

struct{
	#if SERVER
	//movido a la estructura de server player
	#endif

	#if CLIENT
	array<var> inputHintLines
	#endif
}file

void function Sh_FS_MovementRecorder_Init()
{
	#if CLIENT
	AddCallback_OnClientScriptInit( FS_MovementRecorder_SetBindings )
	AddClientCallback_OnResolutionChanged( FS_MovementRecorder_OnResolutionChanged )
	#endif
	
	#if SERVER
	AddClientCommandCallback("toggleMovementRecorder", ClientCommand_ToggleMovementRecorder)

	// no puedo bindear argumentos? Xd
	AddClientCommandCallback("PlayAnimInSlot1", ClientCommand_PlayAnimInSlot1)
	AddClientCommandCallback("PlayAnimInSlot2", ClientCommand_PlayAnimInSlot2)
	AddClientCommandCallback("PlayAnimInSlot3", ClientCommand_PlayAnimInSlot3)
	AddClientCommandCallback("PlayAnimInSlot4", ClientCommand_PlayAnimInSlot4)
	AddClientCommandCallback("PlayAnimInSlot5", ClientCommand_PlayAnimInSlot5)
	AddClientCommandCallback("PlayAllAnims", ClientCommand_PlayAllAnims)

	AddClientCommandCallback("recorder_switchCharacter", ClientCommand_SwitchCharacter)
	AddClientCommandCallback("recorder_recorderHideHud", ClientCommand_HideHud)
	AddClientCommandCallback("recorder_toggleContinueLoop", ClientCommand_ToggleContinueLoop)

	AddCallback_OnClientConnected( FS_MovementRecorder_OnPlayerConnected )
	RegisterSignal( "EndDummyThread" )
	#endif
}

#if CLIENT
void function FS_MovementRecorder_SetBindings( entity player )
{
	// no puedo bindear argumentos? Xd
	player.ClientCommand( "bind_US_standard F2 toggleMovementRecorder" )
	player.ClientCommand( "bind_US_standard F3 PlayAnimInSlot1" )
	player.ClientCommand( "bind_US_standard F4 PlayAnimInSlot2" )
	player.ClientCommand( "bind_US_standard F5 PlayAnimInSlot3" )
	player.ClientCommand( "bind_US_standard F6 PlayAnimInSlot4" )
	player.ClientCommand( "bind_US_standard F7 PlayAnimInSlot5" )
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

	UISize screenSize = GetScreenSize()
	var topo = RuiTopology_CreatePlane( <( screenSize.width * 0.08),( screenSize.height * 0 ), 0>, <float( screenSize.width ), 0, 0>, <0, float( screenSize.height ), 0>, false )
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
	RuiSetString( hintRui2, "hintText", "Slot 1 - Empty" )
	RuiSetString( hintRui2, "altHintText", "" )
	RuiSetInt( hintRui2, "hintOffset", 1 )
	RuiSetBool( hintRui2, "hideWithMenus", false )
	file.inputHintLines.append( hintRui2 )

	var hintRui3 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui3, "buttonText", "%F4%" )
	RuiSetString( hintRui3, "gamepadButtonText", "%F4%" )
	RuiSetString( hintRui3, "hintText", "Slot 2 - Empty" )
	RuiSetString( hintRui3, "altHintText", "" )
	RuiSetInt( hintRui3, "hintOffset", 2 )
	RuiSetBool( hintRui3, "hideWithMenus", false )
	file.inputHintLines.append( hintRui3 )

	var hintRui4 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui4, "buttonText", "%F5%" )
	RuiSetString( hintRui4, "gamepadButtonText", "%F5%" )
	RuiSetString( hintRui4, "hintText", "Slot 3 - Empty" )
	RuiSetString( hintRui4, "altHintText", "" )
	RuiSetInt( hintRui4, "hintOffset", 3 )
	RuiSetBool( hintRui4, "hideWithMenus", false )
	file.inputHintLines.append( hintRui4 )

	var hintRui5 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui5, "buttonText", "%F6%" )
	RuiSetString( hintRui5, "gamepadButtonText", "%F6%" )
	RuiSetString( hintRui5, "hintText", "Slot 4 - Empty" )
	RuiSetString( hintRui5, "altHintText", "" )
	RuiSetInt( hintRui5, "hintOffset", 4 )
	RuiSetBool( hintRui5, "hideWithMenus", false )
	file.inputHintLines.append( hintRui5 )

	var hintRui6 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui6, "buttonText", "%F7%" )
	RuiSetString( hintRui6, "gamepadButtonText", "%F7%" )
	RuiSetString( hintRui6, "hintText", "Slot 5 - Empty" )
	RuiSetString( hintRui6, "altHintText", "" )
	RuiSetInt( hintRui6, "hintOffset", 5 )
	RuiSetBool( hintRui6, "hideWithMenus", false )
	file.inputHintLines.append( hintRui6 )

	var hintRui7 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui7, "buttonText", "%F8%" )
	RuiSetString( hintRui7, "gamepadButtonText", "%F8%" )
	RuiSetString( hintRui7, "hintText", "Play All Anims" )
	RuiSetString( hintRui7, "altHintText", "" )
	RuiSetInt( hintRui7, "hintOffset", 6 )
	RuiSetBool( hintRui7, "hideWithMenus", false )
	file.inputHintLines.append( hintRui7 )

	var hintRui8 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui8, "buttonText", "%F11%" )
	RuiSetString( hintRui8, "gamepadButtonText", "%F11%" )
	RuiSetString( hintRui8, "hintText", "Character: Wraith" )
	RuiSetString( hintRui8, "altHintText", "" )
	RuiSetInt( hintRui8, "hintOffset", 7 )
	RuiSetBool( hintRui8, "hideWithMenus", false )
	file.inputHintLines.append( hintRui8 )

	var hintRui9 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui9, "buttonText", "%F11%" )
	RuiSetString( hintRui9, "gamepadButtonText", "%F11%" )
	RuiSetString( hintRui9, "hintText", "Character: Wraith" )
	RuiSetString( hintRui9, "altHintText", "" )
	RuiSetInt( hintRui9, "hintOffset", 7 )
	RuiSetBool( hintRui9, "hideWithMenus", false )
	file.inputHintLines.append( hintRui9 )

	var hintRui10 = RuiCreate( $"ui/tutorial_hint_line.rpak", topo, RUI_DRAW_POSTEFFECTS, MINIMAP_Z_BASE + 10 )
	RuiSetString( hintRui10, "buttonText", "%$rui/menu/buttons/tip%" )
	RuiSetString( hintRui10, "gamepadButtonText", "%$rui/menu/buttons/tip%" )
	RuiSetString( hintRui10, "hintText", "Crouch + Slot to clear" )
	RuiSetString( hintRui10, "altHintText", "" )
	RuiSetInt( hintRui10, "hintOffset", 8 )
	RuiSetBool( hintRui10, "hideWithMenus", false )
	file.inputHintLines.append( hintRui10 )
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

	if( hint == 7 )
	{
		string characterToUse
		switch( duration.tointeger() )
		{
			case 0:
			characterToUse = "Wraith"
			break
			
			case 1:
			characterToUse = "Pathfinder"
			break
			
			case 2:
			characterToUse = "Bangalore"
			break
			
			case 3:
			characterToUse = "Octane"
			break

			default:
			characterToUse = "Wraith"
		}
		RuiSetString( file.inputHintLines[hint], "hintText", "Character: " + characterToUse )
		return
	}

	if( state )
	{
		DisplayTime dt = SecondsToDHMS( duration.tointeger() )
		RuiSetString( file.inputHintLines[hint], "hintText", "Slot " + hint + " - Play " + format( "%.2d:%.2d", dt.minutes, dt.seconds ) )
		return
	} else if( !state )
	{
		RuiSetString( file.inputHintLines[hint], "hintText", "Slot " + hint + " - Empty" )
		return
	}
}

void function FS_MovementRecorder_OnResolutionChanged()
{
	FS_MovementRecorder_CreateInputHintsRUI( false )
}
#endif

#if SERVER
void function FS_MovementRecorder_OnPlayerConnected( entity player )
{
	if( !player.p.recorderHideHud )
		Message_New( player, "Flowstate Movement Recorder \n\n Made by CafeFPS", 10 )

	player.p.recordingAnims.resize( MAX_SLOT )
	player.p.recordingAnimsCoordinates.resize( MAX_SLOT )
	player.p.recordingAnimsChosenCharacters.resize( MAX_SLOT )
}

bool function ClientCommand_ToggleMovementRecorder(entity player, array<string> args)
{
	if( !IsValid( player ) )
		return false

	if( player.p.isRecording )
	{
		thread StopRecordingAnimation( player )
	} else
	{
		if( !IsAlive( player ) )
			DecideRespawnPlayer( player, true )

		thread StartRecordingAnimation( player )
	}
	return true
}

bool function ClientCommand_PlayAnimInSlot1(entity player, array<string> args)
{
	if( !IsValid( player ) )
		return false

	bool remove = player.IsInputCommandHeld( IN_DUCK )
	thread PlayAnimInSlot( player, 	0, remove )
	return true
}

bool function ClientCommand_PlayAnimInSlot2(entity player, array<string> args)
{
	if( !IsValid( player ) )
		return false

	bool remove = player.IsInputCommandHeld( IN_DUCK )
	thread PlayAnimInSlot( player, 	1, remove )
	return true
}

bool function ClientCommand_PlayAnimInSlot3(entity player, array<string> args)
{
	if( !IsValid( player ) )
		return false

	bool remove = player.IsInputCommandHeld( IN_DUCK )
	thread PlayAnimInSlot( player, 	2, remove )
	return true
}

bool function ClientCommand_PlayAnimInSlot4(entity player, array<string> args)
{
	if( !IsValid( player ) )
		return false

	bool remove = player.IsInputCommandHeld( IN_DUCK )
	thread PlayAnimInSlot( player, 	3, remove )
	return true
}

bool function ClientCommand_PlayAnimInSlot5(entity player, array<string> args)
{
	if( !IsValid( player ) )
		return false

	bool remove = player.IsInputCommandHeld( IN_DUCK )
	thread PlayAnimInSlot( player, 	4, remove )
	return true
}

bool function ClientCommand_PlayAllAnims(entity player, array<string> args)
{
	if( !IsValid( player ) )
		return false

	bool remove = player.IsInputCommandHeld( IN_DUCK )

	for(int i = 0; i<5; i++ )
		thread PlayAnimInSlot( player, 	i, remove )

	if( !player.p.recorderHideHud )
		Message_New( player, "Playing All Anims", 5 )
	return true
}

bool function ClientCommand_SwitchCharacter(entity player, array<string> args)
{
	if( !IsValid( player ) )
		return false

	if( player.p.isRecording )
	{
		if( !player.p.recorderHideHud )
			Message_New( player, "Can't switch character while recording", 3 )
		return false
	}
	player.p.movementRecorderCharacter++

	if( player.p.movementRecorderCharacter > 3 )
		player.p.movementRecorderCharacter = 0

	Remote_CallFunction_NonReplay( player, "FS_MovementRecorder_UpdateHints", 7, true, player.p.movementRecorderCharacter )
	return true
}

bool function ClientCommand_HideHud(entity player, array<string> args)
{
	if( player.p.recorderHideHud )
	{
		player.p.recorderHideHud = false
		Remote_CallFunction_NonReplay( player, "FS_MovementRecorder_CreateInputHintsRUI", false )
	} else if( !player.p.recorderHideHud )
	{
		player.p.recorderHideHud = true
		Remote_CallFunction_NonReplay( player, "FS_MovementRecorder_CreateInputHintsRUI", true )
	}
	return true
}

bool function ClientCommand_ToggleContinueLoop(entity player, array<string> args)
{
	if( player.p.continueLoop )
	{
		player.p.continueLoop = false
		Remote_CallFunction_NonReplay( player, "FS_MovementRecorder_UpdateHints", 8, true, -1 )
	} else if( !player.p.continueLoop )
	{
		player.p.continueLoop = true
		Remote_CallFunction_NonReplay( player, "FS_MovementRecorder_UpdateHints", 8, false, -1 )
	}
	return true
}

void function StartRecordingAnimation( entity player )
{
	player.p.currentOrigin = player.GetOrigin()
	player.p.currentAngles = player.GetAngles()
	
	string msg1

	switch( player.p.movementRecorderCharacter )
	{
		case 0:
			msg1 = "RECORDING MOVEMENT AS WRAITH"
			AssignCharacter(player, 8)
		break
		
		case 1:
			msg1 = "RECORDING MOVEMENT AS PATHFINDER"
			AssignCharacter(player, 7)
		break
		
		case 2:
			msg1 = "RECORDING MOVEMENT AS BANGALORE"
			AssignCharacter(player, 0)
		break
		
		case 3:
			msg1 = "RECORDING MOVEMENT AS OCTANE"
			AssignCharacter(player, 6)
		break
		
		default:
			msg1 = "RECORDING MOVEMENT"
			AssignCharacter(player, 0)
		break
	}

	if( !player.p.recorderHideHud )
	{
		Message_New(player, "%$rui/flowstate_custom/recordinganim% " + msg1, 86400)
		Remote_CallFunction_NonReplay( player, "FS_MovementRecorder_UpdateHints", 0, true, -1 )
	}
	
	asset playermodel = player.GetModelName()
	player.StartRecordingAnimation( player.p.currentOrigin, player.p.currentAngles )

	player.p.isRecording = true
}

int function FS_MovementRecorder_GetEmptySlotForPlayer( entity player )
{
	foreach( int i, var anim in player.p.recordingAnims )
	{
		if( anim == null )
			return i
	}
	
	return -1
}
void function StopRecordingAnimation( entity player )
{
	if( !player.p.isRecording )
		return
	
	int slot = FS_MovementRecorder_GetEmptySlotForPlayer( player )
	
	if( slot == -1 )
	{
		if( !player.p.recorderHideHud )
			Message_New( player, "There are no slots available", 5 )
		return
	}

	LocPair animData
	animData.origin = player.p.currentOrigin
	animData.angles = player.p.currentAngles

	player.p.recordingAnims[slot] = player.StopRecordingAnimation()
	player.p.recordingAnimsCoordinates[slot] = animData
	player.p.recordingAnimsChosenCharacters[slot] = player.p.movementRecorderCharacter

	Assert( file.recordingAnims.len() == file.recordingAnimsCoordinates.len() )

	player.p.isRecording = false

	if( !player.p.recorderHideHud )
	{
		Message_New(player, "MOVEMENT SAVED IN SLOT " + (slot + 1).tostring(), 3)
		Remote_CallFunction_NonReplay( player, "FS_MovementRecorder_UpdateHints", 0, false, -1 )


		var anim = player.p.recordingAnims[slot]
		float duration = GetRecordedAnimationDuration( anim )
		Remote_CallFunction_NonReplay( player, "FS_MovementRecorder_UpdateHints", slot + 1, true, duration )
	}
}

array<entity> dummyList;
void function PlayAnimInSlot( entity player, int slot, bool remove = false )
{
	player.EndSignal("EndDummyThread")

	printt( "playaniminslot", slot )

	// if( file.recordingAnims.len() == 0 ) // || slot > file.recordingAnims.len() - 1 )
		// return

	var anim = player.p.recordingAnims[slot] // file.recordingAnims[ slot ]
	
	if( anim == null )
	{
		if( !player.p.recorderHideHud )
			Message_New(player, "Anim not found", 3)
		return
	}

	if( remove && anim != null )
	{
		player.p.recordingAnims[slot] = null
		Remote_CallFunction_NonReplay( player, "FS_MovementRecorder_UpdateHints", slot + 1, false, -1 )

		if( !player.p.recorderHideHud )
			Message_New(player, "Anim removed in slot " + (slot + 1).tostring(), 3)
		return
	}

	vector initialpos = player.p.recordingAnimsCoordinates[slot].origin
	vector initialang = player.p.recordingAnimsCoordinates[slot].angles

	array<string> r5rDevs = [
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
		"mkos"
	]

	string aiFileToUse
	switch( player.p.recordingAnimsChosenCharacters[slot] )
	{
		case 0:
			aiFileToUse = "npc_dummie_wraith"
		break
		
		case 1:
			aiFileToUse = "npc_dummie_pathfinder"
		break
		
		case 2:
			aiFileToUse = "npc_dummie_bangalore"
		break
		
		case 3:
			aiFileToUse = "npc_dummie_octane"
		break
		
		default:
			aiFileToUse = "npc_dummie_wraith"
		break
	}

	while( true )
	{
		entity dummy = CreateDummy( 99, initialpos, initialang )
		vector pos = dummy.GetOrigin()
		vector angles = dummy.GetAngles()
		StartParticleEffectInWorld( GetParticleSystemIndex( FIRINGRANGE_ITEM_RESPAWN_PARTICLE ), pos, angles )
		SetSpawnOption_AISettings( dummy, aiFileToUse )

		dummy.Hide()

		DispatchSpawn( dummy )
		dummy.SetTitle( r5rDevs.getrandom() )
		SetDummyProperties(dummy, 2)
		
		WaitFrame()
		
		dummy.PlayRecordedAnimation( anim, initialpos, initialang, 0.5 )
		// dummy.SetRecordedAnimationPlaybackRate( 1.0 )
		dummy.Show()
		
		waitthread function () : ( anim, dummy )
		{
			EndSignal(dummy, "OnDeath")
			EndSignal(dummy, "OnDestroy")
			
			dummyList.append(dummy)
			
			wait GetRecordedAnimationDuration( anim )
			
			if(!IsValid(dummy)) return
			
			if(dummyList.contains(dummy))
				dummyList.removebyvalue(dummy)
			
			dummy.Destroy()
		}()

		if( IsValid( player ) && !player.p.continueLoop )
			break
	}
}

void function AssignCharacter( entity player, int index )
{
	ItemFlavor PersonajeEscogido = GetAllCharacters()[index]
	CharacterSelect_AssignCharacter( ToEHI( player ), PersonajeEscogido )		
	
	ItemFlavor playerCharacter = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
	asset characterSetFile = CharacterClass_GetSetFile( playerCharacter )
	player.SetPlayerSettingsWithMods( characterSetFile, [] )
}

int function ReturnShieldAmountForDesiredLevel(int shield)
{
	switch(shield){
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

void function SetDummyProperties(entity dummy, int shield)
{
	dummy.SetShieldHealthMax( ReturnShieldAmountForDesiredLevel(shield) )
	dummy.SetShieldHealth( ReturnShieldAmountForDesiredLevel(shield) )
	dummy.SetMaxHealth( 100 )
	dummy.SetHealth( 100 )
	dummy.SetDamageNotifications( true )
	dummy.SetTakeDamageType( DAMAGE_YES )
	dummy.SetCanBeMeleed( true )
	AddEntityCallback_OnDamaged( dummy, RecordingAnimationDummy_OnDamaged)

	dummy.SetForceVisibleInPhaseShift( true )
}
void function RecordingAnimationDummy_OnDamaged( entity dummy, var damageInfo )
{
	entity ent = dummy	
	entity attacker = DamageInfo_GetAttacker(damageInfo)
	if(!attacker.IsPlayer()) return

	float damage = DamageInfo_GetDamage( damageInfo )
	
	//fake helmet
	float headshotMultiplier = GetHeadshotDamageMultiplierFromDamageInfo(damageInfo)
	float basedamage = DamageInfo_GetDamage(damageInfo)/headshotMultiplier
	
	if(IsValidHeadShot( damageInfo, dummy ))
	{
		int headshot = int(basedamage*(GetCurrentPlaylistVarFloat( "helmet_lv4", 0.65 )+(1-GetCurrentPlaylistVarFloat( "helmet_lv4", 0.65 ))*headshotMultiplier))
		DamageInfo_SetDamage( damageInfo, headshot)
	}

	// if(!attacker.IsPlayer() ) return
	// attacker.RefillAllAmmo()
}

void function DestroyDummys()
{
	entity player = GetPlayerArray()[0]
	
	if( IsValid( player ))
	{
		player.Signal("EndDummyThread")
	}
	
    player.p.continueLoop = false

    while (dummyList.len() > 0)
    {
        entity dummy = dummyList.pop()
        if (IsValid(dummy))
            dummy.Destroy()
    }
}
#endif //IF SERVER