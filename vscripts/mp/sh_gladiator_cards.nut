global function ShGladiatorCards_LevelInit

#if UI
global function ShGladiatorCards_Init
global function ShGladiatorCards_LevelShutdown
#endif

#if SERVER || CLIENT || UI
global function AreGladiatorCardsEnabled
#endif

#if CLIENT
global function CreateNestedGladiatorCard
global function CleanupNestedGladiatorCard
global function ChangeNestedGladiatorCardPresentation
global function ChangeNestedGladiatorCardOwner
global function SetNestedGladiatorCardOverrideName
global function SetNestedGladiatorCardOverrideCharacter
global function SetNestedGladiatorCardOverrideSkin
global function SetNestedGladiatorCardOverrideFrame
global function SetNestedGladiatorCardOverrideStance
global function SetNestedGladiatorCardOverrideBadge
global function SetNestedGladiatorCardOverrideTracker

global function SetNestedGladiatorCardIsKiller
global function SetNestedGladiatorCardDisableBlur

global function SetNestedGladiatorCardOverrideRankedDetails
#endif

#if CLIENT || UI
global function CreateNestedGladiatorCardBadge
#endif

#if UI
global function SetupMenuGladCard
global function SendMenuGladCardPreviewCommand
global function SendMenuGladCardPreviewString
#endif

#if CLIENT
global function DisplayGladiatorCardSidePane
global function HideGladiatorCardSidePane
global function HideGladiatorCardSidePaneThreaded
global function UpdateRuiWithStatTrackerData
global function UIToClient_SetupMenuGladCard
global function UIToClient_HandleMenuGladCardPreviewCommand
global function UIToClient_HandleMenuGladCardPreviewString
global function OnWinnerDetermined
global function GetSituationPlayer
#if true
global function GladCardDebug
#endif
#endif

#if CLIENT && R5DEV
global function DEV_DumpCharacterCaptures
global function DEV_GladiatorCards_ToggleForceMoving
global function DEV_GladiatorCards_ToggleShowSafeAreaOverlay
global function DEV_GladiatorCards_ToggleCameraAlpha
global function DEV_ForceEnableGladiatorCards
#endif

#if SERVER || CLIENT || UI
global function Loadout_GladiatorCardFrame
global function Loadout_GladiatorCardStance
global function Loadout_GladiatorCardBadge
global function Loadout_GladiatorCardBadgeTier
global function Loadout_GladiatorCardStatTracker
global function GladiatorCardFrame_GetSortOrdinal
global function GladiatorCardFrame_GetCharacterFlavor
global function GladiatorCardFrame_ShouldHideIfLocked
global function GladiatorCardStance_GetSortOrdinal
global function GladiatorCardStance_GetCharacterFlavor
global function GladiatorCardBadge_GetSortOrdinal
global function GladiatorCardBadge_GetCharacterFlavor
global function GladiatorCardBadge_GetUnlockStatRef
global function GladiatorCardStatTracker_GetSortOrdinal
global function GladiatorCardStatTracker_GetCharacterFlavor
global function GladiatorCardStatTracker_GetFormattedValueText
global function GladiatorCardBadge_ShouldHideIfLocked
global function GladiatorCardBadge_IsTheEmpty
global function GladiatorCardTracker_IsTheEmpty
global function GladiatorCardBadge_IsCharacterBadge
global function GladiatorCardBadge_GetTierCount
global function GladiatorCardBadge_GetTierData
global function GladiatorCardBadge_GetTierDataList
global function GetPlayerBadgeDataInteger
global function GladiatorCardCharacterSkin_ShouldHideIfLocked
global function GladiatorCardWeaponSkin_ShouldHideIfLocked
#endif

#if CLIENT || UI
global function GladiatorCardStatTracker_GetColor0
global function GladiatorCardBadge_DoesStatSatisfyValue
#endif

#if CLIENT // todo(dw): temp
global function GladiatorCardBadge_HasOwnRUI
global function GladiatorCardBadge_IsOversizedImage
global function ShGladiatorCards_OnDevnetBugScreenshot
#endif


global const int GLADIATOR_CARDS_NUM_BADGES = 3
global const int GLADIATOR_CARDS_NUM_TRACKERS = 3

global const float GLADIATOR_CARDS_STAT_TRACKER_MAX_PRECISION = 100.0

global const int GLADIATOR_CARDS_NUM_FRAME_KEY_COLORS = 3

const bool GLADCARD_CC_DEBUG_PRINTS_ENABLED = false

////////////////////////////////
////////////////////////////////
//// Global & Private Types ////
////////////////////////////////
////////////////////////////////

global enum eGladCardPresentation
{
	OFF,

	_MARK_FRONT_START,
	FRONT_DETAILS,
	PROTO_FRONT_DETAILS_NO_BADGES,
	FRONT_CLEAN,
	FRONT_STANCE_ONLY,
	FRONT_FRAME_ONLY,

	_MARK_BACK_START,
	FULL_BOX,
	_MARK_FRONT_END,

	BACK,
	_MARK_BACK_END,
}

global enum eGladCardDisplaySituation
{
	// the order of this enum determines the priority if there is any contention
	// it is an error for one group to request the display of more cards than can be done at one time
	_INVALID, // lowest priority

	DEATH_BOX_STILL,
	APEX_SCREEN_STILL,
	SPECTATE_ANIMATED,
	GAME_INTRO_CHAMPION_SQUAD_ANIMATED,
	GAME_INTRO_CHAMPION_SQUAD_STILL,
	GAME_INTRO_MY_SQUAD_ANIMATED,
	GAME_INTRO_MY_SQUAD_STILL,
	WEAPON_INSPECT_OVERLAY_ANIMATED,
	DEATH_OVERLAY_ANIMATED,
	SQUAD_MANAGEMENT_PAGE_ANIMATED,
	EOG_SCREEN_LOCAL_SQUAD_ANIMATED,
	EOG_SCREEN_WINNING_SQUAD_ANIMATED,

	// menu
	MENU_CUSTOMIZE_ANIMATED,
	MENU_LOOT_CEREMONY_ANIMATED,

	// dev
	DEV_ANIMATED,

	_COUNT, // highest prioity
}

table<int, bool> eGladCardDisplaySituation_IS_MOVING = {
	[eGladCardDisplaySituation.DEATH_BOX_STILL] = false,
	[eGladCardDisplaySituation.APEX_SCREEN_STILL] = false,
	[eGladCardDisplaySituation.SPECTATE_ANIMATED] = true,
	[eGladCardDisplaySituation.GAME_INTRO_CHAMPION_SQUAD_ANIMATED] = true,
	[eGladCardDisplaySituation.GAME_INTRO_CHAMPION_SQUAD_STILL] = false,
	[eGladCardDisplaySituation.GAME_INTRO_MY_SQUAD_ANIMATED] = true,
	[eGladCardDisplaySituation.GAME_INTRO_MY_SQUAD_STILL] = false,
	[eGladCardDisplaySituation.DEATH_OVERLAY_ANIMATED] = true,
	[eGladCardDisplaySituation.SQUAD_MANAGEMENT_PAGE_ANIMATED] = true,
	[eGladCardDisplaySituation.EOG_SCREEN_LOCAL_SQUAD_ANIMATED] = true,
	[eGladCardDisplaySituation.EOG_SCREEN_WINNING_SQUAD_ANIMATED] = true,
	[eGladCardDisplaySituation.MENU_CUSTOMIZE_ANIMATED] = true,
	[eGladCardDisplaySituation.MENU_LOOT_CEREMONY_ANIMATED] = true,
	[eGladCardDisplaySituation.DEV_ANIMATED] = true,
}

global enum eGladCardLifestateOverride
{
	NONE = 0, // these must match GLADIATOR_LIFESTATE_OVERRIDE_* in gladiator_card_defs.rui
	ALIVE = 1,
	DEAD = 2,
}

global enum eGladCardPreviewCommandType
{
	CHARACTER,
	SKIN,
	FRAME,
	STANCE,
	BADGE,
	TRACKER,
	RANKED_SHOULD_SHOW,
	RANKED_DATA,
	NAME,
}

enum eStatTrackerValueFormat
{
	BASIC = 0,
	FLOAT_TWO_POINTS = 1,
}

#if CLIENT
typedef OnStancePIPSlotReadyFuncType void functionref( int stancePIPSlotIndex, float movingSeqEndTime )
#endif


#if CLIENT
global struct CharacterCaptureState
{
	string            key
	EHI               playerEHI = EHI_null
	bool              isMoving = false
	ItemFlavor&       character
	ItemFlavor&       skin
	ItemFlavor ornull frameOrNull
	ItemFlavor&       stance

	bool                isReady = false
	PIPSlotState ornull stancePIPSlotStateOrNull
	CaptureRoom ornull  captureRoomOrNull = null
	int                 refCount = 0
	float               startTime = 0.0

	void functionref() cleanupSceneFunc

	table<OnStancePIPSlotReadyFuncType, bool> onPIPSlotReadyFuncSet
	#if R5DEV
		PakHandle ornull DEV_framePakHandleOrNull = null
		array<string>    DEV_culprits
		var              DEV_bgTopo = null
		var              DEV_bgRui = null
	#endif

	// thread state
	entity        model
	entity        lightingRig
	entity        camera
	array<entity> lights
	array<bool>   lightDoesShadowsMap
	int           colorCorrectionLayer = -1
}
#endif

#if CLIENT
global struct NestedWidgetState
{
	var   rui
	asset ruiAsset = $""
}
#endif

#if CLIENT
global struct NestedGladiatorCardHandle
{
	var    parentRui
	string argName
	var    cardRui
	int    presentation = eGladCardPresentation.OFF
	bool   isFrontFace
	bool   isBackFace
	int    situation = eGladCardDisplaySituation._INVALID
	bool   shouldShowDetails = false
	bool   isMoving = false

	PakHandle ornull framePakHandleOrNull = null

	NestedWidgetState                             fgFrameNWS
	NestedWidgetState                             bgFrameNWS
	NestedWidgetState[GLADIATOR_CARDS_NUM_BADGES] badgeNWSList

	CharacterCaptureState ornull characterCaptureStateOrNull = null

	EHI currentOwnerEHI

	int   lifestateOverride = eGladCardLifestateOverride.NONE
	float startTime = 0.0

	string ornull                                   overrideName = null
	ItemFlavor ornull                               overrideCharacter = null
	ItemFlavor ornull                               overrideSkin = null
	ItemFlavor ornull                               overrideFrame = null
	ItemFlavor ornull                               overrideStance = null
	ItemFlavor ornull[GLADIATOR_CARDS_NUM_BADGES]   overrideBadgeList
	int[GLADIATOR_CARDS_NUM_BADGES]                 overrideBadgeDataIntegerList
	ItemFlavor ornull[GLADIATOR_CARDS_NUM_TRACKERS] overrideTrackerList
	int[GLADIATOR_CARDS_NUM_TRACKERS]               overrideTrackerDataIntegerList

	int ornull  rankedScoreOrNull = null
	int ornull  rankedLadderPosOrNull = null
	bool ornull rankedForceShowOrNull = null

	bool disableBlur = false
	bool isKiller = false

	bool updateQueued = false

	OnStancePIPSlotReadyFuncType onStancePIPSlotReadyFunc = null

	#if R5DEV
		string DEV_culprit = ""
	#endif
}
#endif

#if SERVER || CLIENT || UI
global struct GladCardBadgeTierData
{
	float unlocksAt
	asset ruiAsset = $""
	asset imageAsset = $""
	bool  isUnlocked = true
}
#endif

#if SERVER || CLIENT || UI
global struct GladCardBadgeDisplayData
{
	asset ruiAsset = $""
	asset imageAsset = $""
	int   dataInteger = -1 // tier or dynamic text
}
#endif

#if CLIENT
struct MenuGladCardPreviewCommand
{
	int               previewType
	int               index
	ItemFlavor ornull flavOrNull
	int               dataInteger
	string            previewString
}
#endif

#if SERVER || CLIENT || UI
struct FileStruct_LifetimeLevel
{
	table<ItemFlavor, LoadoutEntry>             loadoutCharacterFrameSlotMap
	table<ItemFlavor, LoadoutEntry>             loadoutCharacterStanceSlotMap
	table<ItemFlavor, array<LoadoutEntry> >     loadoutCharacterBadgesSlotListMap
	table<ItemFlavor, array<LoadoutEntry> >     loadoutCharacterBadgesTierSlotListMap
	table<ItemFlavor, array<LoadoutEntry> >     loadoutCharacterTrackersSlotListMap
	table<ItemFlavor, array<LoadoutEntry> >     loadoutCharacterTrackersValueSlotListMap

	table<ItemFlavor, ItemFlavor> frameCharacterMap
	table<ItemFlavor, ItemFlavor> stanceCharacterMap
	table<ItemFlavor, ItemFlavor> badgeCharacterMap
	table<ItemFlavor, ItemFlavor> trackerCharacterMap

	table<ItemFlavor, int> cosmeticFlavorSortOrdinalMap

	var currentMenuGladCardPanel
	#if CLIENT
		NestedGladiatorCardHandle& currentMenuGladCardHandle
	#elseif UI
		string currentMenuGladCardArgName
	#endif

	#if CLIENT
		var sidePaneRui = null

		//array<NestedGladiatorCardHandle>                     nestedCards
		table<EHI, array<NestedGladiatorCardHandle> > ownerNestedCardListMap

		bool                                 isCaptureThreadRunning = false
		table<string, CharacterCaptureState> ccsMap
		array<CharacterCaptureState>         ccsStillQueue
		CharacterCaptureState ornull         stillInProgress = null

		EHI situationPlayer

		#if(R5DEV)
			bool DEV_forceMoving = false
			bool DEV_showSafeAreaOverlay = false
			bool DEV_disableCameraAlpha = false
		#endif

		array<MenuGladCardPreviewCommand> menuGladCardPreviewCommandQueue
	#endif

	#if R5DEV
		bool DEV_forceEnabled = false
	#endif
}
FileStruct_LifetimeLevel& fileLevel
#endif



/////////////////////////
/////////////////////////
//// Initialiszation ////
/////////////////////////
/////////////////////////

#if UI
void function ShGladiatorCards_Init()
{
	AddUICallback_UIShutdown( ShGladiatorCards_UIShutdown )
}
#endif

void function ShGladiatorCards_LevelInit()
{
	FileStruct_LifetimeLevel newFileLevel
	fileLevel = newFileLevel

	#if CLIENT
		AddCallback_OnYouDied( OnYouDied )
		AddFirstPersonSpectateStartedCallback( OnSpectateStarted )
		AddThirdPersonSpectateStartedCallback( OnSpectateStarted )
		AddCallback_OnYouRespawned( OnYouRespawned ) // for dev
		AddCallback_OnPlayerLifeStateChanged( OnPlayerLifestateChanged )
		AddCallback_PlayerClassChanged( OnPlayerClassChanged )

		AddCallback_GameStateEnter( eGameState.WinnerDetermined, OnWinnerDetermined )

		RegisterSignal( "DisplayGladiatorCardSidePane" )
		RegisterSignal( "GladiatorCardShown" )
		RegisterSignal( "HideGladiatorCard" )
		RegisterSignal( "StopGladiatorCardCharacterCapture" )
		RegisterSignal( "ActualUpdateNestedGladiatorCard" )
		RegisterSignal( "YouMayProceedWithStillCCS" )
		RegisterSignal( "HaltMenuGladCardThread" )
	#endif

	AddCallback_OnItemFlavorRegistered( eItemType.character, OnItemFlavorRegistered_Character )

	#if SERVER
		for ( int trackerIndex = 0; trackerIndex < GLADIATOR_CARDS_NUM_TRACKERS; trackerIndex++ )
			RegisterSignal( "StopGladCardStatTracker" + trackerIndex )
	#endif
}


#if UI
void function ShGladiatorCards_LevelShutdown()
{
	if ( fileLevel.currentMenuGladCardPanel != null )
	{
		RuiDestroyNestedIfAlive( Hud_GetRui( fileLevel.currentMenuGladCardPanel ), fileLevel.currentMenuGladCardArgName )
		fileLevel.currentMenuGladCardPanel = null
		fileLevel.currentMenuGladCardArgName = ""
	}
}
#endif



//////////////////////////
//////////////////////////
//// Global functions ////
//////////////////////////
//////////////////////////

#if SERVER || CLIENT || UI
bool function AreGladiatorCardsEnabled()
{
	#if R5DEV
		if ( fileLevel.DEV_forceEnabled )
			return true
	#endif

	return GetCurrentPlaylistVarBool( "enable_gladiator_cards", true )
}
#endif


