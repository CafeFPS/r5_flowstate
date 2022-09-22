global function Cl_Survival_InventoryInit

global function Survival_SwapPrimary
global function Survival_SwapToMelee
global function Survival_SwapToOrdnance

global function ServerCallback_RefreshInventory
global function ResetInventoryMenu
global function OpenSurvivalInventory
global function OpenSurvivalGroundList

global function Survival_IsInventoryOpen
global function Survival_IsGroundlistOpen
global function Survival_GetDeathBox
global function Survival_GetDeathBoxItems
global function Survival_GetGroundListBehavior

global function BackpackAction
global function EquipmentAction
global function GroundAction

global function GroundItemUpdate
global function OpenSwapForItem
global function UpdateDpadTooltipText

global function UICallback_BackpackOpened
global function UICallback_BackpackClosed

global function UICallback_GroundlistOpened
global function UICallback_GroundlistClosed

global function UICallback_UpdateInventoryButton
global function UICallback_OnInventoryButtonAction
global function UICallback_OnInventoryButtonAltAction
global function UICallback_PingInventoryItem

global function UICallback_UpdateEquipmentButton
global function UICallback_OnEquipmentButtonAction
global function UICallback_OnEquipmentButtonAltAction
global function UICallback_PingEquipmentItem

global function UICallback_SetGroundMenuHeaderToPlayerName
global function UICallback_UpdateGroundItem
global function UICallback_GroundItemAction
global function UICallback_GroundItemAltAction
global function UICallback_PingGroundListItem

global function UICallback_UpdateQuickSwapItem
global function UICallback_OnQuickSwapItemClick
global function UICallback_OnQuickSwapItemClickRight

global function UICallback_UpdateQuickSwapItemButton

global function UICallback_GetLootDataFromButton
global function UICallback_GetMouseDragAllowedFromButton
global function UICallback_OnInventoryMouseDrop

global function UICallback_WeaponSwap
global function UICallback_UpdatePlayerInfo
global function UICallback_UpdateTeammateInfo
global function UICallback_UpdateUltimateInfo

global function UICallback_BlockPingForDuration

global function UICallback_EnableTriggerStrafing
global function UICallback_DisableTriggerStrafing

global function UpdateHealHint
global function GroundListUpdateNextFrame
global function GetCountForLootType
global function RegisterUseFunctionForItem

global enum eGroundListBehavior
{
	CONTENTS,
	NEARBY,
}

struct CurrentGroundListData
{
	entity deathBox
	int    behavior
}

struct GroundLootData
{
	LootData&         lootData
	array<int>        guids
	int               count
	bool              TEMP_hasMods
	bool              isUpgrade
	bool              isRelevant
	bool              isHeader
}

struct {
	table<string, void functionref( entity, string )>         itemUseFunctions
	table<string, void functionref( entity, string, string )> specialItemUseFunctions
	table<int, void functionref( entity, string )>            itemTypeUseFunctions
	table<int, void functionref( entity, string, string )>    specialItemTypeUseFunctions

	array<GroundLootData> allGroundItems = []
	array<GroundLootData> filteredGroundItems = []

	bool backpackOpened = false
	bool groundlistOpened = false
	bool shouldResetGroundItems = true

	string                swapString
	CurrentGroundListData currentGroundListData

	float lastHealHintDisplayTime
	table<string, string> triggerBinds
} file


void function Cl_Survival_InventoryInit()
{
	//
	//
	#if(false)

#endif
	file.itemTypeUseFunctions[ eLootType.HEALTH ] <- UseHealthPickupRefFromInventory
	file.itemTypeUseFunctions[ eLootType.ORDNANCE ] <- EquipOrdnance
	file.specialItemTypeUseFunctions[ eLootType.ATTACHMENT ] <- EquipAttachment

	RegisterSignal( "OpenSwapForItem" )
	RegisterSignal( "ResetInventoryMenu" )
	RegisterSignal( "BackpackClosed" )

	AddCallback_OnUpdateTooltip( eTooltipStyle.LOOT_PROMPT, OnUpdateLootPrompt )
	AddCallback_OnUpdateTooltip( eTooltipStyle.WEAPON_LOOT_PROMPT, OnUpdateLootPrompt )

	AddCallback_LocalPlayerPickedUpLoot( TryUpdateGroundList )

	AddLocalPlayerTookDamageCallback( TryCloseSurvivalInventoryFromDamage )
	AddLocalPlayerTookDamageCallback( ShowHealHint )
}


void function ServerCallback_RefreshInventory()
{
	ResetInventoryMenu( GetLocalClientPlayer() )
}


void function ResetInventoryMenu( entity player )
{
	thread ResetInventoryMenuInternal( player )
}


void function ResetInventoryMenuInternal( entity player )
{
	clGlobal.levelEnt.Signal( "ResetInventoryMenu" )
	clGlobal.levelEnt.EndSignal( "ResetInventoryMenu" )
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	WaitEndFrame()

	if ( IsWatchingReplay() )
		return

	if ( player != GetLocalClientPlayer() )
		return

	if ( player != GetLocalViewPlayer() )
		return

	PerfStart( PerfIndexClient.InventoryRefreshTotal )

	PerfStart( PerfIndexClient.InventoryRefreshStart )
	RunUIScript( "SurvivalInventoryMenu_BeginUpdate" )
	PerfEnd( PerfIndexClient.InventoryRefreshStart )
	RunUIScript( "SurvivalInventoryMenu_SetInventoryLimit", SURVIVAL_GetInventoryLimit( player ) )
	RunUIScript( "SurvivalInventoryMenu_SetInventoryLimitMax", SURVIVAL_GetMaxInventoryLimit( player ) )
	RunUIScript( "Survival_SetPlayerIsTitan", player.IsTitan() )
	PerfStart( PerfIndexClient.InventoryRefreshEnd )
	RunUIScript( "SurvivalInventoryMenu_EndUpdate" )
	PerfEnd( PerfIndexClient.InventoryRefreshEnd )

	if ( player == GetLocalClientPlayer() && player == GetLocalViewPlayer() )
		UpdateHealHint( player )

	PerfEnd( PerfIndexClient.InventoryRefreshTotal )
}


void function Survival_UseInventoryItem( string ref, string secondRef )
{
	if ( GetLocalViewPlayer() != GetLocalClientPlayer() )
		return

	LootData data = SURVIVAL_Loot_GetLootDataByRef( ref )
	int type      = data.lootType

	if ( ref in file.itemUseFunctions )
	{
		file.itemUseFunctions[ ref ]( GetLocalViewPlayer(), ref )
	}
	else if ( ref in file.specialItemUseFunctions )
	{
		file.specialItemTypeUseFunctions[ type ]( GetLocalViewPlayer(), ref, secondRef )
	}
	else if ( type in file.itemTypeUseFunctions )
	{
		file.itemTypeUseFunctions[ type ]( GetLocalViewPlayer(), ref )
	}
	else if ( type in file.specialItemTypeUseFunctions )
	{
		file.specialItemTypeUseFunctions[ type ]( GetLocalViewPlayer(), ref, secondRef )
	}

	ResetInventoryMenu( GetLocalViewPlayer() )
}


void function Survival_DropInventoryItem( string ref, int num )
{
	entity player = GetLocalViewPlayer()

	if ( !Survival_PlayerCanDrop( player ) )
		return

	string boxString

	if ( IsValid( file.currentGroundListData.deathBox ) && file.currentGroundListData.behavior == eGroundListBehavior.CONTENTS )
	{
		boxString = " " + file.currentGroundListData.deathBox.GetEncodedEHandle()
	}

	player.ClientCommand( "Sur_DropBackpackItem " + ref + " " + num + boxString )
	ResetInventoryMenu( player )
}

void function RegisterUseFunctionForItem( string ref, void functionref(entity, string) func )
{
	file.itemUseFunctions[ ref ] <- func
}

void function Survival_DropEquipment( string ref )
{
	entity player = GetLocalViewPlayer()

	if ( !Survival_PlayerCanDrop( player ) )
		return

	player.ClientCommand( "Sur_DropEquipment " + ref )
	ResetInventoryMenu( player )
}


void function BackpackAction( int lootAction, string slotIndexString )
{
	int slotIndex = int( slotIndexString )

	entity player                                  = GetLocalClientPlayer()
	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	int foundIndex                                 = -1

	foreach ( index, item in playerInventory )
	{
		if ( item.slot != slotIndex )
			continue

		foundIndex = index
		break
	}

	if ( foundIndex < 0 )
	{
		RunUIScript( "SurvivalMenu_AckAction" )
		return
	}

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( playerInventory[foundIndex].type )

	switch ( lootAction )
	{
		case eLootAction.DROP:
			int numToDrop = 1
			if ( lootData.lootType == eLootType.AMMO )
				numToDrop = minint( lootData.countPerDrop, playerInventory[foundIndex].count )
			Survival_DropInventoryItem( lootData.ref, numToDrop )
			break

		case eLootAction.DROP_ALL:
			Survival_DropInventoryItem( lootData.ref, playerInventory[foundIndex].count )
			break

			//

		case eLootAction.ATTACH_TO_ACTIVE:
		case eLootAction.ATTACH_TO_STOWED:
			//
			//
			//
			player.ClientCommand( "Sur_EquipAttachment " + lootData.ref )
			//
			break

		case eLootAction.EQUIP:
			Survival_UseInventoryItem( lootData.ref, "" )
			RunUIScript( "SurvivalMenu_AckAction" )
			break

		case eLootAction.USE:
			Survival_UseInventoryItem( lootData.ref, "" )
			RunUIScript( "SurvivalMenu_AckAction" )
			break
	}
}


void function EquipmentAction( int lootAction, string equipmentSlot )
{
	switch ( lootAction )
	{
		case eLootAction.EQUIP:
			entity player = GetLocalClientPlayer()
			if ( player == GetLocalViewPlayer() )
			{
				if ( EquipmentSlot_IsMainWeaponSlot( equipmentSlot ) )
				{
					EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipmentSlot )
					int slot         = es.weaponSlot
					player.ClientCommand( "weaponSelectPrimary" + slot )
				}
			}
			break

		case eLootAction.DROP:
			Survival_DropEquipment( equipmentSlot )
			break

		case eLootAction.REMOVE_TO_GROUND:
		case eLootAction.REMOVE:
			entity weaponEnt = GetBaseWeaponEntForEquipmentSlot( equipmentSlot )
			int weaponSlot = EquipmentSlot_GetWeaponSlotForEquipmentSlot( equipmentSlot )
			if ( IsValid( weaponEnt ) )
			{
				EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipmentSlot )
				Survival_UnequipAttachment( SURVIVAL_GetWeaponAttachmentForPoint( GetLocalViewPlayer(), weaponSlot, es.attachmentPoint ), weaponSlot, lootAction == eLootAction.REMOVE_TO_GROUND )
			}
			break

		case eLootAction.WEAPON_TRANSFER:
			entity weaponEnt = GetBaseWeaponEntForEquipmentSlot( equipmentSlot )
			int weaponSlot = EquipmentSlot_GetWeaponSlotForEquipmentSlot( equipmentSlot )
			if ( IsValid( weaponEnt ) )
			{
				EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipmentSlot )
				Survival_TransferAttachment( SURVIVAL_GetWeaponAttachmentForPoint( GetLocalViewPlayer(), weaponSlot, es.attachmentPoint ), weaponSlot )
			}
			break
	}
}


