global function ShApexScreens_Init

#if SERVER
global function SvApexScreens_ShowCircleState
global function SvApexScreens_ForceShowSquad
global function SvApexScreens_HighlightPlayerForImpressiveKill
global function SvApexScreens_HighlightPlayerForKillSpree
#endif

#if SERVER && R5DEV
global function DEV_ApexScreens_SetMode
global function DEV_ApexScreens_TogglePreviewMode
global function DEV_ApexScreens_GladCardPreviewMode
global function ApexScreenMasterThink
#endif

#if CLIENT
global function ClApexScreens_DisableAllScreens
global function ClApexScreens_EnableAllScreens
global function ClApexScreens_IsDisabled
global function ServerToClient_ApexScreenKillDataChanged
global function ServerToClient_ApexScreenRefreshAll
//global function ClApexScreens_Lobby_SetMode
//global function ClApexScreens_Lobby_SetCardOwner
global function ClApexScreens_OnStaticPropRuiVisibilityChange
#endif

#if CLIENT && R5DEV
global function DEV_CreatePerfectApexScreen
global function DEV_ToggleActiveApexScreenDebug
global function DEV_ToggleFloatyBitsPrototype
#endif

#if CLIENT
const bool HAS_FLOATING_BITS_PROTOTYPE = false
#endif // CLIENT

const float APEX_SCREEN_TRANSITION_IN_DURATION = 0.7 // must stay in sync with apex_screens.rui

const float APEX_SCREEN_RANDOM_TINT_INTENSITY_MIN = 0.4
const float APEX_SCREEN_RANDOM_TINT_INTENSITY_MAX = 0.6
const vector[3] APEX_SCREEN_RANDOM_TINT_PALETTE = [
			<1.0, 1.0, 1.0> - <0.85, 0.87, 0.88>,
			<1.0, 1.0, 1.0> - <0.80, 0.95, 1.00>,
			<1.0, 1.0, 1.0> - <0.98, 1.00, 1.00>,
]


// "Apex Screen" = really big flex screen (not an entity)
// "Apex Screen state" = what's showing on a particular screen, in particular "mode index" where mode means "show logo", "show blisk's face", "show a gladiator card", etc


global enum eApexScreenPosition
{
	// must match APEX_SCREEN_POSITION_* in apex_screens.rui
	L = 0,
	C = 1,
	R = 2,
	_COUNT_BANNERTYPES,

	TV_LIKE = 3,

	DISABLED = -1,
}

global enum eApexScreenMode
{
	// must match APEX_SCREEN_MODE_* in apex_screens.rui
	OFF                     = 0,
	LOGO                    = 1,
	PLAYER_NAME_CHAMPION    = 2,
	PLAYER_NAME_KILLLEADER  = 3,
	GCARD_FRONT_CLEAN       = 4,
	GCARD_FRONT_DETAILS     = 5,
	GCARD_BACK              = 6,
	UNUSED                  = 7,
	CIRCLE_STATE            = 8,
	PLAYERS_REMAINING       = 9,
	SQUADS_REMAINING        = 10,
	ZONE_NAME               = 11,
	ZONE_LOOT               = 12,
	CAMERA_VIEW             = 13,

	_COUNT,
	INVALID = -1,
}

global enum eApexScreenTransitionStyle
{
	// must match APEX_SCREEN_TRANSITION_STYLE_* in apex_screens.rui
	NONE           = 0,
	SLIDE          = 1,
	FADE_TO_BLACK  = 2,
}


global enum eApexScreenMods
{
	RED = (1 << 0),
}


#if CLIENT
struct ScreenOverrideInfo
{
	asset  ruiAsset
	string scriptNameRequired = ""
	bool   skipStandardVars

	//
	bool bindStartTimeVarToEventTimeA
	bool bindStartTimeVarToEventTimeB

	struct
	{
		table<string, int>    ints
		table<string, float>  floats
		table<string, bool>   bools
		table<string, asset>  images
		table<string, string> strings
		table<string, vector> float3s
		table<string, float>  gametimes
	} vars
}
table<string, ScreenOverrideInfo> s_screenOverrides

struct ApexScreenState
{
	var    rui
	int    magicId
	string mockup
	asset  ruiToCreate
	asset  ruiToCreateOrig
	asset  ruiLastCreated

	bool                overrideInfoIsValid = false
	ScreenOverrideInfo& overrideInfo

	vector uvMin = <0.0, 0.0, 0.0>
	vector uvMax = <1.0, 1.0, 0.0>
	bool   sharesPropWithEnvironmentalRUI = false

	bool  visibleInPVS = false
	bool  isOutsideCircle = false
	float commenceTime

	int    position = -1
	vector spawnOrigin
	vector spawnForward
	vector spawnRight
	vector spawnUp
	float  spawnScale
	vector spawnMins
	vector spawnMaxs
	float  diagonalSize
	int    modBits = 0x00000000

	float                      currDistToSizeRatio = -1.0
	NestedGladiatorCardHandle& nestedGladiatorCard0Handle

	vector tint

	var    floatingTopo  = null
	var    floatingRui   = null
	var[3] floatingNestedBadgeRuiList = [null, null, null]
}
#endif


#if CLIENT
struct ApexScreenPositionMasterState
{
	float commenceTime = -1
	int   modeIndex = eApexScreenMode.LOGO
	int   transitionStyle = -1
	EHI   playerEHI
}
#endif


#if SERVER
struct ApexScreenJob
{
	int mode = eApexScreenMode.INVALID
}
#endif


struct {
	#if SERVER && R5DEV
		bool DEV_inDebugPreviewMode = false
	#endif

	#if CLIENT
		ApexScreenPositionMasterState[eApexScreenPosition._COUNT_BANNERTYPES] screenPositionMasterStates

		bool                        forceDisableScreens = false
		array<ApexScreenState>      staticScreenList
		bool                        allScreenUpdateQueued              = false
		table<int, ApexScreenState> magicIdScreenStateMap
		table<int, array<var> >     environmentalRUIListMapByMagicId
		int                         killScreenDamageSourceID           = -1
		float                       killScreenDistance
		int                         killedPlayerGrade
		string                      killedPlayerName
		table                       signalDummy

		bool DEV_activeScreenDebug                                     = false
		bool DEV_isFloatyBitsPrototypeEnabled                          = false
	#endif
} file