#if CLIENT
NestedGladiatorCardHandle function CreateNestedGladiatorCard( var parentRui, string argName, int situation, int presentation )
{
	NestedGladiatorCardHandle handle
	handle.parentRui = parentRui
	handle.argName = argName
	handle.currentOwnerEHI = EHI_null
	handle.situation = situation
	handle.isMoving = eGladCardDisplaySituation_IS_MOVING[situation]
	//fileLevel.nestedCards.append( handle )
	#if R5DEV
		handle.DEV_culprit = expect string(expect table(getstackinfos( 2 )).func)
	#endif

	ChangeNestedGladiatorCardPresentation( handle, presentation )

	return handle
}
#endif


#if CLIENT
void function CleanupNestedGladiatorCard( NestedGladiatorCardHandle handle, bool isParentAlreadyDead = false )
{
	if ( handle.parentRui == null || handle.cardRui == null )
		return

	Signal( handle, "StopGladiatorCardCharacterCapture" )

	ChangeNestedGladiatorCardOwner( handle, EHI_null )

	if ( !isParentAlreadyDead )
		RuiDestroyNested( handle.parentRui, handle.argName )
	handle.parentRui = null
	handle.cardRui = null

	if ( handle.framePakHandleOrNull != null )
	{
		ReleasePakFile( expect PakHandle(handle.framePakHandleOrNull) )
		handle.framePakHandleOrNull = null
	}

	//fileLevel.nestedCards.fastremovebyvalue( handle )
}
#endif


#if CLIENT
void function ChangeNestedGladiatorCardPresentation( NestedGladiatorCardHandle handle, int presentation )
{
	if ( handle.presentation == presentation )
		return
	handle.presentation = presentation
	handle.isFrontFace = (handle.presentation > eGladCardPresentation._MARK_FRONT_START && handle.presentation < eGladCardPresentation._MARK_FRONT_END)
	handle.isBackFace = (handle.presentation > eGladCardPresentation._MARK_BACK_START && handle.presentation < eGladCardPresentation._MARK_BACK_END)
	handle.shouldShowDetails = (handle.presentation == eGladCardPresentation.FRONT_DETAILS)

	if ( AreGladiatorCardsEnabled() )
	{
		asset ruiAsset = $""
		if ( handle.presentation == eGladCardPresentation.FULL_BOX )
			ruiAsset = $"ui/gladiator_card_full_box.rpak"
		else if ( handle.isFrontFace )
			ruiAsset = $"ui/gladiator_card_frontface.rpak"
		else if ( handle.isBackFace )
			ruiAsset = $"ui/gladiator_card_backface.rpak"

		if ( handle.cardRui != null )
		{
			RuiDestroyNested( handle.parentRui, handle.argName )
			handle.cardRui = null
			handle.fgFrameNWS.rui = null
			handle.bgFrameNWS.rui = null
			for ( int badgeIndex = 0; badgeIndex < GLADIATOR_CARDS_NUM_BADGES; badgeIndex++ )
				handle.badgeNWSList[badgeIndex].rui = null
		}
		if ( ruiAsset != $"" )
			handle.cardRui = RuiCreateNested( handle.parentRui, handle.argName, ruiAsset )
	}

	TriggerNestedGladiatorCardUpdate( handle )
}
#endif


#if CLIENT
void function ChangeNestedGladiatorCardOwner( NestedGladiatorCardHandle handle, EHI newOwnerEHI,
		float ornull startTimeOrNull = null, int lifestateOverride = eGladCardLifestateOverride.NONE )
{
	if ( handle.parentRui == null || handle.cardRui == null )
		return

	if ( handle.currentOwnerEHI != newOwnerEHI )
	{
		if ( handle.currentOwnerEHI != EHI_null )
		{
			array<NestedGladiatorCardHandle> currentOwnerNestedCardList = fileLevel.ownerNestedCardListMap[handle.currentOwnerEHI]
			currentOwnerNestedCardList.fastremovebyvalue( handle )
			if ( currentOwnerNestedCardList.len() == 0 )
				delete fileLevel.ownerNestedCardListMap[handle.currentOwnerEHI]
		}

		handle.currentOwnerEHI = newOwnerEHI

		if ( newOwnerEHI != EHI_null )
		{
			array<NestedGladiatorCardHandle> newOwnerNestedCardList
			if ( newOwnerEHI in fileLevel.ownerNestedCardListMap )
				newOwnerNestedCardList = fileLevel.ownerNestedCardListMap[newOwnerEHI]
			else
				fileLevel.ownerNestedCardListMap[newOwnerEHI] <- newOwnerNestedCardList
			newOwnerNestedCardList.append( handle )
		}
	}

	if ( handle.currentOwnerEHI != EHI_null )
	{
		handle.startTime = startTimeOrNull != null ? expect float( startTimeOrNull ) : Time()
		if ( handle.cardRui != null )
			RuiSetFloat( handle.cardRui, "startTime", handle.startTime )
	}

	handle.lifestateOverride = lifestateOverride

	TriggerNestedGladiatorCardUpdate( handle )
}
#endif


#if CLIENT
void function SetNestedGladiatorCardOverrideName( NestedGladiatorCardHandle handle, string ornull nameOrNull )
{
	handle.overrideName = nameOrNull
	TriggerNestedGladiatorCardUpdate( handle )
}
void function SetNestedGladiatorCardOverrideCharacter( NestedGladiatorCardHandle handle, ItemFlavor ornull characterOrNull )
{
	handle.overrideCharacter = characterOrNull
	TriggerNestedGladiatorCardUpdate( handle )
}
void function SetNestedGladiatorCardOverrideSkin( NestedGladiatorCardHandle handle, ItemFlavor ornull skinOrNull )
{
	handle.overrideSkin = skinOrNull
	TriggerNestedGladiatorCardUpdate( handle )
}
void function SetNestedGladiatorCardOverrideFrame( NestedGladiatorCardHandle handle, ItemFlavor ornull frameOrNull )
{
	handle.overrideFrame = frameOrNull
	TriggerNestedGladiatorCardUpdate( handle )
}
void function SetNestedGladiatorCardOverrideStance( NestedGladiatorCardHandle handle, ItemFlavor ornull stanceOrNull )
{
	handle.overrideStance = stanceOrNull
	TriggerNestedGladiatorCardUpdate( handle )
}
void function SetNestedGladiatorCardOverrideBadge( NestedGladiatorCardHandle handle, int badgeIndex, ItemFlavor ornull badgeOrNull, int dataInteger )
{
	handle.overrideBadgeList[badgeIndex] = badgeOrNull
	handle.overrideBadgeDataIntegerList[badgeIndex] = dataInteger
	TriggerNestedGladiatorCardUpdate( handle )
}
void function SetNestedGladiatorCardOverrideTracker( NestedGladiatorCardHandle handle, int trackerIndex, ItemFlavor ornull trackerOrNull, int dataInteger )
{
	handle.overrideTrackerList[trackerIndex] = trackerOrNull
	handle.overrideTrackerDataIntegerList[trackerIndex] = dataInteger
	TriggerNestedGladiatorCardUpdate( handle )
}
void function SetNestedGladiatorCardIsKiller( NestedGladiatorCardHandle handle, bool isKiller )
{
	handle.isKiller = isKiller
	TriggerNestedGladiatorCardUpdate( handle )
}
void function SetNestedGladiatorCardDisableBlur( NestedGladiatorCardHandle handle, bool disableBlur )
{
	handle.disableBlur = disableBlur
	TriggerNestedGladiatorCardUpdate( handle )
}
void function SetNestedGladiatorCardOverrideRankedShouldShow( NestedGladiatorCardHandle handle, int shouldShowData )
{
	handle.rankedForceShowOrNull = shouldShowData > 0
}
void function SetNestedGladiatorCardOverrideRankedDetails( NestedGladiatorCardHandle handle, int rankScore, int ladderPos )
{
	handle.rankedScoreOrNull = rankScore
	handle.rankedLadderPosOrNull = ladderPos
}
#endif


#if CLIENT || UI 
GladCardBadgeDisplayData function GetBadgeData( EHI playerEHI, ItemFlavor ornull character, int badgeIndex, ItemFlavor badge, int ornull overrideDataIntegerOrNull, bool TEMP_showOneTierHigherThanIsUnlocked = false )
{
	GladCardBadgeDisplayData badgeData

	if ( overrideDataIntegerOrNull != null )
		badgeData.dataInteger = expect int(overrideDataIntegerOrNull)
	else
		badgeData.dataInteger = GetPlayerBadgeDataInteger( playerEHI, badge, badgeIndex, character, TEMP_showOneTierHigherThanIsUnlocked )

	if ( badgeData.dataInteger == -1 ) //This should make a locked badge return an image
		badgeData.dataInteger = 0

	int tierIndex = badgeData.dataInteger
	if ( GladiatorCardBadge_GetDynamicTextStatRef( badge ) != "" )
		tierIndex = 0 // todo(dw): handle badges with both tiers and dynamic text

	array<GladCardBadgeTierData> tierDataList = GladiatorCardBadge_GetTierDataList( badge )
	if ( tierIndex in tierDataList )
	{
		if ( GladiatorCardBadge_HasOwnRUI( badge ) )
		{
			badgeData.ruiAsset = tierDataList[tierIndex].ruiAsset
		}
		else
		{
			if ( GladiatorCardBadge_IsOversizedImage( badge ) )
				badgeData.ruiAsset = $"ui/gcard_badge_oversized.rpak"
			else
				badgeData.ruiAsset = $"ui/gcard_badge_basic.rpak"

			badgeData.imageAsset = tierDataList[tierIndex].imageAsset
		}
	}

	return badgeData
}
#endif


#if CLIENT || UI 
var function CreateNestedGladiatorCardBadge( var parentRui, string argName, EHI playerEHI, ItemFlavor badge, int badgeIndex, ItemFlavor ornull character = null, int ornull overrideDataIntegerOrNull = null, bool TEMP_showOneTierHigherThanIsUnlocked = false )
{
	GladCardBadgeDisplayData gcbdd = GetBadgeData( playerEHI, character, badgeIndex, badge, overrideDataIntegerOrNull, TEMP_showOneTierHigherThanIsUnlocked )

	if ( gcbdd.ruiAsset == $"" )
	{
		gcbdd.ruiAsset = $"ui/gcard_badge_basic.rpak" // todo(dw): fix
		gcbdd.imageAsset = $"rui/gladiator_cards/badge_empty"
	}

	var nestedRui = RuiCreateNested( parentRui, argName, gcbdd.ruiAsset )

	RuiSetInt( nestedRui, "tier", gcbdd.dataInteger )
	if ( gcbdd.imageAsset != $"" )
		RuiSetImage( nestedRui, "img", gcbdd.imageAsset )

	return nestedRui
}
#endif


#if CLIENT
void function DisplayGladiatorCardSidePane( int situation, int playerEHI, asset icon, string titleText, string subtitleText )
{
	Signal( clGlobal.levelEnt, "DisplayGladiatorCardSidePane" )
	EndSignal( clGlobal.levelEnt, "DisplayGladiatorCardSidePane" )

	if ( GetBugReproNum() == 8675309 )
		fileLevel.sidePaneRui = CreateFullscreenPostFXRui( $"ui/gladiator_card_side_pane.rpak", RUI_SORT_GLADCARD )
	else
		fileLevel.sidePaneRui = CreateFullscreenRui( $"ui/gladiator_card_side_pane.rpak", RUI_SORT_GLADCARD )
	//fileLevel.sidePaneRui = RuiCreate( $"ui/gladiator_card_side_pane.rpak", clGlobal.topoFullScreen, RUI_DRAW_POSTEFFECTS, 200 )
	RuiSetImage( fileLevel.sidePaneRui, "titleIcon", icon )
	RuiSetString( fileLevel.sidePaneRui, "titleText", Localize( titleText ) ) // todo(dw): localize in RUI instead of here
	if ( EHIHasValidScriptStruct( playerEHI ) )
	{
		if ( situation == eGladCardDisplaySituation.DEATH_OVERLAY_ANIMATED )
			RuiSetString( fileLevel.sidePaneRui, "playerName", GetKillerName( playerEHI ) )
		else
			RuiSetString( fileLevel.sidePaneRui, "playerName", GetPlayerName( playerEHI ) )
	}

	//RuiSetFloat( fileLevel.sidePaneRui, "endTime", Time() + duration )
	//RuiSetResolution( rui_champion, float( screenSize.width ), float( screenSize.height ) ) // allows for letterbox pinning to work
	NestedGladiatorCardHandle nestedGCHandle = CreateNestedGladiatorCard( fileLevel.sidePaneRui, "card", situation, eGladCardPresentation.FULL_BOX )
	ChangeNestedGladiatorCardOwner( nestedGCHandle, playerEHI, null, eGladCardLifestateOverride.ALIVE )
	EmitSoundOnEntity( GetLocalClientPlayer(), "UI_Survival_Intro_Banner_Appear" )

	if ( situation == eGladCardDisplaySituation.DEATH_OVERLAY_ANIMATED )
		fileLevel.situationPlayer = playerEHI

	OnThreadEnd( void function() : ( nestedGCHandle ) {
		CleanupNestedGladiatorCard( nestedGCHandle )
		RuiDestroyIfAlive( fileLevel.sidePaneRui )
		fileLevel.sidePaneRui = null
		fileLevel.situationPlayer = EHI_null
	} )

	WaitForever()
}
#endif


#if CLIENT
entity function GetSituationPlayer()
{
	return FromEHI( fileLevel.situationPlayer )
}

void function OnWinnerDetermined()
{
	if ( IsSpectating() )	// stop glad card from going away if you just died.
		HideGladiatorCardSidePane()
}
#endif


#if CLIENT
void function HideGladiatorCardSidePane( bool instant = false )
{
	if ( !instant && fileLevel.sidePaneRui != null )
	{
		thread HideGladiatorCardSidePaneThreaded()
	}
	else
	{
		Signal( clGlobal.levelEnt, "DisplayGladiatorCardSidePane" )
	}
}
#endif


#if CLIENT
void function HideGladiatorCardSidePaneThreaded( float totalWaitTime = 1.1 )
{
	//RuiSetFloat( fileLevel.sidePaneRui, "endTime", Time() + totalWaitTime )
	wait totalWaitTime
	Signal( clGlobal.levelEnt, "DisplayGladiatorCardSidePane" )
}
#endif


#if UI
void function SetupMenuGladCard( var panel, string argName, bool isForLocalPlayer )
{
	fileLevel.currentMenuGladCardPanel = panel
	fileLevel.currentMenuGladCardArgName = argName
	RunClientScript( "UIToClient_SetupMenuGladCard", panel, argName, isForLocalPlayer, false )
}
#endif


#if UI
void function SendMenuGladCardPreviewCommand( int previewType, int index, ItemFlavor ornull flavOrNull, int dataInteger = -1 )
{
	Assert( CanRunClientScript() )
	Assert( fileLevel.currentMenuGladCardPanel != null )
	Assert( fileLevel.currentMenuGladCardArgName != "" )
	int guid = 0
	if ( flavOrNull != null )
		guid = ItemFlavor_GetGUID( expect ItemFlavor(flavOrNull) )
	RunClientScript( "UIToClient_HandleMenuGladCardPreviewCommand", previewType, index, guid, dataInteger )
}
#endif

#if UI
void function SendMenuGladCardPreviewString( int previewType, int index, string previewName )
{
	Assert( CanRunClientScript() )
	Assert( fileLevel.currentMenuGladCardPanel != null )
	Assert( fileLevel.currentMenuGladCardArgName != "" )
	RunClientScript( "UIToClient_HandleMenuGladCardPreviewString", previewType, index, previewName )
}
#endif


#if UI
void function ShGladiatorCards_UIShutdown()
{
	if ( CanRunClientScript() )
	{
		//SetupMenuGladCard( null, "" )
		fileLevel.currentMenuGladCardPanel = null
		fileLevel.currentMenuGladCardArgName = ""
		RunClientScript( "UIToClient_SetupMenuGladCard", null, "", true, true )
	}
}
#endif


const float LOADING_COVER_FADE_TIME = 0.13
const float LOADING_COVER_HOLD_TIME = 0.48
const float LOADING_COVER_OUT_TIME = LOADING_COVER_FADE_TIME + LOADING_COVER_HOLD_TIME


#if CLIENT
void function UIToClient_SetupMenuGladCard( var panel, string argName, bool isForLocalPlayer, bool isParentAlreadyDead )
{
	if ( !IsValidSignal( "HaltMenuGladCardThread" ) )
		return

	Signal( fileLevel, "HaltMenuGladCardThread" )

	if ( fileLevel.currentMenuGladCardPanel != null )
	{
		CleanupNestedGladiatorCard( fileLevel.currentMenuGladCardHandle, isParentAlreadyDead )
		fileLevel.currentMenuGladCardPanel = null
	}

	fileLevel.currentMenuGladCardPanel = panel
	if ( panel != null )
	{
		Hud_SetAboveBlur( panel, true )
		var rui = Hud_GetRui( panel )
		fileLevel.currentMenuGladCardHandle = CreateNestedGladiatorCard( rui, argName, eGladCardDisplaySituation.MENU_CUSTOMIZE_ANIMATED, eGladCardPresentation.FULL_BOX )
		thread MenuGladCardThread( isForLocalPlayer )
	}
}
#endif


