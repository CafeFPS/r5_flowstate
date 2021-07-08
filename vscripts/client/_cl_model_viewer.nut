#if R5DEV
untyped
#endif

global function ServerCallback_MVUpdateModelBounds
global function ServerCallback_MVEnable
global function ServerCallback_MVDisable

#if R5DEV
global function ClModelViewInit
global function ModelViewerSpawnModel
global function SelectNextModel
global function SelectPreviousModel
global function SnapViewToModel
global function ClientCodeCallback_HLMV_ModelChanged
global function ClientCodeCallback_HLMV_SequenceChanged
global function ClientCodeCallback_HLMV_SetSpeedScale
global function ClientCodeCallback_HLMV_SetCycle
global function ClientCodeCallback_LevelEd_SetPosition
global function ClientCodeCallback_LevelEd_ClearPreviewEntity
global function ReplaceStringCharacter
global function HLMV_ToggleMoveInPlace
global function IsModelViewerActive

table signals

const MODELVIEWERMODE_GAMEPAD = "gamepad_manipulate_mode"
const MODELVIEWERMODE_INACTIVE = "inactive"
const MODELVIEWERMODE_LEVELED = "leveled"

struct HlmvModelData
{
	entity model
	entity parentEnt
	string sequence
	bool precaching
}

struct {
	array<asset> modelViewerModels

	bool dpadUpPressed = false
	bool dpadDownPressed = false
	bool dpadLeftPressed = false
	bool dpadRightPressed = false
	bool shoulderLeftPressed = false
	bool shoulderRightPressed = false
	bool triggerLeftPressed = false
	bool triggerRightPressed = false
	bool buttonXPressed = false
	bool buttonYPressed = false
	bool buttonBPressed = false
	bool buttonAPressed = false
	bool stickLeftPressed = false
	bool stickRightPressed = false

	TraceResults& dropModelTraceResult

	array<entity> spawnedModels

	string modelViewerMode = MODELVIEWERMODE_INACTIVE

	float modelTranslateSpeed = 1.5
	float modelTranslateZSpeed = 1.25
	float modelRotateSpeed = 2.0

	array<entity> selectedModels
	float selectAllDelay = 1.5
	entity lastSelectedModel = null
	entity bestModelToSelect = null
	bool modelSelectionBoundsVisible = false
	float modelSelectionBoundsHideTime = -1.0
	float modelSectionBoundsShowTime = 7.5 // time to show bounds on all models to be selected
	float modelNewSectionBoundsShowTime = 2.0 // time to show bounds after selection has been made

	vector colorSelected = <160,160,0>
	vector colorUnselected = <60,0,0>
	vector colorHover = <255,0,0>
	vector colorSelectedHover = <255,255,0>

	int modelToDropIndex = 0

	bool tumbleModeActive = false

	array<table<string, vector> > modelBounds

	bool controllerHudCreated = false

	int noclipState = 0

	var hudGrpController
	var controllerBG
	var hudTriggerLeft
	var hudTriggerRight
	var hudShoulderLeft
	var hudShoulderRight
	var hudButtonY
	var hudButtonX
	var hudButtonB
	var hudButtonA
	var hudStickLeft
	var hudStickRight
	var hudDPad

	var hudGrpModelNames
	array hudModelNames

	int lastEnablematchending
	int lastEnabletimelimit

	asset hlmv_lastModel
	float hlmv_speedScale = 1.0
	float hlmv_cycle = -1.0
	bool leveled_positionReceived = false
	vector leveled_origin
	vector leveled_angles
	table<asset,HlmvModelData> hlmv_modelData

	bool hlmv_moveInPlace = false
} file

void function ClModelViewInit()
{
	RegisterSignal( "NewHLMVPreviewModel" )
	RegisterSignal( "NewHLMVSequence" )
}

void function CreateControllerHud()
{
	if ( file.controllerHudCreated )
		return

	file.controllerHudCreated = true

	file.hudGrpController = HudElementGroup( "Controller" )
	file.controllerBG = file.hudGrpController.CreateElement( "ModelViewerControllerImage" )
	file.hudTriggerLeft = file.hudGrpController.CreateElement( "ModelViewerTriggerLeftLabel" )
	file.hudTriggerRight = file.hudGrpController.CreateElement( "ModelViewerTriggerRightLabel" )
	file.hudShoulderLeft = file.hudGrpController.CreateElement( "ModelViewerShoulderLeftLabel" )
	file.hudShoulderRight = file.hudGrpController.CreateElement( "ModelViewerShoulderRightLabel" )
	file.hudButtonY = file.hudGrpController.CreateElement( "ModelViewerButtonYLabel" )
	file.hudButtonX = file.hudGrpController.CreateElement( "ModelViewerButtonXLabel" )
	file.hudButtonB = file.hudGrpController.CreateElement( "ModelViewerButtonBLabel" )
	file.hudButtonA = file.hudGrpController.CreateElement( "ModelViewerButtonALabel" )
	file.hudStickLeft = file.hudGrpController.CreateElement( "ModelViewerStickLeftLabel" )
	file.hudStickRight = file.hudGrpController.CreateElement( "ModelViewerStickRightLabel" )
	file.hudDPad = file.hudGrpController.CreateElement( "ModelViewerStickDPadLabel" )

	Hud_EnableKeyBindingIcons( file.hudTriggerLeft )
	Hud_EnableKeyBindingIcons( file.hudTriggerRight )
	Hud_EnableKeyBindingIcons( file.hudShoulderLeft )
	Hud_EnableKeyBindingIcons( file.hudShoulderRight )
	Hud_EnableKeyBindingIcons( file.hudButtonY )
	Hud_EnableKeyBindingIcons( file.hudButtonX )
	Hud_EnableKeyBindingIcons( file.hudButtonB )
	Hud_EnableKeyBindingIcons( file.hudButtonA )
	Hud_EnableKeyBindingIcons( file.hudStickLeft )
	Hud_EnableKeyBindingIcons( file.hudStickRight )

	file.hudGrpModelNames = HudElementGroup( "ModelNames" )
	file.hudModelNames = [ file.hudGrpModelNames.CreateElement( "ModelViewerModelName0" ),
							file.hudGrpModelNames.CreateElement( "ModelViewerModelName1" ),
							file.hudGrpModelNames.CreateElement( "ModelViewerModelName2" ),
							file.hudGrpModelNames.CreateElement( "ModelViewerModelName3" ),
							file.hudGrpModelNames.CreateElement( "ModelViewerModelName4" ),
							file.hudGrpModelNames.CreateElement( "ModelViewerModelName5" ),
							file.hudGrpModelNames.CreateElement( "ModelViewerModelName6" ),
							file.hudGrpModelNames.CreateElement( "ModelViewerModelName7" ),
							file.hudGrpModelNames.CreateElement( "ModelViewerModelName8" ),
							file.hudGrpModelNames.CreateElement( "ModelViewerModelName9" ) ]

	file.hudModelNames[ 0 ].SetColor( 255, 255, 128 )


	file.lastEnablematchending = 1
	file.lastEnabletimelimit = 1
}