#if SERVER || CLIENT
const string NV_ApexScreensEventTimeA = "NV_ApexScreensEventTimeA"
const string NV_ApexScreensEventTimeB = "NV_ApexScreensEventTimeB"
void function ShApexScreens_Init()
{
	#if SERVER
	#elseif CLIENT
		AddCallback_OnEnumStaticPropRui( OnEnumStaticPropRui )
	#endif

	if ( !GetCurrentPlaylistVarBool( "enable_apex_screens", true ) )
		return

	Remote_RegisterClientFunction( "ServerToClient_ApexScreenKillDataChanged", "int", 0, 512, "float", 0.0, 10000.0, 32, "int", 0, 32, "entity" )
	Remote_RegisterClientFunction( "ServerToClient_ApexScreenRefreshAll" )

	for ( int screenPosition = eApexScreenPosition.L; screenPosition <= eApexScreenPosition.R; screenPosition++ )
	{
		RegisterNetworkedVariable( format( "ApexScreensMasterState_Pos%d_CommenceTime", screenPosition ), SNDC_GLOBAL, SNVT_TIME, -1 )
		RegisterNetworkedVariable( format( "ApexScreensMasterState_Pos%d_ModeIndex", screenPosition ), SNDC_GLOBAL, SNVT_INT, -1 )
		RegisterNetworkedVariable( format( "ApexScreensMasterState_Pos%d_TransitionStyle", screenPosition ), SNDC_GLOBAL, SNVT_INT, -1 )
		RegisterNetworkedVariable( format( "ApexScreensMasterState_Pos%d_Player", screenPosition ), SNDC_GLOBAL, SNVT_BIG_INT, -1 )

		#if CLIENT
			RegisterNetworkedVariableChangeCallback_time( format( "ApexScreensMasterState_Pos%d_CommenceTime", screenPosition ), void function( entity unused, float old, float new, bool ac ) : (screenPosition) {
				file.screenPositionMasterStates[screenPosition].commenceTime = new
				UpdateAllScreensContent()
			} )
			RegisterNetworkedVariableChangeCallback_int( format( "ApexScreensMasterState_Pos%d_ModeIndex", screenPosition ), void function( entity unused, int old, int new, bool ac ) : (screenPosition) {
				file.screenPositionMasterStates[screenPosition].modeIndex = new
				UpdateAllScreensContent()
			} )
			RegisterNetworkedVariableChangeCallback_int( format( "ApexScreensMasterState_Pos%d_TransitionStyle", screenPosition ), void function( entity unused, int old, int new, bool ac ) : (screenPosition) {
				file.screenPositionMasterStates[screenPosition].transitionStyle = new
				UpdateAllScreensContent()
			} )
			RegisterNetworkedVariableChangeCallback_int( format( "ApexScreensMasterState_Pos%d_Player", screenPosition ), void function( entity unused, int old, int new, bool ac ) : (screenPosition) {
				file.screenPositionMasterStates[screenPosition].playerEHI = new
				UpdateAllScreensContent()
			} )
		#endif
	}
	RegisterNetworkedVariable( NV_ApexScreensEventTimeA, SNDC_GLOBAL, SNVT_TIME, -1 )
	#if CLIENT
		RegisterNetworkedVariableChangeCallback_time( NV_ApexScreensEventTimeA, void function( entity unused, float oldTime, float newTime, bool actuallyChanged )
		{
			if ( !actuallyChanged )
				return
			OnUpdateApexScreensEventTime( newTime )
		} )
	#endif //
	RegisterNetworkedVariable( NV_ApexScreensEventTimeB, SNDC_GLOBAL, SNVT_TIME, -1 )
	#if SERVER
		RegisterSignal( "ApexScreenMasterThink" )

		AddCallback_GameStatePostEnter( eGameState.PickLoadout, OnGameStatePostEnter_PickLoadout )
		AddCallback_GameStatePostEnter( eGameState.Prematch, OnGameStatePostEnter_Prematch )

		AddCallback_EntitiesDidLoad( EntitiesDidLoadSv )
	#elseif CLIENT
		RegisterSignal( "UpdateScreenCards" )
		RegisterSignal( "ScreenOff" )

		AddCallback_OnStaticPropRUICreated( ClientStaticPropRUICreated )

		SetupScreenOverrides()
	#endif

	//AddCallback_OnSurvivalDeathFieldStageChanged( OnSurvivalDeathFieldStageChanged )
}
#endif


#if CLIENT
asset function CastStringToAsset( string val )
{
	return GetKeyValueAsAsset( { kn = val }, "kn" )
}

asset function GetCurrentPlaylistVarAsset( string varName, asset defaultAsset = $"" )
{
	string assetRaw = GetCurrentPlaylistVarString( varName, "" )
	if ( assetRaw.len() == 0 )
		return defaultAsset

	return CastStringToAsset( assetRaw )
}

vector function CastStringToFloat3( string val )
{
	array<string> fields = split( val, ", " )
	float xx             = ((fields.len() > 0) ? float( fields[0] ) : 0.0)
	float yy             = ((fields.len() > 1) ? float( fields[1] ) : 0.0)
	float zz             = ((fields.len() > 2) ? float( fields[2] ) : 0.0)
	return <xx, yy, zz>
}

void function SetupScreenOverrides()
{
	for ( int overrideIdx = 0; overrideIdx < 5; ++overrideIdx )
	{
		//
		string keyName = format( "apexscreen_tv_override_%d", overrideIdx )
		if ( !GetCurrentPlaylistVarBool( keyName, false ) )
			continue

		ScreenOverrideInfo newInfo
		newInfo.scriptNameRequired = GetCurrentPlaylistVarString( format( "%s_scriptname", keyName ), "" )
		newInfo.ruiAsset = CastStringToAsset( GetCurrentPlaylistVarString( format( "%s_rui", keyName ), "" ) )
		newInfo.skipStandardVars = GetCurrentPlaylistVarBool( format( "%s_skip_standard_vars", keyName ), false )
		newInfo.bindStartTimeVarToEventTimeA = GetCurrentPlaylistVarBool( format( "%s_bind_startTime_var_to_event_a", keyName ), false )
		newInfo.bindStartTimeVarToEventTimeB = GetCurrentPlaylistVarBool( format( "%s_bind_startTime_var_to_event_b", keyName ), false )

		for ( int varIdx = 0; varIdx < 10; ++varIdx )
		{
			string varPlaylistKey = format( "%s_var%d", keyName, varIdx )
			string val            = GetCurrentPlaylistVarString( varPlaylistKey, "" )
			if ( val.len() == 0 )
				continue

			array<string> splitVals = split( val, "~" )
			Assert( (splitVals.len() == 3), format( "Key '%s' with val '%s' only has %d/3 fields.", varPlaylistKey, val, splitVals.len() ) )
			switch( splitVals[0] )
			{
				case "int":
					newInfo.vars.ints[splitVals[1]] <- int( splitVals[2] )
					break

				case "float":
					newInfo.vars.floats[splitVals[1]] <- float( splitVals[2] )
					break

				case "bool":
					newInfo.vars.bools[splitVals[1]] <- ((int( splitVals[2] ) != 0) || (splitVals[2] == "true"))
					break

				case "string":
					newInfo.vars.strings[splitVals[1]] <- splitVals[2]
					break

				case "image":
					newInfo.vars.images[splitVals[1]] <- CastStringToAsset( splitVals[2] )
					break

				case "float3":
					newInfo.vars.float3s[splitVals[1]] <- CastStringToFloat3( splitVals[2] )
					break

				default:
					Assert( false, format( "Unhandled field type '%s'.", splitVals[0] ) )
					break
			}
		}

		s_screenOverrides[newInfo.scriptNameRequired] <- newInfo
	}
}
#endif //

////
////
//// Server-side screen scheduler
////
////

