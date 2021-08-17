global function Sh_Loot_Vault_Panel_Init

global function SetVaultPanelMinimapObj
global function GetVaultPanelMinimapObj
global function SetVaultPanelOpenMinimapObj
global function GetVaultPanelOpenMinimapObj
global function VaultPanel_GetBestMinimapObjs
global function VaultPanel_GetAllMinimapObjs

global function HACK_IsVaultDoor
global function IsValidLootVaultDoorEnt
global function IsVaultPanel
global function GetVaultPanelFromDoor

global function VaultPanel_GetTeammateWithKey

global const string LOOT_VAULT_PANEL_SCRIPTNAME = "LootVaultPanel"
global const string LOOT_VAULT_DOOR_SCRIPTNAME = "LootVaultDoor"
global const string LOOT_VAULT_DOOR_SCRIPTNAME_RIGHT = "LootVaultDoorRight"

global const string LOOT_VAULT_AUDIO_OPEN = "LootVault_Open"
global const string LOOT_VAULT_AUDIO_ACCESS = "lootVault_Access"
global const string LOOT_VAULT_AUDIO_STATUSBAR = "LootVault_StatusBar"

enum ePanelState
{
	LOCKED,
	UNLOCKING,
	UNLOCKED
}

struct LootVaultPanelData
{
	entity panel
	int panelState = ePanelState.LOCKED

	array<entity> vaultDoors
	#if SERVER

	#endif // SERVER

	entity minimapObj
	entity openMinimapObj
}

struct
{
	array< LootVaultPanelData > vaultControlPanels
	array< void functionref( LootVaultPanelData, int ) > vaultPanelUnlockingStateCallbacks
	array< void functionref( LootVaultPanelData, int ) > vaultPanelUnlockedStateCallbacks

	array< entity > vaultDoors
	entity textPanel
} file

void function Sh_Loot_Vault_Panel_Init()
{

	#if SERVER
	AddSpawnCallback( "prop_dynamic", VaultPanelSpawned )
	AddSpawnCallback( "prop_door", VaultDoorSpawned)
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
	#endif // SERVER

	#if CLIENT
	AddCreateCallback( "prop_dynamic", VaultPanelSpawned )
	AddCreateCallback( "prop_door", VaultDoorSpawned )
	#endif // CLIENT


	LootVaultPanels_AddCallback_OnVaultPanelStateChangedToUnlocking( VaultPanelUnlocking )
	LootVaultPanels_AddCallback_OnVaultPanelStateChangedToUnlocked( VaultPanelUnlocked )
}


void function VaultPanelSpawned( entity panel )
{
	if ( !IsValidLootVaultPanelEnt( panel ) )
		return

	LootVaultPanelData newPanel
	newPanel.panel = panel

	#if SERVER
	
	#endif // SERVER

	file.vaultControlPanels.append( newPanel )
//	SetVaultPanelState(panel, ePanelState.UNLOCKED)

	SetVaultPanelUsable( panel )
}

void function VaultDoorSpawned( entity door )
{
	if ( !IsValidLootVaultDoorEnt( door ) )
		return

	#if SERVER

	door.SetSkin( 1 )
	door.UnsetUsable()

	#endif // SERVER
	
	SetObjectCanBeMeleed( door, false )
	door.SetTakeDamageType( DAMAGE_NO )

	door.kv.IsVaultDoor = true

	if ( !file.vaultDoors.contains( door ) )
		file.vaultDoors.append( door )
}

const float PANEL_TO_DOOR_RADIUS = 150.0
void function EntitiesDidLoad()
{
	foreach( panelData in file.vaultControlPanels )
	{		
		vector panelPos = panelData.panel.GetOrigin()

		foreach ( door in file.vaultDoors )
		{
			vector doorPos = door.GetOrigin()

			if ( Distance( panelPos, doorPos ) <= PANEL_TO_DOOR_RADIUS )
			{
				if ( !panelData.vaultDoors.contains( door ) )
				{
					panelData.vaultDoors.append( door )
				}
			}
		}
	}
}

