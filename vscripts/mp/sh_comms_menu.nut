global function ShCommsMenu_Init

#if CLIENT
global function CommsMenu_HandleKeyInput
global function ClientCodeCallback_OpenChatWheel
global function SetHintTextOnHudElem

global function PingSecondPageIsEnabled
global function AddCallback_OnCommsMenuStateChanged
global function IsCommsMenuActive

global function CommsMenu_ExecuteSelectionIfValid
global function CommsMenu_CanUseMenu
global function CommsMenu_OpenMenuTo
global function CommsMenu_Shutdown
global function CommsMenu_OpenMenuForNewPing
global function CommsMenu_OpenMenuForPingReply
global function CommsMenu_HasValidSelection
global function CommsMenu_ExecuteSelection
global function CommsMenu_GetCurrentCommsMenu

#endif

#if CLIENT
global enum eWheelInputType
{
	NONE,
	USE,
	EQUIP,
	REQUEST
}

global enum eCommsMenuStyle
{
	PING_MENU,
	PINGREPLY_MENU,
	CHAT_MENU,
	INVENTORY_HEALTH_MENU,
	ORDNANCE_MENU,
	SKYDIVE_EMOTE_MENU,

	EDITOR_MODES_MENU,

	_assertion_marker,

	_count
}
Assert( eCommsMenuStyle._assertion_marker == 7 )    //

global enum eChatPage
{
	INVALID = -1,
	//

	DEFAULT,
	PREMATCH,
	BLEEDING_OUT,

	//
	PING_MAIN_1,
	PING_MAIN_2,
	PING_SKYDIVE,

	//
	PINGREPLY_DEFAULT,

	//
	INVENTORY_HEALTH,
	ORDNANCE_LIST,

	SKYDIVE_EMOTES,

	EDITOR_MODES,

	_count
}

const string WHEEL_SOUND_ON_OPEN = "UI_MapPing_Menu_Open_1P"
const string WHEEL_SOUND_ON_CLOSE = "menu_back"
const string WHEEL_SOUND_ON_FOCUS = "menu_focus"
const string WHEEL_SOUND_ON_EXECUTE = "menu_accept"
const string WHEEL_SOUND_ON_DENIED = "menu_deny"

#endif //

global const int WHEEL_HEAL_AUTO = -1

//---------------------

struct
{
	#if CLIENT
		var menuRui
		var menuRuiLastShutdown
		int commsMenuStyle    // eCommsMenuStyle

		array< void functionref(bool menuOpen) > onCommsMenuStateChangedCallbacks
	#endif // CLIENT
} file

//---------------------
// Client commands
//---------------------

const string CHAT_MENU_BIND_COMMAND = "+scriptCommand5"

void function ShCommsMenu_Init()
{
	#if SERVER
		AddClientCommandCallbackNew( "SetSelectedHealthPickupType", ClientCommand_SetSelectedHealthPickupType )
		AddClientCommandCallbackNew( "ClientCommand_Quip", ClientCommand_Quip )
	#endif // SERVER

	#if CLIENT
		AddOnDeathCallback( "player", OnDeathCallback )
		AddScoreboardShowCallback( DestroyCommsMenu )
		AddCallback_KillReplayStarted( DestroyCommsMenu )
		AddCallback_GameStateEnter( eGameState.WinnerDetermined, DestroyCommsMenu )
		AddCallback_GameStateEnter( eGameState.Prematch, DestroyCommsMenu )

		AddCallback_OnBleedoutStarted( OnBleedoutStarted )
		AddCallback_OnBleedoutEnded( OnBleedoutEnded )

		AddCallback_OnPlayerMatchStateChanged( OnPlayerMatchStateChanged )

		RegisterConCommandTriggeredCallback( CHAT_MENU_BIND_COMMAND, ChatMenuButton_Down )
		RegisterConCommandTriggeredCallback( "-" + CHAT_MENU_BIND_COMMAND.slice( 1 ), ChatMenuButton_Up )
	#endif // CLIENT
}

#if CLIENT
bool function PingSecondPageIsEnabled()
{
	return GetCurrentPlaylistVarBool( "ping_second_page_enabled", false )
}

void function AddCallback_OnCommsMenuStateChanged( void functionref(bool) func )
{
	file.onCommsMenuStateChangedCallbacks.append( func )
}

void function CommsMenu_Shutdown( bool makeSound )
{
	if ( !IsCommsMenuActive() )
		return

	DestroyCommsMenu()

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	if ( !MenuStyleIsFastFadeIn( file.commsMenuStyle ) )
		StopSoundOnEntity( player, WHEEL_SOUND_ON_OPEN )

	if ( makeSound )
		EmitSoundOnEntity( player, WHEEL_SOUND_ON_CLOSE )
}

void function ChatMenuButton_Down( entity player )
{
	if ( !CommsMenu_CanUseMenu( player ) )
		return

	if ( IsCommsMenuActive() )
	{
		if ( CommsMenu_HasValidSelection() )
		{
			CommsMenu_ExecuteSelection( eWheelInputType.NONE )
		}
		CommsMenu_Shutdown( true )
		player.SetLookStickDebounce()
		return
	}

	if ( TryPingBlockingFunction( player, "quickchat" ) )
		return

	int ms = PlayerMatchState_GetFor( player )

	if ( !IsFiringRangeGameMode() )
	{
		if ( ms < ePlayerMatchState.SKYDIVE_PRELAUNCH )
			return
	}

	if ( PlayerIsInADS( player ) )
		return

	int chatPage = eChatPage.DEFAULT
	if ( Bleedout_IsBleedingOut( player ) )
		chatPage = eChatPage.BLEEDING_OUT

	if ( GetCurrentPlaylistVarBool( "survival_quick_chat_enabled", true ) )
	{
		//
			CommsMenu_OpenMenuTo( player, chatPage, eCommsMenuStyle.CHAT_MENU )
	}
}

void function ChatMenuButton_Up( entity player )
{
	if ( !IsCommsMenuActive() )
		return
	if ( file.commsMenuStyle != eCommsMenuStyle.CHAT_MENU )
		return

	CommsMenu_ExecuteSelectionIfValid( player, eCommsMenuStyle.CHAT_MENU )
}

void function CommsMenu_ExecuteSelectionIfValid( entity player, int requiredCommsMenuStyle )
{
	if ( file.commsMenuStyle != requiredCommsMenuStyle )
		return

	if ( CommsMenu_HasValidSelection() )
	{
		CommsMenu_ExecuteSelection( eWheelInputType.NONE )
		CommsMenu_Shutdown( true )
	}

	player.SetLookStickDebounce()
}

void function CommsMenu_OpenMenuForNewPing( entity player, vector targetPos )
{
	int chatPage = eChatPage.PING_MAIN_1

	int ms = PlayerMatchState_GetFor( player )
	if ( (ms == ePlayerMatchState.SKYDIVE_PRELAUNCH) || (ms == ePlayerMatchState.SKYDIVE_FALLING) )
		chatPage = eChatPage.PING_SKYDIVE
	else if ( Bleedout_IsBleedingOut( player ) )
		chatPage = eChatPage.BLEEDING_OUT
	CommsMenu_OpenMenuTo( player, chatPage, eCommsMenuStyle.PING_MENU )

	if ( file.menuRui != null )
		RuiSetFloat3( file.menuRui, "targetPos", targetPos )
}