#if SERVER
void function SvApexScreens_ForceShowSquad( EncodedEHandle ply0, EncodedEHandle ply1, EncodedEHandle ply2 )
{
	#if R5DEV
		if ( file.DEV_inDebugPreviewMode )
			return
	#endif

	ShowModeInternal( eApexScreenPosition.L, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.GCARD_FRONT_DETAILS, ply0 )
	ShowModeInternal( eApexScreenPosition.C, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.GCARD_FRONT_DETAILS, ply1 )
	ShowModeInternal( eApexScreenPosition.R, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.GCARD_FRONT_DETAILS, ply2 )
	thread ApexScreenMasterThink()
}
#endif


#if SERVER
void function SvApexScreens_ShowCircleState()
{
	#if R5DEV
		if ( file.DEV_inDebugPreviewMode )
			return
	#endif
	// todo(dw): re-enable
	//ShowModeInternal( eApexScreenPosition.L, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.CIRCLE_STATE, null )
	//ShowModeInternal( eApexScreenPosition.C, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.CIRCLE_STATE, null )
	//ShowModeInternal( eApexScreenPosition.R, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.CIRCLE_STATE, null )
	//thread ApexScreenMasterThink()
}
#endif


#if SERVER
void function SvApexScreens_HighlightPlayerForImpressiveKill( entity player, int damageSourceID, float distanceBetweenPlayers, int killedPlayerGrade, entity killedPlayer )
{
	#if R5DEV
		if ( file.DEV_inDebugPreviewMode )
			return
	#endif
	foreach ( entity playerToInform in GetPlayerArray() )
		Remote_CallFunction_Replay( playerToInform, "ServerToClient_ApexScreenKillDataChanged", damageSourceID, distanceBetweenPlayers, killedPlayerGrade, killedPlayer )

	// todo(dw): re-enable
	//ShowModeInternal( eApexScreenPosition.L, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.LOGO, null )
	//ShowModeInternal( eApexScreenPosition.C, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.GCARD_FRONT_DETAILS, null )
	//ShowModeInternal( eApexScreenPosition.R, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.LOGO, null )
	//thread ApexScreenMasterThink()
}
#endif


#if SERVER
void function SvApexScreens_HighlightPlayerForKillSpree()
{
	#if R5DEV
		if ( file.DEV_inDebugPreviewMode )
			return
	#endif
	// todo(dw)
}
#endif


#if SERVER
void function ShowModeInternal( int screenPosition, int transitionStyle, int mode, EncodedEHandle playerEEH )
{
	if ( !GetCurrentPlaylistVarBool( "enable_apex_screens", true ) )
		return

	SetGlobalNetTime( format( "ApexScreensMasterState_Pos%d_CommenceTime", screenPosition ), Time() )
	SetGlobalNetInt( format( "ApexScreensMasterState_Pos%d_ModeIndex", screenPosition ), mode )
	SetGlobalNetInt( format( "ApexScreensMasterState_Pos%d_TransitionStyle", screenPosition ), transitionStyle )
	SetGlobalNetInt( format( "ApexScreensMasterState_Pos%d_Player", screenPosition ), playerEEH ) // todo(dw)
}
#endif


#if SERVER
void function EntitiesDidLoadSv()
{
	if ( IsLobby() )
		return

	foreach ( entity targetInfo in GetEntArrayByScriptName( "apex_screen" ) )
	{
		// (dw): These are not needed now but may be in the future. Either way, we should destroy them after load to
		// save on edicts.
		targetInfo.Destroy()
	}

	thread ApexScreenMasterThink()
}
#endif


#if SERVER
void function OnGameStatePostEnter_PickLoadout()
{
	thread ApexScreenMasterThink()
}
#endif


#if SERVER
void function OnGameStatePostEnter_Prematch()
{
	thread ApexScreenMasterThink()
}
#endif


#if SERVER
void function HaltApexScreenMasterThink()
{
	svGlobal.levelEnt.Signal( "ApexScreenMasterThink" )
}
void function ApexScreenMasterThink()
{
	// todo(dw): this kind of think function with arbitrary waits is temp

	HaltApexScreenMasterThink()
	svGlobal.levelEnt.EndSignal( "ApexScreenMasterThink" )

	if ( !GetCurrentPlaylistVarBool( "enable_apex_screens", true ) )
		return

	#if R5DEV
		if ( file.DEV_inDebugPreviewMode )
			return
	#endif

	Assert( !IsLobby() )

	table<ItemFlavor, bool> previousChosenCharacterSet

	if ( GetGameState() != eGameState.WaitingForPlayers )
		wait 21.0 // let whatever screen is on there play

	while ( true )
	{
		switch ( GetGameState() )
		{
			case eGameState.WaitingForPlayers:
			{
				ShowModeInternal( eApexScreenPosition.L, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.LOGO, EncodedEHandle_null )
				ShowModeInternal( eApexScreenPosition.C, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.LOGO, EncodedEHandle_null )
				ShowModeInternal( eApexScreenPosition.R, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.LOGO, EncodedEHandle_null )
				wait 2.5

				array<entity> allPlayers = GetPlayerArray()
				if ( allPlayers.len() == 0 )
					continue
				LoadoutEntry characterSlot = Loadout_CharacterClass()

				array<EncodedEHandle> randomPlayerOrNullList
				table<ItemFlavor, bool> chosenCharacterSet
				for ( int tries = 0; randomPlayerOrNullList.len() < 3 && tries < 200; tries++ )
				{
					entity candidate = allPlayers.getrandom()

					if ( LoadoutSlot_IsReady( ToEHI( candidate ), characterSlot ) )
					{
						ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( candidate ), characterSlot )

						if ( character in chosenCharacterSet )
							continue

						if ( character in previousChosenCharacterSet )
							continue

						chosenCharacterSet[character] <- true
						randomPlayerOrNullList.append( candidate.GetEncodedEHandle() )
					}
				}
				randomPlayerOrNullList.resize( 3, EncodedEHandle_null )
				previousChosenCharacterSet = chosenCharacterSet

				ShowModeInternal( eApexScreenPosition.L, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.GCARD_FRONT_DETAILS, randomPlayerOrNullList[0] )
				ShowModeInternal( eApexScreenPosition.C, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.GCARD_FRONT_DETAILS, randomPlayerOrNullList[1] )
				ShowModeInternal( eApexScreenPosition.R, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.GCARD_FRONT_DETAILS, randomPlayerOrNullList[2] )
				wait 18.0

				break
			}

			case eGameState.Playing:
			{
				array<EncodedEHandle> squad
				while ( true )
				{
					EncodedEHandle championEEH = SurvivalCommentary_GetChampionEEH()
					if ( championEEH != EncodedEHandle_null )
					{
						squad = GetPlayerSquadSafe( championEEH, 3 ) // todo(dw): hard-coded squad size?

						ShowModeInternal( eApexScreenPosition.L, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.PLAYER_NAME_CHAMPION, championEEH )
						ShowModeInternal( eApexScreenPosition.C, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.GCARD_FRONT_CLEAN, championEEH )
						ShowModeInternal( eApexScreenPosition.R, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.GCARD_BACK, championEEH )
						wait 20.0

						if ( squad[1] != EncodedEHandle_null || squad[2] != EncodedEHandle_null )
						{
							ShowModeInternal( eApexScreenPosition.L, eApexScreenTransitionStyle.FADE_TO_BLACK, eApexScreenMode.GCARD_FRONT_DETAILS, squad[1] )
							ShowModeInternal( eApexScreenPosition.C, eApexScreenTransitionStyle.NONE, eApexScreenMode.GCARD_FRONT_DETAILS, championEEH )
							ShowModeInternal( eApexScreenPosition.R, eApexScreenTransitionStyle.FADE_TO_BLACK, eApexScreenMode.GCARD_FRONT_DETAILS, squad[2] )
						}
						wait 20.0
					}
					else
					{
						ShowModeInternal( eApexScreenPosition.L, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.LOGO, EncodedEHandle_null )
						ShowModeInternal( eApexScreenPosition.C, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.LOGO, EncodedEHandle_null )
						ShowModeInternal( eApexScreenPosition.R, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.LOGO, EncodedEHandle_null )
						wait 4.5
					}

					EncodedEHandle killLeaderEEH = SurvivalCommentary_GetKillLeaderEEH()
					if ( killLeaderEEH != EncodedEHandle_null )
					{
						squad = GetPlayerSquadSafe( killLeaderEEH, 3 ) // todo(dw): hard-coded squad size?

						ShowModeInternal( eApexScreenPosition.L, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.PLAYER_NAME_KILLLEADER, killLeaderEEH )
						ShowModeInternal( eApexScreenPosition.C, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.GCARD_FRONT_CLEAN, killLeaderEEH )
						ShowModeInternal( eApexScreenPosition.R, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.GCARD_BACK, killLeaderEEH )
						wait 20.0

						if ( squad[1] != EncodedEHandle_null || squad[2] != EncodedEHandle_null )
						{
							ShowModeInternal( eApexScreenPosition.L, eApexScreenTransitionStyle.FADE_TO_BLACK, eApexScreenMode.GCARD_FRONT_DETAILS, squad[1] )
							ShowModeInternal( eApexScreenPosition.C, eApexScreenTransitionStyle.NONE, eApexScreenMode.GCARD_FRONT_DETAILS, killLeaderEEH )
							ShowModeInternal( eApexScreenPosition.R, eApexScreenTransitionStyle.FADE_TO_BLACK, eApexScreenMode.GCARD_FRONT_DETAILS, squad[2] )
						}
						wait 20.0
					}
					else
					{
						ShowModeInternal( eApexScreenPosition.L, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.LOGO, EncodedEHandle_null )
						ShowModeInternal( eApexScreenPosition.C, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.LOGO, EncodedEHandle_null )
						ShowModeInternal( eApexScreenPosition.R, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.LOGO, EncodedEHandle_null )
						wait 4.5
					}
				}
				break
			}

			default:
			{
				wait 0.3
				break
			}
		}
	}
}
#endif