void function GroundAction( int lootAction, string guid, bool isAltAction, bool actionFromMenu )
{
	int extraFlags = actionFromMenu ? PICKUP_FLAG_FROM_MENU : 0
	if ( isAltAction )
		extraFlags = extraFlags | PICKUP_FLAG_ALT

	int deathBoxEntIndex = -1
	if ( IsValid( file.currentGroundListData.deathBox ) )
	{
		deathBoxEntIndex = file.currentGroundListData.deathBox.GetEncodedEHandle()
	}

	string boxString = ""
	if ( deathBoxEntIndex > -1 )
	{
		boxString = " " + deathBoxEntIndex
	}

	entity lootEnt = GetEntityFromEncodedEHandle( int( guid ) )
	if ( !IsValid( lootEnt ) )
		return

	if ( lootEnt.GetNetworkedClassName() != "prop_survival" )
		return

	switch ( lootAction )
	{
		case eLootAction.PICKUP:
		case eLootAction.EQUIP:
		case eLootAction.SWAP:
			RunUIScript( "SurvivalMenu_AckAction" )
			GetLocalClientPlayer().ClientCommand( "PickupSurvivalItem " + guid + " " + extraFlags + " " + boxString )
			break

		case eLootAction.PICKUP_ALL:
			if ( IsValid( lootEnt ) )
			{
				GetLocalClientPlayer().ClientCommand( "PickupAllSurvivalItem " + lootEnt.GetSurvivalInt() )
			}

			GetLocalClientPlayer().ClientCommand( "PickupSurvivalItem " + guid + " 0 " + boxString )
			break

		case eLootAction.ATTACH_TO_ACTIVE:
			GetLocalClientPlayer().ClientCommand( "PickupSurvivalItem " + guid + " " + (PICKUP_FLAG_ATTACH_ACTIVE_ONLY | extraFlags) + " " + boxString )
			break

		case eLootAction.ATTACH_TO_STOWED:
			GetLocalClientPlayer().ClientCommand( "PickupSurvivalItem " + guid + " " + (PICKUP_FLAG_ATTACH_STOWED_ONLY | extraFlags) + " " + boxString )
			break

		case eLootAction.CARRY:
			RunUIScript( "SurvivalMenu_AckAction" )
			break

		case eLootAction.USE:
			GetLocalClientPlayer().ClientCommand( "UseSurvivalItem " + guid )
			break

		case eLootAction.DISMANTLE:
			GetLocalClientPlayer().ClientCommand( "PickupSurvivalItem " + guid + " " + PICKUP_FLAG_ALT + " " + boxString )
	}
}


void function UICallback_BackpackOpened()
{
	file.backpackOpened = true

	entity player = GetLocalClientPlayer()
	if ( player != GetLocalViewPlayer() )
		return

	if ( IsAlive( player ) )
		player.ClientCommand( "BackpackOpened" )
}


void function UICallback_BackpackClosed()
{
	#if DEVELOPER
		if ( !IsValidSignal( "BackpackClosed" ) ) //
			return
	#endif

	file.currentGroundListData.deathBox = null
	file.backpackOpened = false
	file.groundlistOpened = false

	if ( !IsLobby() )
		clGlobal.levelEnt.Signal( "BackpackClosed" )

	entity player = GetLocalClientPlayer()
	if ( player != GetLocalViewPlayer() )
		return

	if ( IsAlive( player ) )
		player.ClientCommand( "BackpackClosed" )
}


void function UICallback_GroundlistOpened()
{
	file.shouldResetGroundItems = true
	file.groundlistOpened = true

	entity player = GetLocalClientPlayer()
	if ( player != GetLocalViewPlayer() )
		return

	if ( IsAlive( player ) && GetGameState() >= eGameState.Prematch )
		player.ClientCommand( "BackpackOpened" )
}


void function UICallback_GroundlistClosed()
{
	file.shouldResetGroundItems = true
	file.currentGroundListData.deathBox = null
	file.backpackOpened = false
	file.groundlistOpened = false
	entity player = GetLocalClientPlayer()
	if ( player != GetLocalViewPlayer() )
		return

	if ( IsAlive( player ) && GetGameState() >= eGameState.Prematch )
		player.ClientCommand( "BackpackClosed" )
}


void function Survival_UnequipAttachment( string ref, int weaponSlot, bool removeToGround )
{
	if ( GetLocalViewPlayer() != GetLocalClientPlayer() )
		return

	if ( !SURVIVAL_Loot_IsRefValid( ref ) )
		return

	LootData data = SURVIVAL_Loot_GetLootDataByRef( ref )
	GetLocalViewPlayer().ClientCommand( "Sur_UnequipAttachment " + ref + " " + weaponSlot + " " + removeToGround )
}


void function Survival_TransferAttachment( string ref, int weaponSlot )
{
	if ( GetLocalViewPlayer() != GetLocalClientPlayer() )
		return

	if ( !SURVIVAL_Loot_IsRefValid( ref ) )
		return

	LootData data = SURVIVAL_Loot_GetLootDataByRef( ref )
	GetLocalViewPlayer().ClientCommand( "Sur_TransferAttachment " + ref + " " + weaponSlot )
}


void function Survival_SwapPrimary()
{
	entity player = GetLocalViewPlayer()

	if ( !CanSwapWeapons( player ) )
		return

	thread WeaponCycle( player )
}


void function WeaponCycle( entity player )
{
	player.EndSignal( "OnDestroy" )

	player.ClientCommand( "invnext" )
}


void function Survival_SwapToMelee()
{
	entity player = GetLocalViewPlayer()

	if ( !CanSwapWeapons( player ) )
		return

	player.ClientCommand( "+ability 10" )
}


void function Survival_SwapToOrdnance()
{
	entity player = GetLocalViewPlayer()

	if ( !CanSwapWeapons( player ) )
		return

	player.ClientCommand( "weaponSelectOrdnance" )
}


bool function CanSwapWeapons( entity player )
{
	if ( player.IsTitan() )
		return false

	if ( !IsAlive( player ) )
		return false

	if ( !GamePlaying() )
		return false

	if ( player.ContextAction_IsActive() && !player.ContextAction_IsRodeo() )
		return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	return true
}


void function OpenSurvivalInventory( entity player, entity deathBox = null )
{
	if ( !player.GetPlayerNetBool( "inventoryEnabled" ) )
		return
	SurvivalMenu_Internal( player, "OpenSurvivalInventoryMenu", deathBox )
}


void function SurvivalMenu_Internal( entity player, string uiScript, entity deathBox = null, int groundListBehavior = eGroundListBehavior.CONTENTS )
{
	if ( !CanOpenInventory( player ) )
		return

	ResetInventoryMenu( player )

	ServerCallback_ClearHints()
	player.ClientCommand( "-zoom" )
	CommsMenu_Shutdown( false )

	file.currentGroundListData.deathBox = deathBox
	file.currentGroundListData.behavior = groundListBehavior

	RunUIScript( uiScript, player.IsTitan() )

	if ( IsValid( deathBox ) )
	{
		thread TrackDistanceFromDeathBox( player, deathBox )
	}
}


bool function CanOpenInventory( entity player )
{
	if ( IsWatchingReplay() )
		return false

	if ( !IsAlive( player ) )
		return false

	if ( !GamePlaying() && GetGameState() != eGameState.WaitingForPlayers )
		return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	return true
}


void function TrackDistanceFromDeathBox( entity player, entity deathBox )
{
	player.EndSignal( "OnDeath" )
	deathBox.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function() : ()
		{
			if ( Survival_IsGroundlistOpen() )
			{
				RunUIScript( "TryCloseSurvivalInventory", null )
			}
		}
	)

	wait 0.5

	while ( Survival_IsGroundlistOpen() )
	{
		if ( Distance( player.GetOrigin(), deathBox.GetOrigin() ) > DEATH_BOX_MAX_DIST || file.filteredGroundItems.len() == 0 )
			return

		WaitFrame()
	}
}


void function OpenSurvivalGroundList( entity player, entity deathBox = null, int groundListBehavior = eGroundListBehavior.CONTENTS )
{
	SurvivalMenu_Internal( player, "OpenSurvivalGroundListMenu", deathBox, groundListBehavior )
}


void function UICallback_UpdateInventoryButton( var button, int position )
{
	entity player = GetLocalClientPlayer()

	var rui = Hud_GetRui( button )

	Hud_SetEnabled( button, true )
	Hud_SetSelected( button, false )
	RuiSetImage( rui, "iconImage", $"" )
	RuiSetInt( rui, "lootTier", 0 )
	RuiSetInt( rui, "count", 0 )
	Hud_ClearToolTipData( button )
	Hud_SetLocked( button, false )

	if ( IsLobby() )
		return

	if ( position >= SURVIVAL_GetInventoryLimit( player ) )
	{
		Hud_SetEnabled( button, false )
		return
	}

	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	if ( playerInventory.len() <= position )
	{
		RunUIScript( "SurvivalQuickInventory_ClearTooltipForSlot", button )
		return
	}

	ConsumableInventoryItem item = playerInventory[ position ]

	if ( !SURVIVAL_Loot_IsLootIndexValid( item.type ) )
	{
		RunUIScript( "SurvivalQuickInventory_ClearTooltipForSlot", button )
		return
	}

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( item.type )
	RuiSetImage( rui, "iconImage", lootData.hudIcon )
	RuiSetInt( rui, "lootTier", lootData.tier )
	RuiSetInt( rui, "count", item.count )
	RuiSetInt( rui, "maxCount", SURVIVAL_GetInventorySlotCountForPlayer( player, lootData ) )

	if ( lootData.lootType == eLootType.AMMO )
		RuiSetInt( rui, "numPerPip", lootData.countPerDrop )
	else
		RuiSetInt( rui, "numPerPip", 1 )

	UpdateLockStatusForBackpackItem( button, player, lootData )

	Hud_SetSelected( button, IsItemEquipped( player, lootData.ref ) )

	RunUIScript( "SurvivalQuickInventory_SetClientUpdateLootTooltipData", button, false )

	ToolTipData dt
	dt.tooltipStyle = eTooltipStyle.LOOT_PROMPT
	dt.lootPromptData.count = item.count
	dt.lootPromptData.index = item.type
	dt.lootPromptData.lootContext = eLootContext.BACKPACK
	dt.tooltipFlags = IsPingEnabledForPlayer( player ) ? dt.tooltipFlags : dt.tooltipFlags | eToolTipFlag.PING_DISSABLED

	Hud_SetToolTipData( button, dt )
}


void function UICallback_PingInventoryItem( var button, int position )
{
	entity player = GetLocalClientPlayer()

	if ( IsLobby() )
		return

	int commsAction = GetCommsActionForBackpackItem( button, position )
	if ( commsAction != eCommsAction.BLANK )
	{
		EmitSoundOnEntity( player, PING_SOUND_DEFAULT )
		RunUIScript( "SurvivalQuickInventory_MarkInventoryButtonPinged", button )
		player.ClientCommand( "ClientCommand_Quickchat " + commsAction )
	}
}


void function UICallback_OnInventoryButtonAction( var button, int position )
{
	if ( IsLobby() )
		return

	OnInventoryButtonAction( button, position, false )
}


void function UICallback_OnInventoryButtonAltAction( var button, int position )
{
	if ( IsLobby() )
		return

	OnInventoryButtonAction( button, position, true )
}


void function OnInventoryButtonAction( var button, int position, bool isAltAction )
{
	entity player = GetLocalClientPlayer()

	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	if ( playerInventory.len() <= position )
		return

	ConsumableInventoryItem item = playerInventory[ position ]

	if ( !SURVIVAL_Loot_IsLootIndexValid( item.type ) )
		return

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( item.type )
	bool didSomething = DispatchLootAction( eLootContext.BACKPACK, SURVIVAL_GetActionForBackpackItem( player, lootData, isAltAction ).action, position )
	if ( didSomething )
		RunUIScript( "SurvivalQuickInventory_MarkInventoryButtonUsed", button )
}