entity s_focusWaypoint = null
void function CommsMenu_OpenMenuForPingReply( entity player, entity wp )
{
	CommsMenu_OpenMenuTo( player, eChatPage.PINGREPLY_DEFAULT, eCommsMenuStyle.PINGREPLY_MENU )

	if ( IsValid( wp ) )
	{
		if ( file.menuRui != null )
		{
			int wpt = wp.GetWaypointType()
			if ( wpt == eWaypoint.PING_LOOT )
			{
				entity lootItem = Waypoint_GetItemEntForLootWaypoint( wp )
				if ( IsValid( lootItem ) )
					RuiTrackFloat3( file.menuRui, "targetPos", lootItem, RUI_TRACK_ABSORIGIN_FOLLOW )
				else
					RuiSetFloat3( file.menuRui, "targetPos", <0, 0, 0> )
			}
			else if ( wpt == eWaypoint.PING_LOCATION )
			{
				RuiTrackFloat3( file.menuRui, "targetPos", wp, RUI_TRACK_ABSORIGIN_FOLLOW )
			}
			else
			{
			}
		}

		SetFocusedWaypointForced( wp )
		RuiSetBool( wp.wp.ruiHud, "hasWheelFocus", true )
		s_focusWaypoint = wp
	}
}

void function CommsMenu_OpenMenuTo( entity player, int chatPage, int commsMenuStyle, bool debounce = true )
{
	// Kill any running instance:
	CommsMenu_Shutdown( true )

	file.commsMenuStyle = commsMenuStyle

	ResetViewInput()

	// Force cleanup of any prev menu that might still be politely fading away:
	if ( file.menuRuiLastShutdown != null )
	{
		RuiDestroyIfAlive( file.menuRuiLastShutdown )
		file.menuRuiLastShutdown = null
	}

	file.menuRui = CreateFullscreenRui( $"ui/comms_menu.rpak", RUI_SORT_SCREENFADE - 2 )

	HudInputContext inputContext
	inputContext.keyInputCallback = CommsMenu_HandleKeyInput

	if ( chatPage == eChatPage.SKYDIVE_EMOTES )
	{
		inputContext.moveInputCallback = CommsMenu_HandleMoveInputControllerOnly
	}

	inputContext.viewInputCallback = CommsMenu_HandleViewInput
	inputContext.hudInputFlags = (HIF_BLOCK_WAYPOINT_FOCUS)
	HudInput_PushContext( inputContext )

	if ( debounce )
		player.SetLookStickDebounce()

	float soundDelay = MenuStyleIsFastFadeIn( file.commsMenuStyle ) ? 0.0 : 0.1
	EmitSoundOnEntityAfterDelay( GetLocalViewPlayer(), WHEEL_SOUND_ON_OPEN, soundDelay )

	ShowCommsMenu( chatPage )
}

int function GetEffectiveChoice()
{
	int effectiveChoice = s_currentChoice

	float delta = (Time() - s_latestValidChoiceTime)
	if ( delta < 0.15 )
		effectiveChoice = s_latestValidChoice

	effectiveChoice = ModifyEffectiveChoiceForCurrentMenu( effectiveChoice )

	return effectiveChoice
}

int function ModifyEffectiveChoiceForCurrentMenu( int choice )
{
	if ( file.commsMenuStyle == eCommsMenuStyle.SKYDIVE_EMOTE_MENU )
	{
		if ( choice < 0 )
			return RandomInt( s_currentMenuOptions.len() )
	}

	return choice
}

bool function CommsMenu_HasValidSelection()
{
	if ( !IsCommsMenuActive() )
		return false

	int choice = GetEffectiveChoice()
	if ( (choice < 0) || (choice >= s_currentMenuOptions.len()) )
		return false

	//CommsMenuOptionData op = s_currentMenuOptions[choice]
	//if ( op.optionType == eOptionType.DO_NOTHING )
	//	return false

	return true
}

bool function CommsMenu_ExecuteSelection( int wheelInputType )
{
	if ( !CommsMenu_HasValidSelection() )
		return false

	int choice       = GetEffectiveChoice()
	bool didAnything = MakeCommMenuSelection( choice, wheelInputType )
	return didAnything
}

enum eOptionType
{
	DO_NOTHING,

	COMMSACTION,
	NEW_PING,
	PING_REPLY,

	QUIP,
	SKYDIVE_EMOTE,
	HEALTHITEM_USE,
	ORDNANCE_EQUIP,

	EDITOR_MODE_ACTIVATE
}

struct CommsMenuOptionData
{
	int optionType

	int chatPage
	int commsAction

	int pingType

	int pingReply

	int healType

	ItemFlavor    ornull    emote
}

CommsMenuOptionData function MakeOption_NoOp()
{
	CommsMenuOptionData op
	op.optionType = eOptionType.DO_NOTHING
	return op
}

CommsMenuOptionData function MakeOption_CommsAction( int commsAction )
{
	CommsMenuOptionData op
	op.optionType = eOptionType.COMMSACTION
	op.commsAction = commsAction
	return op
}

CommsMenuOptionData function MakeOption_Quip( ItemFlavor quip, int index )
{
	CommsMenuOptionData op
	op.optionType = eOptionType.QUIP
	op.emote = quip
	op.healType = index
	return op
}

CommsMenuOptionData function MakeOption_SkydiveEmote( ItemFlavor quip, int index )
{
	CommsMenuOptionData op
	op.optionType = eOptionType.SKYDIVE_EMOTE
	op.emote = quip
	op.healType = index
	return op
}

CommsMenuOptionData function MakeOption_PingReply( int pingReply )
{
	CommsMenuOptionData op
	op.optionType = eOptionType.PING_REPLY
	op.pingReply = pingReply
	return op
}

CommsMenuOptionData function MakeOption_UseHealItem( int healType )
{
	CommsMenuOptionData op
	op.optionType = eOptionType.HEALTHITEM_USE
	op.healType = healType
	return op
}

CommsMenuOptionData function MakeOption_SwitchToOrdnance( int ordnanceIndex )
{
	CommsMenuOptionData op
	op.optionType = eOptionType.ORDNANCE_EQUIP
	op.healType = ordnanceIndex
	return op
}

CommsMenuOptionData function MakeOption_Ping( int pingType )
{
	CommsMenuOptionData op
	op.optionType = eOptionType.NEW_PING
	op.pingType = pingType
	return op
}

CommsMenuOptionData function MakeOption_EditorMode( int index )
{
	CommsMenuOptionData op
	op.optionType = eOptionType.EDITOR_MODE_ACTIVATE
	op.healType = index

	return op
}