#if CLIENT
void function MenuGladCardThread( bool isForLocalPlayer )
{
	EndSignal( fileLevel, "HaltMenuGladCardThread" )

	OnThreadEnd( void function() {
		fileLevel.menuGladCardPreviewCommandQueue.clear()
	} )

	ChangeNestedGladiatorCardOwner( fileLevel.currentMenuGladCardHandle, isForLocalPlayer ? WaitForLocalClientEHI() : ToEHI( clGlobal.levelEnt ), Time() )
	RuiSetGameTime( fileLevel.currentMenuGladCardHandle.cardRui, "menuGladCardRevealAt", Time() )



	while ( true )
	{
		while ( fileLevel.menuGladCardPreviewCommandQueue.len() == 0 )
			WaitFrame()

		bool commandsRequireFade = false
		foreach ( MenuGladCardPreviewCommand mgcpc in fileLevel.menuGladCardPreviewCommandQueue )
		{
			if ( mgcpc.previewType == eGladCardPreviewCommandType.FRAME || mgcpc.previewType == eGladCardPreviewCommandType.STANCE )
			{
				commandsRequireFade = true
				break
			}
		}

		if ( commandsRequireFade )
		{
			RuiSetGameTime( fileLevel.currentMenuGladCardHandle.cardRui, "menuGladCardRevealAt", Time() + LOADING_COVER_OUT_TIME )
			float loadTime = Time() + LOADING_COVER_FADE_TIME + 0.1
			float playTime = Time() + LOADING_COVER_OUT_TIME + 0.02 - 0.5
			while ( Time() < loadTime )
				WaitFrame()

			ChangeNestedGladiatorCardOwner( fileLevel.currentMenuGladCardHandle,
				fileLevel.currentMenuGladCardHandle.currentOwnerEHI,
				playTime )
		}

		while ( fileLevel.menuGladCardPreviewCommandQueue.len() > 0 )
		{
			MenuGladCardPreviewCommand mgcpc = fileLevel.menuGladCardPreviewCommandQueue.pop()
			switch( mgcpc.previewType )
			{
				case eGladCardPreviewCommandType.CHARACTER:
				{
					SetNestedGladiatorCardOverrideCharacter( fileLevel.currentMenuGladCardHandle, mgcpc.flavOrNull )
					break
				}

				case eGladCardPreviewCommandType.SKIN:
				{
					SetNestedGladiatorCardOverrideSkin( fileLevel.currentMenuGladCardHandle, mgcpc.flavOrNull )
					break
				}

				case eGladCardPreviewCommandType.FRAME:
				{
					SetNestedGladiatorCardOverrideFrame( fileLevel.currentMenuGladCardHandle, mgcpc.flavOrNull )
					break
				}

				case eGladCardPreviewCommandType.STANCE:
				{
					SetNestedGladiatorCardOverrideStance( fileLevel.currentMenuGladCardHandle, mgcpc.flavOrNull )
					break
				}

				case eGladCardPreviewCommandType.BADGE:
				{
					SetNestedGladiatorCardOverrideBadge( fileLevel.currentMenuGladCardHandle, mgcpc.index, mgcpc.flavOrNull, mgcpc.dataInteger )
					break
				}

				case eGladCardPreviewCommandType.TRACKER:
				{
					SetNestedGladiatorCardOverrideTracker( fileLevel.currentMenuGladCardHandle, mgcpc.index, mgcpc.flavOrNull, mgcpc.dataInteger )
					break
				}

				case eGladCardPreviewCommandType.NAME:
				{
					SetNestedGladiatorCardOverrideName( fileLevel.currentMenuGladCardHandle, mgcpc.previewString )
					break
				}

				case eGladCardPreviewCommandType.RANKED_SHOULD_SHOW:
				{
					SetNestedGladiatorCardOverrideRankedShouldShow( fileLevel.currentMenuGladCardHandle, mgcpc.index )
					break
				}

				case eGladCardPreviewCommandType.RANKED_DATA:
				{
					SetNestedGladiatorCardOverrideRankedDetails( fileLevel.currentMenuGladCardHandle, mgcpc.dataInteger, mgcpc.index )
					break
				}
			}
		}
	}
}
#endif

#if(CLIENT)
void function GladCardDebug()
{
	printt( "GladCard:" )

	LoadoutEntry characterSlot = Loadout_CharacterClass()

	ItemFlavor character = LoadoutSlot_GetItemFlavor( LocalClientEHI(), characterSlot )

	LoadoutEntry skinSlot = Loadout_CharacterSkin( character )
	ItemFlavor skin       = LoadoutSlot_GetItemFlavor( LocalClientEHI(), skinSlot )

	LoadoutEntry frameSlot = Loadout_GladiatorCardFrame( character )
	ItemFlavor frame       = LoadoutSlot_GetItemFlavor( LocalClientEHI(), frameSlot )


	LoadoutEntry stanceSlot = Loadout_GladiatorCardStance( character )
	ItemFlavor stance       = LoadoutSlot_GetItemFlavor( LocalClientEHI(), stanceSlot )


	LoadoutEntry badge1Slot = Loadout_GladiatorCardBadge( character, 0 )
	ItemFlavor badge1       = LoadoutSlot_GetItemFlavor( LocalClientEHI(), badge1Slot )
	int badge1DataInt       = GetPlayerBadgeDataInteger( LocalClientEHI(), badge1, 0, character )

	LoadoutEntry badge2Slot = Loadout_GladiatorCardBadge( character, 1 )
	ItemFlavor badge2       = LoadoutSlot_GetItemFlavor( LocalClientEHI(), badge2Slot )
	int badge2DataInt       = GetPlayerBadgeDataInteger( LocalClientEHI(), badge2, 1, character )


	LoadoutEntry badge3Slot = Loadout_GladiatorCardBadge( character, 2 )
	ItemFlavor badge3       = LoadoutSlot_GetItemFlavor( LocalClientEHI(), badge3Slot )
	int badge3DataInt       = GetPlayerBadgeDataInteger( LocalClientEHI(), badge3, 2, character )


	printt( GetPlayerName( LocalClientEHI() ) + "," + ItemFlavor_GetHumanReadableRef( character ) + "," + ItemFlavor_GetHumanReadableRef( skin ) + ","
			+ ItemFlavor_GetHumanReadableRef( frame ) + "," + ItemFlavor_GetHumanReadableRef( stance ) + "," + ItemFlavor_GetHumanReadableRef( badge1 ) + ","
			+ badge1DataInt + "," + ItemFlavor_GetHumanReadableRef( badge2 ) + "," + badge2DataInt + "," + ItemFlavor_GetHumanReadableRef( badge3 ) + "," + badge3DataInt )
}
#endif


#if(CLIENT)
void function UIToClient_HandleMenuGladCardPreviewCommand( int previewType, int index, int guid, int dataInteger )
{
	ItemFlavor ornull flavOrNull
	if ( guid != 0 )
		flavOrNull = GetItemFlavorByGUID( guid )

	Assert( fileLevel.currentMenuGladCardPanel != null )

	MenuGladCardPreviewCommand mgcpc
	mgcpc.previewType = previewType
	mgcpc.index = index
	mgcpc.flavOrNull = flavOrNull
	mgcpc.dataInteger = dataInteger
	fileLevel.menuGladCardPreviewCommandQueue.append( mgcpc )
}
#endif


#if CLIENT
void function UIToClient_HandleMenuGladCardPreviewString( int previewType, int index, string previewName )
{
	Assert( fileLevel.currentMenuGladCardPanel != null )
	Assert( previewType == eGladCardPreviewCommandType.NAME )

	MenuGladCardPreviewCommand mgcpc
	mgcpc.previewType = previewType
	mgcpc.index = index
	mgcpc.flavOrNull = null
	mgcpc.previewString = previewName
	fileLevel.menuGladCardPreviewCommandQueue.append( mgcpc )
}
#endif



///////////////////////
///////////////////////
//// Dev functions ////
///////////////////////
///////////////////////
#if CLIENT && R5DEV
void function DEV_DumpCharacterCaptures()
{
	foreach( string key, CharacterCaptureState ccs in fileLevel.ccsMap )
	{
		printf( "%s -- %s", key, DEV_ArrayConcat( ccs.DEV_culprits ) )
		printf( "%s, %s, %s, %s, %s, %s", string(FromEHI( ccs.playerEHI )), ccs.isMoving ? "moving" : "still",
			ItemFlavor_GetHumanReadableRef( ccs.character ), ItemFlavor_GetHumanReadableRef( ccs.skin ), ccs.frameOrNull == null ? "null" : ItemFlavor_GetHumanReadableRef( expect ItemFlavor(ccs.frameOrNull) ), ItemFlavor_GetHumanReadableRef( ccs.stance ) )
	}
}
#endif


#if CLIENT && R5DEV
void function DEV_GladiatorCards_ToggleForceMoving( bool ornull forceTo = null )
{
	fileLevel.DEV_forceMoving = (forceTo != null ? expect bool(forceTo) : !fileLevel.DEV_forceMoving)
}
#endif


#if CLIENT && R5DEV
void function DEV_GladiatorCards_ToggleShowSafeAreaOverlay( bool ornull forceTo = null )
{
	fileLevel.DEV_showSafeAreaOverlay = (forceTo != null ? expect bool(forceTo) : !fileLevel.DEV_showSafeAreaOverlay)

	foreach( EHI unused, array<NestedGladiatorCardHandle> handleList in fileLevel.ownerNestedCardListMap )
	{
		foreach( NestedGladiatorCardHandle handle in handleList )
		{
			TriggerNestedGladiatorCardUpdate( handle )
		}
	}
}
#endif


#if CLIENT && R5DEV
void function DEV_GladiatorCards_ToggleCameraAlpha( bool ornull forceTo = null )
{
	fileLevel.DEV_disableCameraAlpha = (forceTo != null ? expect bool(forceTo) : !fileLevel.DEV_disableCameraAlpha)
}
#endif


#if R5DEV
void function DEV_ForceEnableGladiatorCards()
{
	fileLevel.DEV_forceEnabled = true
}
#endif


///////////////////
///////////////////
//// Internals ////
///////////////////
///////////////////