void function UpdateLockStatusForBackpackItem( var button, entity player, LootData lootData )
{
	if ( !SURVIVAL_Loot_IsRefValid( lootData.ref ) )
		return

	Hud_SetLocked( button, SURVIVAL_IsLootIrrelevant( player, null, lootData, eLootContext.BACKPACK ) )
}


bool function IsItemEquipped( entity player, string ref )
{
	if ( !player.IsTitan() && IsValid( player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_ANTI_TITAN ) ) )
	{
		return player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_ANTI_TITAN ).GetWeaponClassName() == ref
	}

	return false
}


bool function DispatchLootAction( int lootContext, int lootAction, var param, bool isAltAction = false, bool actionFromMenu = true )
{
	if ( lootAction == eLootAction.NONE )
		return false

	switch ( lootContext )
	{
		case eLootContext.BACKPACK:
			BackpackAction( lootAction, string( param ) )
			return true

		case eLootContext.EQUIPMENT:
			EquipmentAction( lootAction, string( param ) )
			return true

		case eLootContext.GROUND:
			GroundAction( lootAction, string( param ), isAltAction, actionFromMenu )
			return true
	}

	return false
}


int function GetCommsActionForBackpackItem( var button, int position )
{
	entity player = GetLocalClientPlayer()

	//
	//
	//

	return eCommsAction.BLANK
}


void function UICallback_UpdateEquipmentButton( var button )
{
	entity player        = GetLocalClientPlayer()
	var rui              = Hud_GetRui( button )
	string equipmentSlot = Hud_GetScriptID( button )

	if ( !EquipmentSlot_IsValidEquipmentSlot( equipmentSlot ) )
	{
		Hud_Hide( button )
		return
	}

	LootData data    = EquipmentSlot_GetEquippedLootDataForSlot( player, equipmentSlot )
	string equipment = data.ref

	RuiSetImage( rui, "iconImage", GetEmptyEquipmentImage( equipmentSlot ) )
	RuiSetInt( rui, "lootTier", 0 )
	RuiSetInt( rui, "count", 0 )
	RuiSetString( rui, "passiveText", "" )
	RuiSetImage( rui, "ammoTypeImage", $"" )
	Hud_ClearToolTipData( button )

	if ( IsLobby() )
		return

	EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipmentSlot )

	if ( es.weaponSlot >= 0 )
		RuiSetImage( rui, "iconImage", $"" )

	if ( equipment == "" )
	{
		int tooltipFlags = IsPingEnabledForPlayer( player ) ? 0 : eToolTipFlag.PING_DISSABLED
		RunUIScript( "SurvivalQuickInventory_SetEmptyTooltipForSlot", button, Localize( "#TOOLTIP_EMPTY_PROMPT", Localize( es.title ) ), eCommsAction.BLANK, tooltipFlags )
	}
	else
	{
		EquipmentButtonInit( button, equipmentSlot, data, 0 )
	}


	if ( EquipmentSlot_IsAttachmentSlot( equipmentSlot ) )
	{
		string attachmentPoint = EquipmentSlot_GetAttachmentPointForSlot( equipmentSlot )
		EquipmentSlot esWeapon = Survival_GetEquipmentSlotDataByRef( es.attachmentWeaponSlot )
		entity weapon          = player.GetNormalWeapon( esWeapon.weaponSlot )

		LootData wData = SURVIVAL_GetLootDataFromWeapon( weapon )
		RuiSetBool( rui, "isFullyKitted", wData.tier == 4 )
		RuiSetBool( rui, "showBrackets", true )

		if ( IsValid( weapon ) && SURVIVAL_Loot_IsRefValid( wData.ref ) && AttachmentPointSupported( attachmentPoint, wData.ref ) )
		{
			Hud_SetEnabled( button, true )
			Hud_SetWidth( button, Hud_GetBaseWidth( button ) )
			if ( equipment == "" )
			{
				string attachmentStyle = GetAttachmentPointStyle( attachmentPoint, wData.ref )
				RuiSetImage( rui, "iconImage", emptyAttachmentSlotImages[attachmentStyle] )
			}
			else
			{
				RuiSetInt( rui, "count", 1 )

				if ( SURVIVAL_Weapon_IsAttachmentLocked( wData.ref ) )
				{
					RuiSetInt( rui, "lootTier", wData.tier )
				}
			}
		}
		else
		{
			RuiSetImage( rui, "iconImage", $"" )
			RuiSetInt( rui, "lootTier", 0 )
			Hud_SetWidth( button, 0 )
			Hud_SetEnabled( button, false )
			RunUIScript( "SurvivalQuickInventory_ClearTooltipForSlot", button )
		}
	}

	if ( es.weaponSlot >= 0 )
	{
		int slot = SURVIVAL_GetActiveWeaponSlot( player )
		if ( slot < 0 )
			slot = 0

		RuiSetString( rui, "weaponSlotString", "#MENU_WEAPON_SLOT" + es.weaponSlot )
		RuiSetString( rui, "weaponSlotStringConsole", "#MENU_WEAPON_SLOT_CONSOLE" + es.weaponSlot )

		RuiSetString( rui, "weaponName", "" )
		RuiSetString( rui, "skinName", "" )
		RuiSetInt( rui, "skinTier", 0 )
		RuiSetInt( rui, "count", 0 )

		entity weapon = player.GetNormalWeapon( es.weaponSlot )

		int skinTier = 0
		string skinName = ""

		string charmName = ""

		if ( IsValid( weapon ) )
		{
			RuiSetInt( rui, "count", weapon.GetWeaponPrimaryClipCount() )

			RuiSetString( rui, "weaponName", data.pickupString )

			if ( IsValidItemFlavorNetworkIndex_DEPRECATED( weapon.GetGrade(), eValidation.DONT_ASSERT ) )
			{
				ItemFlavor weaponSkin = GetItemFlavorByNetworkIndex_DEPRECATED( weapon.GetGrade() )
				ItemFlavor weaponCharm = GetItemFlavorByNetworkIndex_DEPRECATED( weapon.GetGrade() )//TODO: FIX THIS!!!! weapon.GetWeaponCharmIndex()
				RuiSetString( rui, "skinName", ItemFlavor_GetLongName( weaponSkin ) )
				if ( ItemFlavor_HasQuality( weaponSkin ) )
					RuiSetInt( rui, "skinTier", ItemFlavor_GetQuality( weaponSkin ) + 1 )

				ItemFlavor ornull weaponItemOrNull = GetWeaponItemFlavorByClass( weapon.GetWeaponClassName() )
				if ( weaponItemOrNull != null )
				{
					ItemFlavor ornull weaponSkinOrNull = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_WeaponSkin( expect ItemFlavor(weaponItemOrNull) ) )
					if ( weaponSkinOrNull != null && weaponSkinOrNull != weaponSkin )
					{
						expect ItemFlavor( weaponSkinOrNull )
						if ( ItemFlavor_HasQuality( weaponSkinOrNull ) )
						{
							skinTier = ItemFlavor_GetQuality( weaponSkinOrNull ) + 1
							skinName = ItemFlavor_GetLongName( weaponSkinOrNull )
						}
					}

					ItemFlavor ornull weaponCharmOrNull = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_WeaponCharm( expect ItemFlavor(weaponItemOrNull) ) )
					if ( weaponCharmOrNull != null && weaponCharmOrNull != weaponCharm )
					{
						expect ItemFlavor( weaponCharmOrNull )
						charmName = ItemFlavor_GetLongName( weaponCharmOrNull )
					}
				}
			}

			RunUIScript( "SurvivalQuickInventory_UpdateEquipmentForActiveWeapon", slot )
			RunUIScript( "SurvivalQuickInventory_UpdateWeaponSlot", es.weaponSlot, skinTier, skinName, charmName )
		}
	}
}


void function EquipmentButtonInit( var button, string equipmentSlot, LootData lootData, int count )
{
	entity player = GetLocalClientPlayer()
	var rui       = Hud_GetRui( button )
	RuiSetImage( rui, "iconImage", lootData.hudIcon )
	RuiSetInt( rui, "lootTier", lootData.tier )
	RuiSetInt( rui, "count", count )

	if ( lootData.passive != ePassives.INVALID )
		RuiSetString( rui, "passiveText", PASSIVE_NAME_MAP[lootData.passive] )

	bool isMainWeapon = EquipmentSlot_IsMainWeaponSlot( equipmentSlot )

	if ( isMainWeapon )
	{
		string ammoType = lootData.ammoType
		asset icon      = lootData.fakeAmmoIcon
		if ( SURVIVAL_Loot_IsRefValid( ammoType ) )
		{
			LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoType )
			icon = ammoData.hudIcon
		}
		RuiSetImage( rui, "ammoTypeImage", icon )
	}

	ToolTipData dt
	PopulateTooltipWithTitleAndDesc( lootData, dt )
	LootRef lootRef = SURVIVAL_CreateLootRef( lootData, null )

	LootActionStruct asMain = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, false, true )
	SURVIVAL_UpdateStringForEquipmentAction( player, equipmentSlot, asMain, lootRef )
	LootActionStruct asAlt = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, true, true )
	SURVIVAL_UpdateStringForEquipmentAction( player, equipmentSlot, asAlt, lootRef )

	dt.actionHint1 = Localize( asMain.displayString ).toupper()
	dt.actionHint2 = Localize( asAlt.displayString ).toupper()

	dt.commsAction = GetCommsActionForEquipmentSlot( equipmentSlot )

	dt.tooltipFlags = IsPingEnabledForPlayer( player ) ? dt.tooltipFlags : dt.tooltipFlags | eToolTipFlag.PING_DISSABLED

	Hud_SetToolTipData( button, dt )
	RunUIScript( "SurvivalQuickInventory_SetClientUpdateDefaultTooltipData", button )
}


void function PopulateTooltipWithTitleAndDesc( LootData lootData, ToolTipData dt )
{
	string combinedTitle = lootData.pickupString
	string combinedDesc  = lootData.desc

	string passiveName
	string passiveDesc

	if ( lootData.passive != ePassives.INVALID )
	{
		passiveName = PASSIVE_NAME_MAP[lootData.passive]
		passiveDesc = PASSIVE_DESCRIPTION_SHORT_MAP[lootData.passive]
		//
		combinedDesc = Localize( "#HUD_LOOT_WITH_PASSIVE_DESC", Localize( lootData.desc ), Localize( passiveName ).toupper(), Localize( passiveDesc ) )
	}
	dt.tooltipFlags = dt.tooltipFlags | eToolTipFlag.SOLID
	dt.titleText = combinedTitle
	dt.descText = combinedDesc
}


void function UICallback_OnEquipmentButtonAction( var button )
{
	if ( IsLobby() )
		return

	OnEquipmentButtonAction( button, false )
}


void function UICallback_OnEquipmentButtonAltAction( var button, bool fromExtendedUse )
{
	if ( IsLobby() )
		return

	OnEquipmentButtonAction( button, true, fromExtendedUse )
}


void function OnEquipmentButtonAction( var button, bool isAltAction, bool fromExtendedUse = false )
{
	entity player = GetLocalClientPlayer()

	string equipmentType = Hud_GetScriptID( button )
	LootData data        = EquipmentSlot_GetEquippedLootDataForSlot( player, equipmentType )
	string equipmentRef  = data.ref
	if ( equipmentRef == "" )
		return

	LootData lootData   = SURVIVAL_Loot_GetLootDataByRef( equipmentRef )
	LootActionStruct as = SURVIVAL_GetActionForEquipment( player, lootData, isAltAction )
	LootRef lootRef     = SURVIVAL_CreateLootRef( lootData, null )

	SURVIVAL_UpdateStringForEquipmentAction( player, equipmentType, as, lootRef )
	if ( as.action == eLootAction.DROP && lootData.lootType == eLootType.MAINWEAPON && !fromExtendedUse )
	{
		RunUIScript( "ClientCallback_StartEquipmentExtendedUse", button, 0.4 )
	}
	else
	{
		bool didSomething = DispatchLootAction( eLootContext.EQUIPMENT, as.action, equipmentType )
		if ( didSomething )
			RunUIScript( "SurvivalQuickInventory_MarkInventoryButtonUsed", button )
	}
}