void function ShowControllerHud()
{
	file.hudGrpController.Show()
	file.hudGrpModelNames.Show()
}

void function HideControllerHud()
{
	file.hudGrpController.Hide()
	file.hudGrpModelNames.Hide()
}

void function RefreshHudLabels()
{
	if ( file.selectedModels.len() == 0 )
	{
		file.hudTriggerLeft.SetText( "" )
		file.hudTriggerRight.SetText( "" )
		file.hudShoulderLeft.SetText( "" )
		file.hudShoulderRight.SetText( "" )
		file.hudButtonY.SetText( "%[Y_BUTTON|]% Next Model" )
		file.hudButtonX.SetText( "Select %[X_BUTTON|]%" )
		file.hudButtonB.SetText( "" )
		file.hudButtonA.SetText( "%[A_BUTTON|]% Toggle noclip" )
		file.hudStickLeft.SetText( "" )
		file.hudStickRight.SetText( "%[STICK2|]% View Snap" )
		file.hudDPad.SetText( "Drop Model" )
	}
	else if ( file.tumbleModeActive )
	{
		file.hudTriggerLeft.SetText( "" )
		file.hudTriggerRight.SetText( "" )
		file.hudShoulderLeft.SetText( "" )
		file.hudShoulderRight.SetText( "" )
		file.hudButtonY.SetText( "%[Y_BUTTON|]% Swap Model" )
		file.hudButtonX.SetText( "" )
		file.hudButtonB.SetText( "%[B_BUTTON|]% Deselect" )
		file.hudButtonA.SetText( "" )
		file.hudStickLeft.SetText( "Tumble/Reset %[STICK1|]%" )
		file.hudStickRight.SetText( "" )
		file.hudDPad.SetText( "" )
	}
	else
	{
		file.hudTriggerLeft.SetText( "Move Down %[L_TRIGGER|]%" )
		file.hudTriggerRight.SetText( "%[R_TRIGGER|]% Move Up" )
		file.hudShoulderLeft.SetText( "Rotate CCW %[L_SHOULDER|]%" )
		file.hudShoulderRight.SetText( "%[R_SHOULDER|]% Rotate CW" )
		if ( file.selectedModels.len() == 1 )
			file.hudButtonY.SetText( "%[Y_BUTTON|]% Swap Model" )
		else
			file.hudButtonY.SetText( "" )
		file.hudButtonX.SetText( "Select %[X_BUTTON|]%" )
		file.hudButtonB.SetText( "%[B_BUTTON|]% Deselect" )
		file.hudButtonA.SetText( "%[A_BUTTON|]% Toggle noclip" )
		file.hudStickLeft.SetText( "Tumble %[STICK1|]%" )
		file.hudStickRight.SetText( "%[STICK2|]% View Snap" )
		file.hudDPad.SetText( "Move X/Y" )
	}
}
#endif // DEV

void function ServerCallback_MVUpdateModelBounds( int index, float minX, float minY, float minZ, float maxX, float maxY, float maxZ )
{
	#if R5DEV
		table<string, vector> tab = { mins = <minX,minY,minZ>, maxs = <maxX,maxY,maxZ> }

		if ( index < file.modelBounds.len() )
		{
			file.modelBounds[ index ] = tab
		}
		else
		{
			while ( index > file.modelBounds.len() )
			{
				file.modelBounds.append( { mins = <32,32,32>, maxs = <32,32,32> } )
			}

			file.modelBounds.append( tab )
		}
	#endif // DEV
}

void function ServerCallback_MVEnable()
{
	#if R5DEV
		if ( !SetModelViewerMode( MODELVIEWERMODE_GAMEPAD ) )
			return

		file.selectedModels.clear()
		file.lastSelectedModel = null

		UpdateMainHudVisibility( GetLocalViewPlayer() )

		CreateControllerHud()
		ShowControllerHud()
		ReloadShared()

		RegisterButtonPressedCallback( BUTTON_DPAD_UP, ControlsDPadUpPressed )
		RegisterButtonPressedCallback( BUTTON_DPAD_DOWN, ControlsDPadDownPressed )
		RegisterButtonPressedCallback( BUTTON_DPAD_LEFT, ControlsDPadLeftPressed )
		RegisterButtonPressedCallback( BUTTON_DPAD_RIGHT, ControlsDPadRightPressed )
		RegisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, ControlsShoulderLeftPressed )
		RegisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, ControlsShoulderRightPressed )
		RegisterButtonPressedCallback( BUTTON_TRIGGER_LEFT, ControlsTriggerLeftPressed )
		RegisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT, ControlsTriggerRightPressed )
		RegisterButtonPressedCallback( BUTTON_X, ControlsButtonXPressed )
		RegisterButtonPressedCallback( BUTTON_Y, ControlsButtonYPressed )
		RegisterButtonPressedCallback( BUTTON_B, ControlsButtonBPressed )
		RegisterButtonPressedCallback( BUTTON_A, ControlsButtonAPressed )
		RegisterButtonPressedCallback( BUTTON_STICK_LEFT, ControlsStickLeftPressed )
		RegisterButtonPressedCallback( BUTTON_STICK_RIGHT, ControlsStickRightPressed )

		RegisterButtonReleasedCallback( BUTTON_DPAD_UP, ControlsDPadUpReleased )
		RegisterButtonReleasedCallback( BUTTON_DPAD_DOWN, ControlsDPadDownReleased )
		RegisterButtonReleasedCallback( BUTTON_DPAD_LEFT, ControlsDPadLeftReleased )
		RegisterButtonReleasedCallback( BUTTON_DPAD_RIGHT, ControlsDPadRightReleased )
		RegisterButtonReleasedCallback( BUTTON_SHOULDER_LEFT, ControlsShoulderLeftReleased )
		RegisterButtonReleasedCallback( BUTTON_SHOULDER_RIGHT, ControlsShoulderRightReleased )
		RegisterButtonReleasedCallback( BUTTON_TRIGGER_LEFT, ControlsTriggerLeftReleased )
		RegisterButtonReleasedCallback( BUTTON_TRIGGER_RIGHT, ControlsTriggerRightReleased )
		RegisterButtonReleasedCallback( BUTTON_X, ControlsButtonXReleased )
		RegisterButtonReleasedCallback( BUTTON_Y, ControlsButtonYReleased )
		RegisterButtonReleasedCallback( BUTTON_B, ControlsButtonBReleased )
		RegisterButtonReleasedCallback( BUTTON_A, ControlsButtonAReleased )
		RegisterButtonReleasedCallback( BUTTON_STICK_LEFT, ControlsStickLeftReleased )
		RegisterButtonReleasedCallback( BUTTON_STICK_RIGHT, ControlsStickRightReleased )

		file.lastEnablematchending = GetConVarInt( "mp_enablematchending" )
		GetLocalClientPlayer().ClientCommand( "mp_enablematchending 0" )
		file.lastEnabletimelimit = GetConVarInt( "mp_enabletimelimit" )
		GetLocalClientPlayer().ClientCommand( "mp_enabletimelimit 0" )

		ModelViewerModeEnabled()
	#endif // DEV
}