void function SetVaultPanelState( entity panel, int panelState )
{
	LootVaultPanelData panelData = GetVaultPanelDataFromEntity( panel )

	if ( panelState == panelData.panelState )
		return

	printf( "LootVaultPanelDebug: Changing panel state from %i to %i.", panelData.panelState, panelState )

	panelData.panelState = panelState

	switch ( panelState )
	{
		case ePanelState.LOCKED:
			return
		case ePanelState.UNLOCKING:
		{
			printf( "LootVaultPanelDebug: Changing panel state to UNLOCKING" )
			LootVaultPanelState_Unlocking( panelData, panelState )
		}
		case ePanelState.UNLOCKED:
		{
			printf( "LootVaultPanelDebug: Changing panel state to UNLOCKED" )
			LootVaultPanelState_Unlocked( panelData, panelState )
		}
		default:
			return
	}
}

void function LootVaultPanels_AddCallback_OnVaultPanelStateChangedToUnlocking( void functionref( LootVaultPanelData, int ) callbackFunc )
{
	Assert( !file.vaultPanelUnlockingStateCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with LootVaultPanels_AddCallback_OnVaultPanelStateChanged" )
	file.vaultPanelUnlockingStateCallbacks.append( callbackFunc )
}

void function LootVaultPanelState_Unlocking( LootVaultPanelData panelData, int panelState )
{
	foreach ( func in file.vaultPanelUnlockingStateCallbacks )
		func( panelData, panelData.panelState  )
}

void function LootVaultPanels_AddCallback_OnVaultPanelStateChangedToUnlocked( void functionref( LootVaultPanelData, int ) callbackFunc )
{
	Assert( !file.vaultPanelUnlockedStateCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with LootVaultPanels_AddCallback_OnVaultPanelStateChanged" )
	file.vaultPanelUnlockedStateCallbacks.append( callbackFunc )
}

void function LootVaultPanelState_Unlocked( LootVaultPanelData panelData, int panelState )
{
	foreach ( func in file.vaultPanelUnlockedStateCallbacks )
		func( panelData, panelData.panelState  )
}

const int VAULTPANEL_MAX_VIEW_ANGLE_TO_AXIS = 60
bool function LootVaultPanel_CanUseFunction( entity playerUser, entity panel )
{
	if ( Bleedout_IsBleedingOut( playerUser ) )
		return false

	if ( playerUser.ContextAction_IsActive() )
		return false

	entity activeWeapon = playerUser.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( IsValid( activeWeapon ) && activeWeapon.IsWeaponOffhand() )
		return false

	if ( panel.e.isBusy )
		return false

	if ( GetVaultPanelDataFromEntity( panel ).panelState != ePanelState.LOCKED )
		return false

	return true
}

const float VAULT_PANEL_USE_TIME = 3.0
void function OnVaultPanelUse( entity panel, entity playerUser, int useInputFlags )
{	
	if ( !(useInputFlags & USE_INPUT_LONG) )
		return

	// TODO: Fix vault key
	
//	if ( !playerUser.GetPlayerNetBool( "hasDataKnife" ) )
	if ( !VaultPanel_HasPlayerDataKnife(playerUser) )
			return

	ExtendedUseSettings settings

	settings.duration = VAULT_PANEL_USE_TIME
	settings.useInputFlag = IN_USE_LONG
	settings.successSound = LOOT_VAULT_AUDIO_ACCESS
	settings.successFunc = VaultPanelUseSuccess

	#if CLIENT
	settings.loopSound = LOOT_VAULT_AUDIO_STATUSBAR
	settings.displayRuiFunc = DisplayRuiForLootVaultPanel
	settings.displayRui = $"ui/health_use_progress.rpak"
	settings.icon = $"rui/hud/gametype_icons/survival/data_knife"
	settings.hint = "#HINT_VAULT_UNLOCKING"

	//
	#endif // CLIENT

	#if SERVER



	#endif // SERVER

	thread ExtendedUse( panel, playerUser, settings )
}

void function VaultPanelUseSuccess( entity panel, entity player, ExtendedUseSettings settings )
{
	if ( !VaultPanel_HasPlayerDataKnife(player) )
	{
		printf( "LootVaultPanelDebug: Player likely dropped the vault key while opening" )
		return
	}
	
	LootVaultPanelData panelData = GetVaultPanelDataFromEntity( panel )

	printf( "LootVaultPanelDebug: Panel Use Success" )

	#if SERVER

	// TODO: proper anims

	foreach( entity door in GetVaultPanelDataFromEntity( panel ).vaultDoors)
	{
		door.Dissolve( ENTITY_DISSOLVE_CORE, <0,0,0>, 1000 )
	}
	
	panel.SetSkin(0)
	panel.Dissolve( ENTITY_DISSOLVE_CORE, <0,0,0>, 1000 )

	PlayBattleChatterLineToSpeakerAndTeam( player, "bc_vaultOpened" )
	
	SURVIVAL_RemoveFromPlayerInventory( player, "data_knife", 1 )

	#endif

	if ( panelData.panelState != ePanelState.UNLOCKING )
		SetVaultPanelState( panel, ePanelState.UNLOCKING )
}

void function VaultPanelUnlocking( LootVaultPanelData panelData, int panelState )
{
	if ( panelState != ePanelState.UNLOCKING )
		return

	printf( "LootVaultPanelDebug: Panel State: Unlocking" )

	SetVaultPanelUnusable( panelData.panel )

	#if SERVER

	#endif // SERVER

	thread HideVaultPanel( panelData )
}

void function VaultPanelUnlocked( LootVaultPanelData panelData, int panelState )
{
	if ( panelState != ePanelState.UNLOCKED )
	{
		return
	}

	printf( "LootVaultPanelDebug: Panel State: Unlocked" )

	#if SERVER
















	#endif // SERVER
}

#if SERVER





































#endif // SERVER

void function HideVaultPanel( LootVaultPanelData panelData )
{
	entity panel = panelData.panel

	#if SERVER

	#endif // SERVER

	wait 2.0

	SetVaultPanelState( panelData.panel, ePanelState.UNLOCKED )
}

#if CLIENT
string function VaultPanel_TextOverride( entity panel )
{
//	if ( !GetLocalViewPlayer().GetPlayerNetBool( "hasDataKnife" ) )
	if ( !VaultPanel_HasPlayerDataKnife(GetLocalViewPlayer()) )
		return "#HINT_VAULT_NEED"
	return "#HINT_VAULT_USE"
}

void function DisplayRuiForLootVaultPanel( entity ent, entity player, var rui, ExtendedUseSettings settings )
{
	DisplayRuiForLootVaultPanel_Internal( rui, settings.icon, Time(), Time() + settings.duration, settings.hint )
}

void function DisplayRuiForLootVaultPanel_Internal( var rui, asset icon, float startTime, float endTime, string hint )
{
	RuiSetBool( rui, "isVisible", true )
	RuiSetImage( rui, "icon", icon )
	RuiSetGameTime( rui, "startTime", startTime )
	RuiSetGameTime( rui, "endTime", endTime )
	RuiSetString( rui, "hintKeyboardMouse", hint )
	RuiSetString( rui, "hintController", hint )
}
#endif // CLIENT

LootVaultPanelData function GetVaultPanelDataFromEntity( entity panel )
{
	foreach( panelData in file.vaultControlPanels )
	{
		if ( panelData.panel == panel )
			return panelData
	}

	Assert( false, "Invalid Loot Vault Panel ( " + string( panel ) + " )." )

	unreachable
}

bool function IsValidLootVaultPanelEnt( entity ent )
{
	if ( ent.GetScriptName() == LOOT_VAULT_PANEL_SCRIPTNAME )
		return true

	return false
}

bool function IsValidLootVaultDoorEnt( entity ent )
{
	if ( !IsDoor( ent ) )
		return false

	string scriptName = ent.GetScriptName()
	if ( scriptName != LOOT_VAULT_DOOR_SCRIPTNAME && scriptName != LOOT_VAULT_DOOR_SCRIPTNAME_RIGHT )
		return false

	return true
}

void function SetVaultPanelUsable( entity panel )
{
	#if SERVER
	
	panel.SetSkin(1) // red
	
	panel.SetUsable()
	panel.SetUsableByGroup( "pilot" )
	panel.AddUsableValue( VAULTPANEL_MAX_VIEW_ANGLE_TO_AXIS )
	panel.SetUsableValue( USABLE_BY_ALL | USABLE_CUSTOM_HINTS )
	
	#endif // SERVER

	SetCallback_CanUseEntityCallback( panel, LootVaultPanel_CanUseFunction )
	AddCallback_OnUseEntity( panel, OnVaultPanelUse )

	#if CLIENT
	AddEntityCallback_GetUseEntOverrideText( panel, VaultPanel_TextOverride )
	#endif // CLIENT
}

void function SetVaultPanelUnusable( entity panel )
{
	#if SERVER
	SetVaultPanelState( panel, ePanelState.LOCKED )
	#endif // SERVER
}

void function SetVaultPanelMinimapObj( entity panel, entity minimapObj )
{
	LootVaultPanelData panelData = GetVaultPanelDataFromEntity( panel )

	panelData.minimapObj = minimapObj
}

void function SetVaultPanelOpenMinimapObj( entity panel, entity minimapObj )
{
	LootVaultPanelData panelData = GetVaultPanelDataFromEntity( panel )

	panelData.openMinimapObj = minimapObj
}

entity function GetVaultPanelMinimapObj( entity panel )
{
	LootVaultPanelData panelData = GetVaultPanelDataFromEntity( panel )

	return panelData.minimapObj
}

entity function GetVaultPanelOpenMinimapObj( entity panel )
{
	LootVaultPanelData panelData = GetVaultPanelDataFromEntity( panel )

	return panelData.openMinimapObj
}

entity function GetBestVaultPanelMinimapObj( entity panel )
{
	LootVaultPanelData panelData = GetVaultPanelDataFromEntity( panel )

	if( panelData.panelState == ePanelState.UNLOCKED )
		return panelData.openMinimapObj

	return panelData.minimapObj
}

#if SERVER







#endif

//
bool function HACK_IsVaultDoor( entity ent )
{
	if ( !IsValid( ent ) )
		return false

	if ( !IsDoor( ent ) )
		return false
	
	if ( ent.GetSkin() == 1 )
		return true

	return false
}

bool function IsVaultPanel( entity ent )
{
	foreach ( panelData in file.vaultControlPanels )
	{
		if ( panelData.panel == ent )
			return true
	}

	return false
}

entity function GetVaultPanelFromDoor( entity door )
{
	foreach ( panelData in file.vaultControlPanels )
	{
		if ( !IsValid( panelData.panel ) )
			return null

		#if SERVER





		#endif

		#if CLIENT
		vector panelPos = panelData.panel.GetOrigin()
		vector doorPos = door.GetOrigin()

		if ( Distance( panelPos, doorPos ) <= PANEL_TO_DOOR_RADIUS )
			return panelData.panel
		#endif
	}

	return null
}

entity function VaultPanel_GetTeammateWithKey( int teamIdx )
{
	array< entity > squad = GetPlayerArrayOfTeam( teamIdx )

	foreach( player in squad )
	{
	//	if ( player.GetPlayerNetBool( "hasDataKnife" ) )
		if ( VaultPanel_HasPlayerDataKnife(player)  )
			return player
	}

	return null
}

array< entity > function VaultPanel_GetBestMinimapObjs()
{
	array<entity> mapObjs
	foreach ( data in file.vaultControlPanels )
	{
		entity minimapObj
		if ( data.panelState == ePanelState.LOCKED )
			minimapObj = data.minimapObj
		else
			minimapObj = data.openMinimapObj

		if ( IsValid( minimapObj ) )
			mapObjs.append( minimapObj )
	}

	return mapObjs
}

array< entity > function VaultPanel_GetAllMinimapObjs()
{
	array<entity> mapObjs
	foreach ( data in file.vaultControlPanels )
	{
		mapObjs.append( data.minimapObj )
		mapObjs.append( data.openMinimapObj )
	}

	return mapObjs
}

bool function VaultPanel_HasPlayerDataKnife(entity player)
{
	array<ConsumableInventoryItem> playerInventory = SURVIVAL_GetPlayerInventory( player )

	foreach ( invItem in playerInventory )
	{
		if(invItem.type == 120) // no clue what its const is called, 120 == dataknife/vaultkey
			return true
	}
	return false
}