array<CommsMenuOptionData> function BuildMenuOptions( int chatPage )
{
	array<CommsMenuOptionData> results
	entity player                       = GetLocalViewPlayer()
	switch ( chatPage )
	{
		case eChatPage.DEFAULT:
		case eChatPage.PING_MAIN_2:
		{
			EHI playerEHI = ToEHI( player )

			results.append( MakeOption_CommsAction( eCommsAction.QUICKCHAT_CELEBRATE ) )

			if ( !LoadoutSlot_IsReady( playerEHI, Loadout_CharacterClass() ) )
			{
				break
			}

			ItemFlavor character = LoadoutSlot_GetItemFlavor( playerEHI, Loadout_CharacterClass() )
			ItemFlavor ornull emptyQuip
			int quipsInWheel
			for ( int i=0; i<MAX_QUIPS_EQUIPPED; i++ )
			{
				LoadoutEntry entry = Loadout_CharacterQuip( character, i )
				ItemFlavor quip = LoadoutSlot_GetItemFlavor( playerEHI, entry )
				if ( !CharacterQuip_IsTheEmpty( quip ) )
				{
					quipsInWheel++
					results.append( MakeOption_Quip( quip, i ) )
				}
				else
				{
					emptyQuip = quip
				}
			}

			if ( quipsInWheel == 0 && emptyQuip != null )
			{
				expect ItemFlavor( emptyQuip )
				results.append( MakeOption_Quip( emptyQuip, quipsInWheel ) )
			}
		}
		break

		case eChatPage.SKYDIVE_EMOTES:
			table<int,ItemFlavor> emotes = GetValidPlayerSkydiveEmotes( player )
			foreach ( index,emote in emotes )
			{
				if ( !CharacterSkydiveEmote_IsTheEmpty( emote ) )
					results.append( MakeOption_SkydiveEmote( emote, index ) )
			}
			break

		case eChatPage.PREMATCH:
			{
				results.append( MakeOption_NoOp() )
				results.append( MakeOption_NoOp() )
			}
			break

		case eChatPage.BLEEDING_OUT:
		{
			results.append( MakeOption_CommsAction( eCommsAction.QUICKCHAT_BLEEDOUT_HELP ) )
			results.append( MakeOption_Ping( ePingType.I_GO ) )
			results.append( MakeOption_Ping( ePingType.ENEMY_GENERAL ) )
			//results.append( MakeOption_CommsAction( eCommsAction.QUICKCHAT_BLEEDOUT_ITS_OVER ) )
		}
			break

		case eChatPage.PING_MAIN_1:
		{
			results.append( MakeOption_Ping( ePingType.WE_GO ) )
			results.append( MakeOption_Ping( ePingType.ENEMY_GENERAL ) )
			results.append( MakeOption_Ping( ePingType.I_LOOTING ) )
			results.append( MakeOption_Ping( ePingType.I_ATTACKING ) )
			results.append( MakeOption_Ping( ePingType.I_GO ) )
			results.append( MakeOption_Ping( ePingType.I_DEFENDING ) )
			results.append( MakeOption_Ping( ePingType.I_WATCHING ) )
			results.append( MakeOption_Ping( ePingType.AREA_VISITED ) )
		}
			break

		case eChatPage.PING_MAIN_2:
		{
			results.append( MakeOption_CommsAction( eCommsAction.QUICKCHAT_THANKS ) )
			results.append( MakeOption_Ping( ePingType.NEED_HEALTH ) )
			results.append( MakeOption_Ping( ePingType.HOLD_ON ) )
		}
			break

		case eChatPage.PING_SKYDIVE:
		{
			results.append( MakeOption_Ping( ePingType.ENEMY_GENERAL ) )
			results.append( MakeOption_Ping( ePingType.I_GO ) )
			//			results.append( MakeOption_Ping( ePingType.WE_GO ) )
		}
			break

		case eChatPage.INVENTORY_HEALTH:
		{
			if ( GetCurrentPlaylistVarBool( "auto_heal_option", false ) )
				results.append( MakeOption_UseHealItem( WHEEL_HEAL_AUTO ) )
			{
				results.append( MakeOption_UseHealItem( eHealthPickupType.COMBO_FULL ) )
				results.append( MakeOption_UseHealItem( eHealthPickupType.SHIELD_SMALL ) )
				results.append( MakeOption_UseHealItem( eHealthPickupType.SHIELD_LARGE ) )
				results.append( MakeOption_UseHealItem( eHealthPickupType.HEALTH_SMALL ) )
				results.append( MakeOption_UseHealItem( eHealthPickupType.HEALTH_LARGE ) )
			}
			break
		}

		case eChatPage.ORDNANCE_LIST:
		{
			table<string, LootData> allLootData = SURVIVAL_Loot_GetLootDataTable()

			foreach ( data in allLootData )
			{
				if ( SURVIVAL_Loot_IsRefDisabled( data.ref ) )
					continue

				if ( !IsLootTypeValid( data.lootType ) )
					continue

				if ( data.lootType != eLootType.ORDNANCE )
					continue

				//
				if ( data.conditional )
				{
					if ( !SURVIVAL_Loot_RunConditionalCheck( data.ref, player ) )
						continue
				}

				if ( data.isDynamic && SURVIVAL_CountItemsInInventory( player, data.ref ) == 0 )
					continue

				results.append( MakeOption_SwitchToOrdnance( data.index ) )
			}
		}
			break

		case eChatPage.PINGREPLY_DEFAULT:
		{
			// entity player = GetLocalViewPlayer()

			array<int> pingReplies = Ping_GetOptionsForPendingReply( player )
			foreach( int pingReply in pingReplies )
			{
				if ( (pingReply == ePingReply.BLANK) && (results.len() == 0) )
					continue

				results.append( MakeOption_PingReply( pingReply ) )
			}
		}

		case eChatPage.EDITOR_MODES:
		{
			foreach(idx, mode in GetEditorModes())
			{
				results.append( MakeOption_EditorMode( idx ) )
			}
		}
			break
	}

	return results
}

array<CommsMenuOptionData> s_currentMenuOptions
int s_currentChatPage = eChatPage.INVALID
int s_previousChatPage = eChatPage.INVALID

string[2] function GetPromptsForMenuOption( int index )
{
	string[2] promptTexts

	if ( (index < 0) || (index >= s_currentMenuOptions.len()) )
		return promptTexts
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return promptTexts

	CommsMenuOptionData op = s_currentMenuOptions[index]
	switch( op.optionType )
	{
		case eOptionType.COMMSACTION:
			promptTexts[0] = GetMenuOptionTextForCommsAction( op.commsAction )
			break

		case eOptionType.QUIP:
		case eOptionType.SKYDIVE_EMOTE:
			promptTexts[0] = Localize( ItemFlavor_GetLongName( expect ItemFlavor( op.emote ) ) )
			break

		case eOptionType.NEW_PING:
			promptTexts[0] = Ping_GetMenuOptionTextForPing( op.pingType )
			break

		case eOptionType.PING_REPLY:
			entity wp = Ping_GetPendingPingReplyWaypoint()
			ReplyCommsActionInfo caInfo = Ping_GetCommsActionForWaypointReply( player, wp, op.pingReply )
			promptTexts[0] = GetMenuOptionTextForCommsAction( caInfo.commsAction )
			break

		case eOptionType.HEALTHITEM_USE:
			promptTexts[0] = GetNameForHealthItem( op.healType )
			promptTexts[1] = GetDescForHealthItem( op.healType )
			break

		case eOptionType.ORDNANCE_EQUIP:
		{
			if ( op.healType == -1 )
			{
				promptTexts[0] = "#MELEE"
			}
			else
			{
				LootData data = SURVIVAL_Loot_GetLootDataByIndex( op.healType )
				int count     = SURVIVAL_CountItemsInInventory( player, data.ref )
				promptTexts[0] = data.pickupString
				promptTexts[1] = data.desc
			}
			break
		}
		case eOptionType.EDITOR_MODE_ACTIVATE:
		{
			EditorMode mode = GetEditorModes()[op.healType]
			promptTexts[0] = mode.displayName
			promptTexts[1] = mode.description
			break
		}
	}

	return promptTexts
}