#if SERVER || CLIENT || UI
void function OnItemFlavorRegistered_Character( ItemFlavor characterClass )
{
	#if CLIENT
		AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( Loadout_CharacterSkin( characterClass ), OnGladiatorCardSlotChanged )
	#endif

	//RegisterReferencedItemFlavorsFromArray( flavor, "gcardBadges", "flavor", "featureFlag" )
	//RegisterReferencedItemFlavorsFromArray( flavor, "gcardStatTrackers", "flavor", "featureFlag" )

	// frame
	{
		array<ItemFlavor> frameList = RegisterReferencedItemFlavorsFromArray( characterClass, "gcardFrames", "flavor", "featureFlag" )
		MakeItemFlavorSet( frameList, fileLevel.cosmeticFlavorSortOrdinalMap )
		foreach( ItemFlavor frame in frameList )
			fileLevel.frameCharacterMap[frame] <- characterClass

		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "gcard_frame", ItemFlavor_GetGUIDString( characterClass ) )
		entry.DEV_category = "gcard_frames"
		entry.DEV_name = ItemFlavor_GetHumanReadableRef( characterClass ) + " GCard Frame"
		entry.stryderCharDataArrayIndex = ePlayerStryderCharDataArraySlots.BANNER_FRAME
		entry.defaultItemFlavor = frameList[0]//GetItemFlavorByAsset( $"settings/itemflav/gladiator_card_frame/all_proto_default.rpak" )
		entry.validItemFlavorList = frameList
		entry.isSlotLocked = bool function( EHI playerEHI ) {
			return !IsLobby()
		}
		entry.isActiveConditions = { [Loadout_CharacterClass()] = { [characterClass] = true, }, }
		entry.networkTo = eLoadoutNetworking.PLAYER_GLOBAL
		entry.networkVarName = "GladiatorCardFrame"
		#if CLIENT
			AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( entry, OnGladiatorCardSlotChanged )
		#endif
		fileLevel.loadoutCharacterFrameSlotMap[characterClass] <- entry
	}

	// stances
	{
		array<ItemFlavor> stanceList = RegisterReferencedItemFlavorsFromArray( characterClass, "gcardStances", "flavor", "featureFlag" )
		MakeItemFlavorSet( stanceList, fileLevel.cosmeticFlavorSortOrdinalMap )
		foreach( ItemFlavor stance in stanceList )
			fileLevel.stanceCharacterMap[stance] <- characterClass

		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "gcard_stance", ItemFlavor_GetGUIDString( characterClass ) )
		entry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
		entry.DEV_category = "gcard_stances"
		entry.DEV_name = ItemFlavor_GetHumanReadableRef( characterClass ) + " GCard Stance"
		entry.stryderCharDataArrayIndex = ePlayerStryderCharDataArraySlots.BANNER_STANCE
		entry.defaultItemFlavor = stanceList[0]//GetItemFlavorByAsset( $"settings/itemflav/gladiator_card_stance/all_proto_default.rpak" )
		entry.validItemFlavorList = stanceList
		entry.isSlotLocked = bool function( EHI playerEHI ) {
			return !IsLobby()
		}
		entry.isActiveConditions = { [Loadout_CharacterClass()] = { [characterClass] = true, }, }
		entry.networkTo = eLoadoutNetworking.PLAYER_GLOBAL
		entry.networkVarName = "GladiatorCardStance"
		#if CLIENT
			AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( entry, OnGladiatorCardSlotChanged )
		#endif
		fileLevel.loadoutCharacterStanceSlotMap[characterClass] <- entry
	}

	array<ItemFlavor> badgeList = RegisterReferencedItemFlavorsFromArray( characterClass, "gcardBadges", "flavor", "featureFlag" )
	foreach( int index, ItemFlavor badge in badgeList )
	{
		Assert( GladiatorCardBadge_IsTheEmpty( badge ) == (index == 0), "The first (and only the first) badge in the _base character should be the _empty badge." )
		fileLevel.badgeCharacterMap[badge] <- characterClass
	}

	#if SERVER && R5DEV
		AddCallback_EntitiesDidLoad( void function() : ( badgeList ) {
			// these checks need to be done after script init
			foreach ( ItemFlavor badge in badgeList )
			{
				// todo(dw): uncomment this
				//Assert( IsValidStatEntryRef( GladiatorCardBadge_GetUnlockStatRef( badge ) ), "Badge '" + ItemFlavor_GetRef( badge ) + "' refers to non-existant stat: '" + GladiatorCardBadge_GetUnlockStatRef( badge ) + "'" )
				//string dynamicTextStatRef = GladiatorCardBadge_GetDynamicTextStatRef( badge )
				//if ( dynamicTextStatRef != "" )
				//	Assert( IsValidStatEntryRef( GladiatorCardBadge_GetDynamicTextStatRef( badge ) ), "Badge '" + ItemFlavor_GetRef( badge ) + "' refers to non-existant stat: '" + GladiatorCardBadge_GetDynamicTextStatRef( badge ) + "'" )
			}
		} )
	#endif

	MakeItemFlavorSet( badgeList, fileLevel.cosmeticFlavorSortOrdinalMap )
	fileLevel.loadoutCharacterBadgesSlotListMap[characterClass] <- []
	fileLevel.loadoutCharacterBadgesTierSlotListMap[characterClass] <- []

	for ( int badgeIndex = 0; badgeIndex < GLADIATOR_CARDS_NUM_BADGES; badgeIndex++ )
	{
		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "gcard_badge_" + badgeIndex, ItemFlavor_GetGUIDString( characterClass ) )
		entry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
		entry.DEV_category = "gcard_badges"
		entry.DEV_name = ItemFlavor_GetHumanReadableRef( characterClass ) + " GCard Badge " + badgeIndex
		entry.stryderCharDataArrayIndex = ePlayerStryderCharDataArraySlots.BANNER_BADGE1 + 2 * badgeIndex
		entry.validItemFlavorList = badgeList
		if ( badgeIndex == 0 && badgeList.len() > 1 )
		{
			entry.defaultItemFlavor = entry.validItemFlavorList[ 1 ]
		}
		else
		{
			entry.defaultItemFlavor = entry.validItemFlavorList[ 0 ]
		}
		entry.isItemFlavorUnlocked = (bool function( EHI playerEHI, ItemFlavor badge, bool shouldIgnoreOtherSlots ) : ( characterClass, badgeIndex ) {
			int tierIndex = GetPlayerBadgeDataInteger( playerEHI, badge, badgeIndex, characterClass )

			if ( IsEverythingUnlocked() )
				return true

			return (tierIndex >= 0)
		})
		entry.isSlotLocked = bool function( EHI playerEHI ) {
			return !IsLobby()
		}
		entry.isActiveConditions = { [Loadout_CharacterClass()] = { [characterClass] = true, }, }
		entry.networkTo = eLoadoutNetworking.PLAYER_GLOBAL
		entry.networkVarName = "GladiatorCardBadge" + badgeIndex
		#if CLIENT
			AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( entry, OnGladiatorCardSlotChanged )
		#endif
		#if SERVER
			AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( entry, void function( EHI playerEHI, ItemFlavor badge ) : ( badgeIndex ) {
				ManageGladiatorCardBadgeState( playerEHI, badgeIndex, badge )
			} )
		#endif

		fileLevel.loadoutCharacterBadgesSlotListMap[characterClass].append( entry )

		LoadoutEntry tierEntry = RegisterLoadoutSlot( eLoadoutEntryType.INTEGER, "gcard_badge_" + badgeIndex + "_tier", ItemFlavor_GetGUIDString( characterClass ) )
		tierEntry.DEV_category = "gcard_badge_tier"
		tierEntry.DEV_name = ItemFlavor_GetHumanReadableRef( characterClass ) + " GCard Badge" + badgeIndex + " Tier"
		tierEntry.stryderCharDataArrayIndex = ePlayerStryderCharDataArraySlots.BANNER_BADGE1_TIER + 2 * badgeIndex
		tierEntry.minInteger = 0
		tierEntry.maxInteger = INT_MAX
		tierEntry.defaultInteger = 0
		//tierEntry.TEMP_doNotValidateLocking = true
		tierEntry.isActiveConditions = { [Loadout_CharacterClass()] = { [characterClass] = true, }, }
		tierEntry.networkTo = eLoadoutNetworking.PLAYER_GLOBAL
		tierEntry.networkVarName = "GladiatorCardBadge" + badgeIndex + "Tier"
		#if CLIENT
			//AddCallback_LoadoutSlotDidChange_AnyPlayer( tierEntry, OnGladiatorCardSlotChanged )
		#endif
		#if SERVER
			//AddCallback_LoadoutSlotDidChange_AnyPlayer( entry, OnGladiatorCardSlotChanged )
		#endif

		fileLevel.loadoutCharacterBadgesTierSlotListMap[characterClass].append( tierEntry )
	}

	array<ItemFlavor> trackerList = RegisterReferencedItemFlavorsFromArray( characterClass, "gcardStatTrackers", "flavor", "featureFlag" )
	foreach( int index, ItemFlavor tracker in trackerList )
	{
		Assert( GladiatorCardTracker_IsTheEmpty( tracker ) == (index == 0), "The first (and only the first tracker) in the _base character should be the _empty tracker." )
		fileLevel.trackerCharacterMap[tracker] <- characterClass
	}

	#if SERVER && R5DEV
		AddCallback_EntitiesDidLoad( void function() : ( trackerList, characterClass ) {
			// these checks need to be done after script init
			foreach ( ItemFlavor tracker in trackerList )
			{
				string statRef = GladiatorCardStatTracker_GetStatRef( tracker, characterClass )
				Assert( IsValidStatEntryRef( statRef ) || GladiatorCardTracker_IsTheEmpty( tracker )
					, "Stat tracker '" + ItemFlavor_GetHumanReadableRef( tracker ) + "' refers to non-existant stat: '" + statRef + "'" )
			}
		} )
	#endif

	MakeItemFlavorSet( trackerList, fileLevel.cosmeticFlavorSortOrdinalMap )
	fileLevel.loadoutCharacterTrackersSlotListMap[characterClass] <- []
	fileLevel.loadoutCharacterTrackersValueSlotListMap[characterClass] <- []

	for ( int trackerIndex = 0; trackerIndex < GLADIATOR_CARDS_NUM_TRACKERS; trackerIndex++ )
	{
		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "gcard_tracker_" + trackerIndex, ItemFlavor_GetGUIDString( characterClass ) )
		entry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
		entry.DEV_category = "gcard_trackers"
		entry.DEV_name = ItemFlavor_GetHumanReadableRef( characterClass ) + " GCard Tracker " + trackerIndex
		entry.stryderCharDataArrayIndex = ePlayerStryderCharDataArraySlots.BANNER_TRACKER1 + 2 * trackerIndex
		entry.validItemFlavorList = trackerList
		if ( trackerIndex == 0 && trackerList.len() > 1 )
		{
			entry.defaultItemFlavor = entry.validItemFlavorList[ 1 ]
		}
		else
		{
			entry.defaultItemFlavor = entry.validItemFlavorList[ 0 ]
		}
		entry.isSlotLocked = bool function( EHI playerEHI ) {
			return !IsLobby()
		}
		entry.isActiveConditions = { [Loadout_CharacterClass()] = { [characterClass] = true, }, }
		entry.networkTo = eLoadoutNetworking.PLAYER_GLOBAL
		entry.networkVarName = "GladiatorCardTracker" + trackerIndex
		#if CLIENT
			AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( entry, OnGladiatorCardSlotChanged )
		#endif
		fileLevel.loadoutCharacterTrackersSlotListMap[characterClass].append( entry )

		LoadoutEntry valueEntry = RegisterLoadoutSlot( eLoadoutEntryType.INTEGER, "gcard_tracker_" + trackerIndex + "_value", ItemFlavor_GetGUIDString( characterClass ) )
		valueEntry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
		valueEntry.DEV_category = "gcard_tracker_tier"
		valueEntry.DEV_name = ItemFlavor_GetHumanReadableRef( characterClass ) + " GCard Tracker" + trackerIndex + " Value"
		valueEntry.stryderCharDataArrayIndex = ePlayerStryderCharDataArraySlots.BANNER_TRACKER1_VALUE + 2 * trackerIndex
		valueEntry.minInteger = 0
		valueEntry.maxInteger = INT_MAX
		valueEntry.defaultInteger = 0
		//valueEntry.TEMP_doNotValidateLocking = true
		valueEntry.isActiveConditions = { [Loadout_CharacterClass()] = { [characterClass] = true, }, }
		valueEntry.networkTo = eLoadoutNetworking.PLAYER_GLOBAL
		valueEntry.networkVarName = "GladiatorCardTracker" + trackerIndex + "Value"
		#if CLIENT
			AddCallback_IntegerLoadoutSlotDidChange_AnyPlayer( valueEntry, void function( EHI playerEHI, int value ) : ( trackerIndex ) {
				OnGladiatorCardStatTrackerValueChanged( playerEHI, value, trackerIndex )
			} )
		#endif
		#if SERVER
			//AddCallback_LoadoutSlotDidChange_AnyPlayer( entry, OnGladiatorCardSlotChanged )
		#endif

		fileLevel.loadoutCharacterTrackersValueSlotListMap[characterClass].append( valueEntry )


		#if SERVER
			AddCallback_ItemFlavorLoadoutSlotDidChange_AnyPlayer( entry, void function( EHI playerEHI, ItemFlavor tracker ) : ( characterClass, trackerIndex, valueEntry ) {
				ManageGladiatorCardTrackerState( characterClass, playerEHI, trackerIndex, tracker, valueEntry )
			} )
		#endif
	}
}
#endif


#if CLIENT
void function OnYouDied( entity attacker, float healthFrac, int damageSourceId, float recentHealthDamage )
{
	if ( GetGameState() != eGameState.Playing )
		return

	if ( !IsValid( attacker ) || !attacker.IsPlayer() )
		return

	thread PlayKillQuipThread( GetLocalClientPlayer(), ToEHI( attacker ), null, 2.0 )
}
#endif


#if CLIENT
void function OnSpectateStarted( entity spectatingPlayer, entity spectatorTarget )
{
	//clGlobal.levelEnt.Signal( "HideGladiatorCard" )
	HideGladiatorCardSidePane( true )
}
#endif


#if CLIENT
void function OnYouRespawned()
{
	// hide card when respawning in dev mode
	//clGlobal.levelEnt.Signal( "HideGladiatorCard" )
	HideGladiatorCardSidePane( true )
}
#endif


#if SERVER
void function ManageGladiatorCardBadgeState( EHI playerEHI, int badgeIndex, ItemFlavor badge )
{
	// We need to update the player's appropriate badge tier loadout slot with the data for their newly selected badge.

	ItemFlavor character = LoadoutSlot_GetItemFlavor( playerEHI, Loadout_CharacterClass() )
	LoadoutEntry entry   = Loadout_GladiatorCardBadgeTier( character, badgeIndex )

	int tier = GetPlayerBadgeDataInteger( playerEHI, badge, badgeIndex, character )
	SetIntegerLoadoutSlot( playerEHI, entry, tier == -1 ? 0 : tier )
}
#endif


#if SERVER
void function ManageGladiatorCardTrackerState( ItemFlavor character, EHI playerEHI, int trackerIndex, ItemFlavor tracker, LoadoutEntry valueEntry )
{
	entity player = FromEHI( playerEHI )

	string desiredStatRef = ""
	if ( !GladiatorCardTracker_IsTheEmpty( tracker ) )
		desiredStatRef = GladiatorCardStatTracker_GetStatRef( tracker, character )

	int currentStatEntryIndex = player.p.activeGladiatorCardStatTrackerEntries[trackerIndex]
	if ( currentStatEntryIndex != -1 )
	{
		StatEntry currentStat = GetStatEntryByIndex( currentStatEntryIndex )
		if ( StatEntry_GetRef( currentStat ) == desiredStatRef )
			return // no change

		Signal( player, "StopGladCardStatTracker" + trackerIndex )
	}

	if ( desiredStatRef != "" )
	{
		StatEntry desiredStat = GetStatEntryByRef( desiredStatRef )
		player.p.activeGladiatorCardStatTrackerEntries[trackerIndex] = StatEntry_GetIndex( desiredStat )
		thread RunGladCardStatTracker( player, trackerIndex, desiredStat, valueEntry )
	}
}
#endif


#if SERVER
void function RunGladCardStatTracker( entity player, int trackerIndex, StatEntry stat, LoadoutEntry valueEntry )
{
	EndSignal( player, "OnDestroy" )
	EndSignal( player, "StopGladCardStatTracker" + trackerIndex )

	if ( StatEntry_GetType( stat ) == eStatType.INT )
	{
		void functionref( entity, int, int ) cb = void function( entity player, int oldValue, int newValue ) : ( valueEntry ) {
			//player.SetPlayerNetInt( networkVarName, newValue * GLADIATOR_CARDS_STAT_TRACKER_MAX_PRECISION )
			SetIntegerLoadoutSlot( ToEHI( player ), valueEntry, int(float(newValue) * GLADIATOR_CARDS_STAT_TRACKER_MAX_PRECISION) )
		}
		OnThreadEnd( void function() : ( player, trackerIndex, stat, cb ) {
			RemoveCallback_StatChanged_Int( player, stat, cb )

			player.p.activeGladiatorCardStatTrackerEntries[trackerIndex] = -1
		} )
		AddCallback_StatChanged_Int( player, stat, cb )
		cb( player, -1, GetStat_Int( player, stat ) )
	}
	else if ( StatEntry_GetType( stat ) == eStatType.FLOAT )
	{
		void functionref( entity, float, float ) cb = void function( entity player, float oldValue, float newValue ) : ( valueEntry ) {
			//player.SetPlayerNetInt( networkVarName, int(newValue * GLADIATOR_CARDS_STAT_TRACKER_MAX_PRECISION) )
			SetIntegerLoadoutSlot( ToEHI( player ), valueEntry, int(newValue * GLADIATOR_CARDS_STAT_TRACKER_MAX_PRECISION) )
		}
		OnThreadEnd( void function() : ( player, trackerIndex, stat, cb ) {
			RemoveCallback_StatChanged_Float( player, stat, cb )

			player.p.activeGladiatorCardStatTrackerEntries[trackerIndex] = -1
		} )
		AddCallback_StatChanged_Float( player, stat, cb )
		cb( player, -1.0, GetStat_Float( player, stat ) )
	}

	WaitForever()
}
#endif


#if CLIENT
void function TriggerNestedGladiatorCardUpdate( NestedGladiatorCardHandle handle )
{
	if ( handle.updateQueued )
		return

	handle.updateQueued = true
	thread ActualUpdateNestedGladiatorCard( handle )
}
#endif