#if SERVER && R5DEV
void function DEV_ApexScreens_TogglePreviewMode()
{
	file.DEV_inDebugPreviewMode = !file.DEV_inDebugPreviewMode
	printt( "Apex Screen Preview Mode: " + (file.DEV_inDebugPreviewMode ? "ON" : "OFF") )
}
#endif


#if SERVER && R5DEV
void function DEV_ApexScreens_GladCardPreviewMode()
{
	file.DEV_inDebugPreviewMode = true

	array<entity> testArray = GetPlayerArray()

	HaltApexScreenMasterThink()

	//ShowModeInternal( eApexScreenPosition.L, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.GCARD_FRONT_DETAILS, testArray[RandomIntRange( 0, testArray.len() )] )
	//ShowModeInternal( eApexScreenPosition.C, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.GCARD_FRONT_DETAILS, gp()[0] )
	//ShowModeInternal( eApexScreenPosition.R, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.GCARD_FRONT_DETAILS, testArray[RandomIntRange( 0, testArray.len() )] )

	ShowModeInternal( eApexScreenPosition.L, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.PLAYER_NAME_KILLLEADER, gp()[0].GetEncodedEHandle() )
	ShowModeInternal( eApexScreenPosition.C, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.GCARD_FRONT_CLEAN, gp()[0].GetEncodedEHandle() )
	ShowModeInternal( eApexScreenPosition.R, eApexScreenTransitionStyle.SLIDE, eApexScreenMode.GCARD_BACK, gp()[0].GetEncodedEHandle() )
}
#endif


#if SERVER && R5DEV
void function DEV_ApexScreens_SetMode( var opt = "random" )
{
	int currentMode = GetGlobalNetInt( "ApexScreensMasterState_Pos1_ModeIndex" ) // just use center screen
	int nextMode
	if ( opt == "random" )
		nextMode = RandomIntRange( 0, eApexScreenMode._COUNT )
	else if ( opt == "next" )
		nextMode = modint( currentMode + 1, eApexScreenMode._COUNT )
	else if ( opt == "prev" )
		nextMode = modint( currentMode - 1, eApexScreenMode._COUNT )
	else if ( type( opt ) == "string" )
		nextMode = eApexScreenMode[string(opt).toupper()]
	else
		nextMode = int(opt)

	array<entity> testArray = GetPlayerArray()
	testArray.append( null )

	HaltApexScreenMasterThink()
	ShowModeInternal( eApexScreenPosition.L, eApexScreenTransitionStyle.SLIDE, nextMode, EHIToEncodedEHandle( testArray[RandomIntRange( 0, testArray.len() )] ) )
	ShowModeInternal( eApexScreenPosition.C, eApexScreenTransitionStyle.NONE, nextMode, EHIToEncodedEHandle( gp()[0] ) )
	ShowModeInternal( eApexScreenPosition.R, eApexScreenTransitionStyle.SLIDE, nextMode, EHIToEncodedEHandle( testArray[RandomIntRange( 0, testArray.len() )] ) )

	printt( "Apex Screen Mode: " + GetEnumString( "eApexScreenMode", nextMode ) )
}
#endif



////
////
//// Client-side screen state management
////
////

//#if CLIENT
//void function ClApexScreens_Lobby_SetMode( int modeIndex )
//{
//	Assert( IsLobby() )
//
//	file.masterState.modeIndex = modeIndex
//	UpdateAllScreensContent()
//}
//#endif
//
//
//#if CLIENT
//void function ClApexScreens_Lobby_SetCardOwner( int index, entity owner )
//{
//	Assert( IsLobby() )
//
//	switch ( index )
//	{
//		case 0: file.masterState.player0 = owner; break
//
//		case 1: file.masterState.player1 = owner; break
//
//		case 2: file.masterState.player2 = owner; break
//	}
//	UpdateAllScreensContent()
//}
//#endif


#if CLIENT
void function ClApexScreens_DisableAllScreens()
{
	Assert( !file.forceDisableScreens )
	file.forceDisableScreens = true
	UpdateAllScreensContent()
}
#endif


#if CLIENT
void function ClApexScreens_EnableAllScreens()
{
	Assert( file.forceDisableScreens )
	file.forceDisableScreens = false
	UpdateAllScreensContent()
}

bool function ClApexScreens_IsDisabled()
{
	return file.forceDisableScreens
}
#endif