asset function GetIconForMenuOption( int index )
{
	if ( (index < 0) || (index >= s_currentMenuOptions.len()) )
		return $""

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return $""

	CommsMenuOptionData op = s_currentMenuOptions[index]
	switch( op.optionType )
	{
		case eOptionType.COMMSACTION:
			return GetDefaultIconForCommsAction( op.commsAction )

		case eOptionType.SKYDIVE_EMOTE:
			ItemFlavor data = expect ItemFlavor( op.emote )
			return ItemFlavor_GetIcon( data )

		case eOptionType.QUIP:
			ItemFlavor data = expect ItemFlavor( op.emote )
			if ( CharacterQuip_IsTheEmpty( data ) )
				return $""
			int type = ItemFlavor_GetType( data )
			switch ( type )
			{
				case eItemType.gladiator_card_kill_quip:
				case eItemType.gladiator_card_intro_quip:
					return $""
			}
			return ItemFlavor_GetIcon( data )

		case eOptionType.NEW_PING:
		{
			entity targetEnt = Ping_GetPendingNewPingTargetEnt()
			return Ping_IconForPing_Hud( player, op.pingType, targetEnt, player )
		}

		case eOptionType.PING_REPLY:
		{
			entity wp                   = Ping_GetPendingPingReplyWaypoint()
			ReplyCommsActionInfo caInfo = Ping_GetCommsActionForWaypointReply( player, wp, op.pingReply )
			return GetDefaultIconForCommsAction( caInfo.commsAction )
		}

		case eOptionType.HEALTHITEM_USE:
		{
			return GetIconForHealthItem( op.healType )
		}

		case eOptionType.ORDNANCE_EQUIP:
		{
			if ( op.healType == -1 )
			{
				return $"rui/menu/dpad_comms/emoji/fist"
			}

			LootData data = SURVIVAL_Loot_GetLootDataByIndex( op.healType )
			return data.hudIcon
		}

		case eOptionType.EDITOR_MODE_ACTIVATE:
		{
			return $"rui/hud/tactical_icons/tactical_crypto"
		}
	}

	return $""
}


vector function GetIconColorForMenuOption( int index )
{
	if ( (index < 0) || (index >= s_currentMenuOptions.len()) )
		return <0, 0, 0>

	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return <0, 0, 0>

	CommsMenuOptionData op = s_currentMenuOptions[index]
	switch( op.optionType )
	{
		case eOptionType.NEW_PING:
		{
			entity targetEnt = Ping_GetPendingNewPingTargetEnt()

			ItemFlavor ornull pingFlavor = Ping_ItemFlavorForPing( GetLocalViewPlayer(), op.pingType, targetEnt )
			if ( pingFlavor != null )
			{
				expect ItemFlavor( pingFlavor )
				return PingFlavor_GetColor( pingFlavor, GetLocalViewPlayer().GetTeamMemberIndex() )
			}
			else
			{
				return Ping_IconColorForPing_Hud( op.pingType, true )
			}
		}
	}

	return <1, 1, 1>
}

asset function GetIconForHealthItem( int itemType )
{
	if ( WeaponDrivenConsumablesEnabled() )
	{
		ConsumableInfo info = Consumable_GetConsumableInfo( itemType )
		return info.lootData.hudIcon
	}
	else
	{
		if ( itemType ==  WHEEL_HEAL_AUTO )
			return $"rui/hud/gametype_icons/survival/health_pack_auto"

		HealthPickup kit = SURVIVAL_Loot_GetHealthKitDataFromStruct( itemType )
		return kit.lootData.hudIcon
	}

	unreachable
}


int function GetHealthItemTypeForWheelIndex( int wheelIndex )
{
	if ( wheelIndex == 0 )
		return eHealthPickupType.COMBO_FULL
	else if ( wheelIndex == 1 )
		return eHealthPickupType.SHIELD_LARGE
	else if ( wheelIndex == 2 )
		return eHealthPickupType.SHIELD_SMALL
	else if ( wheelIndex == 3 )
		return eHealthPickupType.HEALTH_LARGE
	else if ( wheelIndex == 4 )
		return eHealthPickupType.HEALTH_SMALL

	unreachable
}


string function GetCountStringForHealthItem( int itemType )
{
	entity player = GetLocalViewPlayer()
	return(string( GetCountForHealthItem( player, itemType ) ))
}


int function GetCountForHealthItem( entity player, int itemType )
{
	if ( itemType ==  WHEEL_HEAL_AUTO )
	{
		int totalHeals = SURVIVAL_Loot_GetTotalHealthItems( player )
		return totalHeals
	}

	string itemRef = ""

	if ( WeaponDrivenConsumablesEnabled() )
	{
		itemRef = Consumable_GetConsumableInfo( itemType ).lootData.ref
	}
	else
	{
		itemRef = SURVIVAL_Loot_GetHealthKitDataFromStruct( itemType ).lootData.ref
	}
	return SURVIVAL_CountItemsInInventory( player, itemRef )
}

string function GetNameForHealthItem( int itemType )
{
	if ( itemType ==  WHEEL_HEAL_AUTO )
		return "Automatic"

	if ( WeaponDrivenConsumablesEnabled() )
	{
		ConsumableInfo info = Consumable_GetConsumableInfo( itemType )
		return Localize( info.lootData.pickupString )
	}
	else
	{
		HealthPickup kit = SURVIVAL_Loot_GetHealthKitDataFromStruct( itemType )
		return Localize( kit.lootData.pickupString )
	}
	unreachable
}


string function GetDescForHealthItem( int itemType )
{
	if ( itemType == WHEEL_HEAL_AUTO )
		return ""

	string desc = ""
	if ( WeaponDrivenConsumablesEnabled() )
	{
		ConsumableInfo info = Consumable_GetConsumableInfo( itemType )
		desc = Localize( info.lootData.desc )
	}
	else
	{
		HealthPickup kit = SURVIVAL_Loot_GetHealthKitDataFromStruct( itemType )
		desc = Localize( kit.lootData.desc )
	}

	return desc
}


bool function MenuStyleIsFastFadeIn( int menuStyle )
{
	switch ( file.commsMenuStyle )
	{
		case eCommsMenuStyle.CHAT_MENU:
		case eCommsMenuStyle.INVENTORY_HEALTH_MENU:
		case eCommsMenuStyle.EDITOR_MODES_MENU:
			return true
	}
	return false
}