#if CLIENT
void function ActualUpdateNestedGladiatorCard( NestedGladiatorCardHandle handle )
{
	WaitEndFrame()
	handle.updateQueued = false

	Signal( handle, "ActualUpdateNestedGladiatorCard" )

	ItemFlavor ornull characterOrNull = null
	ItemFlavor ornull skinOrNull      = null
	ItemFlavor ornull frameOrNull     = null
	ItemFlavor ornull stanceOrNull    = null

	int ornull rankedScoreOrNull     = null
	int ornull rankedLadderPosOrNull = null

	string frameRpakPath                               = ""
	bool frameHasOwnRUI                                = false
	bool isArtFullFrame                                = false
	asset fgFrameRuiAsset                              = $""
	asset fgFrameImageAsset                            = $""
	float fgFrameBlend                                 = 1.0
	float fgFramePremul                                = 0.0
	asset bgFrameRuiAsset                              = $""
	asset bgFrameImageAsset                            = $""
	int[GLADIATOR_CARDS_NUM_BADGES] badgeTiers         = [ -1, -1, -1 ]
	asset[GLADIATOR_CARDS_NUM_BADGES] badgeRuiAssets   = [ $"", $"", $"" ]
	asset[GLADIATOR_CARDS_NUM_BADGES] badgeImageAssets = [ $"", $"", $"" ]

	vector[GLADIATOR_CARDS_NUM_FRAME_KEY_COLORS] keyColors

	bool isAlive        = false
	string playerName   = ""
	int teamMemberIndex = -1

	if ( handle.cardRui != null )
	{
		bool havePlayer = (handle.currentOwnerEHI != EHI_null)
		if ( havePlayer )
		{
			entity currentOwner = FromEHI( handle.currentOwnerEHI )

			isAlive = IsAlive( currentOwner )

			if ( handle.overrideName != null )
			{
				playerName = expect string(handle.overrideName)
			}
			else if ( EHIHasValidScriptStruct( handle.currentOwnerEHI ) )
			{
				if ( handle.situation == eGladCardDisplaySituation.DEATH_OVERLAY_ANIMATED || handle.isKiller )
					playerName = GetKillerName( handle.currentOwnerEHI )
				else
					playerName = GetPlayerName( handle.currentOwnerEHI )
			}

			if ( EHIHasValidScriptStruct( handle.currentOwnerEHI ) )
				teamMemberIndex = EHI_GetTeamMemberIndex( handle.currentOwnerEHI )
		}

		if ( handle.overrideCharacter != null )
			characterOrNull = handle.overrideCharacter

		LoadoutEntry characterSlot = Loadout_CharacterClass()
		if ( characterOrNull == null && havePlayer && LoadoutSlot_IsReady( handle.currentOwnerEHI, characterSlot ) )
			characterOrNull = LoadoutSlot_GetItemFlavor( handle.currentOwnerEHI, characterSlot )

		if ( characterOrNull != null )
		{
			ItemFlavor character = expect ItemFlavor(characterOrNull)

			if ( handle.isFrontFace )
			{
				if ( handle.overrideSkin != null )
					skinOrNull = handle.overrideSkin

				LoadoutEntry skinSlot = Loadout_CharacterSkin( character )
				if ( skinOrNull == null && havePlayer && LoadoutSlot_IsReady( handle.currentOwnerEHI, skinSlot ) )
					skinOrNull = LoadoutSlot_GetItemFlavor( handle.currentOwnerEHI, skinSlot )

				if ( handle.presentation != eGladCardPresentation.FRONT_FRAME_ONLY )
				{
					if ( handle.overrideStance != null )
					{
						stanceOrNull = handle.overrideStance
						if ( GladiatorCardStance_GetCharacterFlavor( expect ItemFlavor(stanceOrNull) ) != characterOrNull )
						{
							Warning( "Attempted to use gladiator card stance %s on %s", ItemFlavor_GetHumanReadableRef( expect ItemFlavor(stanceOrNull) ), ItemFlavor_GetHumanReadableRef( character ) )
							stanceOrNull = null
						}
					}

					LoadoutEntry stanceSlot = Loadout_GladiatorCardStance( character )
					if ( stanceOrNull == null && havePlayer && LoadoutSlot_IsReady( handle.currentOwnerEHI, stanceSlot ) )
						stanceOrNull = LoadoutSlot_GetItemFlavor( handle.currentOwnerEHI, stanceSlot )
				}

				if ( handle.overrideFrame != null )
					frameOrNull = handle.overrideFrame

				LoadoutEntry frameSlot = Loadout_GladiatorCardFrame( character )
				if ( frameOrNull == null && havePlayer && LoadoutSlot_IsReady( handle.currentOwnerEHI, frameSlot ) )
				{
					frameOrNull = LoadoutSlot_GetItemFlavor( handle.currentOwnerEHI, frameSlot )
				}
			}

			bool wantsBadges = handle.isBackFace || handle.presentation == eGladCardPresentation.FRONT_DETAILS
			if ( wantsBadges )
			{
				for ( int badgeIndex = 0; badgeIndex < GLADIATOR_CARDS_NUM_BADGES; badgeIndex++ )
				{
					ItemFlavor ornull badgeOrNull = null

					int ornull overrideDataIntegerOrNull = null
					if ( handle.overrideBadgeList[badgeIndex] != null )
					{
						badgeOrNull = handle.overrideBadgeList[badgeIndex]
						overrideDataIntegerOrNull = handle.overrideBadgeDataIntegerList[badgeIndex]
					}

					LoadoutEntry badgeSlot = Loadout_GladiatorCardBadge( character, badgeIndex )
					if ( badgeOrNull == null && havePlayer && LoadoutSlot_IsReady( handle.currentOwnerEHI, badgeSlot ) )
					{
						badgeOrNull = LoadoutSlot_GetItemFlavor( handle.currentOwnerEHI, badgeSlot )
					}

					if ( badgeOrNull != null )
					{
						ItemFlavor badge               = expect ItemFlavor(badgeOrNull)
						GladCardBadgeDisplayData gcbdd = GetBadgeData( handle.currentOwnerEHI, character, badgeIndex, badge, overrideDataIntegerOrNull )
						badgeRuiAssets[badgeIndex] = gcbdd.ruiAsset
						badgeImageAssets[badgeIndex] = gcbdd.imageAsset
						badgeTiers[badgeIndex] = gcbdd.dataInteger
					}
				}
			}
		}

		if ( handle.presentation == eGladCardPresentation.FULL_BOX )
		{
			rankedScoreOrNull = handle.rankedScoreOrNull
			rankedLadderPosOrNull = handle.rankedLadderPosOrNull
		}
	}

	//printt( "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! character:", characterOrNull == null ? "null" : ItemFlavor_GetRef( expect ItemFlavor(characterOrNull) ) )
	//printt( "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! skin:", skinOrNull == null ? "null" : ItemFlavor_GetRef( expect ItemFlavor(skinOrNull) ) )
	//printt( "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! frame:", frameOrNull == null ? "null" : ItemFlavor_GetRef( expect ItemFlavor(frameOrNull) ) )
	//printt( "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! stance:", stanceOrNull == null ? "null" : ItemFlavor_GetRef( expect ItemFlavor(stanceOrNull) ) )


	if ( handle.presentation == eGladCardPresentation.FRONT_STANCE_ONLY )
	{
		fgFrameRuiAsset = $"ui/gcard_frame_stance_preview.rpak"
		bgFrameRuiAsset = $""
	}
	else if ( frameOrNull != null )
	{
		ItemFlavor frame = expect ItemFlavor(frameOrNull)
		frameRpakPath = ItemFlavor_GetHumanReadableRef( frame )
		if ( frameRpakPath == "gcard_frame__temp" )
			frameRpakPath = ""

		if ( GladiatorCardFrame_HasOwnRUI( frame ) )
		{
			frameHasOwnRUI = true
			fgFrameRuiAsset = GladiatorCardFrame_GetFGRuiAsset( frame )
			bgFrameRuiAsset = GladiatorCardFrame_GetBGRuiAsset( frame )
		}
		else
		{
			isArtFullFrame = GladiatorCardFrame_IsArtFullFrame( frame )
			fgFrameRuiAsset = $"ui/gcard_frame_basic_fg.rpak"
			bgFrameRuiAsset = $"ui/gcard_frame_basic_bg.rpak"
			fgFrameImageAsset = GladiatorCardFrame_GetFGImageAsset( frame )
			fgFrameBlend = GladiatorCardFrame_GetFGImageBlend( frame )
			fgFramePremul = GladiatorCardFrame_GetFGImagePremul( frame )
			bgFrameImageAsset = GladiatorCardFrame_GetBGImageAsset( frame )
		}

		keyColors = GladiatorCardFrame_GetKeyColors( frame )
	}

	bool characterCaptureDesired = handle.isFrontFace && (skinOrNull != null && stanceOrNull != null)
	ManageCharacterCaptureStateForNestedCard( handle, characterCaptureDesired, characterOrNull, skinOrNull, frameOrNull, stanceOrNull )

	string currentFrameRpakLoaded = ""
	if ( handle.framePakHandleOrNull != null )
	{
		PakHandle framePakHandle = expect PakHandle(handle.framePakHandleOrNull)
		currentFrameRpakLoaded = framePakHandle.rpakPath
	}
	if ( currentFrameRpakLoaded != frameRpakPath )
	{
		if ( handle.framePakHandleOrNull != null )
		{
			ReleasePakFile( expect PakHandle(handle.framePakHandleOrNull) )
			handle.framePakHandleOrNull = null
		}
		if ( frameRpakPath != "" )
		{
			handle.framePakHandleOrNull = RequestPakFile( frameRpakPath, void function() : ( handle ) {
				if ( handle.cardRui != null )
					TriggerNestedGladiatorCardUpdate( handle )
			} )
		}
	}
	if ( handle.framePakHandleOrNull != null )
	{
		PakHandle framePakHandle = expect PakHandle(handle.framePakHandleOrNull)
		if ( !framePakHandle.isAvailable )
		{
			bgFrameRuiAsset = $""
			fgFrameRuiAsset = $""
		}
	}

	if ( handle.cardRui != null )
	{
		int rankScore = 0
		int ladderPos = 99999

		if ( handle.presentation == eGladCardPresentation.FULL_BOX )
		{
			if ( rankedScoreOrNull != null )
				rankScore = expect int( rankedScoreOrNull )
			else if ( EEHHasValidScriptStruct( handle.currentOwnerEHI ) )
				rankScore = GetPlayerRankScoreFromEHI( handle.currentOwnerEHI )

			if ( rankedLadderPosOrNull != null )
				ladderPos = expect int( rankedLadderPosOrNull )
			else if ( EEHHasValidScriptStruct( handle.currentOwnerEHI ) )
				ladderPos = GetPlayerLadderPosFromEHI( handle.currentOwnerEHI )
		}

		RuiSetString( handle.cardRui, "playerName", playerName )
		RuiSetInt( handle.cardRui, "teamMemberIndex", teamMemberIndex )
		RuiSetBool( handle.cardRui, "shouldShowDetails", handle.shouldShowDetails )

		for ( int idx = 0; idx < GLADIATOR_CARDS_NUM_FRAME_KEY_COLORS; idx++ )
			RuiSetFloat3( handle.cardRui, "keyCol" + idx, keyColors[idx] )

		if ( handle.isFrontFace )
		{
			Assert( handle.parentRui != null )
			RuiSetBool( handle.cardRui, "isAlive", isAlive || IsLobby() )
			#if R5DEV
				RuiSetBool( handle.cardRui, "devShowSafeAreaOverlay", fileLevel.DEV_showSafeAreaOverlay )
			#endif

			var bgFrameRui = UpdateGladiatorCardNestedWidget( handle, "bgFrameInstance", handle.bgFrameNWS, bgFrameRuiAsset )
			if ( bgFrameRui != null )
			{
				if ( !frameHasOwnRUI )
				{
					RuiSetBool( bgFrameRui, "isArtFullFrame", isArtFullFrame )
					RuiSetImage( bgFrameRui, "bgImage", bgFrameImageAsset )
				}
			}

			var fgFrameRui = UpdateGladiatorCardNestedWidget( handle, "fgFrameInstance", handle.fgFrameNWS, fgFrameRuiAsset )
			if ( fgFrameRui != null )
			{
				//RuiSetString( fgFrameRui, "playerName", playerName )
				int stancePIPSlotIndex = -1
				if ( handle.characterCaptureStateOrNull != null )
				{
					CharacterCaptureState ccs = expect CharacterCaptureState(handle.characterCaptureStateOrNull)
					if ( ccs.stancePIPSlotStateOrNull != null )
						stancePIPSlotIndex = PIPSlotState_GetSlotID( expect PIPSlotState(ccs.stancePIPSlotStateOrNull) )

					if ( handle.onStancePIPSlotReadyFunc == null )
					{
						handle.onStancePIPSlotReadyFunc = void function( int stancePIPSlotIndex, float movingSeqEndTime ) : ( handle )
						{
							// start of closure
							if ( handle.cardRui != null && handle.fgFrameNWS.rui != null )
							{
								RuiSetGameTime( handle.cardRui, "movingSeqEndTime", movingSeqEndTime )
								RuiSetInt( handle.fgFrameNWS.rui, "stancePIPSlot", stancePIPSlotIndex )

								//CharacterCaptureState ccs = expect CharacterCaptureState(handle.characterCaptureStateOrNull)
								//printt( "#SETTTTT", stancePIPSlotIndex, ccs.key, handle.currentOwnerEHI )
							}
							// end of closure
						}
					}
					if ( !(handle.onStancePIPSlotReadyFunc in ccs.onPIPSlotReadyFuncSet) )
						ccs.onPIPSlotReadyFuncSet[handle.onStancePIPSlotReadyFunc] <- true
				}
				RuiSetInt( fgFrameRui, "stancePIPSlot", stancePIPSlotIndex )

				if ( !frameHasOwnRUI )
				{
					RuiSetBool( fgFrameRui, "isArtFullFrame", isArtFullFrame )
					RuiSetImage( fgFrameRui, "fgImage", fgFrameImageAsset )
					RuiSetFloat( fgFrameRui, "fgImageBlend", fgFrameBlend )
					RuiSetFloat( fgFrameRui, "fgImagePremul", fgFramePremul )
					RuiSetImage( fgFrameRui, "bgImage", bgFrameImageAsset )
				}
			}
		}

		if ( handle.isBackFace )
		{
			UpdateStatTrackersOfNestedGladiatorCard( handle, characterOrNull )
		}

		if ( handle.presentation == eGladCardPresentation.FULL_BOX )
		{
			RuiSetBool( handle.cardRui, "frameHasOwnRUI", frameHasOwnRUI )

			bool showRanked = IsRankedGame()
			if ( handle.rankedForceShowOrNull != null )
				showRanked = expect bool( handle.rankedForceShowOrNull )
			RuiSetBool( handle.cardRui, "showRanked", showRanked )
			if ( showRanked )
				PopulateRuiWithRankedBadgeDetails( handle.cardRui, rankScore, ladderPos )

			RuiSetBool( handle.cardRui, "isKiller", handle.isKiller )
			RuiSetBool( handle.cardRui, "disableBlur", handle.disableBlur )
		}

		if ( handle.situation == eGladCardDisplaySituation.GAME_INTRO_CHAMPION_SQUAD_STILL
				|| handle.situation == eGladCardDisplaySituation.GAME_INTRO_CHAMPION_SQUAD_ANIMATED )
		{
			RuiSetInt( handle.cardRui, "teamMemberIndex", -1 )
			RuiSetBool( handle.cardRui, "isChampion", (handle.currentOwnerEHI == GetGlobalNetInt( "championEEH" )) )
		}

		for ( int badgeIndex = 0; badgeIndex < GLADIATOR_CARDS_NUM_BADGES; badgeIndex++ )
		{
			var badgeRui = UpdateGladiatorCardNestedWidget( handle, "badge" + badgeIndex + "Instance", handle.badgeNWSList[badgeIndex], badgeRuiAssets[badgeIndex] )
			if ( badgeRui != null )
			{
				RuiSetInt( badgeRui, "tier", badgeTiers[badgeIndex] )
				if ( badgeImageAssets[badgeIndex] != $"" )
					RuiSetImage( badgeRui, "img", badgeImageAssets[badgeIndex] )
			}
		}
	}
}
#endif


#if CLIENT
var function UpdateGladiatorCardNestedWidget( NestedGladiatorCardHandle handle, string argName, NestedWidgetState nws, asset desiredRuiAsset )
{
	if ( nws.rui == null || desiredRuiAsset != nws.ruiAsset )
	{
		if ( nws.rui != null )
		{
			RuiDestroyNested( handle.cardRui, argName )
			nws.rui = null
			nws.ruiAsset = $""
		}
		if ( desiredRuiAsset != $"" )
		{
			nws.ruiAsset = desiredRuiAsset
			nws.rui = RuiCreateNested( handle.cardRui, argName, desiredRuiAsset )
		}
	}
	return nws.rui
}
#endif


#if CLIENT
void function ManageCharacterCaptureStateForNestedCard( NestedGladiatorCardHandle handle, bool characterCaptureDesired, ItemFlavor ornull characterOrNull, ItemFlavor ornull skinOrNull, ItemFlavor ornull frameOrNull, ItemFlavor ornull stanceOrNull )
{
	bool doRelease = false
	bool doCreate  = false
	if ( characterCaptureDesired )
	{
		if ( handle.characterCaptureStateOrNull == null )
		{
			doCreate = true
		}
		else
		{
			CharacterCaptureState ccs = expect CharacterCaptureState(handle.characterCaptureStateOrNull)
			doCreate = (ccs.character != characterOrNull || ccs.skin != skinOrNull || ccs.frameOrNull != frameOrNull || ccs.stance != stanceOrNull)
			doRelease = doCreate
		}
	}
	else if ( handle.characterCaptureStateOrNull != null )
	{
		doRelease = true
	}

	if ( doRelease )
	{
		Assert( handle.characterCaptureStateOrNull != null )
		CharacterCaptureState ccs = expect CharacterCaptureState(handle.characterCaptureStateOrNull)

		if ( handle.onStancePIPSlotReadyFunc in ccs.onPIPSlotReadyFuncSet )
			delete ccs.onPIPSlotReadyFuncSet[handle.onStancePIPSlotReadyFunc]

		ReleaseCharacterCapture( ccs )
		#if R5DEV
			ccs.DEV_culprits.fastremovebyvalue( string(handle) + " " + handle.DEV_culprit )
		#endif
		handle.characterCaptureStateOrNull = null
	}
	if ( doCreate )
	{
		Assert( handle.characterCaptureStateOrNull == null )
		handle.characterCaptureStateOrNull = GetOrStartCharacterCapture( handle, handle.startTime + 0.5, handle.currentOwnerEHI, handle.isMoving, expect ItemFlavor(characterOrNull), expect ItemFlavor(skinOrNull), frameOrNull, expect ItemFlavor(stanceOrNull) )
		#if R5DEV
			CharacterCaptureState ccs = expect CharacterCaptureState(handle.characterCaptureStateOrNull)
			ccs.DEV_culprits.append( string(handle) + " " + handle.DEV_culprit )
		#endif
	}
}
#endif


#if CLIENT
CharacterCaptureState function GetOrStartCharacterCapture( NestedGladiatorCardHandle handle, float startTime, EHI playerEHI, bool isMoving, ItemFlavor character, ItemFlavor skin, ItemFlavor ornull frameOrNull, ItemFlavor stance )
{
	string key = format( "%d:%s:%s:%s:%s:%s",
		playerEHI, isMoving ? string(handle) : "still",
		ItemFlavor_GetHumanReadableRef( character ), ItemFlavor_GetHumanReadableRef( skin ),
				frameOrNull == null ? "null" : ItemFlavor_GetHumanReadableRef( expect ItemFlavor(frameOrNull) ), ItemFlavor_GetHumanReadableRef( stance ) )
	if ( key in fileLevel.ccsMap )
	{
		CharacterCaptureState ccs = fileLevel.ccsMap[key]
		ccs.refCount += 1
		return ccs
	}

	CharacterCaptureState ccs
	ccs.key = key
	ccs.playerEHI = playerEHI
	ccs.isMoving = isMoving
	ccs.character = character
	ccs.skin = skin
	ccs.frameOrNull = frameOrNull
	ccs.stance = stance
	ccs.refCount = 1
	ccs.startTime = startTime
	fileLevel.ccsMap[key] <- ccs

	thread DoGladiatorCardCharacterCapture( ccs )
	//if ( !fileLevel.isCaptureThreadRunning )
	//	thread RunGladiatorCardCharacterCaptures_Thread( ccs )

	return ccs
}
#endif


#if CLIENT
void function ReleaseCharacterCapture( CharacterCaptureState ccs )
{
	Assert( ccs.refCount > 0 )
	ccs.refCount -= 1
	if ( ccs.refCount == 0 )
	{
		Signal( ccs, "StopGladiatorCardCharacterCapture" )
		delete fileLevel.ccsMap[ccs.key]
	}
}
#endif


