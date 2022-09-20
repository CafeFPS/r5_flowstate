global function Cl_Survival_LootInit

global function TryOpenQuickSwap
global function GetPropSurvivalUseEntity

global function Survival_Health_SetSelectedHealthPickupType
global function Survival_Health_GetSelectedHealthPickupType
global function Survival_UseHealthPack

global function DumpAttachmentTags
global function AttachmentTags
global function UpdateLootRuiWithData
global function LootGoesInPack
global function SetupSurvivalLoot
global function SetupCustomLoot
global function SURVIVAL_Loot_QuickSwap
global function SURVIVAL_Loot_UpdateRuiLastUseTime

global function PlayLootPickupFeedbackFX

global function ServerToClient_OnStartedUsingHealthPack

global function GetLootPromptStyle
global function GetEHIForDeathBox

global function DeathBoxGetExtendedUseSettings
global function CreateDeathBoxRui

global function GetHighlightFillAlphaForLoot

global const string PING_SOUND_DEFAULT = "ui_mapping_item_1p"
const float LOOT_PING_DISTANCE = 500.0

const bool LINE_COLORS = true

const float DEFAULT_FOV = 70.0

const float MAGIC_DEATHBOX_Z_OFFSET = 1.25

const bool HAS_ITEM_PICKUP_FEEDACK_FX = false
#if HAS_ITEM_PICKUP_FEEDACK_FX
const asset PICKUP_FEEDBACK_FX = $"P_impact_amped_shield"
#endif //

struct VerticalLineStruct
{
	var    topo
	var    rui
	entity ent
}

struct PlayerLookAtItem
{
	entity ent
	float playerViewDot
}

struct {
	int useAltBind = BUTTON_Y

	entity swapOnUseItem
	entity crosshairEntity
	entity currentLootRuiEntity

	var healthUseProgressRui

	var[eLootPromptStyle._COUNT]                lootPromptRui
	table<int, var[eLootPromptStyle._COUNT]>    lootTypePromptRui

	float nextHealthAllowTime = 0

	#if LOOT_GROUND_VERTICAL_LINES
		array<VerticalLineStruct> verticalLines
	#endif // #if LOOT_GROUND_VERTICAL_LINES
} file

void function Cl_Survival_LootInit()
{
	if ( !WeaponDrivenConsumablesEnabled() )
	{
		RegisterConCommandTriggeredCallback( "+weaponcycle", AttemptCancelHeal )
	}
	RegisterConCommandTriggeredCallback( "+offhand2", AttemptCancelHeal )
	RegisterConCommandTriggeredCallback( "+attack", AttemptCancelHeal )
	RegisterConCommandTriggeredCallback( "+melee", AttemptCancelHeal )
	RegisterConCommandTriggeredCallback( "+speed", AttemptCancelHeal )
	RegisterConCommandTriggeredCallback( "weaponSelectPrimary0", AttemptCancelHeal )
	RegisterConCommandTriggeredCallback( "weaponSelectPrimary1", AttemptCancelHeal )
	RegisterConCommandTriggeredCallback( "weaponSelectOrdnance", AttemptCancelHeal )
	RegisterConCommandTriggeredCallback( "+scriptCommand4", UseSelectedHealthPickupType )
	RegisterConCommandTriggeredCallback( "scoreboard_toggle_focus", UseSelectedHealthPickupType )
	RegisterConCommandTriggeredCallback( "+use_alt", TryHolsterWeapon )

	RegisterConCommandTriggeredCallback( "weaponSelectPrimary0", OnPlayerSwitchesToWeapon00 )
	RegisterConCommandTriggeredCallback( "weaponSelectPrimary1", OnPlayerSwitchesToWeapon01 )
	RegisterConCommandTriggeredCallback( "+weaponCycle", OnPlayerSwitchesWeapons )

	AddCreateTitanCockpitCallback( OnTitanCockpitCreated )
	AddCreatePilotCockpitCallback( OnPilotCockpitCreated )
	AddCallback_OnBleedoutStarted( Sur_OnBleedoutStarted )

	file.healthUseProgressRui = CreateCockpitRui( $"ui/health_use_progress.rpak", HUD_Z_BASE )

	AddCallback_OnPlayerLifeStateChanged( OnPlayerLifeStateChanged )

	AddCallback_UseEntGainFocus( Sur_OnUseEntGainFocus )
	AddCallback_UseEntLoseFocus( Sur_OnUseEntLoseFocus )

	AddCreateCallback( "prop_survival", OnPropCreated )
	AddCreateCallback( "prop_death_box", OnDeathBoxCreated )

	AddCallback_EntitiesDidLoad( SurvivalLoot_EntitiesDidLoad )

	#if LOOT_GROUND_VERTICAL_LINES
		for ( int i = 0; i < VERTICAL_LINE_COUNT; i++ )
		{
			var topo = RuiTopology_CreatePlane( <0, 0, 0>, <VERTICAL_LINE_WIDTH, 0, 0>, <0, 0, VERTICAL_LINE_HEIGHT>, true )
			var rui  = RuiCreate( $"ui/loot_pickup_line.rpak", topo, RUI_DRAW_WORLD, 0 )
			VerticalLineStruct v
			v.topo = topo
			v.rui = rui
			file.verticalLines.append( v )

			HideVerticalLineStruct( v )
		}
	#endif // #if LOOT_GROUND_VERTICAL_LINES

	#if HAS_ITEM_PICKUP_FEEDACK_FX
		PrecacheParticleSystem( PICKUP_FEEDBACK_FX )
	#endif //

	RegisterSignal( "TrackLootToPing" )
	RegisterSignal( "CreateDeathBoxRui" )

	var lootPromptRui   = CreateFullscreenRui( LOOT_PICKUP_HINT_DEFAULT_RUI, 1 )
	var weaponPromptRui = CreateFullscreenRui( WEAPON_PICKUP_HINT_DEFAULT_RUI, 1 )

	var compactLootPromptRui   = CreateFullscreenRui( LOOT_PICKUP_HINT_COMPACT_RUI, 1 )
	var compactWeaponPromptRui = CreateFullscreenRui( WEAPON_PICKUP_HINT_COMPACT_RUI, 1 )

	file.lootPromptRui[eLootPromptStyle.DEFAULT] = lootPromptRui
	file.lootPromptRui[eLootPromptStyle.COMPACT] = compactLootPromptRui

	file.lootTypePromptRui[eLootType.MAINWEAPON] <- _newPromptStyles()
	file.lootTypePromptRui[eLootType.MAINWEAPON][eLootPromptStyle.DEFAULT] = weaponPromptRui
	file.lootTypePromptRui[eLootType.MAINWEAPON][eLootPromptStyle.COMPACT] = compactWeaponPromptRui

	AddCallback_OnRefreshCustomGamepadBinds( OnRefreshCustomGamepadBinds )
}


var[eLootPromptStyle._COUNT] function _newPromptStyles()
{
	var[eLootPromptStyle._COUNT] newArray;
	return newArray;
}


void function SurvivalLoot_EntitiesDidLoad()
{
	thread ManageDeathBoxLoot()
	#if LOOT_GROUND_VERTICAL_LINES
		thread ManageVerticalLines()
	#endif // LOOT_GROUND_VERTICAL_LINES
}