void function SetRuiOptionsForChatPage( var rui, int chatPage )
{
	string labelText        = ""
	string backText         = "#BUTTON_WHEEL_CANCEL"
	string promptText       = "#A_BUTTON_ACCEPT"
	string nextPageText = ""
	bool showNextPageText = false
	bool shouldShowLine     = false
	vector outerCircleColor = <0.0, 0.0, 0.0>

	switch( chatPage )
	{
		case eChatPage.DEFAULT:
		case eChatPage.PREMATCH:
		case eChatPage.BLEEDING_OUT:
			labelText = "#COMMS_QUICK_CHAT"
			promptText = "#COMMS_USE"
			backText = "#COMMS_BACK"
			outerCircleColor = <25, 0, 15>
			break

		case eChatPage.PING_MAIN_1:
			labelText = "#COMMS_PING"
			promptText = " "
			showNextPageText = PingSecondPageIsEnabled()
			nextPageText = "#COMMS_NEXT"
			backText = "#COMMS_BACK"
			shouldShowLine = true
			outerCircleColor = <0, 0, 21>
			break

		case eChatPage.PING_MAIN_2:
			labelText = "#COMMS_QUICK_CHAT"
			promptText = " "
			showNextPageText = s_previousChatPage != eChatPage.INVALID
			nextPageText = "#COMMS_PREV"
			backText = "#COMMS_BACK"
			shouldShowLine = true
			outerCircleColor = <25, 32, 25>
			break

		case eChatPage.PING_SKYDIVE:
			labelText = "#COMMS_PING"
			promptText = " "
			showNextPageText = PingSecondPageIsEnabled()
			nextPageText = "#COMMS_NEXT"
			shouldShowLine = true
			outerCircleColor = <0, 0, 21>
			break

		case eChatPage.PINGREPLY_DEFAULT:
			shouldShowLine = true
			promptText = " "
			outerCircleColor = <0, 15, 32>
			break

		case eChatPage.INVENTORY_HEALTH:
			labelText = "#COMMS_HEALTH_KITS"
			//if ( HealthWheelUseOnRelease() )
			//	promptText = "#LOOT_EQUIP"
			//else
			promptText = "#LOOT_USE"
			outerCircleColor = <25, 0, 15>
			break

		case eChatPage.ORDNANCE_LIST:
			labelText = "#COMMS_ORDNANCE"
			promptText = "#LOOT_EQUIP"
			break

		case eChatPage.SKYDIVE_EMOTES:
			labelText = "#COMMS_SKYDIVE_EMOTES"
			promptText = "#LOOT_USE"
			break

	}

	RuiSetString( rui, "labelText", labelText )
	RuiSetString( rui, "promptText", promptText )
	RuiSetString( rui, "backText", backText )
	RuiSetBool( rui, "shouldShowLine", shouldShowLine )
	RuiSetBool( rui, "showNextPageText", showNextPageText )
	RuiSetString( rui, "nextPageText", nextPageText )
	RuiSetFloat3( rui, "outerCircleColor", SrgbToLinear( outerCircleColor / 255.0 ) ) // the rui isn't actually using this color. It's just black with alpha 0.5
}

const int MAX_COMMS_MENU_OPTIONS = 9
void function ShowCommsMenu( int chatPage )
{
	RunUIScript( "ClientToUI_SetCommsMenuOpen", true )

	var rui = file.menuRui

	array<CommsMenuOptionData> options = BuildMenuOptions( chatPage )
	s_currentMenuOptions = options
	s_previousChatPage = s_currentChatPage
	s_currentChatPage = chatPage

	SetRuiOptionsForChatPage( rui, chatPage )

	int optionCount = options.len()
	for ( int idx = 0; idx < MAX_COMMS_MENU_OPTIONS; ++idx )
	{
		asset icon       = GetIconForMenuOption( idx )
		vector iconColor = SrgbToLinear( GetIconColorForMenuOption( idx ) )
		RuiSetImage( rui, ("optionIcon" + idx), icon )
		RuiSetInt( rui, ("optionTier" + idx), 0 )
		RuiSetFloat3( rui, ("optionColor" + idx), iconColor )

		RuiSetString( rui, ("optionCenterText" + idx), "" )

		if ( idx < s_currentMenuOptions.len() )
		{
			CommsMenuOptionData op = s_currentMenuOptions[idx]
			int WORD_MAX_LEN = 11
			int TEXT_MAX_LEN = 26
			int TEXT_MAX_LEN_W_DOTS = TEXT_MAX_LEN - 2

			if ( op.emote != null )
			{
				ItemFlavor flav = expect ItemFlavor( op.emote )
				int itemType = ItemFlavor_GetType( flav )
				if ( itemType == eItemType.gladiator_card_kill_quip || itemType == eItemType.gladiator_card_intro_quip )
				{
					string txt = Localize( ItemFlavor_GetLongName( flav ) )

					txt = CondenseText( txt, WORD_MAX_LEN, TEXT_MAX_LEN )
					print( "setting optionCenterText" + idx + " to " + txt + "\n" )
					RuiSetString( rui, ("optionCenterText" + idx), txt)
				}
			}
		}


		if ( chatPage == eChatPage.INVENTORY_HEALTH )
		{
			if ( idx < s_currentMenuOptions.len() )
			{
				string countText = GetCountStringForHealthItem( options[idx].healType )
				RuiSetString( rui, ("optionText" + idx), countText )
				int tier      = -1
				int itemCount = GetCountForHealthItem( GetLocalViewPlayer(), options[idx].healType )
				if ( itemCount > 0 )
				{
					//if ( options[idx].healType != -1 )
					//	tier = SURVIVAL_Loot_GetHealthKitDataFromStruct( options[idx].healType ).lootData.tier
					//else
					tier = 0
				}

				RuiSetInt( rui, ("optionTier" + idx), tier )
				RuiSetBool( rui, ("optionEnabled" + idx), itemCount > 0 )
			}
		}
		else if ( chatPage == eChatPage.ORDNANCE_LIST )
		{
			if ( idx < s_currentMenuOptions.len() )
			{
				int index = options[idx].healType

				if ( index != -1 )
				{
					LootData data    = SURVIVAL_Loot_GetLootDataByIndex( index )
					int itemCount    = SURVIVAL_CountItemsInInventory( GetLocalViewPlayer(), data.ref )
					string countText = string( itemCount )
					RuiSetString( rui, ("optionText" + idx), countText )

					int tier = -1
					if ( itemCount > 0 )
						tier = 0
					RuiSetInt( rui, ("optionTier" + idx), tier )
					RuiSetBool( rui, ("optionEnabled" + idx), itemCount > 0 )
				}
			}
		}
		else if (chatPage == eChatPage.EDITOR_MODES)
		{
			if ( idx < s_currentMenuOptions.len() )
			{
				int index = options[idx].healType

				if ( index != -1 )
				{
					EditorMode mode = GetEditorModes()[index]
					
					RuiSetString( rui, ("optionText" + idx), mode.displayName )
					RuiSetInt( rui, ("optionTier" + idx), index % 5 + 1 )
					RuiSetBool( rui, ("optionEnabled" + idx), true )
				}
			}
		}
	}

	RuiSetInt( rui, "optionCount", options.len() )

	foreach ( func in file.onCommsMenuStateChangedCallbacks )
		func( true )

	RuiSetBool( rui, "doFastFadeIn", MenuStyleIsFastFadeIn( file.commsMenuStyle ) )

	if ( (chatPage == eChatPage.INVENTORY_HEALTH) )
	{
		entity player = GetLocalViewPlayer()

		int healthPickupType = Survival_Health_GetSelectedHealthPickupType()

		RuiSetInt( rui, "selectedSlot", -1 )
		for ( int idx = 0; idx < options.len(); ++idx )
		{
			if ( options[idx].healType != healthPickupType )
				continue

			RuiSetInt( rui, "selectedSlot", idx )
			break
		}
	}
	else if ( (chatPage == eChatPage.ORDNANCE_LIST) )
	{
		entity player = GetLocalViewPlayer()
		entity weapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_ANTI_TITAN )
		string equippedRef = IsValid( weapon ) ? weapon.GetWeaponClassName() : ""

		int healthPickupType = Survival_Health_GetSelectedHealthPickupType()

		RuiSetInt( rui, "selectedSlot", -1 )
		for ( int idx = 0; idx < options.len(); ++idx )
		{
			int index = options[idx].healType
			if ( index <= -1 )
				continue

			LootData data = SURVIVAL_Loot_GetLootDataByIndex( index )
			if ( data.ref != equippedRef )
				continue

			if ( SURVIVAL_CountItemsInInventory( player, data.ref ) == 0 )
				continue

			RuiSetInt( rui, "selectedSlot", idx )
			break
		}
	}
}