void function UICallback_PingEquipmentItem( var button )
{
	if ( IsLobby() )
		return

	entity player    = GetLocalClientPlayer()
	string equipSlot = Hud_GetScriptID( button )
	int commsAction  = GetCommsActionForEquipmentSlot( equipSlot )
	if ( commsAction == eCommsAction.BLANK )
		return

	EmitSoundOnEntity( player, PING_SOUND_DEFAULT )
	RunUIScript( "SurvivalQuickInventory_MarkInventoryButtonPinged", button )

	player.ClientCommand( "ClientCommand_Quickchat " + commsAction + " 0 " + equipSlot )
}


int function GetCommsActionForEquipmentSlot( string equipSlot )
{
	entity player       = GetLocalClientPlayer()
	LootData data       = EquipmentSlot_GetEquippedLootDataForSlot( player, equipSlot )
	string equipmentRef = data.ref
	bool isEmpty        = (equipmentRef == "")

	return Survival_GetCommsActionForEquipmentSlot( equipSlot, equipmentRef, isEmpty )
}


int function SortByAmmoThenTierThenPriority( GroundLootData a, GroundLootData b )
{
	if ( a.lootData.lootType == eLootType.AMMO && b.lootData.lootType != eLootType.AMMO )
		return -1
	else if ( a.lootData.lootType != eLootType.AMMO && b.lootData.lootType == eLootType.AMMO )
		return 1

	if ( a.lootData.lootType == eLootType.MAINWEAPON && b.lootData.lootType != eLootType.MAINWEAPON )
		return -1
	else if ( a.lootData.lootType != eLootType.MAINWEAPON && b.lootData.lootType == eLootType.MAINWEAPON )
		return 1

	return SortByTierThenPriority( a, b )
}


int function SortByTierThenPriority( GroundLootData a, GroundLootData b )
{
	int aPriority = GetPriorityForLootType( a.lootData )
	int bPriority = GetPriorityForLootType( b.lootData )

	if ( a.lootData.tier > b.lootData.tier )
		return -1
	if ( a.lootData.tier < b.lootData.tier )
		return 1

	if ( aPriority < bPriority )
		return -1
	else if ( aPriority > bPriority )
		return 1

	if ( a.lootData.lootType < b.lootData.lootType )
		return -1
	if ( a.lootData.lootType > b.lootData.lootType )
		return 1

	if ( a.guids.len() > b.guids.len() )
		return -1
	if ( a.guids.len() < b.guids.len() )
		return 1

	return 0
}


int function SortByPriorityThenTierForGroundLoot( GroundLootData a, GroundLootData b )
{
	int aPriority = GetPriorityForLootType( a.lootData )
	int bPriority = GetPriorityForLootType( b.lootData )

	if ( aPriority < bPriority )
		return -1
	else if ( aPriority > bPriority )
		return 1

	if ( a.lootData.lootType < b.lootData.lootType )
		return -1
	if ( a.lootData.lootType > b.lootData.lootType )
		return 1

	if ( a.lootData.tier > b.lootData.tier )
		return -1
	if ( a.lootData.tier < b.lootData.tier )
		return 1


	return 0
}


void function UICallback_EnableTriggerStrafing()
{
	//
	//
	//
	//
	//
}

void function UICallback_DisableTriggerStrafing()
{
	//
	//
	//
	//
	//
}


void function UICallback_SetGroundMenuHeaderToPlayerName( void elem )
{
	var rui     = Hud_GetRui( elem )
	string text = "#PLAYER_ITEMS"

	if ( IsValid( file.currentGroundListData.deathBox ) && file.currentGroundListData.behavior == eGroundListBehavior.CONTENTS )
	{
		string overrideName = file.currentGroundListData.deathBox.GetCustomOwnerName()
		if ( overrideName != "" )
		{
			text = Localize( "#PLAYERS_ITEMS", overrideName )
		}
		else
		{
			EHI ornull ehi = GetEHIForDeathBox( file.currentGroundListData.deathBox )
			if ( ehi != null )
			{
				expect EHI( ehi )
				if ( EHIHasValidScriptStruct( ehi ) )
				{
					string playerName = GetPlayerName( ehi )
					text = Localize( "#PLAYERS_ITEMS", playerName )
				}
			}
		}
	}

	RuiSetString( rui, "headerText", text )
}


void function UICallback_UpdateGroundItem( var button, int position )
{
	entity player = GetLocalClientPlayer()
	var rui       = Hud_GetRui( button )
	Hud_ClearToolTipData( button )

	if ( IsLobby() )
		return

	if ( position >= file.filteredGroundItems.len() )
		return

	GroundLootData groundLootData = file.filteredGroundItems[position]

	Hud_SetLocked( button, false )
	Hud_SetEnabled( button, !groundLootData.isHeader ) //

	RuiSetImage( rui, "iconImage", $"" )
	RuiSetInt( rui, "lootTier", 0 )
	RuiSetInt( rui, "count", 0 )
	RuiSetInt( rui, "lootType", 0 )
	RuiSetBool( rui, "isPinged", false )
	RuiSetBool( rui, "showWhenEmpty", false )
	RuiSetImage( rui, "ammoTypeImage", $"" )
	RuiSetBool( rui, "isUpgrade", false )

	RuiSetBool( rui, "isHeader", groundLootData.isHeader )

	if ( groundLootData.isHeader )
	{
		RuiSetImage( rui, "iconImage", groundLootData.lootData.hudIcon )
		RuiSetString( rui, "buttonText", groundLootData.lootData.pickupString )
		return
	}

	entity ent = GetEntFromGroundLootData( groundLootData )

	if ( !IsValid( ent ) )
	{
		Hud_SetEnabled( button, false )
		return
	}

	string combinedTitle = groundLootData.lootData.pickupString
	string combinedDesc  = groundLootData.lootData.desc

	string passiveName
	string passiveDesc

	if ( groundLootData.lootData.passive != ePassives.INVALID )
	{
		passiveName = PASSIVE_NAME_MAP[groundLootData.lootData.passive]
		passiveDesc = PASSIVE_DESCRIPTION_SHORT_MAP[groundLootData.lootData.passive]
		combinedTitle = Localize( "#HUD_LOOT_WITH_PASSIVE", Localize( groundLootData.lootData.pickupString ), Localize( passiveName ) )
		combinedDesc = Localize( "#HUD_LOOT_WITH_PASSIVE_DESC", Localize( groundLootData.lootData.desc ), Localize( passiveName ), Localize( passiveDesc ) )
	}

	bool isMainWeapon = (groundLootData.lootData.lootType == eLootType.MAINWEAPON)

	bool isPinged     = IsGroundLootPinged( groundLootData )
	bool isPingedByUs = IsGroundLootPinged( groundLootData, player )

	RuiSetString( rui, "buttonText", combinedTitle )
	RuiSetImage( rui, "iconImage", groundLootData.lootData.hudIcon )
	RuiSetInt( rui, "lootTier", groundLootData.lootData.tier )
	RuiSetInt( rui, "count", groundLootData.count )
	RuiSetInt( rui, "lootType", isMainWeapon ? 1 : 0 )
	RuiSetBool( rui, "isPinged", isPinged )
	RuiSetImage( rui, "ammoTypeImage", $"" )

	if ( isMainWeapon )
	{
		string ammoType = groundLootData.lootData.ammoType
		asset icon      = $""
		if ( SURVIVAL_Loot_IsRefValid( ammoType ) )
		{
			LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoType )
			icon = ammoData.hudIcon
		}
		RuiSetImage( rui, "ammoTypeImage", icon )
	}

	Hud_SetLocked( button, !groundLootData.isRelevant )
	RuiSetBool( rui, "isUpgrade", groundLootData.isUpgrade )

	ToolTipData dt
	dt.tooltipStyle = isMainWeapon ? eTooltipStyle.WEAPON_LOOT_PROMPT : eTooltipStyle.LOOT_PROMPT

	if ( groundLootData.guids.len() > 0 )
		dt.lootPromptData.guid = groundLootData.guids[0]

	dt.lootPromptData.count = groundLootData.count
	dt.lootPromptData.index = groundLootData.lootData.index
	dt.lootPromptData.lootContext = eLootContext.GROUND
	dt.lootPromptData.isPinged = isPinged
	dt.lootPromptData.isPingedByUs = isPingedByUs
	dt.lootPromptData.property = ent.GetSurvivalProperty()
	dt.tooltipFlags = IsPingEnabledForPlayer( player ) ? dt.tooltipFlags : dt.tooltipFlags | eToolTipFlag.PING_DISSABLED

	if ( isMainWeapon )
		dt.lootPromptData.mods = ent.GetWeaponMods()

	Hud_SetToolTipData( button, dt )

	RunUIScript( "SurvivalQuickInventory_SetClientUpdateLootTooltipData", button, groundLootData.lootData.lootType == eLootType.MAINWEAPON )
}


bool function IsGroundLootPinged( GroundLootData grounLootData, entity player = null )
{
	foreach ( guid in grounLootData.guids )
	{
		entity ent = GetEntityFromEncodedEHandle( guid )
		if ( IsValid( ent ) )
		{
			if ( player == null )
			{
				if ( Waypoint_LootItemIsBeingPingedByAnyone( ent ) )
					return true
			}
			else
			{
				entity pingWaypoint = Waypoint_GetWaypointForLootItemPingedBy( ent, player )
				if ( IsValid( pingWaypoint ) )
					return true
			}
		}
	}

	return false
}


void function UICallback_GroundItemAction( var button, int position, bool fromExtendedUse )
{
	entity player = GetLocalClientPlayer()

	if ( IsLobby() )
		return

	if ( position >= file.filteredGroundItems.len() )
		return

	GroundLootData groundLootData = file.filteredGroundItems[position]

	if ( groundLootData.guids.len() == 0 )
		return

	bool isInventoryFull = SURVIVAL_AddToPlayerInventory( player, groundLootData.lootData.ref ) == 0

	entity ent = GetEntFromGroundLootData( groundLootData )

	LootRef lootRef  = SURVIVAL_CreateLootRef( groundLootData.lootData, ent )
	int groundAction = SURVIVAL_GetActionForGroundItem( player, lootRef, false ).action

	if ( groundAction == eLootAction.SWAP && !fromExtendedUse )
	{
		RunUIScript( "ClientCallback_StartGroundItemExtendedUse", button, position, 0.4 )
	}
	else if ( isInventoryFull && groundAction == eLootAction.PICKUP )
	{
		file.swapString = Localize( groundLootData.lootData.pickupString )
		RunUIScript( "GroundItem_OpenQuickSwap", button, position, groundLootData.guids[0] )
	}
	else
	{
		bool didSomething = DispatchLootAction( eLootContext.GROUND, groundAction, groundLootData.guids.top() )
		if ( didSomething )
			RunUIScript( "SurvivalQuickInventory_MarkInventoryButtonUsed", button )
	}
}