#if CLIENT
void function UpdateAllScreensContent()
{
	if ( !GetCurrentPlaylistVarBool( "enable_apex_screens", true ) )
		return

	// todo(dw): make this run when switching spectator targets

	if ( !IsValid( clGlobal.levelEnt ) )
		return // this can be called before scripts have finished initializing

	if ( file.allScreenUpdateQueued )
		return
	file.allScreenUpdateQueued = true

	thread UpdateAllScreensContentThread()
}
void function UpdateAllScreensContentThread()
{
	WaitEndFrame()
	file.allScreenUpdateQueued = false
	UpdateScreensContent( file.staticScreenList )
}
//
void function OnUpdateApexScreensEventTime( float newTime )
{
	printf( "%s() - New time: %.2f", FUNC_NAME(), newTime )

	if ( newTime < 0 )
	{
		bool didChange = false
		foreach( ApexScreenState screen in file.staticScreenList )
		{
			if ( screen.ruiToCreateOrig != $"" )
			{
				screen.overrideInfoIsValid = false
				screen.ruiToCreate = screen.ruiToCreateOrig
				didChange = true
			}
		}

		if ( didChange )
			UpdateAllScreensContent()
		return
	}

	asset eventScreenAsset = GetCurrentPlaylistVarAsset( "banner_event_rui" )
	if ( eventScreenAsset == $"" )
	{
		Warning( "%s() - No banner rui specified for event.", FUNC_NAME() )
		return
	}
	bool showSuccess = GetCurrentPlaylistVarBool( "banner_event_show_success", false )

	ScreenOverrideInfo offScreens
	{
		offScreens.skipStandardVars = true
		offScreens.ruiAsset = eventScreenAsset
		offScreens.vars.gametimes["eventTriggerTime"] <- GetGlobalNetTime( NV_ApexScreensEventTimeA )
	}

	ScreenOverrideInfo onScreens
	{
		onScreens.skipStandardVars = true
		onScreens.ruiAsset = eventScreenAsset
		onScreens.vars.strings["eventText"] <- "#BANNER_EVENT_MAINTEXT"
		onScreens.vars.bools["eventShowFailure"] <- (!showSuccess)
		onScreens.vars.bools["eventShowSuccess"] <- showSuccess
		onScreens.vars.gametimes["eventTriggerTime"] <- GetGlobalNetTime( NV_ApexScreensEventTimeA )
	}

	array<ApexScreenState> centerScreens
	foreach( ApexScreenState screen in file.staticScreenList )
	{
		if ( screen.position == eApexScreenPosition.TV_LIKE )
			continue

		if ( screen.position == eApexScreenPosition.C )
			centerScreens.append( screen )

		screen.overrideInfoIsValid = true
		screen.overrideInfo = offScreens

		if ( screen.ruiToCreateOrig == $"" )
			screen.ruiToCreateOrig = screen.ruiToCreate
		screen.ruiToCreate = offScreens.ruiAsset
	}

	foreach( index, screen in centerScreens )
	{
		if ( index % 3 != 2 )
			continue

		screen.overrideInfo = onScreens
		screen.ruiToCreate = onScreens.ruiAsset
	}

	UpdateAllScreensContent()
}

void function ClApexScreens_OnStaticPropRuiVisibilityChange( array<int> newlyVisible, array<int> newlyHidden )
{
	array<ApexScreenState> screensToUpdate = []

	foreach( int magicId in newlyHidden )
	{
		if ( !(magicId in file.magicIdScreenStateMap) )
			continue // not an apex screen

		ApexScreenState screen = file.magicIdScreenStateMap[magicId]

		Assert( screen.visibleInPVS )

		screen.visibleInPVS = false
		screensToUpdate.append( screen )
	}

	foreach( int magicId in newlyVisible )
	{
		if ( !(magicId in file.magicIdScreenStateMap) )
			continue // not an apex screen

		ApexScreenState screen = file.magicIdScreenStateMap[magicId]

		Assert( !screen.visibleInPVS )

		screen.visibleInPVS = true
		screensToUpdate.append( screen )
	}

	UpdateScreensContent( screensToUpdate )
}
#endif


#if CLIENT && R5DEV
void function DEV_ToggleActiveApexScreenDebug()
{
	file.DEV_activeScreenDebug = !file.DEV_activeScreenDebug
	thread DEV_ActiveApexScreenDebugThread()
}
void function DEV_ActiveApexScreenDebugThread()
{
	RegisterSignal( "DEV_ActiveApexScreenDebugThread" )
	Signal( clGlobal.levelEnt, "DEV_ActiveApexScreenDebugThread" )
	EndSignal( clGlobal.levelEnt, "DEV_ActiveApexScreenDebugThread" )

	const float interval = 0.3

	while ( file.DEV_activeScreenDebug )
	{
		wait interval

		int totalCount = 0, activeCount = 0, activeTVCount = 0
		foreach( ApexScreenState screen in file.staticScreenList )
		{
			totalCount += 1

			if ( screen.visibleInPVS )
			{
				activeCount += 1
				DebugDrawRotatedBox( <0, 0, 0>, screen.spawnMins + <-1, -1, -3>, screen.spawnMaxs + <-1, -1, -3>, <0, 0, 0>, 140, 185, 255, true, interval + 0.1 )
			}
			else
			{
				DebugDrawRotatedBox( <0, 0, 0>, screen.spawnMins + <-1, -1, -3>, screen.spawnMaxs + <-1, -1, -3>, <0, 0, 0>, 25, 25, 80, true, interval + 0.1 )
			}
		}
		printt( "ACTIVE SCREEN COUNT: " + activeCount + " (of " + totalCount + ") (" + activeTVCount + " TVs)" )
	}
}
#endif


#if CLIENT && R5DEV
void function DEV_ToggleFloatyBitsPrototype()
{
	file.DEV_isFloatyBitsPrototypeEnabled = !file.DEV_isFloatyBitsPrototypeEnabled
	UpdateAllScreensContent()
}
#endif