#if CLIENT
void function DoGladiatorCardCharacterCapture( CharacterCaptureState ccs )
{
	// todo(dw): move most of this to cl_character_capture.gnut

	#if GLADCARD_CC_DEBUG_PRINTS_ENABLED
		printf( "#GLADCARDS CC %s: Start", ccs.key )
	#endif

	EndSignal( ccs, "StopGladiatorCardCharacterCapture" )

	bool doMoving = ccs.isMoving && GladiatorCardStance_HasMovingAnimSeq( ccs.stance )
	#if R5DEV
		if ( fileLevel.DEV_forceMoving )
		{
			doMoving = true
		}
	#endif

	string movingSeq = ""
	if ( doMoving )
	{
		movingSeq = string(GladiatorCardStance_GetMovingAnimSeq( ccs.stance ))
	}
	else
	{
		if ( fileLevel.stillInProgress != null )
		{
			fileLevel.ccsStillQueue.append( ccs )

			OnThreadEnd( void function() : ( ccs ) {
				fileLevel.ccsStillQueue.removebyvalue( ccs )
			} )

			WaitSignal( ccs, "YouMayProceedWithStillCCS" )
			WaitFrame()
			fileLevel.ccsStillQueue.remove( 0 )
		}

		OnThreadEnd( function() : ( ccs ) {
			//Assert( fileLevel.stillInProgress == ccs )
			if ( fileLevel.stillInProgress == ccs )
			{
				fileLevel.stillInProgress = null
				if ( fileLevel.ccsStillQueue.len() > 0 )
					Signal( fileLevel.ccsStillQueue[0], "YouMayProceedWithStillCCS" )
			}
		} )

		fileLevel.stillInProgress = ccs
	}

	#if GLADCARD_CC_DEBUG_PRINTS_ENABLED
		printf( "#GLADCARDS CC %s: Passed queueing", ccs.key )
	#endif

	FlagWait( "EntitiesDidLoad" )
	WaitEndFrame() // this wait is important so the nested gladcard handle can add its onStancePIPSlotReadyFunc

	#if R5DEV
		if ( fileLevel.DEV_disableCameraAlpha && ccs.frameOrNull != null )
		{
			string frameRpakPath     = ItemFlavor_GetHumanReadableRef( expect ItemFlavor( ccs.frameOrNull ) )
			PakHandle framePakHandle = RequestPakFile( frameRpakPath )

			OnThreadEnd( function() : ( framePakHandle ) {
				if ( framePakHandle.rpakPath != "" )
					ReleasePakFile( framePakHandle )
			} )

			if ( !framePakHandle.isAvailable )
				WaitSignal( framePakHandle, "PakFileLoaded" )
		}
	#endif

	OnThreadEnd( function() : ( ccs, doMoving ) {
		if ( ccs.stancePIPSlotStateOrNull != null )
		{
			ReleasePIP( expect PIPSlotState(ccs.stancePIPSlotStateOrNull) )
			ccs.stancePIPSlotStateOrNull = null
		}

		if ( ccs.cleanupSceneFunc != null )
		{
			ccs.cleanupSceneFunc()
		}

		#if GLADCARD_CC_DEBUG_PRINTS_ENABLED
			printf( "#GLADCARDS CC %s: Done", ccs.key )
		#endif
	} )

	ccs.cleanupSceneFunc = (void function() : ( ccs )
	{
		// start of closure

		#if GLADCARD_CC_DEBUG_PRINTS_ENABLED
			printf( "#GLADCARDS CC %s, %s: Cleanup", ccs.key, ccs.stancePIPSlotStateOrNull == null ? "null" : string(PIPSlotState_GetSlotID( expect PIPSlotState(ccs.stancePIPSlotStateOrNull) )) )
		#endif

		ccs.cleanupSceneFunc = null

		foreach( int lightIndex, entity light in ccs.lights )
		{
			if ( light == null )
				continue

			if ( ccs.lightDoesShadowsMap[lightIndex] )
			{
				//printt( "# SHADOWS OFF", lightIndex )
				light.SetTweakLightUpdateShadowsEveryFrame( false )
				light.SetTweakLightRealtimeShadows( false )
			}
			light.SetTweakLightDistance( 2.0 ) // make distance small to reduce impact of light
		}

		#if R5DEV
			if ( ccs.DEV_bgRui != null )
				RuiDestroyIfAlive( ccs.DEV_bgRui )
			if ( ccs.DEV_bgTopo != null )
				RuiTopology_Destroy( ccs.DEV_bgTopo )
		#endif

		if ( ccs.colorCorrectionLayer != -1 )
		{
			#if(R5DEV)
				Assert( ccs.colorCorrectionLayer != GetBloodhoundColorCorrectionID(), "gladiator cards tried to release bloodhounds color correction. Related to bug R5DEV-75937. Assign bug to Roger A please." )
			#endif
			ColorCorrection_Release( ccs.colorCorrectionLayer )
			ccs.colorCorrectionLayer = -1
		}

		if ( ccs.captureRoomOrNull != null )
		{
			ReleaseCaptureRoom( expect CaptureRoom( ccs.captureRoomOrNull ) )
			ccs.captureRoomOrNull = null
		}

		if ( IsValid( ccs.camera ) )
			ccs.camera.Destroy()

		if ( IsValid( ccs.lightingRig ) )
			ccs.lightingRig.Destroy()

		if ( IsValid( ccs.model ) )
			ccs.model.Destroy()

		if ( fileLevel.stillInProgress == ccs )
		{
			//Assert( fileLevel.stillInProgress == ccs )
			fileLevel.stillInProgress = null
			if ( fileLevel.ccsStillQueue.len() > 0 )
				Signal( fileLevel.ccsStillQueue[0], "YouMayProceedWithStillCCS" )
		}

		// end of closure
	})

	string stillSeq = string(GladiatorCardStance_GetStillAnimSeq( ccs.stance ))

	CaptureRoom room = WaitForReserveCaptureRoom()
	ccs.captureRoomOrNull = room

	vector modelPos = room.center
	vector modelAng = AnglesCompose( room.ang, <0, 180, 0> )
	ccs.model = CreateClientSidePropDynamic( modelPos, modelAng, $"mdl/dev/empty_model.rmdl" )
	ccs.model.SetForceVisibleInPhaseShift( true )
	ccs.model.MakeSafeForUIScriptHack()

	asset setFile   = CharacterClass_GetSetFile( ccs.character )
	asset bodyModel = GetGlobalSettingsAsset( setFile, "bodyModel" )
	ccs.model.SetModel( bodyModel )
	CharacterSkin_Apply( ccs.model, ccs.skin )

	ccs.lightingRig = CreateClientSidePropDynamic( modelPos, modelAng, SCENE_CAPTURE_LIGHTING_RIG_MODEL )
	ccs.lightingRig.MakeSafeForUIScriptHack()
	string lightingRigMovingSeq = ""
	if ( doMoving )
		lightingRigMovingSeq = string(GladiatorCardStance_GetLightingRigMovingAnimSeq( ccs.stance ))
	string lightingRigStillSeq = string(GladiatorCardStance_GetLightingRigStillAnimSeq( ccs.stance ))
	//
	float cameraWidgetWidth    = 408.0
	//float cameraWidgetHeight = 816.0
	float croppedCardWidth     = 264.0
	float croppedCardHeight    = 720.0

	//float croppedVerticalCameraFOV          = GladiatorCardStance_GetVerticalCameraFOV( ccs.stance )
	//float croppedVerticalCameraTanHalfFOV   = tan( croppedVerticalCameraFOV / 2.0 * DEG_TO_RAD )
	//float clippedVerticalCameraTanHalfFOV   = croppedVerticalCameraTanHalfFOV / croppedCardHeight * cameraWidgetHeight
	////float clippedHorizontalCameraTanHalfFOV = clippedVerticalCameraTanHalfFOV / cameraWidgetHeight * cameraWidgetWidth
	//float clippedHorizontalCameraTanHalfFOV = clippedVerticalCameraTanHalfFOV / croppedCardHeight * croppedCardWidth // todo(dw): the above line is correct, but something is weird
	//float clippedHorizontalCameraFOV        = 2.0 * RAD_TO_DEG * atan( clippedHorizontalCameraTanHalfFOV )

	//float brokenFOV                  = GladiatorCardStance_GetHorizontalCameraFOV( ccs.stance )
	//float croppedHorizontalCameraFOV = 2.0 * RAD_TO_DEG * atan( tan( brokenFOV / 2.0 * DEG_TO_RAD ) / (4.0 / 3.0) * (croppedCardWidth / croppedCardHeight) )
	float croppedHorizontalCameraFOV = GladiatorCardStance_GetHorizontalCameraFOV( ccs.stance )
	float clippedHorizontalCameraFOV = 2.0 * RAD_TO_DEG * atan( tan( croppedHorizontalCameraFOV / 2.0 * DEG_TO_RAD ) / croppedCardWidth * cameraWidgetWidth )

	ccs.camera = CreateClientSidePointCamera( modelPos, modelAng, clippedHorizontalCameraFOV )
	//ccs.camera.MakeSafeForUIScriptHack()
	ccs.camera.SetParent( ccs.model, "VDU", false )
	//DebugDrawAxis( ccs.camera.GetOrigin(), ccs.camera.GetAngles(), 25, 50 )

	float cameraExposure = 0.7
	if ( ccs.frameOrNull != null )
		cameraExposure = GladiatorCardFrame_GetExposure( expect ItemFlavor( ccs.frameOrNull ) )
	ccs.camera.SetMonitorExposure( cameraExposure )

	//float clippedVerticalCameraFOV = 2.0 * RAD_TO_DEG * atan( clippedVerticalCameraTanHalfFOV )
	//DebugDrawLine( ccs.camera.GetOrigin(), ccs.camera.GetOrigin() - 6000.0 * AnglesToForward( AnglesCompose( ccs.camera.GetAngles(), <-croppedVerticalCameraFOV * 0.5, 0, 0> ) ), 255, 80, 40, true, 20.0 )
	//DebugDrawLine( ccs.camera.GetOrigin(), ccs.camera.GetOrigin() - 6000.0 * AnglesToForward( AnglesCompose( ccs.camera.GetAngles(), <croppedVerticalCameraFOV * 0.5, 0, 0> ) ), 255, 80, 40, true, 20.0 )
	//
	//DebugDrawLine( ccs.camera.GetOrigin(), ccs.camera.GetOrigin() - 6000.0 * AnglesToForward( AnglesCompose( ccs.camera.GetAngles(), <-clippedVerticalCameraFOV * 0.5, 0, 0> ) ), 40, 255, 80, true, 20.0 )
	//DebugDrawLine( ccs.camera.GetOrigin(), ccs.camera.GetOrigin() - 6000.0 * AnglesToForward( AnglesCompose( ccs.camera.GetAngles(), <clippedVerticalCameraFOV * 0.5, 0, 0> ) ), 40, 255, 80, true, 20.0 )

	float farZ = 642.0

	#if R5DEV
		if ( fileLevel.DEV_disableCameraAlpha && ccs.frameOrNull != null )
		{
			float ruiWidth       = 528.0
			float ruiHeight      = 912.0
			float ruiAspectRatio = ruiWidth / ruiHeight

			float ruiDistance = 642.0
			farZ = ruiDistance + 20.0
			//float clippedVerticalCameraFOV = 2.0 * RAD_TO_DEG * atan( clippedVerticalCameraTanHalfFOV )
			//float ruiClippedWorldHeight    = 2.0 * tan( clippedVerticalCameraFOV / 2.0 * DEG_TO_RAD ) * ruiDistance
			//float ruiClippedHeight         = cameraWidgetHeight
			//float ruiWorldHeight           = ruiClippedWorldHeight / ruiClippedHeight * ruiHeight
			//float ruiWorldWidth            = ruiWorldHeight * ruiAspectRatio

			float ruiClippedWorldWidth = 2.0 * tan( clippedHorizontalCameraFOV / 2.0 * DEG_TO_RAD ) * ruiDistance
			float ruiFullWorldWidth    = ruiClippedWorldWidth / cameraWidgetWidth * ruiWidth
			float ruiFullWorldHeight   = ruiFullWorldWidth / ruiAspectRatio

			ccs.DEV_bgTopo = RuiTopology_CreatePlane(
				<ruiDistance, 0.5 * ruiFullWorldWidth, 0.5 * ruiFullWorldHeight>,
				<0, -ruiFullWorldWidth, 0>, <0, 0, -ruiFullWorldHeight>,
				false
			)
			RuiTopology_SetParent( ccs.DEV_bgTopo, ccs.camera )

			asset bgFrameRuiAsset, bgFrameImageAsset
			if ( GladiatorCardFrame_HasOwnRUI( expect ItemFlavor(ccs.frameOrNull) ) )
			{
				bgFrameRuiAsset = GladiatorCardFrame_GetBGRuiAsset( expect ItemFlavor(ccs.frameOrNull) )
			}
			else
			{
				bgFrameRuiAsset = $"ui/gcard_frame_basic_bg.rpak"
				bgFrameImageAsset = GladiatorCardFrame_GetBGImageAsset( expect ItemFlavor(ccs.frameOrNull) )
			}
			if ( bgFrameRuiAsset != $"" )
			{
				ccs.DEV_bgRui = RuiCreate( bgFrameRuiAsset, ccs.DEV_bgTopo, RUI_DRAW_WORLD, 32767 )

				if ( bgFrameImageAsset != $"" )
					RuiSetImage( ccs.DEV_bgRui, "bgImage", bgFrameImageAsset )
			}
		}
	#endif

	ccs.camera.SetMonitorZFar( farZ )

	array<string> lightAttachmentNameMap = [ "LIGHT_1", "LIGHT_2", "LIGHT_3", "LIGHT_4" ]
	foreach( int lightIndex, string attachmentName in lightAttachmentNameMap)
	{
		if ( !(lightIndex in room.tweakLights) )
		{
			ccs.lights.append( null )
			continue
		}

		entity light = room.tweakLights[lightIndex]
		if ( ccs.frameOrNull != null )
		{
			GladiatorCardFrame_SetupTweakLightFromSettings( expect ItemFlavor(ccs.frameOrNull), lightIndex, light )
		}
		else
		{
			light.SetTweakLightColor( <1, 1, 1> )
			light.SetTweakLightSpecIntensity( 1.0 )
		}
		GladiatorCardStance_SetupTweakLightFromSettings( ccs.stance, lightIndex, light )
		bool doShadows = GladiatorCardStance_DoesTweakLightRequireShadows( ccs.stance, lightIndex )
		if ( doShadows )
		{
			//

			#if GLADCARD_CC_DEBUG_PRINTS_ENABLED
				printt( "#GLADCARDS --  SHADOWS ON", lightIndex )
			#endif

			light.SetTweakLightRealtimeShadows( true )
			light.SetTweakLightUpdateShadowsEveryFrame( true )
		}
		ccs.lightDoesShadowsMap.append( doShadows )

		//light.SetParent( ccs.lightingRig, attachmentName, false )
		//DebugDrawAxis( lightOrigin, lightAngles, 25, 50 )

		ccs.lights.append( light )
	}

	string colorCorrectionRawPath = ""
	if ( GetConVarBool( "monitor_postfx" ) && GetConVarBool( "monitor_cc" ) && ccs.frameOrNull != null )
		colorCorrectionRawPath = GladiatorCardFrame_GetColorCorrectionRawPath( expect ItemFlavor(ccs.frameOrNull) )

	ccs.colorCorrectionLayer = -1
	if ( colorCorrectionRawPath != "" )
		ccs.colorCorrectionLayer = ColorCorrection_LoadAsync( colorCorrectionRawPath )

	if ( ccs.colorCorrectionLayer != -1 )
	{
		while ( !ColorCorrection_PollAsync( ccs.colorCorrectionLayer ) )
			WaitFrame()

		#if GLADCARD_CC_DEBUG_PRINTS_ENABLED
			printf( "#GLADCARDS CC %s: Color correction loaded %s %d", ccs.key, colorCorrectionRawPath, ccs.colorCorrectionLayer )
		#endif
	}

	Assert( ccs.stancePIPSlotStateOrNull == null )
	ccs.stancePIPSlotStateOrNull = BeginMovingPIP( ccs.camera, ccs.colorCorrectionLayer )

	ccs.isReady = true

	WaitEndFrame()
	if ( ccs.startTime - Time() > 0 )
		wait (ccs.startTime - Time())

	#if GLADCARD_CC_DEBUG_PRINTS_ENABLED
		printf( "#GLADCARDS CC %s, %d: Commence", ccs.key, PIPSlotState_GetSlotID( expect PIPSlotState(ccs.stancePIPSlotStateOrNull) ) )
	#endif

	void functionref() setupStillLighting = (void function() : ( ccs, lightingRigStillSeq, lightAttachmentNameMap ) {
		// start of closure

		if ( lightingRigStillSeq != $"" )
		{
			ccs.lightingRig.Anim_Play( lightingRigStillSeq )

			// todo(dw): temp until SetParent works
			foreach ( int lightIndex, entity light in ccs.lights )
			{
				if ( light == null )
					continue

				int attachmentIndex = ccs.lightingRig.LookupAttachment( lightAttachmentNameMap[lightIndex] )
				vector lightOrigin  = ccs.lightingRig.GetAttachmentOrigin( attachmentIndex )
				vector lightAngles  = ccs.lightingRig.GetAttachmentAngles( attachmentIndex )
				light.SetTweakLightOrigin( lightOrigin )
				light.SetTweakLightAngles( lightAngles )

				//DebugDrawAxis( lightOrigin, lightAngles, 25, 10 )
			}
		}
		else
		{
			// this branch is for dev characters only
			WaitFrame()
			int attachmentIndex = ccs.model.LookupAttachment( "CHESTFOCUS" )
			foreach ( int lightIndex, entity light in ccs.lights )
			{
				if ( light == null )
					continue

				vector lightOrigin = ccs.model.GetAttachmentOrigin( attachmentIndex )
				vector lightAngles = ccs.model.GetAttachmentAngles( attachmentIndex )
				light.SetTweakLightOrigin( lightOrigin + RotateVector( <110, 0, 0>, <0, Graph( lightIndex, 0, 4, 0, 360 ), 0> ) )
				light.SetTweakLightAngles( <0, Graph( lightIndex, 0, 4, -180, 180 ), 0> )
			}
		}

		// end of closure
	})

	float movingSeqDuration
	if ( doMoving )
	{
		if ( movingSeq == "" )
			movingSeq = stillSeq
		if ( movingSeq != "" )
		{
			movingSeqDuration = ccs.model.GetSequenceDuration( movingSeq )
			ccs.model.Anim_Play( movingSeq )
		}
		else
		{
			movingSeqDuration = 10.0
		}

		if ( lightingRigMovingSeq != "" )
		{
			ccs.lightingRig.Anim_Play( lightingRigMovingSeq )

			// todo(dw): temp until SetParent works
			foreach ( int lightIndex, entity light in ccs.lights )
			{
				if ( light == null )
					continue

				int attachmentIndex = ccs.lightingRig.LookupAttachment( lightAttachmentNameMap[lightIndex] )
				vector lightOrigin  = ccs.lightingRig.GetAttachmentOrigin( attachmentIndex )
				vector lightAngles  = ccs.lightingRig.GetAttachmentAngles( attachmentIndex )
				light.SetTweakLightOrigin( lightOrigin )
				light.SetTweakLightAngles( lightAngles )

				//DebugDrawAxis( lightOrigin, lightAngles, 25, 10 )
			}
		}
		else
		{
			setupStillLighting()
		}
	}
	if ( doMoving )
	{
		foreach ( OnStancePIPSlotReadyFuncType cb, bool unused in ccs.onPIPSlotReadyFuncSet )
			cb( PIPSlotState_GetSlotID( expect PIPSlotState(ccs.stancePIPSlotStateOrNull) ), Time() + movingSeqDuration )

		#if GLADCARD_CC_DEBUG_PRINTS_ENABLED
			printf( "#GLADCARDS CC %s, %d: Moving", ccs.key, PIPSlotState_GetSlotID( expect PIPSlotState(ccs.stancePIPSlotStateOrNull) ) )
		#endif

		wait movingSeqDuration

		//printt( "#MOVING", ccs.key, PIPSlotState_GetSlotID( expect PIPSlotState(ccs.stancePIPSlotStateOrNull) ) )
		//float chestDist = Distance( ccs.camera.GetOrigin(), ccs.model.GetAttachmentOrigin( ccs.model.LookupAttachment( "CHESTFOCUS" ) ) )
		//float startTime = Time()
		//float endTime   = startTime + 0.65//movingSeqDuration
		//while ( Time() < endTime )
		//{
		//	ccs.camera.SetMonitorZFar( GraphCapped( pow( (Time() - startTime) / (endTime - startTime), 2.0 ), 0.0, 1.0, chestDist - 20.0, chestDist + 50.0 ) )
		//	WaitFrame()
		//}
	}

	if ( stillSeq != "" )
	{
		ccs.model.Anim_Play( stillSeq )
	}
	else
	{
		ccs.model.Anim_Play( "ACT_MP_MENU_MAIN_IDLE" )
		//ccs.camera.ClearParent()
		//ccs.camera.SetOrigin( LocalPosToWorldPos( <100, 0, 60>, ccs.model ) )
		//ccs.camera.SetAngles( LocalPosToWorldPos( <0, 0, 0>, ccs.model ) )
		ccs.camera.SetParent( ccs.model, "CHESTFOCUS", false )
		ccs.camera.SetLocalOrigin( <110, 0, 0> )
		ccs.camera.SetLocalAngles( <0, 180, 0> )
		DebugDrawAxis( ccs.camera.GetOrigin(), ccs.camera.GetAngles(), 25, 5 )
	}

	setupStillLighting()

	if ( doMoving )
	{
		#if GLADCARD_CC_DEBUG_PRINTS_ENABLED
			printf( "#GLADCARDS CC %s, %d: Moved", ccs.key, PIPSlotState_GetSlotID( expect PIPSlotState(ccs.stancePIPSlotStateOrNull) ) )
		#endif
	}
	else
	{
		#if GLADCARD_CC_DEBUG_PRINTS_ENABLED
			printf( "#GLADCARDS CC %s, %d: Stilling", ccs.key, PIPSlotState_GetSlotID( expect PIPSlotState(ccs.stancePIPSlotStateOrNull) ) )
		#endif

		PIPSlotState ornull[1] outArray_stillSlotState = [null]
		waitthread CaptureStillPIPThenEndMovingPIPThread( expect PIPSlotState(ccs.stancePIPSlotStateOrNull), outArray_stillSlotState )
		ccs.stancePIPSlotStateOrNull = expect PIPSlotState(outArray_stillSlotState[0])

		#if GLADCARD_CC_DEBUG_PRINTS_ENABLED
			printf( "#GLADCARDS CC %s, %d: Still", ccs.key, PIPSlotState_GetSlotID( expect PIPSlotState(ccs.stancePIPSlotStateOrNull) ) )
		#endif

		foreach ( OnStancePIPSlotReadyFuncType cb, bool unused in ccs.onPIPSlotReadyFuncSet )
			cb( PIPSlotState_GetSlotID( expect PIPSlotState(ccs.stancePIPSlotStateOrNull) ), -1.0 )

		WaitFrame()

		ccs.cleanupSceneFunc()

		#if GLADCARD_CC_DEBUG_PRINTS_ENABLED
			printf( "#GLADCARDS CC %s, %d: Stilled", ccs.key, PIPSlotState_GetSlotID( expect PIPSlotState(ccs.stancePIPSlotStateOrNull) ) )
		#endif
	}

	WaitForever()

	//entity light = lights[0]
	//vector pos   = light.GetOrigin()
	//while ( true )
	//{
	//	light.SetTweakLightOrigin( pos + <0, 0, 50 * sin( Time() * 0.5 ) > )
	//	//light.SetTweakLightAngles( <0, 360 * Time() * 0.5, 0 > )
	//	WaitFrame()
	//}
}
#endif