void function ServerCallback_MVDisable()
{
	#if R5DEV
		file.modelViewerMode = MODELVIEWERMODE_INACTIVE

		UpdateMainHudVisibility( GetLocalViewPlayer() )

		HideControllerHud()

		DeregisterButtonPressedCallback( BUTTON_DPAD_UP, ControlsDPadUpPressed )
		DeregisterButtonPressedCallback( BUTTON_DPAD_DOWN, ControlsDPadDownPressed )
		DeregisterButtonPressedCallback( BUTTON_DPAD_LEFT, ControlsDPadLeftPressed )
		DeregisterButtonPressedCallback( BUTTON_DPAD_RIGHT, ControlsDPadRightPressed )
		DeregisterButtonPressedCallback( BUTTON_SHOULDER_LEFT, ControlsShoulderLeftPressed )
		DeregisterButtonPressedCallback( BUTTON_SHOULDER_RIGHT, ControlsShoulderRightPressed )
		DeregisterButtonPressedCallback( BUTTON_TRIGGER_LEFT, ControlsTriggerLeftPressed )
		DeregisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT, ControlsTriggerRightPressed )
		DeregisterButtonPressedCallback( BUTTON_X, ControlsButtonXPressed )
		DeregisterButtonPressedCallback( BUTTON_Y, ControlsButtonYPressed )
		DeregisterButtonPressedCallback( BUTTON_B, ControlsButtonBPressed )
		DeregisterButtonPressedCallback( BUTTON_A, ControlsButtonAPressed )
		DeregisterButtonPressedCallback( BUTTON_STICK_LEFT, ControlsStickLeftPressed )
		DeregisterButtonPressedCallback( BUTTON_STICK_RIGHT, ControlsStickRightPressed )

		DeregisterButtonReleasedCallback( BUTTON_DPAD_UP, ControlsDPadUpReleased )
		DeregisterButtonReleasedCallback( BUTTON_DPAD_DOWN, ControlsDPadDownReleased )
		DeregisterButtonReleasedCallback( BUTTON_DPAD_LEFT, ControlsDPadLeftReleased )
		DeregisterButtonReleasedCallback( BUTTON_DPAD_RIGHT, ControlsDPadRightReleased )
		DeregisterButtonReleasedCallback( BUTTON_SHOULDER_LEFT, ControlsShoulderLeftReleased )
		DeregisterButtonReleasedCallback( BUTTON_SHOULDER_RIGHT, ControlsShoulderRightReleased )
		DeregisterButtonReleasedCallback( BUTTON_TRIGGER_LEFT, ControlsTriggerLeftReleased )
		DeregisterButtonReleasedCallback( BUTTON_TRIGGER_RIGHT, ControlsTriggerRightReleased )
		DeregisterButtonReleasedCallback( BUTTON_X, ControlsButtonXReleased )
		DeregisterButtonReleasedCallback( BUTTON_Y, ControlsButtonYReleased )
		DeregisterButtonReleasedCallback( BUTTON_B, ControlsButtonBReleased )
		DeregisterButtonReleasedCallback( BUTTON_A, ControlsButtonAReleased )
		DeregisterButtonReleasedCallback( BUTTON_STICK_LEFT, ControlsStickLeftReleased )
		DeregisterButtonReleasedCallback( BUTTON_STICK_RIGHT, ControlsStickRightReleased )

		delaythread( 0.5 ) RestoreNoclip() // buttons don't seem to always deregister immediately

		GetLocalClientPlayer().ClientCommand( "mp_enablematchending " + file.lastEnablematchending )
		GetLocalClientPlayer().ClientCommand( "mp_enabletimelimit " + file.lastEnabletimelimit )
	#endif // DEV
}

#if R5DEV
void function ReloadShared()
{
	file.modelViewerModels = GetModelViewerList()

	foreach ( index, elem in file.hudModelNames )
	{
		string name = ""
		array<string> modelPath

		if ( index < file.modelViewerModels.len() )
			modelPath = split( file.modelViewerModels[ index ].tostring(), "/." )

		if ( modelPath.len() >= 2 )
			name = modelPath[ modelPath.len() - 2 ]

		elem.SetText( name )
	}

	for ( int i = file.spawnedModels.len() - 1; i >= 0; i-- )
	{
		entity model = file.spawnedModels[ i ]
		if ( file.modelViewerModels.find( model.GetModelName().tolower() ) < 0 )
		{
			file.spawnedModels.remove( i )
			model.Destroy()
		}
	}

	file.modelToDropIndex = 0
	file.hudGrpModelNames.SetColor( 255, 255, 255, 255 )
	file.hudModelNames[0].SetColor( 255, 255, 128 )
}

void function RestoreNoclip()
{
	if ( file.noclipState == 1 )
		GetLocalClientPlayer().ClientCommand( "noclip" )
}

function ControlsDPadUpPressed( player )
{
	file.dpadUpPressed = true
	if ( file.selectedModels.len() <= 0 )
		thread DropModelStartTrace()
	else
		thread TranslateModelUp()
}

function ControlsDPadUpReleased( player )
{
	file.dpadUpPressed = false
}

function ControlsDPadDownPressed( player )
{
	file.dpadDownPressed = true
	if ( file.selectedModels.len() <= 0 )
		thread DropModelStartTrace()
	else
		thread TranslateModelDown()
}

function ControlsDPadDownReleased( player )
{
	file.dpadDownPressed = false

	if ( file.selectedModels.len() <= 0 )
		DropModel()
}