void function ClientCodeCallback_OpenChatWheel()
{
	ChatMenuButton_Down( GetLocalClientPlayer() )
}

float s_pageSwitchTime = 0.0
const float BUTTON_PAIR_ACTIVITION_TIME = 0.25
bool function CommsMenu_HandleKeyInput( int key )
{
	Assert( IsCommsMenuActive() )


	if ( PingSecondPageIsEnabled() )
	{
		bool isPageButton = IsControllerModeActive() ? ButtonIsBoundToAction( key, "+weaponcycle" ) : ButtonIsBoundToAction( key, "+jump" )

		array<int> pagesAllowedToGoToChat =
		[
			eChatPage.PING_MAIN_1,
			eChatPage.PING_SKYDIVE,
		]

		if ( isPageButton )
		{
			float timeSinceLastPageSwitch = (Time() - s_pageSwitchTime)
			if ( (timeSinceLastPageSwitch > 0.1) && (file.commsMenuStyle == eCommsMenuStyle.PING_MENU) )
			{
				entity player = GetLocalViewPlayer()
				int nextPage = eChatPage.INVALID

				if ( pagesAllowedToGoToChat.contains( s_currentChatPage ) )
				{
					nextPage = eChatPage.PING_MAIN_2
				}
				else if ( s_currentChatPage == eChatPage.PING_MAIN_2 )
				{
					nextPage = s_previousChatPage
				}

				if ( nextPage != eChatPage.INVALID )
				{
					ResetViewInput()
					EmitSoundOnEntity( player, WHEEL_SOUND_ON_CLOSE )
					ShowCommsMenu( nextPage )
					s_pageSwitchTime = Time()
					return true
				}
			}
		}
	}

	bool shouldExecute    = false
	bool shouldCancelMenu = false
	int choice            = -1

	int executeType = eWheelInputType.NONE
	switch ( key )
	{
		case KEY_1:
			choice = 0
			break

		case KEY_2:
			choice = 1
			break

		case KEY_3:
			choice = 2
			break

		case KEY_4:
			choice = 3
			break

		case KEY_5:
			choice = 4
			break

		case KEY_6:
			choice = 5
			break

		case KEY_7:
			choice = 6
			break

		case KEY_8:
			choice = 7
			break

		case BUTTON_A:
		case MOUSE_LEFT:
			executeType = eWheelInputType.USE
			break

		case BUTTON_X:
			executeType = eWheelInputType.EQUIP
			break

		case BUTTON_B:
		case KEY_ESCAPE:
		case MOUSE_RIGHT:
			shouldCancelMenu = true
			break
	}

	if ( ButtonIsBoundToPing( key ) )
	{
		executeType = eWheelInputType.REQUEST
	}

	if ( IsValidChoice( choice ) && executeType == eWheelInputType.NONE )
	{
		SetCurrentChoice( choice )
		executeType = eWheelInputType.USE
	}

	shouldExecute = executeType != eWheelInputType.NONE

	shouldExecute = shouldExecute || ((file.commsMenuStyle == eCommsMenuStyle.CHAT_MENU) && ButtonIsBoundToAction( key, CHAT_MENU_BIND_COMMAND ))
	shouldExecute = shouldExecute || ((file.commsMenuStyle == eCommsMenuStyle.PING_MENU) && ButtonIsBoundToAction( key, "+ping" ))
	shouldExecute = shouldExecute || ((file.commsMenuStyle == eCommsMenuStyle.PINGREPLY_MENU) && ButtonIsBoundToAction( key, "+ping" ))
	shouldExecute = shouldExecute || ((file.commsMenuStyle == eCommsMenuStyle.INVENTORY_HEALTH_MENU) && ButtonIsBoundToAction( key, HEALTHKIT_BIND_COMMAND ))
	shouldExecute = shouldExecute || ((file.commsMenuStyle == eCommsMenuStyle.SKYDIVE_EMOTE_MENU) && executeType == eWheelInputType.USE )

	shouldCancelMenu = shouldCancelMenu || ((file.commsMenuStyle == eCommsMenuStyle.CHAT_MENU) && ButtonIsBoundToAction( key, CHAT_MENU_BIND_COMMAND ))

	if ( shouldExecute )
	{
		if ( CommsMenu_HasValidSelection() )
		{
			bool didAnything = CommsMenu_ExecuteSelection( executeType )
			if ( didAnything )
				CommsMenu_Shutdown( false )

			return true
		}

		shouldCancelMenu = true
	}

	if ( shouldCancelMenu )
	{
		Ping_Interrupt()
		CommsMenu_Shutdown( true )

		entity player = GetLocalViewPlayer()
		if ( IsValid( player ) )
			EmitSoundOnEntity( player, WHEEL_SOUND_ON_CLOSE )

		if ( ( file.commsMenuStyle == eCommsMenuStyle.PING_MENU || file.commsMenuStyle == eCommsMenuStyle.PINGREPLY_MENU )
			&& ButtonIsBoundToAction( key, "+offhand1" ) && Time() - s_latestViewInputResetTime < BUTTON_PAIR_ACTIVITION_TIME )
			return false

		return true
	}

	return false
}

int s_currentChoice = -1
int s_latestValidChoice = -1
float s_latestValidChoiceTime = -1000.0
float s_latestViewInputResetTime = -1000.0

void function ResetViewInput()
{
	s_currentChoice = -1
	s_latestValidChoice = -1
	s_latestValidChoiceTime = -1000.0
	s_latestViewInputResetTime = Time()

	ResetMouseInput()
}
void function SetCurrentChoice( int choice )
{
	if ( file.menuRui != null )
	{
		RuiSetInt( file.menuRui, "focusedSlot", choice )

		string[2] promptTexts = GetPromptsForMenuOption( choice )
		RuiSetString( file.menuRui, "focusedText", promptTexts[0] )
		RuiSetString( file.menuRui, "focusedDescText", promptTexts[1] )
	}

	if ( choice >= 0 )
	{
		s_latestValidChoice = choice
		s_latestValidChoiceTime = Time()
	}
	s_currentChoice = choice

	if ( s_currentChatPage == eChatPage.INVENTORY_HEALTH )
	{
		SetRuiOptionsForChatPage( file.menuRui, s_currentChatPage )

		if ( s_currentChoice < 0 )
		{
			OverrideHUDHealthFractions( GetLocalClientPlayer() )
		}
		else
		{
			CommsMenuOptionData op = s_currentMenuOptions[s_currentChoice]

			string lootRef
			if ( WeaponDrivenConsumablesEnabled() )
			{
				ConsumableInfo kitInfo                   = Consumable_GetConsumableInfo( op.healType )
				TargetKitHealthAmounts targetHealAmounts = Consumable_PredictConsumableUse( GetLocalClientPlayer(), kitInfo )
				OverrideHUDHealthFractions( GetLocalClientPlayer(), targetHealAmounts.targetHealth, targetHealAmounts.targetShields )
				lootRef = kitInfo.lootData.ref
			}
			else
			{
				HealthPickup healthKit                   = SURVIVAL_Loot_GetHealthKitDataFromStruct( op.healType )
				TargetKitHealthAmounts targetHealAmounts = PredictHealthPackUse( GetLocalClientPlayer(), healthKit )
				OverrideHUDHealthFractions( GetLocalClientPlayer(), targetHealAmounts.targetHealth, targetHealAmounts.targetShields )
				lootRef = healthKit.lootData.ref
			}

			int count = SURVIVAL_CountItemsInInventory( GetLocalViewPlayer(), lootRef )
			if ( count == 0 )
				RuiSetString( file.menuRui, "promptText", "#PING_PROMPT_REQUEST" )
		}
	}
}
bool function IsValidChoice( int choice )
{
	//
	return choice >= 0 && choice < s_currentMenuOptions.len()
}