void function PlayLootPickupFeedbackFX( entity ent )
{
	thread function() : ( ent )
	{
		ent.EndSignal( "OnDestroy" )
		ent.SetPredictiveHideForPickup()
		wait 1.0
		ent.ClearPredictiveHideForPickup()
	}()

	Chroma_PredictedLootPickup( ent )

	#if HAS_ITEM_PICKUP_FEEDACK_FX
		vector lootOrigin = ent.GetOrigin() + <0, 0, 0.5>
		entity entParent  = ent.GetParent()

		if ( IsValid( entParent ) )
		{
			vector offset = lootOrigin - entParent.GetOrigin()
			vector angles = <0, 0, 0>

			entity mover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", lootOrigin, angles )
			mover.SetParent( entParent )

			StartParticleEffectOnEntity( mover, GetParticleSystemIndex( PICKUP_FEEDBACK_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )

			thread DelayDestroy( mover )
		}
		else
		{
			StartParticleEffectInWorld( GetParticleSystemIndex( PICKUP_FEEDBACK_FX ), lootOrigin, <0, 0, 0> )
		}
	#endif //
}


void function DelayDestroy( entity mover )
{
	mover.EndSignal( "OnDestroy" )
	wait 0.5
	mover.Destroy()
}

bool function LootGoesInPack( entity player, LootRef lootRef )
{
	LootTypeData lt = GetLootTypeData( lootRef.lootData.lootType )

	if ( lootRef.lootData.inventorySlotCount == 0 )
		return false

	PerfStart( PerfIndexClient.LootGoesInPack )

	bool result = (lt.groundActionFunc( player, lootRef ).action == eLootAction.PICKUP || lt.groundAltActionFunc( player, lootRef ).action == eLootAction.PICKUP)

	PerfEnd( PerfIndexClient.LootGoesInPack )

	return result
}


void function OnPlayerLifeStateChanged( entity player, int oldState, int newState )
{
	if ( player == GetLocalViewPlayer() )
	{
		if ( newState != LIFE_ALIVE )
		{
			RunUIScript( "CloseSurvivalInventoryMenu" )
			RuiSetBool( file.healthUseProgressRui, "isVisible", false )
		}
		else
		{
			thread TrackLootToPing( player )
		}
	}
}


void function Survival_Health_SetSelectedHealthPickupType( int pickup )
{
	GetLocalClientPlayer().ClientCommand( "SetSelectedHealthPickupType " + pickup )
}


int function Survival_Health_GetSelectedHealthPickupType()
{
	entity viewPlayer = GetLocalViewPlayer()
	if ( IsValid( viewPlayer ) )
		return viewPlayer.GetPlayerNetInt( "selectedHealthPickupType" )

	return eHealthPickupType.HEALTH_SMALL
}


void function UseSelectedHealthPickupType( entity player )
{
	if ( HealthkitWheelToggleEnabled() && IsCommsMenuActive() )
		return
	printt("UseSelectedHealthPickupType ", WeaponDrivenConsumablesEnabled())

	if ( WeaponDrivenConsumablesEnabled() )
	{
		Consumable_UseCurrentSelectedItem( player )
	}
	else
	{
		int selectedPickupType = Survival_Health_GetSelectedHealthPickupType()
		if ( selectedPickupType == -1 )
		{
			selectedPickupType = SURVIVAL_GetBestHealthPickupType( player )
			if ( !Survival_CanUseHealthPack( player, selectedPickupType, true ) )
			{
				// We're trying to auto heal, but we can't use the pack it selected.  See what would be ideal, and test against that.
				//
				int idealKitType = SURVIVAL_GetBestHealthPickupType( player, false )
				Survival_CanUseHealthPack( player, idealKitType, true, true )
				return
			}
		}
		else
		{
			if ( !Survival_CanUseHealthPack( player, selectedPickupType, true, true ) )
				return
		}

		Survival_UseHealthPack( player, SURVIVAL_Loot_GetHealthPickupRefFromType( selectedPickupType ) )
	}
}


void function Survival_UseHealthPack( entity player, string ref )
{
	//if ( Time() < file.nextHealthAllowTime )
	//	return

	//file.nextHealthAllowTime = Time() + waitTime
	printt("!!! Sur_UseHealthPack", ref)
	player.ClientCommand( "Sur_UseHealthPack " + ref )
}


void function ServerToClient_OnStartedUsingHealthPack( int kitType )
{
	HealthPickup kitData = SURVIVAL_Loot_GetHealthKitDataFromStruct( kitType )
	LootData lootData    = kitData.lootData

	float waitScale
	if ( PlayerHasPassive( GetLocalViewPlayer(), ePassives.PAS_FAST_HEAL ) && (kitData.healAmount > 0) )
		waitScale = 0.5
	else if ( PlayerHasPassive( GetLocalViewPlayer(), ePassives.PAS_MEDIC ) && (kitData.healAmount > 0) )
		waitScale = 0.75
	else
		waitScale = 1.0
	float waitTime  = (kitData.interactionTime * waitScale)

	RuiSetBool( file.healthUseProgressRui, "isVisible", true )
	RuiSetImage( file.healthUseProgressRui, "icon", lootData.hudIcon )

	RuiSetGameTime( file.healthUseProgressRui, "startTime", Time() )
	RuiSetGameTime( file.healthUseProgressRui, "endTime", Time() + waitTime )
}


void function AttemptCancelHeal( entity player )
{
	if ( Survival_IsPlayerHealing( player ) )
	{
		if ( WeaponDrivenConsumablesEnabled() )
		{
			Consumable_CancelHeal( player )
		}
		else
		{
			RuiSetBool( file.healthUseProgressRui, "isVisible", false )
			GetLocalViewPlayer().ClientCommand( "Sur_CancelHeal" )
		}
	}
}


void function HideHealthProgressRui()
{
	RuiSetBool( file.healthUseProgressRui, "isVisible", false )
}


void function OnPilotCockpitCreated( entity cockpit, entity player )
{
	HideHealthProgressRui()
}


void function OnTitanCockpitCreated( entity cockpit, entity player )
{
	HideHealthProgressRui()
}


void function Sur_OnBleedoutStarted( entity victim, float endTime )
{
	if ( victim != GetLocalViewPlayer() )
		return

	HideHealthProgressRui()
}


void function OnDeathBoxCreated( entity ent )
{
	if ( ent.GetTargetName() == DEATH_BOX_TARGETNAME )
	{
		AddEntityCallback_GetUseEntOverrideText( ent, DeathBoxTextOverride )
		ent.SetDoDestroyCallback( true )
		//thread AttachCoverToDeathBox( ent )

		if ( ent.GetOwner() == GetLocalClientPlayer() )
		{
			thread CreateDeathBoxRui( ent )
		}
	}
}


void function AttachCoverToDeathBox( entity ent )
{
	ent.EndSignal( "OnDestroy" )

	entity plane = CreateClientSidePropDynamic( ent.GetOrigin() + <0, 0, MAGIC_DEATHBOX_Z_OFFSET>, ent.GetAngles(), DEATH_BOX_FLAT_PLANE )
	plane.SetParent( ent )

	OnThreadEnd(
		function() : ( plane )
		{
			if ( IsValid( plane ) )
				plane.Destroy()
		}
	)

	WaitForever()
}


void function CreateDeathBoxRui( entity deathBox )
{
	EHI ornull ehi = GetEHIForDeathBox( deathBox )
	if ( ehi == null )
		return

	expect EHI( ehi )

	clGlobal.levelEnt.Signal( "CreateDeathBoxRui" )
	clGlobal.levelEnt.EndSignal( "CreateDeathBoxRui" )

	deathBox.EndSignal( "OnDestroy" )

	float scale      = 0.0820
	float width      = 264 * scale
	float height     = 720 * scale
	vector ang       = deathBox.GetAngles()
	vector rgt       = AnglesToRight( ang )
	vector up        = AnglesToUp( ang )
	entity player    = GetLocalViewPlayer()
	vector playerDir = player.GetOrigin() - deathBox.GetOrigin()
	bool onBoxRight  = DotProduct2D( rgt, playerDir ) < 0.0
	float direction  = onBoxRight ? 1.0 : -1.0
	vector right     = <0, 1, 0> * height * 0.5 * direction
	vector fwd       = <1, 0, 0> * width * 0.5 * direction * -1.0

	vector org = <0.5, 0, deathBox.GetBoundingMaxs().z + MAGIC_DEATHBOX_Z_OFFSET - 0.9>

	var topo = RuiTopology_CreatePlane( org - right * 0.5 - fwd * 0.5, fwd, right, true )
	RuiTopology_SetParent( topo, deathBox )

	var rui = RuiCreate( $"ui/gladiator_card_deathbox.rpak", topo, RUI_DRAW_WORLD, MINIMAP_Z_BASE + 10 )

	NestedGladiatorCardHandle nestedGCHandle = CreateNestedGladiatorCard( rui, "card", eGladCardDisplaySituation.DEATH_BOX_STILL, eGladCardPresentation.FRONT_DETAILS )
	#if SERVER
		if (  deathBox.GetNetBool( "overrideRUI"  ) )
		{
			CreateDeathBoxRuiWithOverridenData( deathBox, nestedGCHandle  )
		}
	#endif
	ChangeNestedGladiatorCardOwner( nestedGCHandle, ehi, null, eGladCardLifestateOverride.ALIVE )

	OnThreadEnd (
		void function() : ( topo, rui, nestedGCHandle )
		{
			CleanupNestedGladiatorCard( nestedGCHandle )
			RuiDestroy( rui )
			RuiTopology_Destroy( topo )
		}
	)

	entity plane = CreateClientSidePropDynamic( deathBox.GetOrigin() + <0, 0, MAGIC_DEATHBOX_Z_OFFSET>, deathBox.GetAngles(), DEATH_BOX_FLAT_PLANE )
	plane.SetParent( deathBox )

	OnThreadEnd(
		function() : ( plane )
		{
			if ( IsValid( plane ) )
				plane.Destroy()
		}
	)

	WaitFrame()

	WaitForever()
}


string function DeathBoxTextOverride( entity ent )
{
	if ( ent.e.isBusy )
		return " "

	if ( ShouldPickupDNAFromDeathBox( ent, GetLocalViewPlayer() ) )
	{
		if ( ent.GetCustomOwnerName() != "" )
		{
			return Localize( "#HINT_PICKUP_DNA_USE", ent.GetCustomOwnerName() )
		}
		else
		{
			return Localize( "#HINT_PICKUP_DNA_USE", ent.GetOwner().GetPlayerName() )
		}
	}

	if ( ent.GetLinkEntArray().len() == 0 )
		return " "

	EHI ornull ehi = GetEHIForDeathBox( ent )
	if ( ehi == null )
		return ""
	expect EHI( ehi )
	if ( !EHIHasValidScriptStruct( ehi ) )
		return ""

	int team          = EHI_GetTeam( ehi )
	string playerName = GetPlayerName( ehi )

	if ( ent.GetCustomOwnerName() != "" ) //
		playerName = ent.GetCustomOwnerName()

	string hint       = "#DEATHBOX_HINT_NAME"

	if ( IsEnemyTeam( team, GetLocalViewPlayer().GetTeam() ) )
		hint = "#DEATHBOX_HINT_ENEMY"

	return Localize( hint, playerName )
}


void function OnPropCreated( entity prop )
{
	AddEntityCallback_GetUseEntOverrideText( prop, Sur_LootTextOverride )
}


var function GetLootPrompt( entity lootEnt )
{
	int style = GetLootPromptStyle()

	LootData data = SURVIVAL_Loot_GetLootDataByIndex( lootEnt.GetSurvivalInt() )
	if ( data.lootType in file.lootTypePromptRui )
		return file.lootTypePromptRui[data.lootType][style]

	return file.lootPromptRui[style]
}


int lastPromptStyle
int function GetLootPromptStyle()
{
	int style = GetConVarInt( HUD_SETTING_LOOTPROMPTSTYLE )
	Assert( style < eLootPromptStyle._COUNT )

	if ( style != lastPromptStyle )
		HideLootPrompts()

	lastPromptStyle = style

	return style
}


void function HideLootPrompts()
{
	foreach ( lootType, ruis in file.lootTypePromptRui )
	{
		foreach ( rui in ruis )
		{
			RuiSetVisible( rui, false )
			RuiSetBool( rui, "isVisible", false )
		}
	}

	foreach ( rui in file.lootPromptRui )
	{
		RuiSetVisible( rui, false )
		RuiSetBool( rui, "isVisible", false )
	}
}


string function Sur_LootTextOverride( entity ent )
{
	var rui = GetLootPrompt( ent )

	if ( Time() - ent.e.lastUseTime < 0.5 )
	{
		RuiSetVisible( rui, false )
	}
	else
	{
		RuiSetVisible( rui, true )
	}

	UpdateUseHintForEntity( ent )

	bool quickSwapActive = ent == file.swapOnUseItem
	if ( quickSwapActive )
	{
		LootData lootData       = SURVIVAL_Loot_GetLootDataByIndex( ent.GetSurvivalInt() )
		LootRef lootRef         = SURVIVAL_CreateLootRef( lootData, ent )
		LootActionStruct asMain = SURVIVAL_BuildStringForAction( GetLocalViewPlayer(), eLootContext.GROUND, lootRef, false, false )
		LootActionStruct asAlt  = SURVIVAL_BuildStringForAction( GetLocalViewPlayer(), eLootContext.GROUND, lootRef, true, false )


		if ( asMain.action == eLootAction.PICKUP )
		{
			if ( GetLootPromptStyle() == eLootPromptStyle.COMPACT )
				RuiSetString( rui, "usePromptText", Localize( "#HINT_SWAP_COMPACT" ) )
			else
				RuiSetString( rui, "usePromptText", Localize( "#HINT_SWAP_ON_USE" ) )
		}
		else if ( asAlt.action == eLootAction.PICKUP && ShouldShowButtonHints() )
		{
			if ( GetLootPromptStyle() == eLootPromptStyle.COMPACT )
				RuiSetString( rui, "altUsePromptText", Localize( "#HINT_SWAP_COMPACT_ALT" ) )
			else
				RuiSetString( rui, "altUsePromptText", Localize( "#HINT_SWAP_ON_USE_ALT" ) )
		}

	}

	//return "BRUH MOMENT NUMERO DOS"
	return ""
}


void function CheckSwapOnUse( entity ent )
{
	if ( ent.GetNetworkedClassName() == "prop_survival" && ent != file.swapOnUseItem )
	{
		LootData data   = SURVIVAL_Loot_GetLootDataByIndex( ent.GetSurvivalInt() )
		LootRef lootRef = SURVIVAL_CreateLootRef( data, null )
		if ( ShouldOpenQuickswap( ent ) )
		{
			thread SwapOnUseThread( ent )
		}
	}
}


void function Sur_OnUseEntGainFocus( entity ent )
{
	GetLocalViewPlayer().Signal( "TrackLootToPing" )

	UpdateUseHintForEntity( ent )

	if ( ent.GetNetworkedClassName() == "prop_survival" )
	{
		SURVIVAL_Loot_SetHighlightForLoot( ent, true )
		CheckSwapOnUse( ent )
		RuiSetGameTime( GetLootPrompt( ent ), "lastUseTime", 0 )
	}
	else if ( ent.GetTargetName() == DEATH_BOX_TARGETNAME )
	{
		thread CreateDeathBoxRui( ent )
	}
}


void function Sur_OnUseEntLoseFocus( entity ent )
{
	thread TrackLootToPing( GetLocalViewPlayer() )

	HideLootPrompts()

	clGlobal.levelEnt.Signal( "ClearSwapOnUseThread" )
	//clGlobal.levelEnt.Signal( "CreateDeathBoxRui" )

	if ( IsValid( ent ) && ent.GetNetworkedClassName() == "prop_survival" )
		SURVIVAL_Loot_SetHighlightForLoot( ent, false )
}

void function SURVIVAL_Loot_UpdateRuiLastUseTime( entity ent, var rui = null )
{
	if ( !IsConnected() )
		return

	if ( rui == null )
		rui = GetLootPrompt( ent )

	RuiSetGameTime( rui, "lastUseTime", Time() )
}

void function UpdateUseHintForEntity( entity ent, var rui = null )
{
	if ( !IsConnected() )
		return

	if ( !ShouldLootHintBeVisible( ent ) )
	{
		HideLootPrompts()
		if ( rui != null )
			RuiSetVisible( rui, false )
		return
	}

	PerfStart( PerfIndexClient.UpdateLootRui )

	CheckSwapOnUse( ent )

	if ( rui == null )
		rui = GetLootPrompt( ent )

	entity player                 = GetLocalViewPlayer()
	bool isPinged                 = Waypoint_LootItemIsBeingPingedByAnyone( ent )
	entity focusedWp              = GetFocusedWaypointEnt()
	bool isFocusedOnOtherWaypoint = (IsValid( focusedWp ) && (focusedWp != ent))
	LootData data                 = SURVIVAL_Loot_GetLootDataByIndex( ent.GetSurvivalInt() )

	RuiSetBool( rui, "isTooltip", false )
	RuiSetBool( rui, "isPinged", isPinged )
	RuiSetBool( rui, "isFocusedOnOtherWaypoint", isFocusedOnOtherWaypoint )
	RuiSetGameTime( rui, "localPingBeginTime", ent.e.localPingBeginTime )

	LootRef lootRef = SURVIVAL_CreateLootRef( data, ent )
	lootRef.count = ent.GetClipCount()
	UpdateLootRuiWithData( player, rui, data, eLootContext.GROUND, lootRef, false )

	entity pingWaypoint = Waypoint_GetWaypointForLootItemPingedBy( ent, player )
	RuiSetBool( rui, "isPingedByUs", IsValid( pingWaypoint ) )
	RuiSetInt( rui, "eHandle", ent.GetEncodedEHandle() )
	RuiSetInt( rui, "predictedUseCount", ent.e.predictedUseCount )

	RuiTrackFloat3( rui, "worldPos", ent, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiSetFloat( rui, "zOffset", ent.GetBoundingMaxs().z )

	PerfEnd( PerfIndexClient.UpdateLootRui )
}

table<string, string> function BuildAttachmentMapForPickupPrompt( entity player, LootData data, LootRef lootRef, LootActionStruct asMain )
{
	//
	if ( IsValid( lootRef.lootEnt ) && SURVIVAL_Weapon_IsAttachmentLocked( data.ref ) )
	{
		table<string, string> results
		array<string> mods = lootRef.lootEnt.GetWeaponMods()
		foreach ( mod in mods )
		{
			if ( SURVIVAL_Loot_IsRefValid( mod ) && (SURVIVAL_Loot_GetLootDataByRef( mod ).lootType == eLootType.ATTACHMENT) )
			{
				string attachPoint = GetAttachPointForAttachment( mod )
				results[attachPoint] <- mod
			}
		}

		return results
	}

	//
	array<entity> weapons = SURVIVAL_GetPrimaryWeaponsSorted( player )
	entity latestPrimary = (weapons.len() > 0) ? weapons[0] : null
	if ( IsValid( latestPrimary ) && (asMain.action == eLootAction.SWAP) )
	{
		LootData weapData = SURVIVAL_GetLootDataFromWeapon( latestPrimary )
		if ( (weapData.lootType == eLootType.MAINWEAPON) && SURVIVAL_Loot_IsRefValid( weapData.ref ) && !SURVIVAL_Weapon_IsAttachmentLocked( weapData.ref )  )
			return GetCompatibleAttachmentMap( player, latestPrimary, data.ref, true )
	}

	//
	return GetCompatibleAttachmentsFromInventory( player, data.ref )
}

void function UpdateLootRuiWithData( entity player, var rui, LootData data, int lootContext, LootRef lootRef, bool isInMenu )
{
	RuiSetVisible( rui, true )
	RuiSetBool( rui, "isVisible", true )
	RuiSetBool( rui, "isFocused", true )

	RuiSetImage( rui, "iconImage", data.hudIcon )
	RuiSetInt( rui, "lootTier", data.tier )

	vector iconScale = data.lootType == eLootType.MAINWEAPON ? <2.0, 1.0, 0.0> : <1.0, 1.0, 0.0>
	RuiSetFloat2( rui, "iconScale", iconScale )

	RuiSetString( rui, "titleText", Localize( data.pickupString ).toupper() )
	RuiSetString( rui, "subText", data.desc )

	RuiSetBool( rui, "canPing", ShouldShowButtonHints() && !isInMenu && IsPingEnabledForPlayer( player ) )

	string passiveName = data.passive != ePassives.INVALID ? PASSIVE_NAME_MAP[data.passive] : ""
	string passiveDesc = data.passive != ePassives.INVALID ? PASSIVE_DESCRIPTION_SHORT_MAP[data.passive] : ""
	RuiSetString( rui, "passiveText", passiveName )
	RuiSetString( rui, "passiveDesc", passiveDesc )

	LootActionStruct asMain = SURVIVAL_BuildStringForAction( player, lootContext, lootRef, false, isInMenu )
	LootActionStruct asAlt  = SURVIVAL_BuildStringForAction( player, lootContext, lootRef, true, isInMenu )

	RuiSetInt( rui, "lootTierReplace", 0 )
	RuiSetImage( rui, "replaceImage", $"" )
	RuiSetString( rui, "replacePassive", "" )
	RuiSetString( rui, "replaceName", "" )
	RuiSetBool( rui, "hasReplace", false )
	RuiSetInt( rui, "propertyValue", -1 )
	RuiSetInt( rui, "replacePropertyValue", -1 )


	RuiSetString( rui, "usePromptText", asMain.displayString )
	if ( asMain.additionalData.ref != "" )
	{
		RuiSetInt( rui, "lootTierReplace", asMain.additionalData.tier )
		RuiSetImage( rui, "replaceImage", asMain.additionalData.hudIcon )
		if ( asMain.additionalData.pickupString.len() <= 1 )
			RuiSetString( rui, "replaceName", "#EMPTY" )
		else
			RuiSetString( rui, "replaceName", asMain.additionalData.pickupString )

		RuiSetBool( rui, "hasReplace", true )

		if ( asMain.additionalData.passive != ePassives.INVALID )
		{
			RuiSetString( rui, "replacePassive", PASSIVE_NAME_MAP[asMain.additionalData.passive] )
		}

		if ( asMain.additionalData.lootType == eLootType.ARMOR )
		{
			RuiSetInt( rui, "replacePropertyValue", int( SURVIVAL_GetPlayerShieldHealthFromArmor( player ) / float(SURVIVAL_GetArmorShieldCapacity( asMain.additionalData.tier )) * 100) )
		}
	}

	RuiSetString( rui, "altUsePromptText", "" )

	if ( asMain.action != asAlt.action )
	{
		if ( ShouldShowButtonHints() || isInMenu )
			RuiSetString( rui, "altUsePromptText", asAlt.displayString )

		if ( asAlt.additionalData.ref != "" )
		{
			RuiSetInt( rui, "lootTierReplace", asAlt.additionalData.tier )
			RuiSetImage( rui, "replaceImage", asAlt.additionalData.hudIcon )
			RuiSetString( rui, "replaceName", asAlt.additionalData.pickupString )
			RuiSetBool( rui, "hasReplace", true )
		}
	}

	if ( (data.lootType == eLootType.HEALTH || data.lootType == eLootType.AMMO) && lootRef.count > 1 )
	{
		RuiSetString( rui, "titleText", Localize( "#SURVIVAL_PICKUP_STACK_COUNT", Localize( data.pickupString ).toupper(), lootRef.count ) )
	}
	else if ( data.lootType == eLootType.ARMOR )
	{
		if ( !isInMenu && GetLootPromptStyle() == eLootPromptStyle.COMPACT )
			RuiSetString( rui, "titleText", Localize( "#SURVIVAL_PICKUP_ARMOR_STATUS", Localize( data.pickupString ).toupper(), lootRef.lootProperty, SURVIVAL_GetArmorShieldCapacity( data.tier ) ) )

		RuiSetInt( rui, "propertyValue", int(lootRef.lootProperty / float(SURVIVAL_GetArmorShieldCapacity( data.tier )) * 100) )
	}

	if ( data.ammoType != "" )
	{
		string ammoType   = data.ammoType
		LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoType )
		RuiSetImage( rui, "ammoImage", ammoData.hudIcon )
	}
	else
	{
		asset icon = data.fakeAmmoIcon
		RuiSetImage( rui, "ammoImage", icon )
	}

	RuiSetImage( rui, "attachWeapon1Icon", $"" )
	RuiSetBool( rui, "hasAttach1", false )

	const int MAX_ATTACHMENT_TAGS = 4
	for ( int index = 0; index < MAX_ATTACHMENT_TAGS; index++ )
	{
		RuiSetString( rui, "tagText" + (index + 1), "" )
	}
	RuiSetInt( rui, "numTags", 0 )
	RuiSetString( rui, "typeText", "" )
	RuiSetString( rui, "typeTextTag", "" )

	string generalType = SURVIVAL_Loot_GetGeneralTypeStringFromType( data.lootType )
	string detailType  = SURVIVAL_Loot_GetDetailTypeStringFromRef( data.ref )
	if ( data.lootType == eLootType.MAINWEAPON )
	{
		RuiSetString( rui, "skinName", "" )
		RuiSetInt( rui, "skinTier", 0 )

		if ( lootRef.lootProperty > 0 )
		{
			ItemFlavor weaponSkin = GetItemFlavorByNetworkIndex_DEPRECATED( lootRef.lootProperty )
			if ( ItemFlavor_HasQuality( weaponSkin ) )
			{
				string weaponName = GetWeaponInfoFileKeyField_GlobalString( data.baseWeapon, "shortprintname" )
				RuiSetString( rui, "titleText", Localize( weaponName ).toupper() )
				RuiSetString( rui, "skinName", ItemFlavor_GetLongName( weaponSkin ) )
				RuiSetInt( rui, "skinTier", ItemFlavor_GetQuality( weaponSkin ) + 1 )
			}
		}

		for ( int index = 0; index < 5; index++ )
		{
			RuiSetImage( rui, "attachEmptyImage" + (index + 1), $"" )
			RuiSetImage( rui, "attachImage" + (index + 1), $"" )
			RuiSetInt( rui, "attachTier" + (index + 1), -1 )
		}

		RuiSetString( rui, "typeText", Localize( "#LOOT_TYPE_WEAPON", Localize( generalType ) ) )
		RuiSetString( rui, "typeTextTag", detailType )


		int attachmentCount = 0
		int numSwaps        = 0
		table<string, string> attachmentMap = BuildAttachmentMapForPickupPrompt( player, data, lootRef, asMain )
		foreach ( string attachmentPoint in data.supportedAttachments )
		{
			attachmentCount++

			string attachmentStyle = GetAttachmentPointStyle( attachmentPoint, data.ref )
			if ( attachmentPoint in attachmentMap && attachmentMap[attachmentPoint] != "" )
			{
				LootData attachmentData = SURVIVAL_Loot_GetLootDataByRef( attachmentMap[attachmentPoint] )
				RuiSetImage( rui, "attachImage" + attachmentCount, attachmentData.hudIcon )
				RuiSetInt( rui, "attachTier" + attachmentCount, attachmentData.tier )

				bool lootIsGoldAttach = SURVIVAL_Weapon_IsAttachmentLocked( data.ref )
				if ( lootIsGoldAttach )
					RuiSetInt( rui, "attachTier" + attachmentCount, data.tier )
				else
					numSwaps++
			}
			else
			{
				RuiSetImage( rui, "attachImage" + attachmentCount, $"" )
				RuiSetInt( rui, "attachTier" + attachmentCount, 0 )
			}

			RuiSetImage( rui, "attachEmptyImage" + attachmentCount, emptyAttachmentSlotImages[attachmentStyle] )
		}

		if ( numSwaps > 1 )
			RuiSetString( rui, "attachSwapText", Localize( "#LOOT_SWAP_COUNT_N", numSwaps ) )
		else if ( numSwaps == 1 )
			RuiSetString( rui, "attachSwapText", Localize( "#LOOT_SWAP_COUNT_1", numSwaps ) )
		else
			RuiSetString( rui, "attachSwapText", "" )
	}
	else if ( detailType != "" )
	{
		RuiSetString( rui, "typeText", Localize( "#LOOT_TYPE_GENERAL", Localize( generalType ), Localize( detailType ) ) )
	}
	else
	{
		RuiSetString( rui, "typeText", Localize( generalType ) )
	}


	if ( data.lootType == eLootType.ATTACHMENT )
	{
		array<entity> weapons = SURVIVAL_GetPrimaryWeaponsSorted( player )

		int action = asAlt.action

		if ( action != eLootAction.ATTACH_TO_ACTIVE && action != eLootAction.ATTACH_TO_STOWED )
			action = asMain.action

		int slot = -1
		if ( action == eLootAction.ATTACH_TO_ACTIVE )
		{
			slot = 0
		}

		if ( action == eLootAction.ATTACH_TO_STOWED )
		{
			slot = 1
		}

		if ( slot != -1 && slot < weapons.len() )
		{
			entity weapon = weapons[slot]
			if ( SURVIVAL_Loot_IsRefValid( weapon.GetWeaponClassName() ) )
			{
				LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( weapon.GetWeaponClassName() )
				RuiSetImage( rui, "attachWeapon1Icon", weaponData.hudIcon )
				RuiSetBool( rui, "hasAttach1", true )
			}
		}

		AttachmentTagData attachmentTagData = AttachmentTags( data.ref )
		RuiSetInt( rui, "numTags", attachmentTagData.attachmentTags.len() )

		if ( attachmentTagData.ammoRef != "" )
		{
			LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( attachmentTagData.ammoRef )

			bool hasCompatibleWeapon = true//IsAmmoInUse( player, attachmentTagData.ammoRef )
			if ( hasCompatibleWeapon )
				RuiSetString( rui, "tagText1", Localize( "#LOOT_FIT_AMMO", ammoData.hudIcon ) )
			else
				RuiSetString( rui, "tagText1", Localize( "#LOOT_FIT_AMMO_NONE", ammoData.hudIcon ) )
		}
		else
		{
			int tagIndex = 0
			foreach ( int tagId in attachmentTagData.attachmentTags )
			{
				if ( tagIndex < MAX_ATTACHMENT_TAGS && passiveDesc == "" )
				{
					bool hasWeaponForTag = true//HasWeaponForTag( player, tagId )
					if ( hasWeaponForTag )
						RuiSetString( rui, "tagText" + (tagIndex + 1), GetStringForTagId( tagId ) )
					else
						RuiSetString( rui, "tagText" + (tagIndex + 1), "`2" + GetStringForTagId( tagId ) + "`0" )
				}

				tagIndex++
			}

			foreach ( index, weaponRef in attachmentTagData.weaponRefs )
			{
				if ( tagIndex < MAX_ATTACHMENT_TAGS && passiveDesc == "" )
				{
					string weaponName = GetWeaponInfoFileKeyField_GlobalString( weaponRef, "shortprintname" )
					if ( index < attachmentTagData.weaponRefs.len() - 1 )
						weaponName += ","

					bool hasWeapon = true//HasWeapon( player, weaponRef, [], false )
					if ( hasWeapon )
						RuiSetString( rui, "tagText" + (tagIndex + 1), weaponName )
					else
						RuiSetString( rui, "tagText" + (tagIndex + 1), "`2" + weaponName + "`0" )
				}

				tagIndex++
			}
		}
	}
	else if ( data.lootType == eLootType.AMMO )
	{
		array<entity> weapons = SURVIVAL_GetPrimaryWeaponsSorted( player )
		foreach ( weapon in weapons )
		{
			string weaponRef = weapon.GetWeaponClassName()
			if ( SURVIVAL_Loot_IsRefValid( weaponRef ) && IsWeaponKeyFieldDefined( weaponRef, "ammo_pool_type" ) )
			{
				string ammoType = GetWeaponInfoFileKeyField_GlobalString( weaponRef, "ammo_pool_type" )
				if ( ammoType == data.ref )
				{
					LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( weaponRef )
					RuiSetImage( rui, "attachWeapon1Icon", weaponData.hudIcon )
					RuiSetBool( rui, "hasAttach1", true )
					break
				}
			}
		}
	}
}


bool function HasWeaponForTag( entity player, int tagId )
{
	array<entity> weapons = player.GetMainWeapons()
	foreach ( weapon in weapons )
	{
		string weaponRef = weapon.GetWeaponClassName()
		if ( !SURVIVAL_Loot_IsRefValid( weaponRef ) )
			continue

		LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( weaponRef )
		if ( weaponData.lootType != eLootType.MAINWEAPON )
			continue

		switch ( tagId )
		{
			case eAttachmentTag.ALL:
				return true;

			case eAttachmentTag.PISTOL:
			case eAttachmentTag.ASSAULT:
			case eAttachmentTag.SHOTGUN:
			case eAttachmentTag.LMG:
			case eAttachmentTag.SNIPER:
			case eAttachmentTag.SMG:
			case eAttachmentTag.LAUNCHER:
				if ( weaponClassToTag[weaponData.lootTags[0]] == tagId )
					return true
				break

			case eAttachmentTag.BARREL:
				if ( AttachmentPointSupported( "barrel", weaponRef ) )
					return true
				break

			default:
				Assert( 0, "Unhandled tag " + tagId )
		}
	}

	return false
}


bool function ShouldLootHintBeVisible( entity prop )
{
	if ( !IsValid( prop ) )
		return false

	if ( prop.GetNetworkedClassName() != "prop_survival" )
		return false

	if ( prop.GetSurvivalInt() < 0 )
		return false

	if ( prop.e.isBusy )
		return false

	entity player = GetLocalViewPlayer()

	if ( player.GetWeaponDisableFlags() == WEAPON_DISABLE_FLAGS_ALL )
	{
		return false
	}

	if ( GetAimAssistCurrentTarget() )
		return false

	return true
}

void function ManageDeathBoxLoot()
{
	while ( 1 )
	{
		WaitFrame()

		entity player = GetLocalViewPlayer()

		if ( !IsValid( player ) )
			continue

		if ( player != GetLocalClientPlayer() )
			continue

		if ( !player.IsPhaseShifted() )
		{
			if ( Survival_IsGroundlistOpen() )
			{
				array<entity> loot

				if ( IsValid( Survival_GetDeathBox() ) )
				{
					switch ( Survival_GetGroundListBehavior() )
					{
						case eGroundListBehavior.CONTENTS:
							loot = Survival_GetDeathBoxItems()
							break

						case eGroundListBehavior.NEARBY:
							loot = GetSurvivalLootNearbyPlayer( player, SURVIVAL_GROUNDLIST_NEARBY_RADIUS, false, false )
							break
					}
				}
				else if ( IsValid( file.swapOnUseItem ) )
				{
					loot = GetSurvivalLootNearbyPlayer( player, SURVIVAL_PICKUP_ALL_MAX_RANGE, true, false )
				}

				GroundItemUpdate( player, loot )
			}
		}
	}
}


void function ManageVerticalLines()
{
	while ( 1 )
	{
		WaitFrame()

		entity player = GetLocalViewPlayer()

		if ( !IsValid( player ) )
			continue

		if ( player != GetLocalClientPlayer() )
			continue

		if ( !CanPlayerLoot( player ) )
			continue

		array<entity> loot

		int l
		int v

		entity useEntity = GetPropSurvivalUseEntity( player )
		float scalar     = GraphCapped( GetFovScalar( player ), 1.0, 2.0, 1.0, 3.0 )

		if ( !player.IsPhaseShifted() )
		{
			vector org
			if ( player.ContextAction_IsInVehicle() )
				org = player.EyePosition()
			else
				org = player.GetOrigin()

			if ( !Survival_IsGroundlistOpen() )
			{
				loot = GetSurvivalLootNearbyPos( org, VERTICAL_LINE_DIST_MAX, false, true )

				if ( useEntity != null )
				{
					vector fwd = AnglesToForward( player.CameraAngles() )
					fwd = Normalize( < fwd.x, fwd.y, 0.0 > )
					vector rgt  = CrossProduct( fwd, <0, 0, 1> )
					float width = VERTICAL_LINE_WIDTH

					if ( useEntity == player.GetUsePromptEntity() )
						width *= 3.0

					float dist = Distance( useEntity.GetOrigin(), player.CameraPosition() ) / scalar
					if ( LOOT_PING_DISTANCE > VERTICAL_LINE_DIST_MAX )
						width *= GraphCapped( dist, VERTICAL_LINE_DIST_MAX, LOOT_PING_DISTANCE, 1.0, 2.0 )

					RuiTopology_UpdatePos( file.verticalLines[v].topo, useEntity.GetOrigin() - (0.5 * rgt * width), rgt * width, <0, 0, VERTICAL_LINE_HEIGHT> )
					ShowVerticalLineStruct( file.verticalLines[v], useEntity )
					RuiSetBool( file.verticalLines[v].rui, "isSelected", true )

					file.verticalLines[v].ent = useEntity

					v++
				}
			}
		}

		while ( v < VERTICAL_LINE_COUNT )
		{
			if ( loot.len() > l )
			{
				entity item = loot[ l++ ]

				if ( IsValid( item.GetParent() ) )
				{
					entity p = item.GetParent()
					if ( p.IsPlayer() )
						continue

					if ( p.GetTargetName() == DEATH_BOX_TARGETNAME )
						continue
				}

				if ( IsValid( item ) && !item.DoesShareRealms( player ) )
					continue

				if ( !PlayerCanSeePos( player, item.GetOrigin(), false, 65 ) )
					continue

				vector fwd = AnglesToForward( player.CameraAngles() )
				fwd = Normalize( < fwd.x, fwd.y, 0.0 > )
				vector rgt = CrossProduct( fwd, <0, 0, 1> )

				RuiTopology_UpdatePos( file.verticalLines[v].topo, item.GetOrigin() - (0.5 * rgt * VERTICAL_LINE_WIDTH / scalar), rgt * VERTICAL_LINE_WIDTH / scalar, <0, 0, VERTICAL_LINE_HEIGHT> )
				ShowVerticalLineStruct( file.verticalLines[v], item )

				file.verticalLines[v].ent = item

				v++
			}
			else
			{
				file.verticalLines[v].ent = null
				HideVerticalLineStruct( file.verticalLines[v] )
				v++
			}
		}
	}
}

void function ShowVerticalLineStruct( VerticalLineStruct lineStruct, entity ent )
{
	if ( !IsValid( ent ) || (ent.GetNetworkedClassName() != "prop_survival") || (ent.GetSurvivalInt() < 0) || ent.HasPredictiveHideForPickup() )
	{
		HideVerticalLineStruct( lineStruct )
		return
	}

	entity player = GetLocalViewPlayer()

	RuiSetBool( lineStruct.rui, "isSelected", false )
	RuiSetVisible( lineStruct.rui, true )
	RuiSetFloat3( lineStruct.rui, "worldPos", ent.GetOrigin() )
	RuiSetBool( lineStruct.rui, "isVisible", true )

	#if LINE_COLORS
		LootData data = SURVIVAL_Loot_GetLootDataByIndex( ent.GetSurvivalInt() )
		RuiSetInt( lineStruct.rui, "tier", data.tier )
	#else
		RuiSetInt( lineStruct.rui, "tier", 1 )
	#endif

	bool isPinged = Waypoint_LootItemIsBeingPingedByAnyone( ent )
	RuiSetBool( lineStruct.rui, "isPinged", isPinged )
}

void function HideVerticalLineStruct( VerticalLineStruct lineStruct )
{
	RuiSetBool( lineStruct.rui, "isVisible", false )
	RuiSetVisible( lineStruct.rui, false )
}

bool function TryOpenQuickSwap( entity overrideItem = null )
{
	entity itemToUse = overrideItem
	if ( !IsValid( itemToUse ) )
	{
		itemToUse = file.swapOnUseItem
	}

	if ( IsValid( itemToUse ) && GetLocalViewPlayer() == GetLocalClientPlayer() && !IsWatchingReplay() )
	{
		entity player = GetLocalClientPlayer()

		entity deathBox = player.GetUsePromptEntity()
		if ( deathBox.GetTargetName() != DEATH_BOX_TARGETNAME )
			deathBox = null

		if ( itemToUse.GetTargetName() != DEATH_BOX_TARGETNAME )
		{
			LootData data = SURVIVAL_Loot_GetLootDataByIndex( itemToUse.GetSurvivalInt() )
			thread OpenSwapForItem( data.ref, string( itemToUse.GetEncodedEHandle() ) )
		}
		else
		{
			OpenSurvivalGroundList( player, deathBox )
		}

		return true
	}

	return false
}


void function SwapOnUseThread( entity item )
{
	clGlobal.levelEnt.Signal( "ClearSwapOnUseThread" )
	clGlobal.levelEnt.EndSignal( "ClearSwapOnUseThread" )
	item.EndSignal( "OnDestroy" )

	entity player = GetLocalViewPlayer()

	player.EndSignal( "OnDeath" )

	file.swapOnUseItem = item

	OnThreadEnd(
		function() : ()
		{
			file.swapOnUseItem = null
		}
	)

	WaitEndFrame()

	while ( player.GetUsePromptEntity() == file.swapOnUseItem )
		WaitFrame()
}

bool function ShouldOpenQuickswap( entity ent )
{
	entity player = GetLocalViewPlayer()

	int lootIndex = ent.GetSurvivalInt()
	Assert( lootIndex >= 0 )

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( lootIndex )
	LootRef lootRef   = SURVIVAL_CreateLootRef( lootData, ent )
	bool lootGoesInPack = LootGoesInPack( GetLocalViewPlayer(), lootRef )

	if ( lootGoesInPack && SURVIVAL_AddToPlayerInventory( player, lootData.ref, ent.GetClipCount(), false ) == 0 )
	{
		return true
	}

	return false
}

const int PF_IS_WEAPON					= 1 << 0
const int PF_IS_AMMO					= 1 << 1
const int PF_IS_KITTED					= 1 << 2

void function TrackLootToPing( entity player )
{
	player.Signal( "TrackLootToPing" )
	player.EndSignal( "TrackLootToPing" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	if ( player != GetLocalClientPlayer() )
		return

	if ( !CanPlayerLoot( player ) )
		return

	table e
	e.farRui <- null

	OnThreadEnd(
		function() : ( e )
		{
			if ( e.farRui != null )
				RuiDestroy( e.farRui )
			file.crosshairEntity = null
		}
	)

	entity lastEnt

	while ( IsValid( player ) )
	{
		bool shouldLookForLoot = (GetAimAssistCurrentTarget() == null &&
						player.GetTargetInCrosshairRange() == null &&
				!player.IsPhaseShifted()
				)

		array<entity> loot
		if ( shouldLookForLoot )
		{
			if ( player.ContextAction_IsInVehicle() )
				loot = GetSurvivalLootNearbyPos( player.EyePosition(), LOOT_PING_DISTANCE * GetFovScalar( player ), false, false )
			else
				loot = GetSurvivalLootNearbyPlayer( player, LOOT_PING_DISTANCE * GetFovScalar( player ), false, false )
			file.crosshairEntity = GetEntityPlayerIsLookingAt( player, loot )
		}
		else
		{
			file.crosshairEntity = null
		}

		if ( IsValid( file.crosshairEntity ) )
		{
			if ( e.farRui == null )
			{
				LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( file.crosshairEntity.GetSurvivalInt() )
				switch ( lootData.lootType )
				{
					case eLootType.MAINWEAPON:
						e.farRui = CreateFullscreenRui( $"ui/loot_pickup_hint_weapon_far.rpak", -1 )
						break

					case eLootType.AMMO:
						e.farRui = CreateFullscreenRui( $"ui/loot_pickup_hint_far.rpak", -1 )
						//RuiSetInt( e.farRui, "promptFlags", PF_IS_AMMO )
						break

					default:
						e.farRui = CreateFullscreenRui( $"ui/loot_pickup_hint_far.rpak", -1 )
				}

				RuiSetGameTime( e.farRui, "lastItemChangeTime", Time() )
			}

			UpdateUseHintForEntity( file.crosshairEntity, e.farRui )
		}
		else
		{
			if ( e.farRui != null )
				RuiSetBool( e.farRui, "isVisible", false )
		}

		if ( lastEnt != file.crosshairEntity )
		{
			if ( e.farRui != null )
			{
				RuiDestroy( e.farRui )
				e.farRui = null
			}

			lastEnt = file.crosshairEntity
		}

		WaitFrame()
	}
}

int function PlayerLookSort( PlayerLookAtItem entA, PlayerLookAtItem entB )
{
	if ( entA.playerViewDot < entB.playerViewDot )
		return 1

	if ( entA.playerViewDot > entB.playerViewDot )
		return -1

	return 0
}

entity function GetEntityPlayerIsLookingAt( entity player, array<entity> ents, float degrees = 8 )
{
	entity theEnt
	float largestDot = -1.0

	float minDot = deg_cos( degrees )
	float dot

	array<PlayerLookAtItem> finalLootEnts

	vector playerEyePos = player.EyePosition()

	foreach ( ent in ents )
	{
		if ( IsValid( ent.GetParent() ) )
		{
			if ( ent.GetParent().GetTargetName() == DEATH_BOX_TARGETNAME )
				continue
		}

		dot = DotProduct( Normalize( ent.GetWorldSpaceCenter() - playerEyePos ), player.GetViewVector() )
		if ( dot < minDot )
			continue

		if ( ent.e.canUseEntityCallback != null )
		{
			if ( !ent.e.canUseEntityCallback( player, ent ) )
				continue
		}

		PlayerLookAtItem lootItem
		lootItem.ent = ent
		lootItem.playerViewDot = dot
		finalLootEnts.append( lootItem )

#if R5DEV
		//DebugDrawMark( ent.GetWorldSpaceCenter(), 10, [255, 128, 0], true, 10.0 )
		//DebugDrawText( ent.GetWorldSpaceCenter() + <0,0,16>, format( "%f\n", dot ), false, 0.1 )
#endif
	}

	finalLootEnts.sort( PlayerLookSort )

	foreach ( item in finalLootEnts )
	{
		TraceResults result = TraceLineHighDetail( playerEyePos, item.ent.GetWorldSpaceCenter(), player, TRACE_MASK_SOLID_BRUSHONLY, TRACE_COLLISION_GROUP_PLAYER )
		if ( result.fraction == 1.0 )
		{
			theEnt = item.ent
			break
		}
	}

	return theEnt
}


entity function GetPropSurvivalUseEntity( entity player )
{
	entity useEnt = player.GetUsePromptEntity() != null ? player.GetUsePromptEntity() : file.crosshairEntity
	if ( !IsValid( useEnt ) )
		return null

	if ( Bleedout_IsBleedingOut( player ) )
		return null

	if ( useEnt.GetNetworkedClassName() != "prop_survival" )
		return null

	if ( useEnt.GetSurvivalInt() < 0 )
		return null

	return useEnt
}


float function GetFovScalar( entity player )
{
	float fov     = DEFAULT_FOV
	float adsFrac = player.GetAdsFraction()
	if ( adsFrac == 1.0 )
	{
		entity weapon = player.GetLatestPrimaryWeapon( eActiveInventorySlot.mainHand )
		if ( IsValid( weapon ) )
			fov = weapon.GetWeaponZoomFOV()
	}

	return DEFAULT_FOV / fov
}


void function DumpAttachmentTags()
{
	var attachmentMatrix = GetDataTable( $"datatable/weapon_attachment_matrix.rpak" )
	for ( int row = 0; row < GetDatatableRowCount( attachmentMatrix ); row++ )
	{
		string attachment      = GetDataTableString( attachmentMatrix, row, GetDataTableColumnByName( attachmentMatrix, "attachmentName" ) )
		string attachmentPoint = GetDataTableString( attachmentMatrix, row, GetDataTableColumnByName( attachmentMatrix, "attachmentPoint" ) )
		AttachmentTags( attachment )
	}
}


AttachmentTagData function AttachmentTags( string attachment )
{
	AttachmentData aData = GetAttachmentData( attachment )
	return aData.tagData
}

void function SetupSurvivalLoot( var categories )
{
	string cats              = expect string( categories )
	array<string> stringCats = split( cats, " " )

	if (stringCats.contains("attachment_custom"))
	{
		SetupCustomLoot( "attachment" )
		return	
	}

	// turn menu strings into real category enums
	array<int> catTypes
	foreach( string cat in stringCats )
		catTypes.append( SURVIVAL_Loot_GetLootTypeFromString( cat ) )

	// HACK
	if ( catTypes.contains( eLootType.ATTACHMENT ) )
		RunUIScript( "SetupDevCommand", "Spawn All Optics", "script SpawnAllOptics()" )

	// flip thru all the loot and find the ones that match the cats we want to display
	foreach ( ref, data in SURVIVAL_Loot_GetLootDataTable() )
	{
		if ( !IsLootTypeValid( data.lootType ) )
			continue

		if ( !catTypes.contains( data.lootType ) )
			continue
		
		if (data.lootType == eLootType.ATTACHMENT && IsCustomAttachment(data)) continue
		if (data.lootType == eLootType.MAINWEAPON && IsCustomWeapon(data)) continue

		string displayString = CreateLootDisplayString( data )
		RunUIScript( "SetupDevCommand", displayString, "script SpawnGenericLoot( \"" + data.ref + "\", gp()[0].GetOrigin(), <-1,-1,-1>, " + data.countPerDrop + " )" )
	}
}

void function SetupCustomLoot( var categories )
{
	string cats              = expect string( categories )
	array<string> stringCats = split( cats, " " )

	// turn menu strings into real category enums
	array<int> catTypes
	foreach( string cat in stringCats )
		catTypes.append( SURVIVAL_Loot_GetLootTypeFromString( cat ) )

	// flip thru all the loot and find the ones that match the cats we want to display
	foreach ( ref, data in SURVIVAL_Loot_GetLootDataTable() )
	{
		if ( !IsLootTypeValid( data.lootType ) )
			continue

		if ( !catTypes.contains( data.lootType ) )
			continue
		
		if (data.lootType == eLootType.ATTACHMENT && !IsCustomAttachment(data)) continue
		if (data.lootType == eLootType.MAINWEAPON && !IsCustomWeapon(data)) continue

		string displayString = CreateLootDisplayString( data )
		RunUIScript( "SetupDevCommand", displayString, "script SpawnGenericLoot( \"" + data.ref + "\", gp()[0].GetOrigin(), <-1,-1,-1>, " + data.countPerDrop + " )" )
	}
}

string function CreateLootDisplayString( LootData data )
{
	string displayString = Localize( data.pickupString )

	if ( data.passive != ePassives.INVALID )
		displayString += " - " + Localize( PASSIVE_NAME_MAP[data.passive] )

	if ( ShouldAppendLootLevel( data ) )
		displayString += " [Lv" + data.tier + "]"

	if ( data.baseMods.contains( "gold" ) )
		displayString = "[GOLD] " + displayString

	return displayString
}


bool function ShouldAppendLootLevel( LootData data )
{
	switch ( data.lootType )
	{
		case eLootType.MAINWEAPON:
			return false

		case eLootType.AMMO:
			return false

		case eLootType.ORDNANCE:
			return false
	}

	return true
}
/*
----- UTILITY -----
*/

bool function SURVIVAL_Loot_QuickSwap( entity pickup, entity player, int pickupFlags = 0, entity deathBox = null )
{
	if ( pickup.GetSurvivalInt() == -1 )
		return false

	LootData data   = SURVIVAL_Loot_GetLootDataByIndex( pickup.GetSurvivalInt() )
	int numPickedUp = SURVIVAL_AddToPlayerInventory( player, data.ref, pickup.GetClipCount() )
	if ( numPickedUp > 0 )
		return false

	thread SURVIVAL_Loot_QuickSwap_Internal( pickup, player, pickupFlags, deathBox )

	return false
}


void function SURVIVAL_Loot_QuickSwap_Internal( entity pickup, entity player, int pickupFlags = 0, entity deathBox = null )
{
	ExtendedUseSettings settings
	settings.loopSound = "UI_Survival_PickupTicker"
	settings.successSound = "UI_Survival_DeathBoxOpen"
	settings.displayRui = $"ui/extended_use_hint.rpak"
	settings.displayRuiFunc = DefaultExtendedUseRui
	settings.icon = $""
	settings.hint = "#PROMPT_SWAP"
	settings.duration = 0.3
	settings.successFunc = ExtendedTryOpenQuickSwap
	settings.useInputFlag = IN_USE_LONG

	clGlobal.levelEnt.EndSignal( "ClearSwapOnUseThread" )
	pickup.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDeath" )

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( pickup.GetSurvivalInt() )
	LootRef lootRef   = SURVIVAL_CreateLootRef( lootData, pickup )

	LootActionStruct asMain = SURVIVAL_BuildStringForAction( GetLocalViewPlayer(), eLootContext.GROUND, lootRef, false, false )
	LootActionStruct asAlt  = SURVIVAL_BuildStringForAction( GetLocalViewPlayer(), eLootContext.GROUND, lootRef, true, false )

	if ( asMain.action != eLootAction.PICKUP && asAlt.action == eLootAction.PICKUP )
	{
		settings.holdHint = "%use_alt%"
		settings.useInputFlag = IN_USE_ALT
	}

	waitthread ExtendedUse( pickup, player, settings )
}


ExtendedUseSettings function DeathBoxGetExtendedUseSettings( entity ent, entity playerUser )
{
	ExtendedUseSettings settings
	settings.loopSound = "UI_Survival_PickupTicker"
	settings.successSound = "UI_Survival_DeathBoxOpen"
	settings.displayRui = $"ui/extended_use_hint.rpak"
	settings.displayRuiFunc = DefaultExtendedUseRui
	settings.icon = $""
	settings.hint = "#PROMPT_OPEN"
	settings.successFunc = ExtendedTryOpenGroundList

	return settings
}


void function ExtendedTryOpenQuickSwap( entity ent, entity player, ExtendedUseSettings settings )
{
	TryOpenQuickSwap()
}


void function ExtendedTryOpenGroundList( entity ent, entity player, ExtendedUseSettings settings )
{
	OpenSurvivalGroundList( player, ent )
}



EHI ornull function GetEHIForDeathBox( entity box )
{
	EHI eHandle = box.GetNetInt( "ownerEHI" )
	
	if ( eHandle == -1  )
		return null

	return eHandle
}


void function TryHolsterWeapon( entity player )
{
	if ( !IsGamepadEnabled() )
		return

	if ( file.useAltBind == -1 )
		return

	// TODO: this should be read in from data
	if ( !InputIsButtonDown( file.useAltBind ) )
		return

	entity useEnt = player.GetUsePromptEntity()

	if ( IsValid( useEnt ) )
	{
		if ( useEnt.GetNetworkedClassName() == "prop_survival" )
		{
			LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( useEnt.GetSurvivalInt() )
			LootRef lootRef   = SURVIVAL_CreateLootRef( lootData, useEnt )
			if ( SURVIVAL_GetActionForItem( player, eLootContext.GROUND, lootRef, true ).action != eLootAction.NONE )
			{
				return
			}
		}
	}

	entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( activeWeapon == player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_PRIMARY_2 ) )
	{
		player.ClientCommand( "invnext" )
		return
	}

	//ExtendedUseSettings settings
	//settings.loopSound = ""
	//settings.successSound = ""
	//settings.displayRui = $"ui/extended_use_hint.rpak"
	//settings.displayRuiFunc = DisplayRuiForDeathBox
	//settings.icon = $""
	//settings.hint = ""
	//settings.duration = 0.5
	//settings.successFunc = ExtendedTryHolster
	//settings.holdHint = "%use_alt%"
	//settings.useInputFlag = IN_USE_ALT
	//
	//thread ExtendedUse( player, player, settings )

	player.ClientCommand( "weaponSelectPrimary2" )
}


void function ExtendedTryHolster( entity ent, entity player, ExtendedUseSettings settings )
{
	player.ClientCommand( "weaponSelectPrimary2" )
}


void function OnPlayerSwitchesToWeapon00( entity player )
{
	player.ClientCommand( CMDNAME_PLAYER_SWITCHED_WEAPONS + " " + "0" )
}

void function OnPlayerSwitchesToWeapon01( entity player )
{
	player.ClientCommand( CMDNAME_PLAYER_SWITCHED_WEAPONS + " " + "1" )
}

void function OnPlayerSwitchesWeapons( entity player )
{
	player.ClientCommand( CMDNAME_PLAYER_SWITCHED_WEAPONS + " " + "-1" )
}


void function OnRefreshCustomGamepadBinds( entity player )
{
	file.useAltBind = GetButtonBoundTo( "+use_alt" )
}

const float LOOT_FILL_VOLUME_MIN = 200.0
const float LOOT_FILL_VOLUME_MAX = 2000.0
const float LOOT_FILL_ALPHA_MIN = 0.4
const float LOOT_FILL_ALPHA_MAX = 0.9

table<int, float> s_highlightFillCache
float function GetHighlightFillAlphaForLoot( entity lootEnt )
{
	int survivalInt = lootEnt.GetSurvivalInt()

	// uncomment for tuning
	//if ( (survivalInt in s_highlightFillCache) )
	//	delete s_highlightFillCache[survivalInt]

	if ( !(survivalInt in s_highlightFillCache) )
	{
		vector mins = lootEnt.GetBoundingMins()
		vector maxs = lootEnt.GetBoundingMaxs()

		float volume = (maxs.x - mins.x) * (maxs.y - mins.y) * (maxs.z - mins.z)

		s_highlightFillCache[survivalInt] <- GraphCapped( volume, LOOT_FILL_VOLUME_MIN, LOOT_FILL_VOLUME_MAX, LOOT_FILL_ALPHA_MAX, LOOT_FILL_ALPHA_MIN )
	}

	return s_highlightFillCache[survivalInt]

}
void function CreateDeathBoxRuiWithOverridenData( entity deathBox, NestedGladiatorCardHandle nestedGCHandle  )
{
	printt( "Creating with overriden profile data"  )
	SetNestedGladiatorCardOverrideName( nestedGCHandle, deathBox.GetCustomOwnerName() )

	int characterIndex = deathBox.GetNetInt(  "characterIndex" )
	LoadoutEntry characterLoadoutEntry = Loadout_CharacterClass()
	ItemFlavor character = ConvertLoadoutSlotContentsIndexToItemFlavor( characterLoadoutEntry, characterIndex )
	SetNestedGladiatorCardOverrideCharacter( nestedGCHandle, character )

	int skinIndex = deathBox.GetNetInt( "skinIndex" )
	LoadoutEntry skinLoadoutEntry = Loadout_CharacterSkin( character )
	SetNestedGladiatorCardOverrideSkin( nestedGCHandle, ConvertLoadoutSlotContentsIndexToItemFlavor( skinLoadoutEntry, skinIndex ) )

	int frameIndex = deathBox.GetNetInt( "frameIndex" )
	LoadoutEntry frameLoadoutEntry = Loadout_GladiatorCardFrame( character )
	SetNestedGladiatorCardOverrideFrame( nestedGCHandle, ConvertLoadoutSlotContentsIndexToItemFlavor( frameLoadoutEntry, frameIndex ) )

	int stanceIndex = deathBox.GetNetInt( "stanceIndex"  )
	LoadoutEntry stanceLoadoutEntry = Loadout_GladiatorCardStance( character )
	SetNestedGladiatorCardOverrideStance( nestedGCHandle, ConvertLoadoutSlotContentsIndexToItemFlavor( stanceLoadoutEntry, stanceIndex ) )

	int firstBadgeIndex = deathBox.GetNetInt( "firstBadgeIndex" )
	LoadoutEntry firstBadgeLoadoutEntry = Loadout_GladiatorCardBadge( character, 0 )
	int firstBadgeDataInt = deathBox.GetNetInt( "firstBadgeDataInt"  )
	SetNestedGladiatorCardOverrideBadge( nestedGCHandle, 0, ConvertLoadoutSlotContentsIndexToItemFlavor( firstBadgeLoadoutEntry, firstBadgeIndex ), firstBadgeDataInt )

	int secondBadgeIndex = deathBox.GetNetInt( "secondBadgeIndex" )
	LoadoutEntry secondBadgeLoadoutEntry = Loadout_GladiatorCardBadge( character, 1 )
	int secondBadgeDataInt = deathBox.GetNetInt( "secondBadgeDataInt"  )
	SetNestedGladiatorCardOverrideBadge( nestedGCHandle, 1, ConvertLoadoutSlotContentsIndexToItemFlavor( secondBadgeLoadoutEntry, secondBadgeIndex ), secondBadgeDataInt )

	int thirdBadgeIndex = deathBox.GetNetInt( "thirdBadgeIndex" )
	LoadoutEntry thirdBadgeLoadoutEntry = Loadout_GladiatorCardBadge( character, 2 )
	int thirdBadgeDataInt = deathBox.GetNetInt( "thirdBadgeDataInt"  )
	SetNestedGladiatorCardOverrideBadge( nestedGCHandle, 2, ConvertLoadoutSlotContentsIndexToItemFlavor( thirdBadgeLoadoutEntry, thirdBadgeIndex ), thirdBadgeDataInt )

}