#if CLIENT
void function UpdateScreensContent( array<ApexScreenState> screenList )
{
	entity localViewPlayer = GetLocalViewPlayer()
	bool isCrypto          = PlayerHasPassive( localViewPlayer, ePassives.PAS_CRYPTO )
	bool inCamera          = StatusEffect_GetSeverity( localViewPlayer, eStatusEffect.camera_view ) > 0.0
	foreach( ApexScreenState screen in screenList )
	{
		bool shouldShow = true

		if ( file.forceDisableScreens )
			shouldShow = false
		else if ( !screen.visibleInPVS )
			shouldShow = false
		else if ( screen.position == eApexScreenPosition.DISABLED )
			shouldShow = false
		else if ( screen.isOutsideCircle )
			shouldShow = false

		bool needShutdown = ((screen.rui != null) && (!shouldShow || (screen.ruiToCreate != screen.ruiLastCreated)))
		if ( needShutdown )
		{
			screen.commenceTime = -1.0
			Signal( screen, "ScreenOff" ) // to clean up any threads expecting the RUI to exist

			CleanupNestedGladiatorCard( screen.nestedGladiatorCard0Handle )

			RuiDestroyIfAlive( screen.rui )
			screen.rui = null
		}

		bool doStandardVars = (!screen.overrideInfoIsValid || !screen.overrideInfo.skipStandardVars)

		bool needStartup = (shouldShow && (screen.rui == null))
		if ( needStartup )
		{
			screen.rui = CreateApexScreenRUIElement( screen )
			if ( screen.rui != null )
			{
				if ( doStandardVars )
					screen.nestedGladiatorCard0Handle = CreateNestedGladiatorCard( screen.rui, "card0", eGladCardDisplaySituation.APEX_SCREEN_STILL, eGladCardPresentation.OFF )
			}
			else
			{
				shouldShow = false
			}
		}

		if ( !shouldShow )
			continue
		if ( !doStandardVars )
			continue

		ApexScreenPositionMasterState masterState = file.screenPositionMasterStates[screen.position]
		float desiredCommenceTime                 = masterState.commenceTime
		int desiredMode                           = masterState.modeIndex
		int desiredTransitionStyle                = masterState.transitionStyle
		EHI desiredPlayerEHI                      = masterState.playerEHI

		if ( desiredCommenceTime == screen.commenceTime && !inCamera )
			continue

		if ( isCrypto )
			RuiSetFloat( screen.rui, "cryptoHintAlpha", 1.0 )
		else
			RuiSetFloat( screen.rui, "cryptoHintAlpha", 0.0 )

		if ( inCamera )
		{
			desiredMode = eApexScreenMode.CAMERA_VIEW
			desiredTransitionStyle = eApexScreenTransitionStyle.NONE
			desiredCommenceTime = -1
		}

		screen.commenceTime = desiredCommenceTime

		RuiSetGameTime( screen.rui, "commenceTime", desiredCommenceTime )
		RuiSetInt( screen.rui, "modeIndex", desiredMode )
		RuiSetInt( screen.rui, "transitionStyle", desiredTransitionStyle )

		int lifestateOverride = eGladCardLifestateOverride.NONE
		int gcardPresentation = GetGCardpresentationForApexScreenMode( desiredMode )

		#if(false)


#endif //

		thread UpdateScreenDetails( screen, desiredTransitionStyle, gcardPresentation, desiredPlayerEHI, lifestateOverride )
	}
}

int function GetGCardpresentationForApexScreenMode( int screenMode )
{
	switch( screenMode )
	{
		case eApexScreenMode.GCARD_FRONT_CLEAN:
			return eGladCardPresentation.FRONT_CLEAN

		case eApexScreenMode.GCARD_FRONT_DETAILS:
			return eGladCardPresentation.FRONT_DETAILS

		case eApexScreenMode.GCARD_BACK:
			return eGladCardPresentation.BACK
	}

	return eGladCardPresentation.OFF
}
#endif


#if CLIENT
void function UpdateScreenDetails( ApexScreenState screen, int transitionStyle, int gcardPresentation, EHI playerEHI, int lifestateOverride )
{
	Signal( screen, "UpdateScreenCards" )
	EndSignal( screen, "UpdateScreenCards" )
	EndSignal( screen, "ScreenOff" )

	float modeChangeTime = screen.commenceTime
	if ( transitionStyle != eApexScreenTransitionStyle.NONE )
		modeChangeTime += APEX_SCREEN_TRANSITION_IN_DURATION

	if ( modeChangeTime - Time() > 0.02 )
		wait (modeChangeTime - Time())

	//RuiSetBool( screen.rui, "isCardValid", IsValid( player ) )

	string playerName = ""
	if ( EHIHasValidScriptStruct( playerEHI ) )
		playerName = EHI_GetName( playerEHI )
	//for ( int ci = 0; ci < 16; ci++ )
	//{
	//	string c = (ci < playerName.len() ? playerName.slice( ci, ci + 1 ) : "")
	//	c = RegexpReplace( c, "_", "-" )
	//	RuiSetString( screen.rui, format( "playerNameChar%02d", ci ), c )
	//}
	//playerName = RepeatString( " ", 16 - playerName.len() ) + playerName
	RuiSetString( screen.rui, "playerName", playerName )

	entity player = FromEHI( playerEHI ) // todo(dw): cache kills
	if ( IsValid( player ) )
		RuiTrackInt( screen.rui, "playerKillCount", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "kills" ) )

	RuiSetFloat( screen.rui, "xpBonusAmount", XpEventTypeData_GetAmount( XP_TYPE.KILL_CHAMPION_MEMBER ) )

	ChangeNestedGladiatorCardPresentation( screen.nestedGladiatorCard0Handle, gcardPresentation )
	ChangeNestedGladiatorCardOwner( screen.nestedGladiatorCard0Handle, playerEHI, modeChangeTime, lifestateOverride )

	//if ( screen.floatingRui != null )
	//{
	//	ItemFlavor character = LoadoutSlot_GetItemFlavor( playerEHI, Loadout_CharacterClass() )
	//
	//	// todo(dw): aaaaaaaaa
	//	// todo(dw): aaaaaaaaa
	//	// todo(dw): aaaaaaaaa
	//	// todo(dw): aaaaaaaaa
	//	for ( int badgeIndex = 0; badgeIndex < GLADIATOR_CARDS_NUM_BADGES; badgeIndex++ )
	//	{
	//		if ( screen.floatingNestedBadgeRuiList[badgeIndex] != null )
	//		{
	//			RuiDestroyNested( screen.floatingRui, "badge" + badgeIndex + "Instance" )
	//			screen.floatingNestedBadgeRuiList[badgeIndex] = null
	//		}
	//
	//		LoadoutEntry badgeSlot        = Loadout_GladiatorCardBadge( character, badgeIndex )
	//		ItemFlavor ornull badgeOrNull = LoadoutSlot_GetItemFlavorOrNull( playerEHI, badgeSlot )
	//
	//		if ( badgeOrNull != null )
	//		{
	//			ItemFlavor badge = expect ItemFlavor(badgeOrNull)
	//
	//			// todo(dw): tier override
	//			int tierIndex = -1
	//
	//			//LoadoutEntry badgeTierSlot = Loadout_GladiatorCardBadgeTier( character, badgeIndex )
	//			//if ( tierIndex == -1 && LoadoutSlot_IsReady( playerEHI, badgeTierSlot ) )
	//			//{
	//			//	ItemFlavor tierDummy = LoadoutSlot_GetItemFlavor( playerEHI, badgeTierSlot )
	//			//	tierIndex = DummyItemFlavor_GetDummyIndex( tierDummy )
	//			//}
	//
	//			if ( tierIndex == -1 )
	//				tierIndex = 0
	//
	//			asset badgeRuiAsset, badgeImageAsset
	//			array<GladCardBadgeTierData> tierDataList = GladiatorCardBadge_GetTierDataList( badge )
	//			if ( GladiatorCardBadge_HasOwnRUI( badge ) )
	//			{
	//				badgeRuiAsset = tierDataList[tierIndex].ruiAsset
	//			}
	//			else
	//			{
	//				badgeRuiAsset = $"ui/gcard_badge_basic.rpak"
	//				badgeImageAsset = tierDataList[tierIndex].imageAsset
	//			}
	//
	//			var badgeRui = RuiCreateNested( screen.floatingRui, "badge" + badgeIndex + "Instance", badgeRuiAsset )
	//			screen.floatingNestedBadgeRuiList[badgeIndex] = badgeRui
	//
	//			RuiSetInt( badgeRui, "tier", tierIndex )
	//
	//			if ( badgeImageAsset != $"" )
	//				RuiSetImage( badgeRui, "img", badgeImageAsset )
	//		}
	//	}
	//}
}
#endif