function ControlsDPadLeftPressed( player )
{
	file.dpadLeftPressed = true
	if ( file.selectedModels.len() > 0 )
		thread TranslateModelLeft()
}

function ControlsDPadLeftReleased( player )
{
	file.dpadLeftPressed = false
}

function ControlsDPadRightPressed( player )
{
	file.dpadRightPressed = true
	if ( file.selectedModels.len() > 0 )
		thread TranslateModelRight()
}

function ControlsDPadRightReleased( player )
{
	file.dpadRightPressed = false
}

function ControlsShoulderLeftPressed( player )
{
	file.shoulderLeftPressed = true
	if ( file.selectedModels.len() > 0 )
		thread RotateModelCCW()
}

function ControlsShoulderLeftReleased( player )
{
	file.shoulderLeftPressed = false
}

function ControlsShoulderRightPressed( player )
{
	file.shoulderRightPressed = true
	if ( file.selectedModels.len() > 0 )
		thread RotateModelCW()
}

function ControlsShoulderRightReleased( player )
{
	file.shoulderRightPressed = false
}

function ControlsTriggerLeftPressed( player )
{
	file.triggerLeftPressed = true

	if ( file.selectedModels.len() > 0 )
		thread TranslateModelZDown()
}

function ControlsTriggerLeftReleased( player )
{
	file.triggerLeftPressed = false
}

function ControlsTriggerRightPressed( player )
{
	file.triggerRightPressed = true

	if ( file.selectedModels.len() > 0 )
		thread TranslateModelZUp()
}

function ControlsTriggerRightReleased( player )
{
	file.triggerRightPressed = false
}

function ControlsButtonXPressed( player )
{
	file.buttonXPressed = true

	thread ShowModelSectionBounds()

	thread TrySelectAllModels()
}

function ControlsButtonXReleased( player )
{
	file.buttonXPressed = false
}

function ControlsButtonYPressed( player )
{
	file.buttonYPressed = true

	file.modelToDropIndex++
	if ( file.modelToDropIndex >= file.modelViewerModels.len() )
		file.modelToDropIndex = 0

	file.hudGrpModelNames.SetColor( 255, 255, 255, 255 )
	file.hudModelNames[ file.modelToDropIndex ].SetColor( 255, 255, 128 )

	SwapSelectedModel()
}

function ControlsButtonYReleased( player )
{
	file.buttonYPressed = false
}

function ControlsButtonBPressed( player )
{
	file.buttonBPressed = true

	DeselectModel()
}

function ControlsButtonBReleased( player )
{
	file.buttonYPressed = false
}

function ControlsButtonAPressed( player )
{
	file.buttonAPressed = true

	if ( file.tumbleModeActive )
		return

	player.ClientCommand( "noclip" )

	file.noclipState = file.noclipState == 0 ? 1 : 0
}

function ControlsButtonAReleased( player )
{
	file.buttonAPressed = false
}

function ControlsStickLeftPressed( player )
{
	expect entity( player )

	file.stickLeftPressed = true

	if ( !file.tumbleModeActive && file.selectedModels.len() > 0 )
	{
		file.tumbleModeActive = true
		thread TumbleModel( player )
	}
	else
	{
		file.tumbleModeActive = false
	}
}

function ControlsStickLeftReleased( player )
{
	file.stickLeftPressed = false
}

function ControlsStickRightPressed( player )
{
	file.stickRightPressed = true
	SelectNextModel()
}

function ControlsStickRightReleased( player )
{
	file.stickRightPressed = false
}

void function TumbleModel( entity player )
{
	if ( file.selectedModels.len() <= 0 )
		return

	player.ClientCommand( "ModelViewer freeze_player" )

	RefreshHudLabels()

	foreach ( model in file.selectedModels )
	{
		if ( !( "tumbling" in model.s ) )
			InitModel( model )

		if ( !model.s.tumbling )
		{
			model.s.tumbling = true
			model.s.center = GetModelCenter( model )
			model.s.centerDiff = model.s.center - model.GetOrigin()
			model.s.centerDiffAngles = VectorToAngles( model.s.centerDiff )
			model.s.startOrg = model.GetOrigin()
		}
	}

	while ( file.tumbleModeActive && file.selectedModels.len() > 0 )
	{
		foreach ( model in file.selectedModels )
		{
			float xAxis = InputGetAxis( 0 )
			float yAxis = InputGetAxis( 1 )

			xAxis *= 0.1
			yAxis *= 0.1

			vector angles = model.GetAngles()

			if ( fabs( yAxis ) + fabs( xAxis ) < 0.05 )
			{
				wait( 0.0 )
				continue
			}

			if ( fabs( yAxis ) > fabs( xAxis ) )
				angles = AnglesCompose( angles, <yAxis * 10, 0, 0> )
			else
				angles = AnglesCompose( angles, <0, xAxis * 15, 0> )

			model.SetAngles( angles )

			vector forward = AnglesToForward( AnglesCompose( angles, model.s.centerDiffAngles ) ) * Length( model.s.centerDiff )

			model.SetOrigin( model.s.startOrg + model.s.centerDiff - forward )
		}

		wait( 0.0 )
	}

	if ( file.selectedModels.len() > 0 )
	{
		foreach ( model in file.selectedModels )
		{
			if ( !( "tumbling" in model.s ) )
				continue

			model.SetOrigin( model.s.startOrg )
			model.SetAngles( <0,0,0> )
			model.s.tumbling = false
		}

		RefreshHudLabels()
	}

	player.ClientCommand( "ModelViewer unfreeze_player" )
}

void function DropModelStartTrace()
{
	if ( file.modelViewerModels.len() <= 0 )
		return

	entity player = GetLocalViewPlayer()
	vector playerEyePosition
	vector traceStartPos
	vector traceEndPos

	while ( file.dpadDownPressed )
	{
		playerEyePosition = player.EyePosition()

		traceStartPos = playerEyePosition
		traceEndPos = playerEyePosition + player.GetViewVector() * 16000.0

		file.dropModelTraceResult = TraceLine( traceStartPos, traceEndPos, null, TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )

		DebugDrawCircle( file.dropModelTraceResult.endPos, <0,0,0>, 16.0, 255, 0, 0, true, 0.02 )

		wait( 0.0 )
	}
}

void function DropModel()
{
	if ( file.modelViewerModels.len() <= 0 )
		return

	entity model = CreateClientSidePropDynamic( file.dropModelTraceResult.endPos, <0,0,0>, file.modelViewerModels[ file.modelToDropIndex ] )

	InitModel( model )

	file.spawnedModels.append( model )

	RefreshHudLabels()
}