vector s_mousePad
void function ResetMouseInput()
{
	s_mousePad = <0, 0, 0>
}
vector function ProcessMouseInput( float deltaX, float deltaY )
{
	float MAX_BOUNDS = 200.0

	s_mousePad = <s_mousePad.x + deltaX, s_mousePad.y + deltaY, 0.0>

	// clamp to circle:
	{
		float lenRaw = Length( s_mousePad )
		if ( lenRaw > MAX_BOUNDS )
			s_mousePad = (s_mousePad / lenRaw * MAX_BOUNDS)
	}

	float lenNow = Length( s_mousePad )
	if ( lenNow < 25.0 )
	{
		//DebugScreenText( 0.25, 0.25, format( "lenNow:%.2f", lenNow ) )
		return <0, 0, 0>
	}

	vector result = (s_mousePad / Length( s_mousePad ))
	//DebugScreenText( 0.25, 0.25, format( "result:(%.1f, %.1f)  posNow:(%.1f, %.1f)  lenNow:%.2f", result.x, result.y, s_mousePad.x, s_mousePad.y, lenNow ) )
	return result
}

bool function CommsMenu_HandleMoveInputControllerOnly( float x, float y )
{
	if ( IsControllerModeActive() )
		CommsMenu_HandleViewInput( x, y )

	return false
}

bool function CommsMenu_HandleViewInput( float x, float y )
{
	//printt( format( "x: %.1f  y: %.1f", x, y ) )
	{
		float lockoutTime            = IsControllerModeActive() ? 0.0 : 0.01
		float deltaSinceInputStarted = (Time() - s_latestViewInputResetTime)
		if ( deltaSinceInputStarted < lockoutTime )
			return false
	}

	int optionCount = s_currentMenuOptions.len()
	int choice      = -1

	//float lenCutoff = IsControllerModeActive() ? ((s_currentChoice < 0) ? 0.8 : 0.4) : 15.0
	float lenCutoff = IsControllerModeActive() ? ((s_currentChoice < 0) ? 0.8 : 0.4) : ((s_currentChoice < 0) ? 0.8 : 0.4)

	RuiSetFloat2( file.menuRui, "inputVec", <0, 0, 0> )
	vector inputVec = IsControllerModeActive() ? <x, y, 0.0> : ProcessMouseInput( x, y )
	float inputLen  = Length( inputVec )
	if ( optionCount <= 0 )
	{
		choice = -1
	}
	else if ( inputLen > lenCutoff )
	{
		float circle = 2.0 * PI
		float angle  = atan2( inputVec.x, inputVec.y )        // center of index 0 is always <0,1>
		if ( angle < 0.0 )
			angle += circle

		float slotWidth = (circle / float( optionCount ))
		angle += slotWidth * 0.5

		choice = (int( (angle / circle) * optionCount ) % optionCount)

		//DebugScreenText( 0.25, 0.30, format( "inputVec:%s", string( inputVec ) ) )

		vector ruiInputVec = IsControllerModeActive() ? Normalize( inputVec ) : inputVec
		RuiSetFloat2( file.menuRui, "inputVec", Normalize( inputVec ) )
	}
	else
	{
		if ( IsControllerModeActive() )
			choice = s_currentChoice // -1
		else
			choice = s_currentChoice
	}

	if ( (choice >= 0) && (choice != s_currentChoice) )
	{
		entity player = GetLocalViewPlayer()
		EmitSoundOnEntity( player, WHEEL_SOUND_ON_FOCUS )
	}

	SetCurrentChoice( choice )
	return true
}

bool function MakeCommMenuSelection( int choice, int wheelInputType )
{
	CommsMenuOptionData op = s_currentMenuOptions[choice]
	switch( op.optionType )
	{
		case eOptionType.COMMSACTION:
		{
			HandleCommsActionPick( op.commsAction, choice )
			return true
		}

		case eOptionType.QUIP:
		{
			HandleQuipPick( expect ItemFlavor( op.emote ), op.healType )
			return true
		}

		case eOptionType.SKYDIVE_EMOTE:
		{
			entity player = GetLocalViewPlayer()

			EmitSoundOnEntity( player, WHEEL_SOUND_ON_EXECUTE )

			player.ClientCommand( "SkydiveEmote " + op.healType )
			return true
		}

		case eOptionType.NEW_PING:
		{
			Ping_ExecutePendingNewPingWithOverride( op.pingType )
			return true
		}

		case eOptionType.PING_REPLY:
		{
			Ping_ExecutePendingPingReplyWithOverride( op.pingReply )
			return true
		}

		case eOptionType.HEALTHITEM_USE:
		{
			if ( wheelInputType == eWheelInputType.USE )
			{
				HandleHealthItemUse( op.healType )
			}
			else if ( wheelInputType == eWheelInputType.REQUEST )
			{
				HealthPickup pickup = SURVIVAL_Loot_GetHealthKitDataFromStruct( op.healType )
				int kitCat          = SURVIVAL_Loot_GetHealthPickupCategoryFromData( pickup )
				bool useShieldRequest = (kitCat == eHealthPickupCategory.SHIELD)

				if ( WeaponDrivenConsumablesEnabled() )
				{
					ConsumableInfo info = Consumable_GetConsumableInfo( op.healType )
					useShieldRequest = (info.healAmount == 0 && info.shieldAmount > 0)
				}

				if ( useShieldRequest )
					Quickchat( GetLocalViewPlayer(), eCommsAction.INVENTORY_NEED_SHIELDS )
				else
					Quickchat( GetLocalViewPlayer(), eCommsAction.INVENTORY_NEED_HEALTH )

				return false // don't close the menu
			}
			else if ( wheelInputType == eWheelInputType.NONE && HealthkitWheelUseOnRelease() )
			{
				HandleHealthItemUse( op.healType )
			}

			HandleHealthItemSelection( op.healType )
			return true
		}

		case eOptionType.ORDNANCE_EQUIP:
		{
			HandleOrdnanceSelection( op.healType )
			return true
		}

		case eOptionType.EDITOR_MODE_ACTIVATE:
		{
			HandleEditorModeSelection( op.healType )
			return true
		}
	}

	return false
}