#if CLIENT
void function ClientStaticPropRUICreated( StaticPropRui propRui, var ruiInstance )
{
	if ( !(propRui.magicId in file.environmentalRUIListMapByMagicId) )
	{
		file.environmentalRUIListMapByMagicId[propRui.magicId] <- []
	}
	file.environmentalRUIListMapByMagicId[propRui.magicId].append( ruiInstance )
}
#endif


#if CLIENT
void function SetupForHorizontalTVScreen( StaticPropRui staticPropRuiInfo, ApexScreenState apexScreen )
{
	if ( staticPropRuiInfo.scriptName in s_screenOverrides )
	{
		apexScreen.overrideInfo = s_screenOverrides[staticPropRuiInfo.scriptName]
		apexScreen.overrideInfoIsValid = true
		apexScreen.ruiToCreate = apexScreen.overrideInfo.ruiAsset
		apexScreen.position = eApexScreenPosition.TV_LIKE
		return
	}

	apexScreen.position = eApexScreenPosition.DISABLED
}

bool function OnEnumStaticPropRui( StaticPropRui staticPropRuiInfo )
{
	if ( !GetCurrentPlaylistVarBool( "enable_apex_screens", true ) )
		return (staticPropRuiInfo.mockupName.find( "apex_screen" ) != -1)
	//printt( "STATIC RUI", staticPropRuiInfo.magicId, "SCRIPTNAME:" + staticPropRuiInfo.scriptName, "MOCKUP:" + staticPropRuiInfo.mockupName, "MODEL:" + staticPropRuiInfo.modelName, "RUI:" + staticPropRuiInfo.ruiName )

	ApexScreenState apexScreen
	apexScreen.magicId = staticPropRuiInfo.magicId
	apexScreen.rui = null
	apexScreen.spawnOrigin = staticPropRuiInfo.spawnOrigin
	apexScreen.spawnForward = Normalize( staticPropRuiInfo.spawnForward )
	apexScreen.spawnRight = Normalize( staticPropRuiInfo.spawnRight )
	apexScreen.spawnUp = Normalize( staticPropRuiInfo.spawnUp )
	apexScreen.spawnScale = Length( staticPropRuiInfo.spawnForward )
	apexScreen.spawnMins = staticPropRuiInfo.spawnMins
	apexScreen.spawnMaxs = staticPropRuiInfo.spawnMaxs
	apexScreen.ruiToCreate = $"ui/apex_screen.rpak" //$"ui/apex_screen_vertical.rpak"
	apexScreen.mockup = staticPropRuiInfo.mockupName
	apexScreen.diagonalSize = Distance( staticPropRuiInfo.spawnMins, staticPropRuiInfo.spawnMaxs )

	float tintIntensity = RandomFloatRange( APEX_SCREEN_RANDOM_TINT_INTENSITY_MIN, APEX_SCREEN_RANDOM_TINT_INTENSITY_MAX )
	apexScreen.tint = tintIntensity * APEX_SCREEN_RANDOM_TINT_PALETTE[RandomInt( APEX_SCREEN_RANDOM_TINT_PALETTE.len() )]

	if ( "apex_screen_mods" in staticPropRuiInfo.args )
	{
		string modsStr = staticPropRuiInfo.args.apex_screen_mods
		apexScreen.modBits = 0
		foreach( string modKey in GetTrimmedSplitString( modsStr, "," ) )
		{
			if ( modKey.toupper() in eApexScreenMods )
				apexScreen.modBits = apexScreen.modBits | eApexScreenMods[modKey.toupper()]
			else
				Warning( "Apex screen at " + apexScreen.spawnOrigin + " has unknown mod '" + modKey.toupper() + "' (" + modsStr + ")" )
		}
	}

	bool needsScreenPositionSetup = true
	switch( staticPropRuiInfo.modelName )
	{
		case "mdl/eden\\beacon_small_screen_02_off.rmdl":
			apexScreen.uvMin = <0.0, 0.295, 0.0>
			apexScreen.uvMax = <1.0, 0.705, 0.0>
			SetupForHorizontalTVScreen( staticPropRuiInfo, apexScreen )
			needsScreenPositionSetup = false
			break

		case "mdl/thunderdome\\apex_screen_05.rmdl":
			apexScreen.uvMin = <0.235, 0.0, 0.0>
			apexScreen.uvMax = <0.765, 1.0, 0.0>
			break

		case "mdl/thunderdome\\survival_modular_flexscreens_01.rmdl":
		case "mdl/thunderdome\\survival_modular_flexscreens_02.rmdl":
		case "mdl/thunderdome\\survival_modular_flexscreens_03.rmdl":
		case "mdl/thunderdome\\survival_modular_flexscreens_04.rmdl":
			apexScreen.uvMin = <0.323, 0.0, 0.0>
			apexScreen.uvMax = <0.684, 1.0, 0.0>
			break

		case "mdl/thunderdome\\survival_modular_flexscreens_05.rmdl":
			apexScreen.uvMin = <0.0, 0.215, 0.0>
			apexScreen.uvMax = <1.0, 0.785, 0.0>
			break

		default:
			return false // don't block default, we're not going to put any apex screen stuff on this prop
			//apexScreen.sharesPropWithEnvironmentalRUI = true
			//apexScreen.isVideoOnly = true
			//apexScreen.uvMin = <0.0, 0.0, 0.0>
			//apexScreen.uvMax = <1.0, 1.0, 0.0>
			break
	}

	if ( needsScreenPositionSetup )
	{
		float uvWidth           = (apexScreen.uvMax.x - apexScreen.uvMin.x)
		float uvHeight          = (apexScreen.uvMax.y - apexScreen.uvMin.y)
		float screenAspectRatio = (uvHeight < 0.0001) ? 0.0 : uvWidth / uvHeight
		bool isVertical         = (screenAspectRatio < 1.1)
		if ( !isVertical )
		{
			//
			apexScreen.position = eApexScreenPosition.DISABLED
		}
		else
		{
			switch( staticPropRuiInfo.scriptName )
			{
				case "leftScreen":
					apexScreen.position = eApexScreenPosition.L
					break

				case "rightScreen":
					apexScreen.position = eApexScreenPosition.R
					break

				default:
					apexScreen.position = eApexScreenPosition.C
					break
			}
		}
	}

	Assert( string( apexScreen.ruiToCreate ) != "" )

	file.staticScreenList.append( apexScreen )
	file.magicIdScreenStateMap[apexScreen.magicId] <- apexScreen

	if ( apexScreen.sharesPropWithEnvironmentalRUI )
		return false // don't block default if the model is not an "apex-only" model (it could be showing an ad or a sushi menu, etc)

	return true
}
#endif