void function InitModel( entity model )
{
	model.Code_SetTeam( 2 + ( file.spawnedModels.len() % 2 ) )
	model.s.tumbling <- false
	model.s.center <- <0,0,0>
	model.s.centerDiff <- <0,0,0>
	model.s.centerDiffAngles <- <0,0,0>
	model.s.startOrg <- <0,0,0>
}

void function ModelViewerSpawnModel( vector pos, vector ang, int idx )
{
	if ( idx >= file.modelViewerModels.len() )
		return

	file.spawnedModels.append( CreateClientSidePropDynamic( pos, ang, file.modelViewerModels[ idx ] ) )

	RefreshHudLabels()
}

void function DeleteSelectedModels()
{
	if ( file.selectedModels.len() <= 0 )
		return

	foreach ( model in file.selectedModels )
	{
		file.spawnedModels.removebyvalue( model )
		model.Destroy()
		model = null
		file.lastSelectedModel = null
	}
}

void function SelectModel( entity model )
{
	if ( model == null )
		return

	file.lastSelectedModel = file.selectedModels.len() > 0 ? file.selectedModels[ 0 ] : null
	file.selectedModels.clear()
	file.selectedModels.append( model )
	file.tumbleModeActive = false

	RefreshHudLabels()

	file.modelToDropIndex = file.modelViewerModels.find( model.GetModelName().tolower() )

	file.hudGrpModelNames.SetColor( 255, 255, 255, 255 )
	file.hudModelNames[ file.modelToDropIndex ].SetColor( 255, 255, 128 )
}

void function TrySelectAllModels()
{
	float delay = Time() + file.selectAllDelay

	while ( Time() < delay )
	{
		if ( file.buttonXPressed != true )
			return
		wait( 0.0 )
	}

	file.selectedModels.clear()
	file.tumbleModeActive = false

	foreach ( model in file.spawnedModels )
	{
		file.selectedModels.append( model )
	}

	RefreshHudLabels()

	thread ShowModelSectionBounds()
}

void function DeselectModel()
{
	file.lastSelectedModel = file.selectedModels.len() > 0 ? file.selectedModels[ 0 ] : null
	file.selectedModels.clear()

	file.tumbleModeActive = false

	RefreshHudLabels()

	if ( file.modelSelectionBoundsVisible )
		return

	thread ShowModelSectionBounds()
}

void function SwapSelectedModel()
{
	if ( file.selectedModels.len() != 1 )
	{
		printt( "Model Viewer: More than one model is currently selected. Select a single model before trying to swap." )
		return
	}

	asset modelName = file.selectedModels[ 0 ].GetModelName().tolower()
	int currentIndex = file.modelViewerModels.find( modelName )

	int newIndex = currentIndex + 1

	if ( newIndex >= file.modelViewerModels.len() )
		newIndex = 0

	file.selectedModels[ 0 ].SetModel( file.modelViewerModels[ newIndex ] )

	if ( !( "tumbling" in file.selectedModels[ 0 ].s ) )
		InitModel( file.selectedModels[ 0 ] )
	file.selectedModels[ 0 ].s.tumbling = false
}

vector function GetModelCenter( entity model )
{
	int modelIndex = file.modelViewerModels.find( model.GetModelName().tolower() )
	if ( modelIndex < 0 || modelIndex >= file.modelBounds.len() )
		return model.GetOrigin()

	vector mins = file.modelBounds[ modelIndex ].mins
	vector maxs = file.modelBounds[ modelIndex ].maxs

	return model.GetOrigin() + <mins.x + ( ( maxs.x - mins.x ) * 0.5 ), mins.y + ( ( maxs.y - mins.y ) * 0.5 ), mins.z + ( ( maxs.z - mins.z ) * 0.5 )>
}

void function ShowModelSectionBounds()
{
	if ( file.tumbleModeActive )
		return

	entity player = GetLocalViewPlayer()

	file.modelSelectionBoundsHideTime = Time() + file.modelSectionBoundsShowTime
	if ( file.modelSelectionBoundsVisible )
		return

	bool buttonXWasPressed = true
	bool showNewSelectionOnly = false
	file.modelSelectionBoundsVisible = true

	while ( Time() < file.modelSelectionBoundsHideTime )
	{
		float bestDot = -1.0

		file.bestModelToSelect = null

		foreach ( model in file.spawnedModels )
		{
			vector diff = Normalize( GetModelCenter( model ) - player.EyePosition() )

			float dot = diff.Dot( player.GetViewVector() )

			if ( /*dot > 0.95 &&*/ dot > bestDot )
			{
				bestDot = dot
				file.bestModelToSelect = model
			}
		}

		if ( file.buttonXPressed )
		{
			if ( !buttonXWasPressed )
			{
				if ( showNewSelectionOnly )
				{
					file.modelSelectionBoundsHideTime = Time() + file.modelNewSectionBoundsShowTime
					buttonXWasPressed = true
					showNewSelectionOnly = false
				}
				else
				{
					SelectModel( file.bestModelToSelect )

					if ( file.selectedModels.len() > 0 )
					{
						file.modelSelectionBoundsHideTime = Time() + file.modelNewSectionBoundsShowTime
						buttonXWasPressed = true
						showNewSelectionOnly = true
					}
				}
			}
		}
		else
		{
			buttonXWasPressed = false
		}

		foreach ( model in file.spawnedModels )
		{
			vector color = file.colorUnselected

			if ( file.selectedModels.contains( model ) && model == file.bestModelToSelect )
				color = file.colorSelectedHover
			else if ( file.selectedModels.contains( model ) )
				color = file.colorSelected
			else if ( model == file.bestModelToSelect )
				color = file.colorHover

			if ( !showNewSelectionOnly || ( showNewSelectionOnly && file.selectedModels.contains( model ) ) )
			{
				int modelIndex = file.modelViewerModels.find( model.GetModelName().tolower() )
				vector mins = ( modelIndex >= file.modelBounds.len() || modelIndex < 0 ) ? <-32,-32,-32> : file.modelBounds[ modelIndex ].mins
				vector maxs = ( modelIndex >= file.modelBounds.len() || modelIndex < 0 ) ? <32,32,32> : file.modelBounds[ modelIndex ].maxs

				int r = int( color.x )
				int g = int( color.y )
				int b = int( color.z )

				DrawAngledBox( model.GetOrigin(), model.GetAngles(), mins, maxs, r, g, b, true, 0.02 )
			}
		}
		wait( 0.0 )
	}

	file.modelSelectionBoundsVisible = false
}