void function UICallback_GroundItemAltAction( var button, int position )
{
	if ( IsLobby() )
		return

	if ( position >= file.filteredGroundItems.len() )
		return

	entity player                 = GetLocalClientPlayer()
	GroundLootData groundLootData = file.filteredGroundItems[position]

	if ( groundLootData.guids.len() == 0 )
		return

	entity ent = GetEntFromGroundLootData( groundLootData )

	LootRef lootRef = SURVIVAL_CreateLootRef( groundLootData.lootData, ent )

	bool isInventoryFull = SURVIVAL_AddToPlayerInventory( player, groundLootData.lootData.ref ) == 0

	int groundAction = SURVIVAL_GetActionForGroundItem( player, lootRef, true ).action

	if ( isInventoryFull && groundAction == eLootAction.PICKUP )
	{
		file.swapString = Localize( groundLootData.lootData.pickupString )
		RunUIScript( "GroundItem_OpenQuickSwap", button, position, groundLootData.guids[0] )
	}
	else
	{
		bool didSomething = DispatchLootAction( eLootContext.GROUND, SURVIVAL_GetActionForGroundItem( player, lootRef, true ).action, groundLootData.guids.top(), true, false )
		if ( didSomething )
			RunUIScript( "SurvivalQuickInventory_MarkInventoryButtonUsed", button )
	}
}


void function UICallback_PingGroundListItem( var button, int position )
{
	entity player = GetLocalClientPlayer()

	if ( IsLobby() )
		return

	if ( position >= file.filteredGroundItems.len() )
		return

	GroundLootData groundLootData = file.filteredGroundItems[position]

	if ( groundLootData.guids.len() == 0 )
		return

	UIFunc_PingGroundLoot( groundLootData.guids.top() )
}


void function UICallback_UpdateQuickSwapItem( var button, int position )
{
	entity player = GetLocalClientPlayer()
	var rui       = Hud_GetRui( button )

	Hud_SetSelected( button, false )
	Hud_SetLocked( button, false )
	RuiSetImage( rui, "iconImage", $"" )
	RuiSetInt( rui, "lootTier", 0 )
	RuiSetInt( rui, "count", 0 )

	if ( IsLobby() )
		return

	if ( position >= SURVIVAL_GetInventoryLimit( player ) )
	{
		Hud_ClearToolTipData( button )
		Hud_SetEnabled( button, false )
		return
	}

	Hud_SetEnabled( button, true )

	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	if ( playerInventory.len() <= position )
	{
		int commsAction = GetCommsActionForBackpackItem( button, position )
		RunUIScript( "SurvivalQuickInventory_ClearTooltipForSlot", button )
		return
	}

	ConsumableInventoryItem item = playerInventory[position]

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( item.type )
	RuiSetImage( rui, "iconImage", lootData.hudIcon )
	RuiSetInt( rui, "lootTier", lootData.tier )
	RuiSetInt( rui, "count", item.count )
	RuiSetInt( rui, "maxCount", SURVIVAL_GetInventorySlotCountForPlayer( player, lootData ) )

	if ( lootData.lootType == eLootType.AMMO )
		RuiSetInt( rui, "numPerPip", lootData.countPerDrop )
	else
		RuiSetInt( rui, "numPerPip", 1 )

	ToolTipData toolTipData
	toolTipData.titleText = lootData.pickupString
	toolTipData.descText = lootData.desc
	toolTipData.actionHint1 = Localize( "#LOOT_SWAP", file.swapString ).toupper()
	toolTipData.tooltipFlags = IsPingEnabledForPlayer( player ) ? toolTipData.tooltipFlags : toolTipData.tooltipFlags | eToolTipFlag.PING_DISSABLED

	if ( Survival_PlayerCanDrop( player ) )
		toolTipData.actionHint2 = Localize( "#LOOT_ALT_DROP" ).toupper()

	Hud_SetToolTipData( button, toolTipData )
	RunUIScript( "SurvivalQuickInventory_SetClientUpdateDefaultTooltipData", button )

	Hud_SetSelected( button, IsItemEquipped( player, lootData.ref ) )
	Hud_SetLocked( button, SURVIVAL_IsLootIrrelevant( player, null, lootData, eLootContext.BACKPACK ) )
}


void function UICallback_OnQuickSwapItemClick( var button, int position )
{
	if ( IsLobby() )
		return

	entity player                                  = GetLocalClientPlayer()
	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )

	int slot = -1
	if ( playerInventory.len() > position )
	{
		slot = position
	}

	int deathBoxEntIndex = -1
	if ( IsValid( file.currentGroundListData.deathBox ) && file.currentGroundListData.behavior == eGroundListBehavior.CONTENTS )
	{
		deathBoxEntIndex = file.currentGroundListData.deathBox.GetEncodedEHandle()
	}

	RunUIScript( "SurvivalQuickInventory_DoQuickSwap", slot, deathBoxEntIndex )
}


void function UICallback_OnQuickSwapItemClickRight( var button, int position )
{
	if ( IsLobby() )
		return

	entity player                                  = GetLocalClientPlayer()
	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
	if ( playerInventory.len() <= position )
	{
		return
	}

	BackpackAction( eLootAction.DROP, string( position ) )
}


void function UICallback_UpdateQuickSwapItemButton( var button, int guid )
{
	if ( guid < 0 )
		return

	entity loot = GetEntityFromEncodedEHandle( guid )

	if ( !IsValid( loot ) )
		return

	if ( loot.GetNetworkedClassName() != "prop_survival" )
		return

	int lootIdx = loot.GetSurvivalInt()

	if ( !SURVIVAL_Loot_IsLootIndexValid( lootIdx ) )
		return

	LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( lootIdx )

	entity player = GetLocalClientPlayer()
	var rui       = Hud_GetRui( button )
	Hud_ClearToolTipData( button )

	if ( IsLobby() )
		return

	string combinedTitle = lootData.pickupString
	string combinedDesc  = lootData.desc

	string passiveName
	string passiveDesc

	int count = loot.GetClipCount()

	if ( lootData.passive != ePassives.INVALID )
	{
		passiveName = PASSIVE_NAME_MAP[lootData.passive]
		passiveDesc = PASSIVE_DESCRIPTION_SHORT_MAP[lootData.passive]
		combinedTitle = Localize( "#HUD_LOOT_WITH_PASSIVE", Localize( lootData.pickupString ), Localize( passiveName ) )
		combinedDesc = Localize( "#HUD_LOOT_WITH_PASSIVE_DESC", Localize( lootData.desc ), Localize( passiveName ), Localize( passiveDesc ) )
	}

	file.swapString = Localize( lootData.pickupString )

	bool isMainWeapon = (lootData.lootType == eLootType.MAINWEAPON)

	RuiSetString( rui, "buttonText", combinedTitle )
	RuiSetImage( rui, "iconImage", lootData.hudIcon )
	RuiSetInt( rui, "lootTier", lootData.tier )
	RuiSetInt( rui, "count", count )
	RuiSetInt( rui, "lootType", isMainWeapon ? 1 : 0 )

	LootRef lootRef = SURVIVAL_CreateLootRef( lootData, null )

	RuiSetImage( rui, "ammoTypeImage", $"" )

	if ( isMainWeapon )
	{
		string ammoType = lootData.ammoType
		asset icon      = lootData.fakeAmmoIcon
		if ( SURVIVAL_Loot_IsRefValid( ammoType ) )
		{
			LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoType )
			icon = ammoData.hudIcon
		}
		RuiSetImage( rui, "ammoTypeImage", icon )
	}
}


void function OpenSwapForItem( string ref, string guid )
{
	Signal( clGlobal.levelEnt, "OpenSwapForItem" )
	EndSignal( clGlobal.levelEnt, "OpenSwapForItem" )

	if ( !CanOpenInventory( GetLocalClientPlayer() ) )
		return

	RunUIScript( "SurvivalQuickInventory_OpenSwapForItem", guid )
}


bool function FilteredGroundItemsContains( string ref )
{
	for ( int i = 0; i < file.filteredGroundItems.len(); i++ )
	{
		GroundLootData item = file.filteredGroundItems[i]
		if ( item.lootData.ref == ref )
			return true
	}

	return false
}


void function OnUpdateLootPrompt( int style, ToolTipData dt )
{
	UpdateLootTooltip( dt )
}


void function UpdateLootTooltip( ToolTipData dt )
{
	int index       = dt.lootPromptData.index
	int count       = dt.lootPromptData.count
	int entIndex    = dt.lootPromptData.guid
	int lootContext = dt.lootPromptData.lootContext
	int property    = dt.lootPromptData.property

	entity ent
	if ( entIndex != -1 )
		ent = GetEntityFromEncodedEHandle( entIndex )

	LootData data   = SURVIVAL_Loot_GetLootDataByIndex( index )
	LootRef lootRef = SURVIVAL_CreateLootRef( data, ent )
	lootRef.count = count
	lootRef.lootProperty = property

	entity player = GetLocalViewPlayer()

	LootActionStruct asMain = SURVIVAL_BuildStringForAction( player, lootContext, lootRef, false, true )

	var rui = GetTooltipRui()
	RuiSetBool( rui, "canPing", lootContext == eLootContext.GROUND && IsPingEnabledForPlayer( player ) )
	RuiSetBool( rui, "isTooltip", true )
	RuiSetBool( rui, "isVisible", true )
	RuiSetBool( rui, "isPinged", dt.lootPromptData.isPinged )
	RuiSetBool( rui, "isPingedByUs", dt.lootPromptData.isPingedByUs )

	UpdateLootRuiWithData( player, rui, data, lootContext, lootRef, true )
}


void function UpdateDpadTooltipText( string ref, string emptySlotText, string equipmentSlot )
{
	entity player = GetLocalViewPlayer()

	if ( SURVIVAL_Loot_IsRefValid( ref ) )
	{
		LootActionStruct asMain
		LootActionStruct asAlt
		LootData lootData = SURVIVAL_Loot_GetLootDataByRef( ref )
		LootRef lootRef   = SURVIVAL_CreateLootRef( lootData, null )
		LootTypeData lt   = GetLootTypeData( lootData.lootType )

		string itemTitle         = ""
		string backpackAction    = ""
		string backpackAltAction = ""
		string specialPrompt     = ""
		string commsPrompt       = ""

		if ( EquipmentSlot_IsValidEquipmentSlot( equipmentSlot ) )
		{
			asMain = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, false, true )
			SURVIVAL_UpdateStringForEquipmentAction( player, equipmentSlot, asMain, lootRef )
			asAlt = SURVIVAL_BuildStringForAction( player, eLootContext.EQUIPMENT, lootRef, true, true )
			SURVIVAL_UpdateStringForEquipmentAction( player, equipmentSlot, asAlt, lootRef )

			EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipmentSlot )

			if ( es.weaponSlot == 0 )
				itemTitle = Localize( "#MENU_WEAPON_SLOT_CONSOLE0" ) + " - "
			else if ( es.weaponSlot == 1 )
				itemTitle = Localize( "#MENU_WEAPON_SLOT_CONSOLE1" ) + " - "

			if ( EquipmentSlot_IsAttachmentSlot( equipmentSlot ) )
				specialPrompt = Localize( "#INVENTORY_SELECT_WEAPON" )
		}
		else
		{
			asMain = SURVIVAL_BuildStringForAction( player, eLootContext.BACKPACK, lootRef, false, true )
			asAlt = SURVIVAL_BuildStringForAction( player, eLootContext.BACKPACK, lootRef, true, true )
		}

		backpackAction = asMain.displayString
		backpackAltAction = asAlt.displayString
		itemTitle += lootData.pickupString

		if ( lootData.lootType == eLootType.MAINWEAPON )
		{
			specialPrompt = Localize( "#INVENTORY_MANAGE_ATTACHMENTS" )
			commsPrompt = IsControllerModeActive() ? "#PING_PROMPT_REQUEST_AMMO_GAMEPAD" : "#PING_PROMPT_REQUEST_AMMO"
			commsPrompt = Localize( commsPrompt )
		}

		RunUIScript( "UpdateInventoryDpadTooltip", itemTitle, backpackAction, backpackAltAction, commsPrompt, specialPrompt )
	}
	else //
	{
		string specialPrompt = ""
		if ( EquipmentSlot_IsValidEquipmentSlot( equipmentSlot ) && EquipmentSlot_IsAttachmentSlot( equipmentSlot ) )
			specialPrompt = Localize( "#INVENTORY_SELECT_WEAPON" )

		string commsPrompt = IsControllerModeActive() ? "#PING_PROMPT_REQUEST_GAMEPAD" : "#PING_PROMPT_REQUEST"
		commsPrompt = Localize( commsPrompt )
		RunUIScript( "UpdateInventoryDpadTooltip", emptySlotText, "", "", commsPrompt, specialPrompt )
	}
}