void function HandleQuipPick( ItemFlavor quip, int choice )
{
	entity player = GetLocalViewPlayer()

	EmitSoundOnEntity( player, WHEEL_SOUND_ON_EXECUTE )

	player.ClientCommand( "BroadcastQuip " + choice )

	#if(false)


#endif

	#if(false)


#endif
}

void function HandleCommsActionPick( int commsAction, int directionIndex )
{
	Assert( (commsAction >= 0) && (commsAction < eCommsAction._count) )

	EmitSoundOnEntity( GetLocalViewPlayer(), WHEEL_SOUND_ON_EXECUTE )
	Quickchat( GetLocalViewPlayer(), commsAction )
}

void function HandleHealthItemSelection( int healthPickupType )
{
	entity player = GetLocalViewPlayer()

	if ( healthPickupType != -1 )
	{
		string kitRef    = SURVIVAL_Loot_GetHealthPickupRefFromType( healthPickupType )
		if ( SURVIVAL_CountItemsInInventory( player, kitRef ) == 0 )
			return
	}

	EmitSoundOnEntity( GetLocalViewPlayer(), WHEEL_SOUND_ON_EXECUTE )

	if ( WeaponDrivenConsumablesEnabled() )
		Consumable_SetSelectedConsumableType( healthPickupType )
	else
		Survival_Health_SetSelectedHealthPickupType( healthPickupType )
}

bool function HandleHealthItemUse( int healthPickupType )
{
	entity player = GetLocalViewPlayer()

	if ( WeaponDrivenConsumablesEnabled() )
	{
		Consumable_UseItemByType( player, healthPickupType )
		return true
	}
	else
	{
		if ( !Survival_CanUseHealthPack( player, healthPickupType, true, true ) )
			return false

		Survival_UseHealthPack( player, SURVIVAL_Loot_GetHealthPickupRefFromType( healthPickupType ) )
		return true
	}

	unreachable
}

void function HandleOrdnanceSelection( int ordnanceIndex )
{
	entity player = GetLocalViewPlayer()

	LootData data
	if ( ordnanceIndex != -1 )
	{
		data = SURVIVAL_Loot_GetLootDataByIndex( ordnanceIndex )
		if ( SURVIVAL_CountItemsInInventory( player, data.ref ) == 0 )
			return
	}

	EmitSoundOnEntity( player, WHEEL_SOUND_ON_EXECUTE )

	if ( !OrdnanceWheelUseOnRelease() )
		player.ClientCommand( "Sur_SwitchToOrdnance " + ordnanceIndex + " 1" )
	else
		player.ClientCommand( "Sur_SwitchToOrdnance " + ordnanceIndex )
}

void function HandleEditorModeSelection( int editorIndex )
{
	entity player = GetLocalViewPlayer()
	player.ClientCommand("SetEditorMode "+ editorIndex.tostring())
}

void function OnDeathCallback( entity player )
{
	if ( IsLocalClientPlayer( player ) )
		DestroyCommsMenu()
}

void function OnBleedoutStarted( entity victim, float endTime )
{
	if ( victim != GetLocalViewPlayer() )
		return

	DestroyCommsMenu()
}

void function OnBleedoutEnded( entity victim )
{
	if ( victim != GetLocalViewPlayer() )
		return

	DestroyCommsMenu()
}

void function OnPlayerMatchStateChanged( entity player, int oldValue, int newValue )
{
	if ( player != GetLocalViewPlayer() )
		return

	DestroyCommsMenu()
}

void function DestroyCommsMenu()
{
	DestroyCommsMenu_( true )
}

void function DestroyCommsMenu_( bool instant )
{
	RunUIScript( "ClientToUI_SetCommsMenuOpen", false )

	if ( !IsCommsMenuActive() )
		return

	if ( file.commsMenuStyle == eCommsMenuStyle.PINGREPLY_MENU )
		SetFocusedWaypointForcedClear()

	if ( IsValid( s_focusWaypoint ) )
	{
		RuiSetBool( s_focusWaypoint.wp.ruiHud, "hasWheelFocus", false )
		s_focusWaypoint = null
	}

	if ( s_currentChatPage == eChatPage.INVENTORY_HEALTH )
		OverrideHUDHealthFractions( GetLocalClientPlayer() )

	s_currentChatPage = eChatPage.INVALID
	s_previousChatPage = eChatPage.INVALID

	RuiSetBool( file.menuRui, "isFinished", true )

	if ( instant )
	{
		RuiDestroy( file.menuRui )
		ReleaseHUDRui( file.menuRui )
	}
	else
		file.menuRuiLastShutdown = file.menuRui
	file.menuRui = null

	entity player = GetLocalViewPlayer()

	float deltaSinceInputStarted = (Time() - s_latestViewInputResetTime)
	if ( (s_latestValidChoice < 0) && (deltaSinceInputStarted < 0.35) )
		player.ClearLookStickDebounce()

	HudInput_PopContext()

	foreach ( func in file.onCommsMenuStateChangedCallbacks )
		func( false )
}

bool function IsCommsMenuActive()
{
	return (s_currentChatPage != eChatPage.INVALID)
}

bool function CommsMenu_CanUseMenu( entity player )
{
	if ( IsWatchingReplay() )
		return false

	if ( !IsAlive( player ) )
		return false

	if ( IsScoreboardShown() )
		return false

	#if(false)


#endif

	if ( IsCommsMenuActive() )
		return false

	#if(true)
		if ( IsFallLTM() && IsPlayerShadowSquad( player ) )
			return false
	#endif

	return true
}

int function CommsMenu_GetCurrentCommsMenu()
{
	return file.commsMenuStyle
}
#endif // CLIENT
#if SERVER
void function ClientCommand_SetSelectedHealthPickupType( entity player, array<string> args )
{
	if ( args.len() == 0 )
		return

	int healthPickupType = int( args[0] )

	switch( healthPickupType )
	{
		case eHealthPickupType.COMBO_FULL:
		case eHealthPickupType.SHIELD_LARGE:
		case eHealthPickupType.SHIELD_SMALL:
		case eHealthPickupType.HEALTH_LARGE:
		case eHealthPickupType.HEALTH_SMALL:
			player.SetPlayerNetInt( "selectedHealthPickupType", healthPickupType )
			return

		case WHEEL_HEAL_AUTO:
			player.SetPlayerNetInt( "selectedHealthPickupType", -1 )
			return

		default:
			Assert( 0, "tried to set an unsupported Health Pickup Type" )
			return
	}

	unreachable
}

void function ClientCommand_Quip( entity player, array<string> args )
{
	if ( args.len() == 0 )
		return

	int commsAction = int( args[0] )

	PlayQuip( player, commsAction )
}
#endif
#if(CLIENT)
void function SetHintTextOnHudElem( var hudElem, string text )
{
	RuiSetString( Hud_GetRui( hudElem ), "buttonText", Localize( text ) )
}
#endif
void function PlayQuip( entity player, int commsAction )
{
	switch ( commsAction )
	{
		case eCommsAction.QUICKCHAT_INTRO_QUIP:
			thread PlayIntroQuipThread( player, ToEHI( player ) )
			break

		case eCommsAction.QUICKCHAT_KILL_QUIP:
			thread PlayKillQuipThread( player, ToEHI( player ) )
			break
	}
}