void function TranslateModelUp()
{
	if ( file.tumbleModeActive )
		return

	entity player = GetLocalViewPlayer()

	while ( file.dpadUpPressed && IsValid( player ) )
	{
		foreach ( model in file.selectedModels )
		{
			if ( IsValid( model ) )
			{
				vector trans = model.GetOrigin() - player.GetOrigin()
				trans.z = 0.0
				trans = Normalize( trans )
				trans *= file.modelTranslateSpeed

				model.SetOrigin( model.GetOrigin() + trans )
			}
		}
		wait( 0.0 )
	}
}

void function TranslateModelDown()
{
	if ( file.tumbleModeActive )
		return

	entity player = GetLocalViewPlayer()

	while ( file.dpadDownPressed && IsValid( player ) )
	{
		foreach ( model in file.selectedModels )
		{
			if ( IsValid( model ) )
			{
				vector trans = model.GetOrigin() - player.GetOrigin()
				trans.z = 0.0
				trans = Normalize( trans )
				trans *= -file.modelTranslateSpeed

				model.SetOrigin( model.GetOrigin() + trans )
			}
		}
		wait( 0.0 )
	}
}

void function TranslateModelLeft()
{
	if ( file.tumbleModeActive )
		return

	entity player = GetLocalViewPlayer()

	while ( file.dpadLeftPressed && IsValid( player ) )
	{
		foreach ( model in file.selectedModels )
		{
			if ( IsValid( model ) )
			{
				vector trans = AnglesToRight( <0,player.CameraAngles().y,0> )
				trans *= -file.modelTranslateSpeed

				model.SetOrigin( model.GetOrigin() + trans )
			}
		}
		wait( 0.0 )
	}
}

void function TranslateModelRight()
{
	if ( file.tumbleModeActive )
		return

	entity player = GetLocalViewPlayer()

	while ( file.dpadRightPressed && IsValid( player ) )
	{
		foreach ( model in file.selectedModels )
		{
			if ( IsValid( model ) )
			{
				vector trans = AnglesToRight( <0,player.CameraAngles().y,0> )
				trans *= file.modelTranslateSpeed

				model.SetOrigin( model.GetOrigin() + trans )
			}
		}
		wait( 0.0 )
	}
}

void function TranslateModelZUp()
{
	if ( file.tumbleModeActive )
		return

	while ( file.triggerRightPressed )
	{
		foreach ( model in file.selectedModels )
		{
			if ( IsValid( model ) )
			{
				vector trans = <0,0,1>
				trans *= file.modelTranslateZSpeed

				model.SetOrigin( model.GetOrigin() + trans )
			}
		}
		wait( 0.0 )
	}
}

void function TranslateModelZDown()
{
	if ( file.tumbleModeActive )
		return

	while ( file.triggerLeftPressed )
	{
		foreach ( model in file.selectedModels )
		{
			if ( IsValid( model ) )
			{
				vector trans = <0,0,-1>
				trans *= file.modelTranslateZSpeed

				model.SetOrigin( model.GetOrigin() + trans )
			}
		}
		wait( 0.0 )
	}
}

void function RotateModelCCW()
{
	if ( file.tumbleModeActive )
		return

	while ( file.shoulderLeftPressed )
	{
		foreach ( model in file.selectedModels )
		{
			if ( IsValid( model ) )
			{
				model.SetAngles( AnglesCompose( model.GetAngles(), <0,file.modelRotateSpeed,0> ) )
			}
		}
		wait( 0.0 )
	}
}

void function RotateModelCW()
{
	if ( file.tumbleModeActive )
		return

	while ( file.shoulderRightPressed )
	{
		foreach ( model in file.selectedModels )
		{
			if ( IsValid( model ) )
			{
				model.SetAngles( AnglesCompose( model.GetAngles(), <0,-file.modelRotateSpeed,0> ) )
			}
		}
		wait( 0.0 )
	}
}

table<string, vector> function GetBounds( entity model )
{
	table<string, vector> bounds = { mins = <0,0,0>, maxs = <0,0,0> }

	int modelIndex = file.modelViewerModels.find( model.GetModelName().tolower() )
	if ( modelIndex >= 0 )
	{
		bounds.mins = file.modelBounds[ modelIndex ].mins
		bounds.maxs = file.modelBounds[ modelIndex ].maxs
	}

	return bounds
}

void function DropModelsToGround()
{
	if ( file.selectedModels.len() <= 0 )
		return

	foreach ( model in file.selectedModels )
	{
		table<string, vector> bounds = GetBounds( model )

		vector traceOrg = model.GetOrigin() + <0,0,bounds.mins.z>
		vector traceEndPos = traceOrg + <0,0,-16000>

		TraceResults trace = TraceLine( traceOrg, traceEndPos, null, TRACE_MASK_BLOCKLOS, TRACE_COLLISION_GROUP_NONE )

		if ( trace.fraction < 1.0 )
		{
			model.SetOrigin( trace.endPos - <0,0,bounds.mins.z> )
		}
	}
}

int function GetFocusedModelIndex()
{
	int lastSelectedIndex = file.spawnedModels.len() - 1

	if ( file.selectedModels.len() > 0 )
	{
		lastSelectedIndex = file.spawnedModels.find( file.selectedModels[ 0 ] )
	}
	else if ( file.lastSelectedModel != null )
	{
		lastSelectedIndex = file.spawnedModels.find( file.lastSelectedModel )
	}

	return lastSelectedIndex
}

void function SelectNextModel()
{
	if ( file.spawnedModels.len() <= 0 )
		return

	int startIndex = GetFocusedModelIndex()

	int nextIndex = startIndex + 1

	if ( nextIndex >= file.spawnedModels.len() )
		nextIndex = 0

	SelectModel( file.spawnedModels[ nextIndex ] )
	//thread ShowModelSectionBounds()

	SnapViewToModel( file.selectedModels[ 0 ] )
}

void function SelectPreviousModel()
{
	if ( file.spawnedModels.len() <= 0 )
		return

	int startIndex = GetFocusedModelIndex()

	int previousIndex = startIndex - 1

	if ( previousIndex < 0 )
		previousIndex = file.spawnedModels.len() - 1

	SelectModel( file.spawnedModels[ previousIndex ] )
	//thread ShowModelSectionBounds()

	SnapViewToModel( file.selectedModels[ 0 ] )
}