void function GroundItemUpdate( entity player, array<entity> loot )
{
	RunUIScript( "SurvivalGroundItem_BeginUpdate" )

	if ( file.shouldResetGroundItems )
	{
		GroundItemsInit( player, loot )

		if ( GetCurrentPlaylistVarBool( "deathbox_diff_enabled", true ) )
			file.shouldResetGroundItems = false
	}
	else
	{
		GroundItemsDiff( player, loot )
	}

	RunUIScript( "SurvivalGroundItem_SetGroundItemCount", file.filteredGroundItems.len() )
	foreach ( index, item in file.filteredGroundItems )
	{
		RunUIScript( "SurvivalGroundItem_SetGroundItemHeader", index, item.isHeader )
	}
	RunUIScript( "SurvivalGroundItem_EndUpdate" )
}


void function GroundItemsDiff( entity player, array<entity> loot )
{
	array<int> indecesInList

	foreach ( gd in file.filteredGroundItems )
	{
		gd.guids.clear()

		bool found       = false
		int currentCount = 0
		foreach ( item in loot )
		{
			if ( item.GetNetworkedClassName() != "prop_survival" )
				continue

			if ( gd.lootData.index == item.GetSurvivalInt() )
			{
				currentCount += item.GetClipCount()
				found = true
				gd.guids.append( item.GetEncodedEHandle() )
			}
		}

		gd.count = currentCount
		indecesInList.append( gd.lootData.index )
	}

	table<string, GroundLootData> extras

	foreach ( item in loot )
	{
		if ( item.GetNetworkedClassName() != "prop_survival" )
			continue

		if ( !indecesInList.contains( item.GetSurvivalInt() ) )
		{
			LootData data = SURVIVAL_Loot_GetLootDataByIndex( item.GetSurvivalInt() )
			GroundLootData gd

			if ( data.ref in extras )
				gd = extras[ data.ref ]
			else
			{
				extras[ data.ref ] <- gd
				gd.isRelevant = SURVIVAL_IsLootIrrelevant( player, item, gd.lootData, eLootContext.GROUND )
				gd.isUpgrade = (GetCurrentPlaylistVarBool( "deathbox_show_upgrades", true ) && SURVIVAL_IsLootAnUpgrade( player, item, gd.lootData, eLootContext.GROUND ))
			}

			gd.lootData = data
			gd.count += item.GetClipCount()
			gd.guids.append( item.GetEncodedEHandle() )
		}
	}

	foreach ( gd in extras )
		file.filteredGroundItems.append( gd )
}


void function GroundItemsInit( entity player, array<entity> loot )
{
	file.filteredGroundItems.clear()

	array<GroundLootData> upgradeItems
	array<GroundLootData> unusableItems
	array<GroundLootData> relevantItems
	table<string, GroundLootData> allItems

	for ( int groundIndex = 0; groundIndex < loot.len(); groundIndex++ )
	{
		entity item = loot[groundIndex]

		if ( item.GetNetworkedClassName() != "prop_survival" )
			continue

		LootData data = SURVIVAL_Loot_GetLootDataByIndex( item.GetSurvivalInt() )

		GroundLootData gd

		if ( data.ref in allItems )
			gd = allItems[ data.ref ]
		else
			allItems[ data.ref ] <- gd

		gd.lootData = data
		gd.count += item.GetClipCount()
		gd.guids.append( item.GetEncodedEHandle() )
	}

	bool sortByType    = GetCurrentPlaylistVarBool( "deathbox_sort_by_type", true )
	bool showUpgrades  = !sortByType && GetCurrentPlaylistVarBool( "deathbox_show_upgrades", true )
	bool splitUnusable = !sortByType && GetCurrentPlaylistVarBool( "deathbox_split_unusable", true )

	foreach ( gd in allItems )
	{
		entity ent = GetEntFromGroundLootData( gd )

		if ( showUpgrades && SURVIVAL_IsLootAnUpgrade( player, ent, gd.lootData, eLootContext.GROUND ) )
		{
			gd.isRelevant = true
			gd.isUpgrade = true
			upgradeItems.append( gd )
		}
		else if ( SURVIVAL_IsLootIrrelevant( player, ent, gd.lootData, eLootContext.GROUND ) )
		{
			gd.isRelevant = false
			gd.isUpgrade = false
			if ( splitUnusable )
				unusableItems.append( gd )
			else
				relevantItems.append( gd )
		}
		else
		{
			gd.isRelevant = true
			gd.isUpgrade = false
			relevantItems.append( gd )
		}
	}

	if ( sortByType )
	{
		upgradeItems.sort( SortByPriorityThenTierForGroundLoot )
		relevantItems.sort( SortByPriorityThenTierForGroundLoot )
		unusableItems.sort( SortByPriorityThenTierForGroundLoot )
	}
	else
	{
		upgradeItems.sort( SortByAmmoThenTierThenPriority )
		relevantItems.sort( SortByAmmoThenTierThenPriority )
		unusableItems.sort( SortByAmmoThenTierThenPriority )
	}

	if ( upgradeItems.len() > 0 )
	{
		file.filteredGroundItems.append( CreateHeaderData( "#HEADER_UPGRADES", $"rui/pilot_loadout/kit/titan_cowboy_filled" ) )
	}
	file.filteredGroundItems.extend( upgradeItems )

	if ( splitUnusable && relevantItems.len() > 0 )
	{
		file.filteredGroundItems.append( CreateHeaderData( "#HEADER_USEABLE", $"" ) )
	}
	file.filteredGroundItems.extend( relevantItems )

	if ( splitUnusable && unusableItems.len() > 0 )
	{
		file.filteredGroundItems.append( CreateHeaderData( "#HEADER_UNUSEABLE", $"rui/menu/common/button_unbuyable" ) )
	}
	file.filteredGroundItems.extend( unusableItems )

	if ( !splitUnusable && sortByType && file.filteredGroundItems.len() > 1 )
	{
		int lastLootCat = -1
		for ( int i = file.filteredGroundItems.len() - 1; i >= -1; i-- )
		{
			GroundLootData gd
			int cat = -1

			if ( i >= 0 )
			{
				gd = file.filteredGroundItems[i]
				cat = GetPriorityForLootType( gd.lootData )
			}

			if ( lastLootCat != cat )
			{
				if ( lastLootCat != -1 )
				{
					file.filteredGroundItems.insert( i + 1, CreateHeaderData( GetCategoryTitleFromPriority( lastLootCat ), $"" ) )
				}

				lastLootCat = cat
			}
		}
	}
}


GroundLootData function CreateHeaderData( string title, asset icon )
{
	GroundLootData gd
	gd.isHeader = true
	LootData data
	data.pickupString = title
	data.hudIcon = icon
	gd.lootData = data
	return gd
}


bool function Survival_IsInventoryOpen()
{
	return file.backpackOpened
}


bool function Survival_IsGroundlistOpen()
{
	return file.groundlistOpened
}


void function ShowHealHint( float damage, vector damageOrigin, int damageType, int damageSourceId, entity attacker )
{
	if ( GetLocalClientPlayer() != GetLocalViewPlayer() )
		return

	UpdateHealHint( GetLocalClientPlayer() )
}


void function UpdateHealHint( entity player )
{
	const float HINT_DURATION = 5.0
	if ( ShouldShowHealHint( player ) )
	{
		if ( Time() - file.lastHealHintDisplayTime < 10.0 )
			return

		file.lastHealHintDisplayTime = Time()

		if ( CanDeployHealDrone( player ) && player.GetHealth() < player.GetMaxHealth() )
		{
			AddPlayerHint( HINT_DURATION, 0.25, $"", "#SURVIVAL_MEDIC_HEAL_HINT" )
			return
		}

		int kitType
		if ( WeaponDrivenConsumablesEnabled() )
		{
			kitType = Consumable_GetLocalViewPlayerSelectedConsumableType()
			ConsumableInfo kitInfo = Consumable_GetConsumableInfo( kitType )

			if ( Consumable_IsCurrentSelectedConsumableTypeUseful() )
			{
				AddPlayerHint( HINT_DURATION, 0.25, $"", "#SURVIVAL_HEAL_HINT_CROSSHAIR", Localize( kitInfo.lootData.pickupString ) )
			}
		}
		else
		{
			kitType = Survival_Health_GetSelectedHealthPickupType()

			if ( kitType == -1 )
				kitType = SURVIVAL_GetBestHealthPickupType( player )

			HealthPickup pickup = SURVIVAL_Loot_GetHealthKitDataFromStruct( kitType )

			AddPlayerHint( HINT_DURATION, 0.25, $"", "#SURVIVAL_HEAL_HINT_CROSSHAIR", Localize( pickup.lootData.pickupString ) )
		}
	}
	else
	{
		HidePlayerHint( "#SURVIVAL_HEAL_HINT_CROSSHAIR" )
		HidePlayerHint( "#SURVIVAL_MEDIC_HEAL_HINT" )
	}
}


bool function ShouldShowHealHint( entity player )
{
	if ( !IsAlive( player ) )
		return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	if ( GetGameState() >= eGameState.WinnerDetermined )
		return false

	float shieldHealthFrac = GetShieldHealthFrac( player )
	float healthFrac       = GetHealthFrac( player )
	if ( (!player.GetShieldHealthMax() || shieldHealthFrac > 0.25) && healthFrac > 0.5 )
		return false

	if ( WeaponDrivenConsumablesEnabled() )
	{
		int kitType = Consumable_GetLocalViewPlayerSelectedConsumableType()
		if ( kitType == -1 )
			kitType = Consumable_GetBestConsumableTypeForPlayer( player )

		if ( !Consumable_CanUseConsumable( player, kitType, false ) && !CanDeployHealDrone( player ) )
			return false

		PotentialHealData healData = Consumable_CreatePotentialHealData( player, kitType )
		if ( healData.totalAppliedHeal < 75 && (healData.totalAppliedHeal > 25 && healData.overHeal >= 100) )
			return false

		if ( player.GetPlayerNetBool( "isHealing" ) )
			return false

		return true
	}
	else
	{
		int kitType = Survival_Health_GetSelectedHealthPickupType()
		if ( kitType == -1 )
			kitType = SURVIVAL_GetBestHealthPickupType( player )

		if ( !Survival_CanUseHealthPack( player, kitType, true, false ) && !CanDeployHealDrone( player ) )
			return false

		KitHealData healData = SURVIVAL_CreateKitHealData( player, kitType )
		if ( healData.totalAppliedHeal < 75 && (healData.totalAppliedHeal > 25 && healData.overHeal >= 100) )
			return false

		if ( player.GetPlayerNetBool( "isHealing" ) )
			return false

		return true
	}

	unreachable
}


void function UseHealthPickupRefFromInventory( entity player, string ref )
{
	if ( WeaponDrivenConsumablesEnabled() )
	{
		Consumable_UseItemByRef( player, ref )
	}
	else
	{
		int itemType = SURVIVAL_Loot_GetHealthPickupTypeFromRef( ref )

		if ( !Survival_CanUseHealthPack( player, itemType ) )
			return

		Survival_UseHealthPack( player, ref )
	}
}


#if(false)
























//




#endif