#if CLIENT
void function OnGladiatorCardSlotChanged( EHI playerEHI, ItemFlavor unused )
{
	TriggerUpdateOfNestedGladiatorCardsForPlayer( FromEHI( playerEHI ) )
}
#endif


#if CLIENT
void function OnGladiatorCardStatTrackerValueChanged( EHI playerEHI, int value, int trackerIndex )
{
	float newVal = float(value) / GLADIATOR_CARDS_STAT_TRACKER_MAX_PRECISION
	UpdateStatTrackerIndexOfAllNestedGladiatorCardsForPlayer( playerEHI, trackerIndex, newVal )
}
#endif


#if CLIENT
void function TriggerUpdateOfNestedGladiatorCardsForPlayer( entity owner )
{
	EHI ownerEHI = ToEHI( owner )
	if ( !(ownerEHI in fileLevel.ownerNestedCardListMap) )
		return

	foreach( NestedGladiatorCardHandle handle in fileLevel.ownerNestedCardListMap[ownerEHI] )
	{
		// assuming there's at most 10 gladiator cards per player visible at a time, this loop is fine
		TriggerNestedGladiatorCardUpdate( handle )
	}
}
#endif


#if CLIENT
void function UpdateStatTrackerIndexOfAllNestedGladiatorCardsForPlayer( EHI ownerEHI, int trackerIndex, float newVal )
{
	if ( !(ownerEHI in fileLevel.ownerNestedCardListMap) )
		return

	foreach( NestedGladiatorCardHandle handle in fileLevel.ownerNestedCardListMap[ownerEHI] )
	{
		if ( !handle.isBackFace || handle.cardRui == null )
			continue

		UpdateRuiWithStatTrackerData_JustValue( handle.cardRui, "statTracker" + trackerIndex, newVal )
	}
}
#endif


#if(CLIENT)
void function UpdateStatTrackersOfNestedGladiatorCard( NestedGladiatorCardHandle handle, ItemFlavor ornull characterOrNull )
{
	for ( int index = 0; index < GLADIATOR_CARDS_NUM_TRACKERS; index++ )
	{
		ItemFlavor ornull trackerFlavOrNull = null

		int ornull overrideDataIntegerOrNull = null
		if ( handle.overrideTrackerList[index] != null )
		{
			trackerFlavOrNull = expect ItemFlavor(handle.overrideTrackerList[index])
			overrideDataIntegerOrNull = handle.overrideTrackerDataIntegerList[index]
		}

		if ( trackerFlavOrNull == null && characterOrNull != null )
		{
			LoadoutEntry trackerSlot = Loadout_GladiatorCardStatTracker( expect ItemFlavor(characterOrNull), index )
			if ( LoadoutSlot_IsReady( handle.currentOwnerEHI, trackerSlot ) )
				trackerFlavOrNull = LoadoutSlot_GetItemFlavor( handle.currentOwnerEHI, trackerSlot )
		}

		if ( trackerFlavOrNull != null )
			UpdateRuiWithStatTrackerData( handle.cardRui, "statTracker" + index, handle.currentOwnerEHI, characterOrNull, index, trackerFlavOrNull, overrideDataIntegerOrNull )
	}
}
#endif


#if CLIENT
void function UpdateRuiWithStatTrackerData( var rui, string prefix, EHI playerEHI, ItemFlavor ornull characterOrNull, int trackerIndex, ItemFlavor ornull trackerFlavorOrNull, int ornull overrideDataIntegerOrNull = null, bool isLootCeremony = false )
{
	// todo(dw): remove concatenation
	if ( trackerFlavorOrNull == null || GladiatorCardTracker_IsTheEmpty( expect ItemFlavor(trackerFlavorOrNull) ) )
	{
		RuiSetString( rui, prefix + "Label", "" )
		RuiSetFloat( rui, prefix + "Value", 0 )
		RuiSetInt( rui, prefix + "ValueFormat", 0 )
		RuiSetString( rui, prefix + "ValueSuffix", "" )

		if ( isLootCeremony )
		{
			RuiSetBool( rui, prefix + "IsLootCeremony", isLootCeremony )
			RuiSetString( rui, prefix + "Character", "" )
		}

		return
	}

	ItemFlavor trackerFlav = expect ItemFlavor(trackerFlavorOrNull)
	RuiSetString( rui, prefix + "Label", ItemFlavor_GetShortName( trackerFlav ) )
	RuiSetInt( rui, prefix + "ValueFormat", GladiatorCardStatTracker_GetValueNumberFormat( trackerFlav ) )
	RuiSetString( rui, prefix + "ValueSuffix", GladiatorCardStatTracker_GetValueSuffix( trackerFlav ) )
	RuiSetAsset( rui, prefix + "BackgroundImage", GladiatorCardStatTracker_GetBackgroundImage( trackerFlav ) )

	if ( isLootCeremony )
	{
		RuiSetBool( rui, prefix + "IsLootCeremony", isLootCeremony )
		RuiSetString( rui, prefix + "Character", ItemFlavor_GetShortName( GladiatorCardStatTracker_GetCharacterFlavor( trackerFlav ) ) )
	}

	LoadoutEntry valueEntry
	if ( characterOrNull != null && trackerIndex != -1 )
		valueEntry = Loadout_GladiatorCardStatTrackerValue( expect ItemFlavor(characterOrNull), trackerIndex )
	float value = -1337.0
	if ( playerEHI == LocalClientEHI() && (isLootCeremony || IsLobby() || !IsLoadoutSlotActive( playerEHI, valueEntry )) )
	{
		if ( !GladiatorCardTracker_IsTheEmpty( trackerFlav ) )
		{
			string desiredStatRef = GladiatorCardStatTracker_GetStatRef( trackerFlav, expect ItemFlavor(characterOrNull) )
			StatEntry desiredStat = GetStatEntryByRef( desiredStatRef )
			if ( StatEntry_GetType( desiredStat ) == eStatType.INT )
			{
				value = float( GetStat_Int( GetLocalClientPlayer(), desiredStat, eStatGetWhen.START_OF_CURRENT_MATCH ) )
			}
			else if ( StatEntry_GetType( desiredStat ) == eStatType.FLOAT )
			{
				value = GetStat_Float( GetLocalClientPlayer(), desiredStat, eStatGetWhen.START_OF_CURRENT_MATCH )
			}
		}
	}
	else
	{
		int intValue
		if ( overrideDataIntegerOrNull != null )
		{
			intValue = expect int(overrideDataIntegerOrNull)
		}
		else
		{
			intValue = LoadoutSlot_GetInteger( playerEHI, valueEntry )
		}
		value = float(intValue) / GLADIATOR_CARDS_STAT_TRACKER_MAX_PRECISION
	}
	RuiSetFloat( rui, prefix + "Value", value )
}
#endif


#if CLIENT
void function UpdateRuiWithStatTrackerData_JustValue( var rui, string prefix, float value )
{
	RuiSetFloat( rui, prefix + "Value", value )
}
#endif


#if CLIENT
void function OnPlayerLifestateChanged( entity player, int oldLifeState, int newLifeState )
{
	TriggerUpdateOfNestedGladiatorCardsForPlayer( player )

	#if R5DEV
		if ( GetLocalClientPlayer() == player && !AreGladiatorCardsEnabled() )
			player.ClientCommand( "devmenu_alias \"features/GladCards/Force enable (if disabled)\"   \"script_client DEV_ForceEnableGladiatorCards()\"" )
	#endif
}
#endif


#if CLIENT
void function OnPlayerClassChanged( entity player )
{
	TriggerUpdateOfNestedGladiatorCardsForPlayer( player )
}
#endif


#if SERVER || CLIENT || UI 
int function GetPlayerBadgeDataInteger( EHI playerEHI, ItemFlavor badge, int badgeIndex, ItemFlavor ornull character, bool TEMP_showOneTierHigherThanIsUnlocked = false )
{
	//

	if ( ItemFlavor_GetGRXMode( badge ) != eItemFlavorGRXMode.NONE )
		return 0 //

	#if CLIENT || UI 
		if ( playerEHI != LocalClientEHI() )
		{
			LoadoutEntry tierSlot = Loadout_GladiatorCardBadgeTier( expect ItemFlavor(character), badgeIndex )
			return LoadoutSlot_GetInteger( playerEHI, tierSlot )
		}
	#endif

	string dynamicTextStatRef = GladiatorCardBadge_GetDynamicTextStatRef( badge )
	int dynamicStatVal        = -1
	if ( dynamicTextStatRef != "" )
	{
		if ( !IsValidStatEntryRef( dynamicTextStatRef ) )
			return 0 //
		StatEntry stat = GetStatEntryByRef( dynamicTextStatRef )
		dynamicStatVal = GetStat_Int( FromEHI( playerEHI ), stat, eStatGetWhen.START_OF_CURRENT_MATCH ) //
	}

	string unlockStatRef = GladiatorCardBadge_GetUnlockStatRef( badge, character )

	if ( !IsValidStatEntryRef( unlockStatRef ) )
		return 0 //

	StatEntry stat = GetStatEntryByRef( unlockStatRef )

	int dataInteger = -1
	entity player   = FromEHI( playerEHI )
	int tierCount   = GladiatorCardBadge_GetTierCount( badge )
	for ( int tierIdx = 0; tierIdx < tierCount; tierIdx++ )
	{
		GladCardBadgeTierData tierData = GladiatorCardBadge_GetTierData( badge, tierIdx )
		if ( !DoesStatSatisfyValue( player, stat, tierData.unlocksAt, IsLobby() ? eStatGetWhen.CURRENT : eStatGetWhen.START_OF_CURRENT_MATCH ) )
			break
		dataInteger = tierIdx
	}
	if ( dataInteger == -1 )
		return dataInteger
	if ( dynamicStatVal != -1 )
		return dynamicStatVal
	return dataInteger + ((TEMP_showOneTierHigherThanIsUnlocked && dataInteger < tierCount - 1) ? 1 : 0)
}
#endif