void function SnapViewToModel( entity model )
{
	vector modelOrg = model.GetOrigin()
	vector modelCenter = GetModelCenter( model )
	table<string, vector> modelBounds = GetBounds( model )
	float modelBiggestDimension = max( max( modelBounds.maxs.x - modelBounds.mins.x, modelBounds.maxs.y - modelBounds.mins.y ), modelBounds.maxs.z - modelBounds.mins.z )

	float modelViewDist = modelBiggestDimension * 1.3
	float diagFac = 0.707107

	array<vector> viewOffsets
	viewOffsets.append( <modelViewDist, 0, 0> )
	viewOffsets.append( <-modelViewDist, 0, 0> )
	viewOffsets.append( <0, modelViewDist, 0> )
	viewOffsets.append( <0, -modelViewDist, 0> )
	viewOffsets.append( <modelViewDist * diagFac, modelViewDist * diagFac, 0> )
	viewOffsets.append( <-modelViewDist * diagFac, -modelViewDist * diagFac, 0> )
	viewOffsets.append( <modelViewDist * diagFac, -modelViewDist * diagFac, 0> )
	viewOffsets.append( <-modelViewDist * diagFac, modelViewDist * diagFac, 0> )

	vector playerPos = modelOrg + viewOffsets[0]
	vector viewAng = <0,0,0>
	vector playerEyePos = <0,0,0>
	entity player = GetLocalClientPlayer()
	array<float> scores
	scores.resize( viewOffsets.len() )

	foreach ( i, offset in viewOffsets )
	{
		playerPos = modelOrg + viewOffsets[i]
		playerEyePos = playerPos + <0,0,60>

		// position down to ground
		TraceResults trace = TraceLineHighDetail( playerPos, playerPos - <0,0,256>, player, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
		scores[i] = ( 1 - trace.fraction ) * 2.0

		// eye to model origin
		trace = TraceLineHighDetail( playerEyePos, modelOrg + <0,0,16>, player, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
		if ( trace.fractionLeftSolid != 1 )
			scores[i] += 0.25
		if ( trace.startSolid != true )
			scores[i] += 0.25
		if ( trace.allSolid != true )
			scores[i] += 0.25
		scores[i] += trace.fraction * 0.25

		// eye to model center
		trace = TraceLineHighDetail( playerEyePos, modelCenter, player, TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_NONE )
		if ( trace.fractionLeftSolid != 1 )
			scores[i] += 0.25
		if ( trace.startSolid != true )
			scores[i] += 0.25
		if ( trace.allSolid != true )
			scores[i] += 0.25
		scores[i] += trace.fraction * 0.25
	}

	float topScore = 0
	int topIndex = 0

	foreach ( i, score in scores )
	{
		if ( score > topScore )
		{
			topScore = score
			topIndex = i
		}
	}

	playerPos = modelOrg + viewOffsets[ topIndex ]
	playerEyePos = playerPos + <0,0,60>
	viewAng = VectorToAngles( modelCenter - playerEyePos )

	player.ClientCommand( "setpos " + playerPos.x + " " + playerPos.y + " " + playerPos.z )
	player.ClientCommand( "setang " + viewAng.x + " " + viewAng.y + " " + viewAng.z )
}

string function ReplaceStringCharacter( string msg, string findChar, string replaceChar )
{
	array<string> tokens = split( msg, findChar )
	if ( tokens.len() == 0 )
		return msg

	string newString = tokens[0]
	for ( int i = 1; i < tokens.len(); i++ )
	{
		newString += replaceChar
		newString += tokens[i]
	}

	return newString
}

void function ClientCodeCallback_HLMV_ModelChanged( asset modelName )
{
	thread ClientCodeCallback_HLMV_ModelChanged_Thread( modelName )
}

bool function SetModelViewerMode( string mode )
{
	if ( file.modelViewerMode == mode )
		return true

	if ( file.modelViewerMode != MODELVIEWERMODE_INACTIVE )
	{
		AnnouncementData announcement = Announcement_Create( "CANT SET MODEL VIEWER MODE" )
		string subText = "Mode already set: " + file.modelViewerMode
		Announcement_SetSubText( announcement, subText )
		Announcement_SetPurge( announcement, true )
		Announcement_SetSoundAlias( announcement, "UI_InGame_CoOp_SentryGunAvailable" )
		AnnouncementFromClass( GetLocalViewPlayer(), announcement )
		return false
	}

	file.modelViewerMode = mode
	return true
}

void function ClientCodeCallback_LevelEd_SetPosition( string script_name, vector origin, vector angles )
{
	thread ClientCodeCallback_LevelEd_SetPositionThread( script_name, origin, angles )
}

void function ClientCodeCallback_LevelEd_SetPositionThread( string script_name, vector origin, vector angles )
{
	printt( "LEVELED Set Position: " + script_name + " " + origin )
	if ( !SetModelViewerMode( MODELVIEWERMODE_LEVELED ) )
		return

	wait 0.05 // let set model callbacks run first

	file.leveled_positionReceived = true
	file.leveled_origin = origin
	file.leveled_angles = angles

	if ( script_name != "model_viewer" )
	{
		// try to find the ent in the level
		array<entity> ents = GetEntArrayByScriptName( script_name )
		if ( ents.len() == 1 )
		{
			entity ent = ents[0]
			ent.SetOrigin( origin )
			ent.SetAngles( angles )
			return
		}
	}

	if ( file.hlmv_lastModel != $"" )
	{
		HlmvModelData data = file.hlmv_modelData[ file.hlmv_lastModel ]
		if ( IsValid( data.parentEnt ) )
		{
			data.parentEnt.SetOrigin( origin )
			data.parentEnt.SetAngles( angles )
			data.model.SetOrigin( origin )
			data.model.SetAngles( angles )
			thread ClientCodeCallback_HLMV_SequenceChanged_Thread( data )
		}
	}
}

bool function IsModelViewerActive()
{
	return file.modelViewerMode != MODELVIEWERMODE_INACTIVE
}

void function ClientCodeCallback_HLMV_ModelChanged_Thread( asset modelName )
{
	if ( !IsModelViewerActive() )
		return

	printl( "HLMV CALLBACK model: " + modelName )
	file.hlmv_lastModel = modelName

	HlmvModelData data
	if ( !( modelName in file.hlmv_modelData ) )
	{
		file.hlmv_modelData[ modelName ] <- data
		data.precaching = true

		// add the model to the model list
		DisablePrecacheErrors()
		wait 0.25

		data.model = CreateClientSidePropDynamic( <0,0,0>, <0,0,0>, modelName )
		data.parentEnt = CreateClientSidePropDynamic( <0,0,0>, <0,0,0>, $"mdl/dev/empty_model.rmdl" )
		data.precaching = false
	}

	data = file.hlmv_modelData[ modelName ]
	if ( data.precaching )
		return

	Assert( IsValid( data.model ) )

	if ( data.sequence != "" )
	{
		thread ClientCodeCallback_HLMV_SequenceChanged_Thread( data )
	}

	if ( file.leveled_positionReceived )
	{
		//data.model.SetParent( data.parentEnt, "", false, 0 )
		data.model.SetOrigin( file.leveled_origin )
		data.model.SetAngles( file.leveled_angles )
		data.parentEnt.SetOrigin( file.leveled_origin )
		data.parentEnt.SetAngles( file.leveled_angles )
	}
	else
	{
		thread DisplayPreviewModelAtCursor( data )
	}
}

void function HLMV_ToggleMoveInPlace()
{
	file.hlmv_moveInPlace = !file.hlmv_moveInPlace
	printt( "Toggled Move In Place, is now " + file.hlmv_moveInPlace )

	if ( file.hlmv_lastModel == $"" )
		return

	HlmvModelData data = file.hlmv_modelData[ file.hlmv_lastModel ]
	if ( file.hlmv_moveInPlace )
	{
		data.model.SetParent( data.parentEnt, "", false, 0 )
	}
	else
	{
		data.model.ClearParent()
	}
}

void function DisplayPreviewModelAtCursor( HlmvModelData data )
{
	entity model = data.model
	Signal( model, "NewHLMVPreviewModel" )
	EndSignal( model, "NewHLMVPreviewModel" )

	float endTime = Time() + 2.5

	model.SetParent( data.parentEnt, "", false, 0 )

	OnThreadEnd(
	function() : ( model )
		{
			if ( IsValid( model ) && file.hlmv_moveInPlace )
			{
				model.ClearParent()
			}
		}
	)

	for ( ;; )
	{
		vector origin = GetFreecamPos()
		vector angles = GetFreecamAngles()
		vector forward = AnglesToForward( angles )
		vector end = origin + forward * 5000
		TraceResults result = TraceLine( origin, end, null, TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )

		vector previewAngles = GetFreecamAngles()
		previewAngles.x = 0
		previewAngles.z = 0
		//previewAngles = AnglesCompose( previewAngles, <0,180,0> )

		vector dest = ClampToMap( result.endPos )
		data.parentEnt.SetOrigin( dest )
		data.parentEnt.SetAngles( previewAngles )

		if ( Time() > endTime )
			break

		wait 0
	}
}

void function ClientCodeCallback_HLMV_SequenceChanged( string sequence )
{
	if ( !IsModelViewerActive() )
		return

	printl( "HLMV CALLBACK sequence: " + sequence )

	// no model set
	if ( file.hlmv_lastModel == $"" )
		return

	// cant actually play this one
	if ( sequence == "ref" )
		return

	if ( !( file.hlmv_lastModel in file.hlmv_modelData ) )
		return

	HlmvModelData data = file.hlmv_modelData[ file.hlmv_lastModel ]
	if ( data.precaching )
	{
		data.sequence = sequence
		return
	}

	if ( !data.model.Anim_HasSequence( sequence ) )
		return

	data.sequence = sequence

	thread ClientCodeCallback_HLMV_SequenceChanged_Thread( data )
}

void function ClientCodeCallback_HLMV_SequenceChanged_Thread( HlmvModelData data )
{
	entity model = data.model
	string sequence = data.sequence

	if ( !model.Anim_HasSequence( data.sequence ) )
		return

	Signal( model, "NewHLMVSequence" )
	EndSignal( model, "NewHLMVSequence" )

	vector origin = model.GetOrigin()
	vector angles = model.GetAngles()

	// can't animate
	if ( model.LookupAttachment( "ref" ) == 0 )
	{
		Warning( "Can't animate without ref attachment: " + model.GetModelName() )
		return
	}

	//var animStartPos = model.Anim_GetStartForRefPoint_Old( sequence, <0,0,0>, <0,0,0> )
	thread MapLimitsProtect( model )

	for ( ;; )
	{
		switch ( file.modelViewerMode )
		{
			case MODELVIEWERMODE_LEVELED:
				model.Anim_PlayWithRefPoint( sequence, origin, angles, 0 )
				break

			case MODELVIEWERMODE_GAMEPAD:
				model.Anim_Play( sequence )
				break

			default:
				return
		}

		model.Anim_SetPlaybackRate( file.hlmv_speedScale )
		if ( file.hlmv_cycle != -1.0 )
		{
			model.SetCycle( file.hlmv_cycle )
			model.Anim_SetPaused( true )
		}
		else
		{
			model.Anim_SetPaused( false )
		}
		WaittillAnimDone( model )

		wait 0.85
	}
}


void function ClientCodeCallback_HLMV_SetSpeedScale( float speedScale )
{
	file.hlmv_speedScale = speedScale
	file.hlmv_cycle = -1.0

	if ( file.hlmv_lastModel == $"" )
		return

	HlmvModelData data = file.hlmv_modelData[ file.hlmv_lastModel ]
	if ( IsValid( data.model ) )
	{
		data.model.Anim_SetPlaybackRate( speedScale )
		data.model.Anim_SetPaused( false )
	}
}

void function ClientCodeCallback_HLMV_SetCycle( float cycle )
{
	file.hlmv_speedScale = 0.0
	file.hlmv_cycle = cycle

	if ( file.hlmv_lastModel == $"" )
		return

	HlmvModelData data = file.hlmv_modelData[ file.hlmv_lastModel ]
	if ( IsValid( data.model ) )
	{
		data.model.Anim_SetPlaybackRate( 0.0 )
		data.model.Anim_SetPaused( true )
		data.model.SetCycle( cycle )
	}
}

void function MapLimitsProtect( entity model )
{
	model.EndSignal( "OnDestroy" )
	for ( ;; )
	{
		if ( ClampToMap( model.GetOrigin() ) != model.GetOrigin() )
		{
			model.Anim_Stop()
		}

		wait 0
	}
}

void function ClientCodeCallback_LevelEd_ClearPreviewEntity()
{
	table<asset,HlmvModelData> hlmv_modelData
	foreach ( modelData in file.hlmv_modelData )
	{
		if ( IsValid( modelData.model ) )
			modelData.model.Destroy()
	}

	file.hlmv_modelData = {}
	file.hlmv_lastModel = $""
}
#endif // DEV