void function EquipOrdnance( entity player, string ref )
{
	if ( player.IsTitan() )
		return

	if ( !IsAlive( player ) )
		return

	if ( !GamePlaying() )
		return

	if ( Bleedout_IsBleedingOut( player ) )
		return

	player.ClientCommand( "Sur_EquipOrdnance " + ref )

	ServerCallback_ClearHints()
}


void function EquipAttachment( entity player, string item, string weaponName )
{
	if ( player.IsTitan() )
		return

	if ( !IsAlive( player ) )
		return

	if ( !GamePlaying() )
		return

	if ( player.ContextAction_IsActive() && !player.ContextAction_IsRodeo() )
		return

	if ( Bleedout_IsBleedingOut( player ) )
		return

	//
	//
	//
	player.ClientCommand( "Sur_EquipAttachment " + item )
	//

	ServerCallback_ClearHints()
}


entity function GetBaseWeaponEntForEquipmentSlot( string equipmentSlot )
{
	int slot = EquipmentSlot_GetWeaponSlotForEquipmentSlot( equipmentSlot )

	if ( slot >= 0 )
		return GetLocalClientPlayer().GetNormalWeapon( slot )

	return null
}


entity function Survival_GetDeathBox()
{
	return file.currentGroundListData.deathBox
}


int function Survival_GetGroundListBehavior()
{
	return file.currentGroundListData.behavior
}


array<entity> function Survival_GetDeathBoxItems()
{
	if ( !IsValid( file.currentGroundListData.deathBox ) || file.currentGroundListData.behavior == eGroundListBehavior.NEARBY )
		return []

	return file.currentGroundListData.deathBox.GetLinkEntArray()
}


void function TryCloseSurvivalInventoryFromDamage( float damage, vector damageOrigin, int damageType, int damageSourceId, entity attacker )
{
	if ( GetLocalClientPlayer() == GetLocalViewPlayer() )
	{
		if ( IsValid( attacker ) && (attacker.IsNPC() || attacker.IsPlayer()) )
			RunUIScript( "TryCloseSurvivalInventoryFromDamage", null )
	}
}


entity function GetEntFromGroundLootData( GroundLootData groundLootData )
{
	entity ent
	for ( int i = 0; i < groundLootData.guids.len() && !IsValid( ent ); i++ )
	{
		ent = GetEntityFromEncodedEHandle( groundLootData.guids[i] )
	}
	return ent
}


void function UICallback_GetLootDataFromButton( var button, int position )
{
	RunUIScript( "ClientCallback_SetTempButtonRef", "" )

	entity player = GetLocalClientPlayer()
	string ref

	if ( position > -1 )
	{
		if ( position >= SURVIVAL_GetInventoryLimit( player ) )
			return

		array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
		if ( playerInventory.len() <= position )
			return

		ConsumableInventoryItem item = playerInventory[ position ]
		LootData lootData            = SURVIVAL_Loot_GetLootDataByIndex( item.type )

		ref = lootData.ref
	}
	else
	{
		string equipmentSlot = Hud_GetScriptID( button )

		LootData data = EquipmentSlot_GetEquippedLootDataForSlot( player, equipmentSlot )

		ref = data.ref
	}

	RunUIScript( "ClientCallback_SetTempButtonRef", ref )
}


void function UICallback_GetMouseDragAllowedFromButton( var button, int position )
{
	entity player = GetLocalClientPlayer()
	bool allowed  = true

	if ( position > -1 )
	{
		if ( position >= SURVIVAL_GetInventoryLimit( player ) )
		{
			allowed = false
		}
		else
		{
			array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
			if ( playerInventory.len() <= position )
				allowed = false
		}
	}
	else
	{
		string equipmentSlot = Hud_GetScriptID( button )
		if ( EquipmentSlot_IsAttachmentSlot( equipmentSlot ) )
		{
			EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipmentSlot )
			EquipmentSlot ws = Survival_GetEquipmentSlotDataByRef( es.attachmentWeaponSlot )

			LootData wData = EquipmentSlot_GetEquippedLootDataForSlot( player, ws.ref )
			if ( !SURVIVAL_Loot_IsRefValid( wData.ref ) || SURVIVAL_Weapon_IsAttachmentLocked( wData.ref ) )
			{
				allowed = false
			}
		}
	}

	RunUIScript( "ClientCallback_SetTempBoolMouseDragAllowed", allowed )
}

//
void function UICallback_OnInventoryMouseDrop( var dropButton, var sourcePanel, var sourceButton, int sourceIndex, bool initOnly )
{
	if ( initOnly )
		Hud_SetLocked( dropButton, false )

	string sourceEquipmentSlot
	if ( sourceIndex > -1 )
		sourceEquipmentSlot = "inventory"
	else
		sourceEquipmentSlot = Hud_GetScriptID( sourceButton )

	string dropEquipmentSlot = Hud_GetScriptID( dropButton )

	string sourceEquipmentWeaponSlot

	if ( EquipmentSlot_IsValidEquipmentSlot( sourceEquipmentSlot ) )
	{
		if ( EquipmentSlot_IsAttachmentSlot( sourceEquipmentSlot ) )
		{
			EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( sourceEquipmentSlot )
			sourceEquipmentWeaponSlot = es.attachmentWeaponSlot
		}
	}

	//
	if ( dropEquipmentSlot == sourceEquipmentSlot || dropEquipmentSlot == sourceEquipmentWeaponSlot )
		return

	if ( initOnly )
		Hud_SetLocked( dropButton, true )

	entity player = GetLocalClientPlayer()
	LootData data

	if ( sourceIndex > -1 )
	{
		if ( sourceIndex >= SURVIVAL_GetInventoryLimit( player ) )
			return

		array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )
		if ( playerInventory.len() <= sourceIndex )
			return

		ConsumableInventoryItem item = playerInventory[ sourceIndex ]
		data = SURVIVAL_Loot_GetLootDataByIndex( item.type )
	}
	else
	{
		string equipmentSlot = Hud_GetScriptID( sourceButton )

		data = EquipmentSlot_GetEquippedLootDataForSlot( player, equipmentSlot )
	}

	//
	if ( EquipmentSlot_IsValidEquipmentSlot( dropEquipmentSlot ) )
	{
		if ( EquipmentSlot_IsMainWeaponSlot( dropEquipmentSlot ) )
		{
			LootData dropSlotData = EquipmentSlot_GetEquippedLootDataForSlot( player, dropEquipmentSlot )
			EquipmentSlot es      = Survival_GetEquipmentSlotDataByRef( dropEquipmentSlot )

			if ( data.lootType == eLootType.ATTACHMENT )
			{
				if ( EquipmentSlot_IsValidEquipmentSlot( sourceEquipmentSlot ) )
				{
					if ( EquipmentSlot_IsAttachmentSlot( sourceEquipmentSlot ) )
					{
						if ( CanAttachToWeapon( data.ref, dropSlotData.ref ) )
						{
							if ( initOnly )
								Hud_SetLocked( dropButton, false )
							else
								EquipmentAction( eLootAction.WEAPON_TRANSFER, sourceEquipmentSlot )
						}
					}
				}
				else if ( sourceEquipmentSlot == "inventory" )
				{
					if ( CanAttachToWeapon( data.ref, dropSlotData.ref ) )
					{
						if ( initOnly )
							Hud_SetLocked( dropButton, false )
						else
							player.ClientCommand( "Sur_EquipAttachment " + data.ref + " " + es.weaponSlot )
					}
				}
			}
			else if ( EquipmentSlot_IsValidEquipmentSlot( sourceEquipmentSlot ) )
			{
				if ( EquipmentSlot_IsMainWeaponSlot( sourceEquipmentSlot ) )
				{
					if ( initOnly )
						Hud_SetLocked( dropButton, false )
					else
						player.ClientCommand( "Sur_SwapPrimaryPositions" )
				}
			}
		}
	}
	else if ( dropEquipmentSlot == "inventory" )
	{
		if ( EquipmentSlot_IsAttachmentSlot( sourceEquipmentSlot ) )
		{
			if ( SURVIVAL_AddToPlayerInventory( player, data.ref ) > 0 )
			{
				if ( initOnly )
					Hud_SetLocked( dropButton, false )
				else
					EquipmentAction( eLootAction.REMOVE, sourceEquipmentSlot )
			}
		}
	}
	else if ( dropEquipmentSlot == "ground" )
	{
		if ( EquipmentSlot_IsValidEquipmentSlot( sourceEquipmentSlot ) )
		{
			if ( initOnly )
				Hud_SetLocked( dropButton, false )
			else if ( !EquipmentSlot_IsAttachmentSlot( sourceEquipmentSlot ) )
				EquipmentAction( eLootAction.DROP, sourceEquipmentSlot )
			else
				EquipmentAction( eLootAction.REMOVE_TO_GROUND, sourceEquipmentSlot )
		}
		else if ( sourceEquipmentSlot == "inventory" )
		{
			if ( initOnly )
				Hud_SetLocked( dropButton, false )
			else
				BackpackAction( eLootAction.DROP_ALL, string( sourceIndex ) )
		}
	}
}


void function UICallback_WeaponSwap()
{
	entity player = GetLocalViewPlayer()

	if ( player != GetLocalClientPlayer() )
		return

	thread WeaponSwap( player )
}


void function WeaponSwap( entity player )
{
	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )

	player.ClientCommand( "invnext" )
}


void function TryUpdateGroundList( entity player, LootData data, int lootAction )
{
	if ( file.groundlistOpened )
		GroundListUpdateNextFrame()
}


void function GroundListUpdateNextFrame()
{
	file.shouldResetGroundItems = true
}


void function UICallback_UpdatePlayerInfo( var elem )
{
	var rui = Hud_GetRui( elem )

	entity player = GetLocalClientPlayer()

	if ( GetBugReproNum() == 54268 )
		SURVIVAL_PopulatePlayerInfoRui( player, rui )
	else
		thread TEMP_UpdatePlayerRui( rui, player )
}


void function UICallback_UpdateTeammateInfo( var elem )
{
	var rui           = Hud_GetRui( elem )
	int teammateIndex = int( Hud_GetScriptID( elem ) )

	entity player = GetLocalClientPlayer()

	array<entity> team = GetPlayerArrayOfTeam( player.GetTeam() )
	team.fastremovebyvalue( player )

	#if(true)
		//
		if ( IsFallLTM() )
			team.clear()
	#endif

	if ( teammateIndex < team.len() )
	{
		Hud_SetHeight( elem, Hud_GetBaseHeight( elem ) )
		Hud_Show( elem )
	}
	else
	{
		Hud_SetHeight( elem, 0 )
		Hud_Hide( elem )
		return
	}

	entity ent = team[teammateIndex]

	if ( GetBugReproNum() == 54268 )
		thread SetUnitFrameDataFromOwner( rui, ent )
	else
		thread TEMP_UpdateTeammateRui( rui, ent )
}


void function UICallback_UpdateUltimateInfo( var elem )
{
	var rui = Hud_GetRui( elem )

	entity player = GetLocalClientPlayer()

	thread TEMP_UpdateUltimateInfo( rui, player )
}


void function TEMP_UpdateUltimateInfo( var rui, entity player )
{
	player.EndSignal( "OnDestroy" )
	clGlobal.levelEnt.EndSignal( "BackpackClosed" )

	int slot = OFFHAND_INVENTORY

	float PROTO_storedAmmoRegenRate = -1.0

	while ( 1 )
	{
		if ( IsAlive( player ) )
		{
			entity weapon = player.GetOffhandWeapon( slot )
			if ( IsValid( weapon ) )
			{
				thread UpdateInventoryUltimateRui( rui, player, weapon )
			}

			if ( IsValid( weapon ) )
			{
				float currentAmmoRegenRate = weapon.GetWeaponSettingFloat( eWeaponVar.regen_ammo_refill_rate )
				if ( currentAmmoRegenRate != PROTO_storedAmmoRegenRate )
				{
					RuiSetFloat( rui, "refillRate", currentAmmoRegenRate )
					PROTO_storedAmmoRegenRate = currentAmmoRegenRate
				}
			}
		}
		WaitFrame()
	}
}