#if CLIENT
var function CreateApexScreenRUIElement( ApexScreenState screen )
{
	var rui
	if ( screen.magicId == -1 )
	{
		#if R5DEV
			float aspectRatio = 1.0//0.38
			float height      = screen.diagonalSize / sqrt( 1.0 + pow( aspectRatio, 2.0 ) )
			float width       = aspectRatio * height
			vector origin     = screen.spawnOrigin// + <0, 0, -height>
			var topo          = RuiTopology_CreatePlane( origin, <0, width, 0>, <0, 0, -height>, false )

			rui = RuiCreate( screen.ruiToCreate, topo, RUI_DRAW_WORLD, 32767 )
		#else
			return null
		#endif
	}
	else
	{
		StaticPropRui propStaticRuiInfo
		propStaticRuiInfo.ruiName = screen.ruiToCreate
		propStaticRuiInfo.magicId = screen.magicId
		rui = RuiCreateOnStaticProp( propStaticRuiInfo )
	}
	screen.ruiLastCreated = screen.ruiToCreate

	vector basePos = screen.spawnOrigin
	basePos.z -= (screen.spawnMaxs.z - screen.spawnMins.z)
	//DebugDrawAxis( basePos, VectorToAngles( screen.spawnForward ), 25, 5 )
	RuiSetFloat3( rui, "screenWorldPos", basePos )
	RuiSetFloat( rui, "screenScale", screen.spawnScale )
	RuiSetFloat2( rui, "uvMin", screen.uvMin )
	RuiSetFloat2( rui, "uvMax", screen.uvMax )
	RuiSetInt( rui, "screenPosition", screen.position )
	RuiSetInt( rui, "modBits", screen.modBits )
	RuiSetFloat3( rui, "tintColor", screen.tint )
	RuiSetFloat( rui, "tintIntensity", 1.0 )
	RuiSetInt( rui, "unixTimeStamp", GetUnixTimestamp() )
	if ( screen.sharesPropWithEnvironmentalRUI )
		RuiSetBool( rui, "sharesPropWithEnvironmentalRUI", true )

	RuiTrackInt( rui, "cameraNearbyEnemySquads", GetLocalViewPlayer(), RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "cameraNearbyEnemySquads" ) )

	#if(true)
		if ( IsFallLTM() )
		{
			RuiSetImage( rui, "overlayImg", $"rui/rui_screens/banner_c_shadowfall" )
			RuiSetFloat3( rui, "logoTint", <1.0, 1.0, 1.0> )
		}
	#endif

	if ( screen.overrideInfoIsValid )
	{
		foreach( string varName, int varValue in screen.overrideInfo.vars.ints )
			RuiSetInt( rui, varName, varValue )

		foreach( string varName, float varValue in screen.overrideInfo.vars.floats )
			RuiSetFloat( rui, varName, varValue )

		foreach( string varName, bool varValue in screen.overrideInfo.vars.bools )
			RuiSetBool( rui, varName, varValue )

		foreach( string varName, string varValue in screen.overrideInfo.vars.strings )
			RuiSetString( rui, varName, varValue )

		foreach( string varName, asset varValue in screen.overrideInfo.vars.images )
			RuiSetImage( rui, varName, varValue )

		foreach( string varName, vector varValue in screen.overrideInfo.vars.float3s )
			RuiSetFloat3( rui, varName, varValue )

		foreach( string varName, float varValue in screen.overrideInfo.vars.gametimes )
			RuiSetGameTime( rui, varName, varValue )

		if ( screen.overrideInfo.bindStartTimeVarToEventTimeA )
			RuiTrackFloat( rui, "startTime", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL, GetNetworkedVariableIndex( NV_ApexScreensEventTimeA ) )
		if ( screen.overrideInfo.bindStartTimeVarToEventTimeB )
			RuiTrackFloat( rui, "startTime", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL, GetNetworkedVariableIndex( NV_ApexScreensEventTimeB ) )
	}

	return rui
}
#endif


#if CLIENT && R5DEV
void function DEV_CreatePerfectApexScreen( vector origin, float diagonalSize, int screenPosition )
{
	ApexScreenState apexScreen
	apexScreen.magicId = -1
	apexScreen.rui = null
	apexScreen.spawnOrigin = origin
	apexScreen.ruiToCreate = $"ui/apex_screen.rpak"
	apexScreen.diagonalSize = diagonalSize
	apexScreen.position = screenPosition
	apexScreen.uvMin = <0.31, 0.0, 0.0>
	apexScreen.uvMax = <0.69, 1.0, 0.0>

	file.staticScreenList.append( apexScreen )

	UpdateScreensContent( [apexScreen] )
}
#endif



////
////
//// Kill event data
////
////

#if CLIENT
void function ServerToClient_ApexScreenKillDataChanged( int damageSourceID, float distanceBetweenPlayers, int killedPlayerGrade, entity killedPlayer )
{
	file.killScreenDamageSourceID = damageSourceID
	file.killScreenDistance = floor( distanceBetweenPlayers / 12 )
	file.killedPlayerGrade = killedPlayerGrade

	if ( IsValid( killedPlayer ) )
		file.killedPlayerName = killedPlayer.GetPlayerName()

	UpdateAllScreensContent()
}

void function ServerToClient_ApexScreenRefreshAll()
{
	UpdateAllScreensContent()
}
#endif





////
////
//// Work-in-progress scheduler
////
////

//#if CLIENT
//struct ApexScreenSituation
//{
//	bool  required = false
//	float earliestStart = -1.0
//	float latestStart = -1.0
//	float minimumDuration = 0.0
//	float earliestFinish = -1.0
//	float latestFinish = -1.0
//
//	int    mode = eApexScreenMode.INVALID
//	entity player0 = null
//	entity player1 = null
//	entity player2 = null
//}
//#endif
//
//void function OnSurvivalDeathFieldStageChanged( int stage, float nextCircleStartTime )
//{
//	// todo(dw): first circle
//	// todo(dw): last circle
//
//	#if CLIENT
//		ApexScreenSituation sit
//		sit.onlyOnce = false
//		sit.required = true
//		sit.earliestStart = nextCircleStartTime - 30.0
//		sit.latestStart = nextCircleStartTime - 8.0
//		sit.minimumDuration = 0.0
//		sit.earliestFinish = nextCircleStartTime + 5.0
//		sit.latestFinish = nextCircleStartTime + 120.0
//		sit.mode = eApexScreenMode.CIRCLE_STATE
//		file.circleWillCloseSituationOrNull = sit
//
//		ApexScreenSituation sit
//		sit.onlyOnce = false
//		sit.required = true
//		sit.earliestStart = nextCircleStartTime - 30.0
//		sit.latestStart = nextCircleStartTime - 8.0
//		sit.minimumDuration = 0.0
//		sit.earliestFinish = nextCircleStartTime + 5.0
//		sit.latestFinish = nextCircleStartTime + 120.0
//		sit.mode = eApexScreenMode.CIRCLE_STATE
//		file.circleWillCloseSituationOrNull = sit
//	#endif
//}
//
//#if SERVER
//ApexScreenSituation function GetScreenSituation( ApexScreenState screenState )
//{
//	array<ApexScreenSituation> choices = []
//
//	{
//		// circle state -- about to close & just closed
//		float nextCircleStartTime = GetGlobalNetTime( "nextCircleStartTime" )
//	}
//
//	// impressive kill
//
//	// players remaining
//	// squads remaining
//
//	// champion squad
//
//	// logo
//}
//#endif