/////////////////////////////////////////
/////////////////////////////////////////
//// Loadout & item flavor functions ////
/////////////////////////////////////////
/////////////////////////////////////////

#if SERVER || CLIENT || UI
LoadoutEntry function Loadout_GladiatorCardFrame( ItemFlavor characterClass )
{
	return fileLevel.loadoutCharacterFrameSlotMap[characterClass]
}
#endif


#if SERVER || CLIENT || UI
LoadoutEntry function Loadout_GladiatorCardStance( ItemFlavor characterClass )
{
	return fileLevel.loadoutCharacterStanceSlotMap[characterClass]
}
#endif


#if SERVER || CLIENT || UI
LoadoutEntry function Loadout_GladiatorCardBadge( ItemFlavor characterClass, int badgeIndex )
{
	return fileLevel.loadoutCharacterBadgesSlotListMap[characterClass][badgeIndex]
}
#endif


#if SERVER || CLIENT || UI
LoadoutEntry function Loadout_GladiatorCardBadgeTier( ItemFlavor characterClass, int badgeIndex )
{
	return fileLevel.loadoutCharacterBadgesTierSlotListMap[characterClass][badgeIndex]
}
#endif


#if SERVER || CLIENT || UI
LoadoutEntry function Loadout_GladiatorCardStatTracker( ItemFlavor characterClass, int trackerIndex )
{
	return fileLevel.loadoutCharacterTrackersSlotListMap[characterClass][trackerIndex]
}
#endif


#if SERVER || CLIENT || UI
LoadoutEntry function Loadout_GladiatorCardStatTrackerValue( ItemFlavor characterClass, int trackerIndex )
{
	return fileLevel.loadoutCharacterTrackersValueSlotListMap[characterClass][trackerIndex]
}
#endif


#if SERVER || CLIENT || UI
int function GladiatorCardFrame_GetSortOrdinal( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	return fileLevel.cosmeticFlavorSortOrdinalMap[flavor]
}
#endif


#if SERVER || CLIENT || UI
ItemFlavor function GladiatorCardFrame_GetCharacterFlavor( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	return fileLevel.frameCharacterMap[flavor]
}
#endif

#if SERVER || CLIENT || UI
bool function GladiatorCardFrame_ShouldHideIfLocked( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "shouldHideIfLocked" )
}
#endif

#if SERVER || CLIENT || UI
vector[GLADIATOR_CARDS_NUM_FRAME_KEY_COLORS] function GladiatorCardFrame_GetKeyColors( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	vector[GLADIATOR_CARDS_NUM_FRAME_KEY_COLORS] out
	for ( int idx = 0; idx < GLADIATOR_CARDS_NUM_FRAME_KEY_COLORS; idx++ )
		out[idx] = GetGlobalSettingsVector( ItemFlavor_GetAsset( flavor ), "keyCol_" + idx )
	return out
}
#endif


#if CLIENT || UI
bool function GladiatorCardFrame_HasOwnRUI( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "hasOwnRui" )
}
#endif


#if CLIENT || UI 
bool function GladiatorCardFrame_IsArtFullFrame( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )
	Assert( !GladiatorCardFrame_HasOwnRUI( flavor ) )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "isArtFullFrame" )
}
#endif


#if CLIENT || UI 
asset function GladiatorCardFrame_GetFGImageAsset( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )
	Assert( !GladiatorCardFrame_HasOwnRUI( flavor ) )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "fgImageAsset" )
}
#endif


#if CLIENT || UI
float function GladiatorCardFrame_GetFGImageBlend( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )
	Assert( !GladiatorCardFrame_HasOwnRUI( flavor ) )

	return GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "fgImageBlend" )
}
#endif


#if CLIENT || UI
float function GladiatorCardFrame_GetFGImagePremul( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )
	Assert( !GladiatorCardFrame_HasOwnRUI( flavor ) )

	return GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "fgImagePremul" )
}
#endif


#if CLIENT || UI
asset function GladiatorCardFrame_GetBGImageAsset( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )
	Assert( !GladiatorCardFrame_HasOwnRUI( flavor ) )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "bgImageAsset" )
}
#endif


#if CLIENT || UI
asset function GladiatorCardFrame_GetFGRuiAsset( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )
	Assert( GladiatorCardFrame_HasOwnRUI( flavor ) )

	return GetGlobalSettingsStringAsAsset( ItemFlavor_GetAsset( flavor ), "fgRuiAsset" )
}
#endif


#if CLIENT || UI
asset function GladiatorCardFrame_GetBGRuiAsset( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )
	Assert( GladiatorCardFrame_HasOwnRUI( flavor ) )

	return GetGlobalSettingsStringAsAsset( ItemFlavor_GetAsset( flavor ), "bgRuiAsset" )
}
#endif


#if CLIENT || UI
string function GladiatorCardFrame_GetColorCorrectionRawPath( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "colorCorrectionRawPath" )
}
#endif


#if CLIENT || UI
float function GladiatorCardFrame_GetExposure( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	return GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "exposure" )
}
#endif


#if CLIENT
void function GladiatorCardFrame_SetupTweakLightFromSettings( ItemFlavor flavor, int index, entity tweakLight )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_frame )

	var block = ItemFlavor_GetSettingsBlock( flavor )
	//printt( "# WTF", "LightColor", GetSettingsBlockVector( block, "light" + index + "_col" ) )
	//printt( "# WTF", "LightSpecIntensity", GetSettingsBlockFloat( block, "light" + index + "_specintensity" ) )

	tweakLight.SetTweakLightColor( GetSettingsBlockVector( block, "light" + index + "_col" ) )
	tweakLight.SetTweakLightSpecIntensity( GetSettingsBlockFloat( block, "light" + index + "_specintensity" ) )
}
#endif


#if SERVER || CLIENT || UI
int function GladiatorCardStance_GetSortOrdinal( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	return fileLevel.cosmeticFlavorSortOrdinalMap[flavor]
}
#endif


#if SERVER || CLIENT || UI
ItemFlavor function GladiatorCardStance_GetCharacterFlavor( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	return fileLevel.stanceCharacterMap[flavor]
}
#endif


#if CLIENT
void function GladiatorCardStance_SetupTweakLightFromSettings( ItemFlavor flavor, int index, entity tweakLight )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	var block = ItemFlavor_GetSettingsBlock( flavor )
	//printt( "# WTF", "Brightness", GetSettingsBlockFloat( block, "light" + index + "_brightness" ) )
	//printt( "# WTF", "Distance", GetSettingsBlockFloat( block, "light" + index + "_distance" ) )
	//printt( "# WTF", "Cone", GetSettingsBlockFloat( block, "light" + index + "_cone" ) )
	//printt( "# WTF", "InnerCone", GetSettingsBlockFloat( block, "light" + index + "_innercone" ) )
	//printt( "# WTF", "HalfBrightFrac", GetSettingsBlockFloat( block, "light" + index + "_halfbrightfrac" ) )
	//printt( "# WTF", "PBRFalloff", GetSettingsBlockBool( block, "light" + index + "_pbrfalloff" ) )

	tweakLight.SetTweakLightBrightness( GetSettingsBlockFloat( block, "light" + index + "_brightness" ) )
	tweakLight.SetTweakLightDistance( GetSettingsBlockFloat( block, "light" + index + "_distance" ) )
	tweakLight.SetTweakLightCone( GetSettingsBlockFloat( block, "light" + index + "_cone" ) )
	tweakLight.SetTweakLightInnerCone( GetSettingsBlockFloat( block, "light" + index + "_innercone" ) )
	tweakLight.SetTweakLightHalfBrightFrac( GetSettingsBlockFloat( block, "light" + index + "_halfbrightfrac" ) )
	tweakLight.SetTweakLightPBRFalloff( GetSettingsBlockBool( block, "light" + index + "_pbrfalloff" ) )
}
#endif


#if CLIENT
bool function GladiatorCardStance_DoesTweakLightRequireShadows( ItemFlavor flavor, int index )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "light" + index + "_castshadows" )
}
#endif


#if CLIENT
float function GladiatorCardStance_GetHorizontalCameraFOV( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	return GetGlobalSettingsFloat( ItemFlavor_GetAsset( flavor ), "horizontalFOV" )
}
#endif


#if CLIENT
asset function GladiatorCardStance_GetStillAnimSeq( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "stillAnimSeq" )
}
#endif


#if CLIENT
asset function GladiatorCardStance_GetLightingRigStillAnimSeq( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "lightingRigStillAnimSeq" )
}
#endif


#if CLIENT
bool function GladiatorCardStance_HasMovingAnimSeq( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "hasMovingAnim" )
}
#endif


#if CLIENT
asset function GladiatorCardStance_GetMovingAnimSeq( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "movingAnimSeq" )
}
#endif


#if CLIENT
asset function GladiatorCardStance_GetLightingRigMovingAnimSeq( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stance )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "lightingRigMovingAnimSeq" )
}
#endif


#if SERVER || CLIENT || UI
bool function GladiatorCardBadge_IsTheEmpty( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "isTheEmpty" )
}
#endif

#if SERVER || CLIENT || UI
bool function GladiatorCardBadge_ShouldHideIfLocked( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "shouldHideIfLocked" )
}
#endif


#if SERVER || CLIENT || UI
bool function GladiatorCardBadge_IsCharacterBadge( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "isCharacterBadge" )
}
#endif

#if SERVER || CLIENT || UI
int function GladiatorCardBadge_GetSortOrdinal( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	return fileLevel.cosmeticFlavorSortOrdinalMap[flavor]
}
#endif


#if SERVER || CLIENT || UI
ItemFlavor function GladiatorCardBadge_GetCharacterFlavor( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	return fileLevel.badgeCharacterMap[flavor]
}
#endif


#if SERVER || CLIENT || UI
string function GladiatorCardBadge_GetUnlockStatRef( ItemFlavor flavor, ItemFlavor ornull character )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )


	string statRef = GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "unlockStatRef" )
	if ( character != null )
		statRef = StringReplace( statRef, "%char%", ItemFlavor_GetGUIDString( expect ItemFlavor(character) ) )
	else
		Assert( StringReplace( statRef, "%char%", "" ) == statRef )
	return statRef
}
#endif


#if SERVER || CLIENT || UI
string function GladiatorCardBadge_GetDynamicTextStatRef( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "dynamicTextStatRef" )
}
#endif

#if SERVER || CLIENT || UI
int function GladiatorCardBadge_GetTierCount( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	var flavorBlock = ItemFlavor_GetSettingsBlock( flavor )
	return GetSettingsArraySize( GetSettingsBlockArray( flavorBlock, "tiers" ) )
}
#endif

#if SERVER || CLIENT || UI
GladCardBadgeTierData function GladiatorCardBadge_GetTierData( ItemFlavor flavor, int tierIdx )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	var flavorBlock        = ItemFlavor_GetSettingsBlock( flavor )
	var tierDataBlockArray = GetSettingsBlockArray( flavorBlock, "tiers" )
	Assert( tierIdx >= 0 && tierIdx < GetSettingsArraySize( tierDataBlockArray ) )
	var tierDataBlock = GetSettingsArrayElem( tierDataBlockArray, tierIdx )

	GladCardBadgeTierData data
	data.unlocksAt = GetSettingsBlockFloat( tierDataBlock, "unlocksAt" )
	data.ruiAsset = GetSettingsBlockStringAsAsset( tierDataBlock, "ruiAsset" )
	data.imageAsset = GetSettingsBlockAsset( tierDataBlock, "imageAsset" )
	return data
}
#endif

#if SERVER || CLIENT || UI
array<GladCardBadgeTierData> function GladiatorCardBadge_GetTierDataList( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	array<GladCardBadgeTierData> tierDataList = []
	for ( int tierIdx = 0; tierIdx < GladiatorCardBadge_GetTierCount( flavor ); tierIdx++ )
		tierDataList.append( GladiatorCardBadge_GetTierData( flavor, tierIdx ) )

	return tierDataList
}
#endif


#if CLIENT || UI
bool function GladiatorCardBadge_HasOwnRUI( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "hasOwnRui" )
}
#endif

#if CLIENT || UI 
bool function GladiatorCardBadge_IsOversizedImage( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_badge )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "isOversizedImage" )
}
#endif

#if SERVER || CLIENT || UI
bool function GladiatorCardTracker_IsTheEmpty( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stat_tracker )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "isTheEmpty" )
}
#endif


#if SERVER || CLIENT || UI
int function GladiatorCardStatTracker_GetSortOrdinal( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stat_tracker )

	return fileLevel.cosmeticFlavorSortOrdinalMap[flavor]
}
#endif


#if SERVER || CLIENT || UI
ItemFlavor function GladiatorCardStatTracker_GetCharacterFlavor( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stat_tracker )

	return fileLevel.trackerCharacterMap[flavor]
}
#endif


#if SERVER || CLIENT || UI
string function GladiatorCardStatTracker_GetStatRef( ItemFlavor flavor, ItemFlavor character )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stat_tracker )

	string statRef = GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "statRef" )
	statRef = StringReplace( statRef, "%char%", ItemFlavor_GetGUIDString( character ) )
	return statRef
}
#endif


#if SERVER || CLIENT || UI
int function GladiatorCardStatTracker_GetValueNumberFormat( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stat_tracker )

	return eStatTrackerValueFormat[GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "valueNumberFormat" )]
}
#endif


#if SERVER || CLIENT || UI
string function GladiatorCardStatTracker_GetValueSuffix( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stat_tracker )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "valueSuffix" )
}
#endif

#if SERVER || CLIENT || UI
asset function GladiatorCardStatTracker_GetBackgroundImage( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stat_tracker )

	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( flavor ), "backgroundImage" )
}
#endif


#if SERVER || CLIENT || UI
vector function GladiatorCardStatTracker_GetColor0( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.gladiator_card_stat_tracker )

	return GetGlobalSettingsVector( ItemFlavor_GetAsset( flavor ), "color0" )
}
#endif

#if SERVER || CLIENT || UI
string function GladiatorCardStatTracker_GetFormattedValueText( entity player, ItemFlavor character, ItemFlavor flavor )
{
	if ( GladiatorCardTracker_IsTheEmpty( flavor ) )
		return ""

	int valueFormat = GladiatorCardStatTracker_GetValueNumberFormat( flavor )
	string statRef  = GladiatorCardStatTracker_GetStatRef( flavor, character )

	StatEntry statEntry = GetStatEntryByRef( statRef )

	float statVal
	if ( StatEntry_GetType( statEntry ) == eStatType.INT )
	{
		statVal = float( GetStat_Int( player, statEntry ) )
	}
	else
	{
		Assert( StatEntry_GetType( statEntry ) == eStatType.FLOAT )
		statVal = GetStat_Float( player, statEntry )
	}

	string valueText
	if ( valueFormat == eStatTrackerValueFormat.FLOAT_TWO_POINTS )
	{
		valueText = format( "%0.2f", statVal )
	}
	else
	{
		Assert( valueFormat == eStatTrackerValueFormat.BASIC )
		valueText = format( "%i", statVal )
	}

	return valueText
}
#endif



#if CLIENT
void function ShGladiatorCards_OnDevnetBugScreenshot()
{
	#if R5DEV
		DEV_DumpCharacterCaptures()
	#endif
}
#endif

#if SERVER || CLIENT || UI
bool function GladiatorCardCharacterSkin_ShouldHideIfLocked( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.character_skin )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "shouldHideIfLocked" )
}
#endif


#if SERVER || CLIENT || UI
bool function GladiatorCardWeaponSkin_ShouldHideIfLocked( ItemFlavor flavor )
{
	Assert( ItemFlavor_GetType( flavor ) == eItemType.weapon_skin )

	return GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "shouldHideIfLocked" )
}
#endif


//
#if CLIENT || UI 
bool function GladiatorCardBadge_DoesStatSatisfyValue( ItemFlavor badge, float val )
{
	Assert( ItemFlavor_GetType( badge ) == eItemType.gladiator_card_badge )

	string unlockStatRef = GladiatorCardBadge_GetUnlockStatRef( badge, GladiatorCardBadge_GetCharacterFlavor( badge ) )
	Assert( IsValidStatEntryRef( unlockStatRef ) )
	StatEntry statEntry = GetStatEntryByRef( unlockStatRef )

	return DoesStatSatisfyValue( GetLocalClientPlayer(), statEntry, val, eStatGetWhen.CURRENT )
}
#endif