void function UpdateInventoryUltimateRui( var rui, entity player, entity weapon )
{
	//
	Assert ( IsNewThread(), "Must be threaded off." )

	RuiSetGameTime( rui, "hintTime", Time() )

	RuiSetBool( rui, "isTitan", player.IsTitan() )
	RuiSetBool( rui, "isReverseCharge", false )
	bool isPaused = weapon.HasMod( "survival_ammo_regen_paused" )
	RuiSetBool( rui, "isPaused", isPaused )

	RuiSetFloat( rui, "chargeFrac", 0.0 )
	RuiSetFloat( rui, "useFrac", 0.0 )
	RuiSetFloat( rui, "chargeMaxFrac", 1.0 )
	RuiSetFloat( rui, "minFireFrac", 1.0 )
	RuiSetInt( rui, "segments", 1 )
	RuiSetFloat( rui, "refillRate", 1 ) //

	RuiSetImage( rui, "hudIcon", weapon.GetWeaponSettingAsset( eWeaponVar.hud_icon ) )

	RuiSetFloat( rui, "readyFrac", weapon.GetWeaponReadyToFireProgress() )
	//

	RuiSetFloat( rui, "chargeFracCaution", 0.0 )
	RuiSetFloat( rui, "chargeFracAlert", 0.0 )
	RuiSetFloat( rui, "chargeFracAlertSpeed", 16.0 )
	RuiSetFloat( rui, "chargeFracAlertScale", 1.0 )

	RuiSetInt( rui, "ammoMinToFire", weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire ) )

	ItemFlavor character                    = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
	CharacterHudUltimateColorData colorData = CharacterClass_GetHudUltimateColorData( character )

	RuiSetColorAlpha( rui, "ultimateColor", SrgbToLinear( colorData.ultimateColor ), 1 )
	RuiSetColorAlpha( rui, "ultimateColorHighlight", SrgbToLinear( colorData.ultimateColorHighlight ), 1 )

	switch ( weapon.GetWeaponSettingEnum( eWeaponVar.cooldown_type, eWeaponCooldownType ) )
	{
		case eWeaponCooldownType.ammo_timed:
		case eWeaponCooldownType.ammo_instant:
		case eWeaponCooldownType.ammo_deployed:
			RuiSetFloat( rui, "readyFrac", 0.0 )

		case eWeaponCooldownType.ammo:
			int maxAmmoReady = weapon.UsesClipsForAmmo() ? weapon.GetWeaponSettingInt( eWeaponVar.ammo_clip_size ) : weapon.GetWeaponPrimaryAmmoCountMax( weapon.GetActiveAmmoSource() )
			int ammoPerShot = weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
			int ammoMinToFire = weapon.GetWeaponSettingInt( eWeaponVar.ammo_min_to_fire )

			if ( maxAmmoReady == 0 )
				maxAmmoReady = 1
			RuiSetFloat( rui, "minFireFrac", float( ammoMinToFire ) / float( maxAmmoReady ) )
			if ( ammoPerShot == 0 )
				ammoPerShot = 1
			RuiSetInt( rui, "segments", maxAmmoReady / ammoPerShot )

			RuiSetFloat( rui, "chargeFrac", float( weapon.GetWeaponPrimaryClipCount() ) / float( weapon.GetWeaponPrimaryClipCountMax() ) )

			RuiSetFloat( rui, "useFrac", StatusEffect_GetSeverity( weapon, eStatusEffect.simple_timer ) )
			break

		case eWeaponCooldownType.vortex_drain:
			RuiSetBool( rui, "isReverseCharge", true )
			RuiSetFloat( rui, "chargeFrac", 1.0 )
			RuiSetFloat( rui, "readyFrac", 0.0 )
			RuiSetFloat( rui, "minFireFrac", 0.0 )

			RuiSetFloat( rui, "chargeFrac", weapon.GetWeaponChargeFraction() )
			break

		default:
			Assert( false, "Unsupported cooldown_type: " + weapon.GetWeaponSettingEnum( eWeaponVar.cooldown_type, eWeaponCooldownType ) )
	}
}


void function TEMP_UpdatePlayerRui( var rui, entity player )
{
	player.EndSignal( "OnDestroy" )
	clGlobal.levelEnt.EndSignal( "BackpackClosed" )

	ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_CharacterClass() )
	asset classIcon      = CharacterClass_GetGalleryPortrait( character )
	RuiSetImage( rui, "playerIcon", classIcon )

	RuiSetInt( rui, "micStatus", player.HasMic() ? 3 : -1 ) //

	while ( 1 )
	{
		foreach ( equipSlot, es in EquipmentSlot_GetAllEquipmentSlots() )
		{
			if ( es.trackingNetInt != "" )
			{
				LootData data = EquipmentSlot_GetEquippedLootDataForSlot( player, equipSlot )
				int tier      = data.tier
				asset hudIcon = data.hudIcon

				#if(false)






#endif

				RuiSetInt( rui, es.unitFrameTierVar, tier )
				RuiSetImage( rui, es.unitFrameImageVar, hudIcon )
			}
		}

		RuiSetString( rui, "name", player.GetPlayerName() )
		RuiSetFloat( rui, "playerHealthFrac", GetHealthFrac( player ) )
		RuiSetFloat( rui, "playerShieldFrac", GetShieldHealthFrac( player ) )
		RuiSetInt( rui, "teamMemberIndex", player.GetTeamMemberIndex() )
		#if(false)

#endif //

		vector shieldFrac = < SURVIVAL_GetArmorShieldCapacity( 0 ) / 100.0,
				SURVIVAL_GetArmorShieldCapacity( 1 ) / 100.0,
				SURVIVAL_GetArmorShieldCapacity( 2 ) / 100.0 >

		RuiSetColorAlpha( rui, "shieldFrac", shieldFrac, float( SURVIVAL_GetArmorShieldCapacity( 3 ) ) )

		RuiSetFloat( rui, "playerTargetShieldFrac", StatusEffect_GetSeverity( player, eStatusEffect.target_shields ) )
		RuiSetFloat( rui, "playerTargetHealthFrac", StatusEffect_GetSeverity( player, eStatusEffect.target_health ) )
		RuiSetFloat( rui, "cameraViewFrac", StatusEffect_GetSeverity( player, eStatusEffect.camera_view ) )

		//
		OverwriteWithCustomPlayerInfoTreatment( player, rui )

		WaitFrame()
	}
}


void function TEMP_UpdateTeammateRui( var rui, entity ent )
{
	ent.EndSignal( "OnDestroy" )
	clGlobal.levelEnt.EndSignal( "BackpackClosed" )

	ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( ent ), Loadout_CharacterClass() )
	asset classIcon      = CharacterClass_GetGalleryPortrait( character )
	RuiSetImage( rui, "icon", classIcon )

	RuiSetInt( rui, "micStatus", ent.HasMic() ? 3 : -1 ) //

	bool weaponDrivenConsumables = WeaponDrivenConsumablesEnabled()

	while ( 1 )
	{
		foreach ( equipSlot, es in EquipmentSlot_GetAllEquipmentSlots() )
		{
			if ( es.trackingNetInt != "" )
			{
				LootData data = EquipmentSlot_GetEquippedLootDataForSlot( ent, equipSlot )
				int tier      = data.tier
				asset hudIcon = tier > 0 ? data.hudIcon : es.emptyImage

				RuiSetInt( rui, es.unitFrameTierVar, tier )
				RuiSetImage( rui, es.unitFrameImageVar, hudIcon )
			}
		}

		RuiSetString( rui, "name", ent.GetPlayerName() )
		RuiSetFloat( rui, "healthFrac", GetHealthFrac( ent ) )
		RuiSetFloat( rui, "shieldFrac", GetShieldHealthFrac( ent ) )
		RuiSetFloat( rui, "targetHealthFrac", StatusEffect_GetSeverity( ent, eStatusEffect.target_health ) )
		RuiSetFloat( rui, "targetShieldFrac", StatusEffect_GetSeverity( ent, eStatusEffect.target_shields ) )
		RuiSetFloat( rui, "cameraViewFrac", StatusEffect_GetSeverity( ent, eStatusEffect.camera_view ) )
		RuiSetInt( rui, "teamMemberIndex", ent.GetTeamMemberIndex() )
		#if(false)

#endif //

		asset hudIcon = $""
		int kitType   = ent.GetPlayerNetInt( "healingKitTypeCurrentlyBeingUsed" )
		if ( kitType != -1 )
		{
			if ( weaponDrivenConsumables )
			{
				ConsumableInfo info = Consumable_GetConsumableInfo( kitType )
				LootData lootData   = info.lootData
				hudIcon = lootData.hudIcon
			}
			else
			{
				HealthPickup kitData = SURVIVAL_Loot_GetHealthKitDataFromStruct( kitType )
				LootData lootData    = kitData.lootData
				hudIcon = lootData.hudIcon
			}
		}
		RuiSetImage( rui, "healTypeIcon", hudIcon )
		RuiSetBool( rui, "consumablePanelVisible", hudIcon != $"" )


		RuiSetFloat( rui, "reviveEndTime", ent.GetPlayerNetTime( "reviveEndTime" ) )
		RuiSetInt( rui, "reviveType", ent.GetPlayerNetInt( "reviveType" ) )
		RuiSetFloat( rui, "bleedoutEndTime", ent.GetPlayerNetTime( "bleedoutEndTime" ) )
		RuiSetInt( rui, "respawnStatus", ent.GetPlayerNetInt( "respawnStatus" ) )

		SetUnitFrameAmmoTypeIcons( rui, ent )

		WaitFrame()
	}
}


void function SetUnitFrameAmmoTypeIcons( var rui, entity player )
{
	for ( int i = 0; i < 2; i++ )
	{
		string ammoTypeIconBool = "showAmmoIcon0" + string( i )
		string ammoTypeIcon = "ammoTypeIcon0" + string( i )

		asset hudIcon = $"white"

		entity weapon = player.GetNormalWeapon( i )
		if ( !IsValid( weapon ) )
		{
			hudIcon = $"white"

			RuiSetBool( rui, ammoTypeIconBool, false )
			RuiSetImage( rui, ammoTypeIcon, hudIcon )
		}
		else
		{
			string weaponRef    = weapon.GetWeaponClassName()
			LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( weaponRef )
			string ammoType     = weaponData.ammoType
			if ( ammoType != "" )
			{
				LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoType )
				hudIcon = ammoData.hudIcon
			}
			else
				hudIcon = weaponData.fakeAmmoIcon

			RuiSetImage( rui, ammoTypeIcon, hudIcon )
			RuiSetBool( rui, ammoTypeIconBool, true )
		}
	}
}


void function UICallback_BlockPingForDuration( float duration )
{
	AddPingBlockingFunction( "ping", PingBlocker_DoNothing, 0.5, "" )
}


void function PingBlocker_DoNothing( entity player )
{

}


int function GetCountForLootType( int lootType )
{
	entity player                       = GetLocalViewPlayer()
	table<string, LootData> allLootData = SURVIVAL_Loot_GetLootDataTable()

	int typeCount = 0

	foreach ( data in allLootData )
	{
		if ( !IsLootTypeValid( data.lootType ) )
			continue

		if ( data.lootType != lootType )
			continue

		if ( SURVIVAL_CountItemsInInventory( player, data.ref ) == 0 )
			continue

		typeCount++
	}

	return typeCount
}