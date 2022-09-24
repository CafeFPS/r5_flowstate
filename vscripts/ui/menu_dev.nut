untyped

global function InitDevMenu
#if DEVELOPER
global function DEV_InitLoadoutDevSubMenu
global function SetupDevCommand // for dev
global function SetupDevFunc // for dev
global function SetupDevMenu
global function RepeatLastDevCommand
global function UpdatePrecachedSPWeapons
global function ServerCallback_OpenDevMenu
global function RunCodeDevCommandByAlias
global function DEV_ExecBoundDevMenuCommand
global function DEV_InitCodeDevMenu
#endif

global function AddLevelDevCommand

const string DEV_MENU_NAME = "[LEVEL]"

struct DevMenuPage
{
	void functionref()      devMenuFunc
	void functionref( var ) devMenuFuncWithOpParm
	var                     devMenuOpParm
}

struct DevCommand
{
	string                  label
	string                  command
	var                     opParm
	void functionref( var ) func
	bool                    isAMenuCommand = false
}


struct
{
	array<DevMenuPage> pageHistory = []
	DevMenuPage &      currentPage
	var                header
	array<var>         buttons
	array<table>       actionBlocks
	array<DevCommand>  devCommands
	DevCommand&        lastDevCommand
	bool               lastDevCommandAssigned
	string             lastDevCommandLabel
	string             lastDevCommandLabelInProgress
	bool               precachedWeapons

	DevCommand& focusedCmd
	bool        focusedCmdIsAssigned

	DevCommand boundCmd
	bool       boundCmdIsAssigned

	var footerHelpTxtLabel

	bool                      initializingCodeDevMenu = false
	string                    codeDevMenuPrefix = DEV_MENU_NAME + "/"
	table<string, DevCommand> codeDevMenuCommands

	array<DevCommand> levelSpecificCommands = []
} file

function Dummy_Untyped( param )
{

}


void function InitDevMenu( var newMenuArg )
{
	//#if DEVELOPER
		var menu = GetMenu( "DevMenu" )

		AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenDevMenu )

		file.header = Hud_GetChild( menu, "MenuTitle" )
		file.buttons = GetElementsByClassname( menu, "DevButtonClass" )
		foreach ( button in file.buttons )
		{
			Hud_AddEventHandler( button, UIE_CLICK, OnDevButton_Activate )
			Hud_AddEventHandler( button, UIE_GET_FOCUS, OnDevButton_GetFocus )
			Hud_AddEventHandler( button, UIE_GET_FOCUS, OnDevButton_LoseFocus )

			RuiSetString( Hud_GetRui( button ), "buttonText", "" )
			Hud_SetEnabled( button, false )
		}

		AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "%[B_BUTTON|]% Back", "Back" )
		AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, BackOnePage_Activate )
		AddMenuFooterOption( menu, LEFT, BUTTON_Y, true, "%[Y_BUTTON|]% Repeat Last Dev Command:", "Repeat Last Dev Command:", RepeatLastCommand_Activate )
		AddMenuFooterOption( menu, LEFT, BUTTON_BACK, true, "%[BACK|]% Bind Selection to Gamepad", "", BindCommandToGamepad_Activate )
		file.footerHelpTxtLabel = GetElementsByClassname( menu, "FooterHelpTxt" )[0]

		RegisterSignal( "DEV_InitCodeDevMenu" )
		AddUICallback_LevelLoadingFinished( DEV_InitCodeDevMenu )
		AddUICallback_LevelShutdown( ClearCodeDevMenu )
		//OnOpenDevMenu()
	//#endif
}


void function AddLevelDevCommand( string label, string command )
{
	#if DEVELOPER
		string codeDevMenuAlias = DEV_MENU_NAME + "/" + label
		DevMenu_Alias_DEV( codeDevMenuAlias, command )

		DevCommand cmd
		cmd.label = label
		cmd.command = command
		file.levelSpecificCommands.append( cmd )
	#endif
}

#if DEVELOPER
void function OnOpenDevMenu()
{
	file.pageHistory.clear()
	file.currentPage.devMenuFunc = null
	file.currentPage.devMenuFuncWithOpParm = null
	file.currentPage.devMenuOpParm = null
	file.lastDevCommandLabelInProgress = ""

	SetDevMenu_MP()

	//DelayedFocusFirstButton()
}


//void function DelayedFocusFirstButton()
//{
//	//Hud_SetFocused( file.buttons[0] )
//	//Hud_SetSelected( file.buttons[0], true )
//	//vector screenSize = <GetScreenSize().width, GetScreenSize().height, 0>
//	vector buttonPos = <Hud_GetAbsX( file.buttons[0] ), Hud_GetAbsY( file.buttons[1] ), 0>
//	buttonPos += 0.5 * <Hud_GetWidth( file.buttons[0] ), -1 * Hud_GetHeight( file.buttons[0] ), 0>
//	WarpMouseCursorDEV( <buttonPos.x, buttonPos.y, 0> )
//}


void function ServerCallback_OpenDevMenu()
{
	AdvanceMenu( GetMenu( "DevMenu" ) )
}


void function DEV_InitCodeDevMenu()
{
	thread DEV_InitCodeDevMenu_Internal()
}


void function DEV_InitCodeDevMenu_Internal()
{
	Signal( uiGlobal.signalDummy, "DEV_InitCodeDevMenu" )
	EndSignal( uiGlobal.signalDummy, "DEV_InitCodeDevMenu" )

	while ( !IsFullyConnected() || !IsItemFlavorRegistrationFinished() )
	{
		WaitFrame()
	}

	file.initializingCodeDevMenu = true
	DevMenu_Alias_DEV( DEV_MENU_NAME, "" )
	DevMenu_Rm_DEV( DEV_MENU_NAME )
	OnOpenDevMenu()
	file.initializingCodeDevMenu = false
}


void function ClearCodeDevMenu()
{
	DevMenu_Alias_DEV( DEV_MENU_NAME, "" )
	DevMenu_Rm_DEV( DEV_MENU_NAME )
}


void function UpdateDevMenuButtons()
{
	file.devCommands.clear()
	if ( developer() == 0 )
		return

	if ( file.initializingCodeDevMenu )
		return

	// Title:
	{
		string titleText = file.lastDevCommandLabelInProgress
		if ( titleText == "" )
			titleText = ("Developer Menu    -    " + GetActiveLevel())
		Hud_SetText( file.header, titleText )
	}

	if ( file.currentPage.devMenuOpParm != null )
		file.currentPage.devMenuFuncWithOpParm( file.currentPage.devMenuOpParm )
	else
		file.currentPage.devMenuFunc()

	foreach ( index, button in file.buttons )
	{
		int buttonID = int( Hud_GetScriptID( button ) )

		if ( buttonID < file.devCommands.len() )
		{
			RuiSetString( Hud_GetRui( button ), "buttonText", file.devCommands[buttonID].label )
			Hud_SetEnabled( button, true )
		}
		else
		{
			RuiSetString( Hud_GetRui( button ), "buttonText", "" )
			Hud_SetEnabled( button, false )
		}

		if ( buttonID == 0 )
			Hud_SetFocused( button )
	}

	RefreshRepeatLastDevCommandPrompts()
}

void function SetDevMenu_MP()
{
	if ( file.initializingCodeDevMenu )
	{
		SetupDefaultDevCommandsMP()
		return
	}
	PushPageHistory()
	file.currentPage.devMenuFunc = SetupDefaultDevCommandsMP
	UpdateDevMenuButtons()
}


void function ChangeToThisMenu( void functionref() menuFunc )
{
	if ( file.initializingCodeDevMenu )
	{
		menuFunc()
		return
	}
	PushPageHistory()
	file.currentPage.devMenuFunc = menuFunc
	file.currentPage.devMenuFuncWithOpParm = null
	file.currentPage.devMenuOpParm = null
	UpdateDevMenuButtons()
}


void function ChangeToThisMenu_WithOpParm( void functionref( var ) menuFuncWithOpParm, opParm = null )
{
	if ( file.initializingCodeDevMenu )
	{
		menuFuncWithOpParm( opParm )
		return
	}

	PushPageHistory()
	file.currentPage.devMenuFunc = null
	file.currentPage.devMenuFuncWithOpParm = menuFuncWithOpParm
	file.currentPage.devMenuOpParm = opParm
	UpdateDevMenuButtons()
}

void function SetupDefaultDevCommandsMP()
{
	if(IsConnected() && GetCurrentPlaylistName() == "map_editor")
		SetupDevMenu( "Editor", SetDevMenu_Editor )
	SetupDevMenu( "Abilities", SetDevMenu_Abilities )
	SetupDevMenu( "Equip Weapon", SetDevMenu_Weapons )
	SetupDevMenu( "TDM Weapon", SetDevMenu_TDMWeapons )
	//SetupDevMenu( "MDLSpawner", SetDevMenu_ModelSpawner )

	if ( IsSurvivalMenuEnabled() )
	{
		SetupDevMenu( "Change Character", SetDevMenu_SurvivalCharacter )
		//SetupDevMenu( "Override Spawn Character", SetDevMenu_OverrideSpawnSurvivalCharacter )
		SetupDevMenu( "Survival", SetDevMenu_Survival )
		SetupDevMenu( "Custom Attachments", SetDevMenu_SurvivalLoot, "attachment_custom" )
		SetupDevMenu( "Survival Weapons", SetDevMenu_SurvivalLoot, "main_weapon" )
		SetupDevMenu( "Survival Attachments", SetDevMenu_SurvivalLoot, "attachment" )
		SetupDevMenu( "Survival Helmets", SetDevMenu_SurvivalLoot, "helmet" )
		SetupDevMenu( "Survival Armor", SetDevMenu_SurvivalLoot, "armor" )
		SetupDevMenu( "Survival Backpack", SetDevMenu_SurvivalLoot, "backpack" )
		SetupDevMenu( "Survival Incap Shield", SetDevMenu_SurvivalLoot, "incapshield" )
		//SetupDevMenu( "Survival Incap Shield Debugging", SetDevMenu_SurvivalIncapShieldBots )

		string itemsString = "ordnance ammo health custom_pickup data_knife"

		SetupDevMenu( "Survival Items", SetDevMenu_SurvivalLoot, itemsString )

		//SetupDevCommand( "Survival Loot Zone Preprocess", "script_ui Dev_CommandLineAddParm( \"-survival_preprocess\", \"\" ); reload" )
	}


	SetupDevMenu( "Respawn Player(s)", SetDevMenu_RespawnPlayers )
	SetupDevMenu( "Set Respawn Behaviour Override", SetDevMenu_RespawnOverride )

	//SetupDevMenu( "Spawn NPC [IMC]", SetDevMenu_AISpawn, TEAM_IMC )
	//SetupDevMenu( "Spawn NPC [Militia]", SetDevMenu_AISpawn, TEAM_MILITIA )
	//SetupDevMenu( "Spawn NPC [Team 4]", SetDevMenu_AISpawn, TEAM_NPC )


	SetupDevCommand( "Toggle NoClip", "noclip" )

	SetupDevCommand( "Recharge Abilities", "recharge" )
	SetupDevCommand( "Infinite Ammo", "infinite_ammo" )

	//SetupDevCommand( "Toggle Model Viewer", "script thread ToggleModelViewer()" )
	SetupDevCommand( "Start Skydive", "script thread SkydiveTest()" )
	SetupDevCommand( "Spawn Deathbox", "script thread SURVIVAL_CreateDeathBox(gp()[0], false)" )
	//SetupDevCommand( "Toggle Weapon Preview", "ToggleWeaponSkinPreview" )
	//SetupDevMenu( "Threat Tracker", SetDevMenu_ThreatTracker )
	//SetupDevMenu( "High-Vis NPC Test", SetDevMenu_HighVisNPCTest )

	//SetupDevCommand( "Disable NPCs", "script disable_npcs()" )
	// SetupDevCommand( "Disable New NPCs", "script disable_new_npcs()" )

	//SetupDevCommand( "Toggle Friendly Highlights", "script DEV_ToggleFriendlyHighlight()" )
	//SetupDevCommand( "Export precache script", "script_ui Dev_CommandLineAddParm( \"-autoprecache\", \"\" ); script_ui Dev_CommandLineRemoveParm( \"" + STARTPOINT_DEV_STRING + "\" ); reload" )

	//SetupDevCommand( "Doom my titan", "script_client GetLocalViewPlayer().ClientCommand( \"DoomTitan\" )" )
	//SetupDevCommand( "DoF debug (ads)", "script_client ToggleDofDebug()" )

	//SetupDevCommand( "ToggleTitanCallInEffects", "script FlagToggle( \"EnableIncomingTitanDropEffects\" )" )

	//SetupDevCommand( "Spawn IMC grunt", "SpawnViewGrunt " + TEAM_IMC )
	//SetupDevCommand( "Spawn Militia grunt", "SpawnViewGrunt " + TEAM_MILITIA )

	//SetupDevCommand( "Enable titan-always-executes-titan", "script FlagSet( \"ForceSyncedMelee\" )" )

	//SetupDevCommand( "Kill All Titans", "script killtitans()" )
	//SetupDevCommand( "Kill All Minions", "script killminions()" )

	// SetupDevCommand( "Export leveled_weapons.def / r2_weapons.fgd", "script thread LeveledWeaponDump()" )

	SetupDevCommand( "Summon Players to player 0", "script summonplayers()" )
	//SetupDevCommand( "Display Titanfall spots", "script thread ShowAllTitanFallSpots()" )
	//SetupDevCommand( "Toggle check inside Titanfall Blocker", "script thread DevCheckInTitanfallBlocker()" )
	//SetupDevCommand( "Test Dropship Intro Spawns with Bots", "script thread DebugTestDropshipStartSpawnsForAll()" )
	//SetupDevCommand( "Preview Dropship Spawn at this location", "script SetCustomPlayerDropshipSpawn()" )
	//SetupDevCommand( "Test Dropship Spawn at this location", "script thread DebugTestCustomDropshipSpawn()" )
	//SetupDevCommand( "Max Activity (Pilots)", "script SetMaxActivityMode(1)" )
	//SetupDevCommand( "Max Activity (Titans)", "script SetMaxActivityMode(2)" )
	//SetupDevCommand( "Max Activity (Conger Mode)", "script SetMaxActivityMode(4)" )
	//SetupDevCommand( "Max Activity (Disabled)", "script SetMaxActivityMode(0)" )

	SetupDevCommand( "Toggle Skybox View", "script thread ToggleSkyboxView()" )
	SetupDevCommand( "Toggle HUD", "ToggleHUD" )

	SetupDevCommand( "Equip Custom Heirloom", "script thread SetupHeirloom()" )
	SetupDevCommand( "Equip Custom Heirloom (All Players)", "script thread SetupHeirloom( true )" )
	SetupDevCommand( "Unequip Custom Heirloom", "script thread UnEquipHeirloom()" )
	SetupDevCommand( "Unequip Custom Heirloom (All Players)", "script thread UnEquipHeirloom( true )" )
	
	//SetupDevCommand( "Toggle Offhand Low Recharge", "ToggleOffhandLowRecharge" )
	//SetupDevCommand( "Map Metrics Toggle", "script_client GetLocalClientPlayer().ClientCommand( \"toggle map_metrics 0 1 2 3\" )" )
	//SetupDevCommand( "Toggle Pain Death sound debug", "script TogglePainDeathDebug()" )
	//SetupDevCommand( "Jump Randomly Forever", "script_client thread JumpRandomlyForever()" )

	//SetupDevCommand( "Toggle Zeroing Mode", "script ToggleZeroingMode()" )
	SetupDevCommand( "Enable God Mode", "script EnableDemigod( gp()[0] )" )
	SetupDevCommand( "Disable God Mode", "script DisableDemigod( gp()[0] )" )
	//SetupDevCommand( "Toggle Screen Alignment Tool", "script_client DEV_ToggleScreenAlignmentTool()" )

	SetupDevCommand( "Toggle Third Person Mode", "ToggleThirdPerson" )

	SetupDevMenu( "Prototypes", SetDevMenu_Prototypes )

	// This adds CAPTURE MODE every time you load a level.
	// Capture mode doesn't work, so I am commenting this out.
	// Coded in sh_capturemode.nut
	// foreach ( DevCommand cmd in file.levelSpecificCommands )
	// 	SetupDevCommand( cmd.label, cmd.command )
}


void function SetDevMenu_LevelCommands( var _ )
{
	ChangeToThisMenu( SetupLevelDevCommands )
}


void function SetupLevelDevCommands()
{
	string activeLevel = GetActiveLevel()
	if ( activeLevel == "" )
		return

	switch ( activeLevel )
	{
		case "model_viewer":
			SetupDevCommand( "Toggle Rebreather Masks", "script ToggleRebreatherMasks()" )
			break
	}
}

void function SetDevMenu_ModelSpawner( var _ )
{
	thread ChangeToThisMenu( SetupModelSpawner )
}

void function SetDevMenu_Abilities( var _ )
{
	thread ChangeToThisMenu( SetupAbilities )
}

void function SetDevMenu_Weapons( var _ )
{
	thread ChangeToThisMenu( SetupWeapons )
}
void function SetDevMenu_TDMWeapons( var _ )
{
	thread ChangeToThisMenu( SetupTDMweapsons )
}
void function SetDevMenu_SurvivalCharacter( var _ )
{
	thread ChangeToThisMenu( SetupChangeSurvivalCharacterClass )
}

void function SetDevMenu_Editor( var _ ) 
{
	thread ChangeToThisMenu( SetupEditor ) 
}

void function DEV_InitLoadoutDevSubMenu()
{
	file.initializingCodeDevMenu = true
	string codeDevMenuPrefix = file.codeDevMenuPrefix
	//file.codeDevMenuPrefix = "Alter Loadout"
	//DevMenu_Alias_DEV( file.codeDevMenuPrefix, "" )
	//DevMenu_Rm_DEV( file.codeDevMenuPrefix )
	//file.codeDevMenuPrefix += "/"
	file.codeDevMenuPrefix += "Alter Loadout/"
	DevMenu_Rm_DEV( file.codeDevMenuPrefix + "(Click to load this menu..)" )
	thread ChangeToThisMenu( SetupAlterLoadout )
	file.codeDevMenuPrefix = codeDevMenuPrefix
	file.initializingCodeDevMenu = false
}


void function SetDevMenu_AlterLoadout( var _ )
{
	if ( file.initializingCodeDevMenu )
	{
		//return
		DevMenu_Alias_DEV( file.codeDevMenuPrefix + "(Click to load this menu..)", "script_ui DEV_InitLoadoutDevSubMenu()" )
	}
	else
	{
		thread ChangeToThisMenu( SetupAlterLoadout )
	}
}


void function SetupAlterLoadout()
{
	array<string> categories = []
	foreach( LoadoutEntry entry in GetAllLoadoutSlots() )
	{
		if ( !categories.contains( entry.DEV_category ) )
			categories.append( entry.DEV_category )
	}
	categories.sort()
	foreach( string category in categories )
	{
		SetupDevMenu( category, void function( var unused ) : ( category ) {
			thread ChangeToThisMenu( void function() : ( category ) {
				SetupAlterLoadout_CategoryScreen( category )
			} )
		} )
	}
}


void function SetupAlterLoadout_CategoryScreen( string category )
{
	array<LoadoutEntry> entries = clone GetAllLoadoutSlots()
	entries.sort( int function( LoadoutEntry a, LoadoutEntry b ) {
		if ( a.DEV_name < b.DEV_name )
			return -1
		if ( a.DEV_name > b.DEV_name )
			return 1
		return 0
	} )

	array<string> charactersUsed = []

	foreach( LoadoutEntry entry in  entries)
	{
		if ( entry.DEV_category != category )
			continue

		string prefix = "character_"

		if ( entry.DEV_name.find( prefix ) == 0 )
		{
			string character = GetCharacterNameFromDEV_name( entry.DEV_name )

			if ( !charactersUsed.contains( character ) )
			{
				charactersUsed.append( character )
				SetupDevMenu( character, void function( var unused ) : ( category, character ) {
					thread ChangeToThisMenu( void function() : ( category, character ) {
						SetupAlterLoadout_CategoryScreenForCharacter( category, character )
					} )
				} )
			}
		}
		else
		{
			SetupDevMenu( entry.DEV_name, void function( var unused ) : ( entry ) {
				thread ChangeToThisMenu( void function() : ( entry ) {
					SetupAlterLoadout_SlotScreen( entry )
				} )
			} )
		}
	}
}

void function SetupAlterLoadout_CategoryScreenForCharacter( string category, string character )
{
	array<LoadoutEntry> entries = clone GetAllLoadoutSlots()
	entries.sort( int function( LoadoutEntry a, LoadoutEntry b ) {
		if ( a.DEV_name < b.DEV_name )
			return -1
		if ( a.DEV_name > b.DEV_name )
			return 1
		return 0
	} )

	array< LoadoutEntry > entriesToUse

	foreach( LoadoutEntry entry in entries )
	{
		if ( entry.DEV_category != category )
			continue

		string entryCharacter = GetCharacterNameFromDEV_name( entry.DEV_name )

		if ( entryCharacter != character )
			continue

		entriesToUse.append( entry )
	}


	if ( entriesToUse.len() > 1 )
	{
		foreach ( LoadoutEntry entry in entriesToUse )
		{
			SetupDevMenu( entry.DEV_name, void function( var unused ) : ( entry ) {
				thread ChangeToThisMenu( void function() : ( entry ) {
					SetupAlterLoadout_SlotScreen( entry )
				} )
			} )
		}
	}
	else if ( entriesToUse.len() == 1 )
	{
		LoadoutEntry entry = entriesToUse[ 0 ]
		SetupAlterLoadout_SlotScreen( entry )
	}
}

string function GetCharacterNameFromDEV_name( string DEV_name )
{
	string prefix = "character_"
	return split( DEV_name.slice( prefix.len() ), " " )[ 0 ]
}

void function SetupAlterLoadout_SlotScreen( LoadoutEntry entry )
{
	// todo(dw): 368482
	//if ( entry.canBeEmpty )
	//{
	//	SetupDevFunc( "(empty)", void function( var unused ) : ( entry ) {
	//		DEV_RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), entry, null )
	//	} )
	//}

	array<ItemFlavor> flavors = clone DEV_GetValidItemFlavorsForLoadoutSlotForDev( LocalClientEHI(), entry )
	flavors.sort( int function( ItemFlavor a, ItemFlavor b ) {
		if ( Localize( ItemFlavor_GetLongName( a ) ) < Localize( ItemFlavor_GetLongName( b ) ) )
			return -1
		if ( Localize( ItemFlavor_GetLongName( a ) ) > Localize( ItemFlavor_GetLongName( b ) ) )
			return 1
		return 0
	} )

	foreach( ItemFlavor flav in flavors )
	{
		SetupDevFunc( Localize( ItemFlavor_GetLongName( flav ) ), void function( var unused ) : ( entry, flav ) {
			DEV_RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), entry, flav )
		} )
	}
}


void function SetDevMenu_OverrideSpawnSurvivalCharacter( var _ )
{
	thread ChangeToThisMenu( SetupOverrideSpawnSurvivalCharacter )
}


void function SetDevMenu_Survival( var _ )
{
	thread ChangeToThisMenu( SetupSurvival )
}


void function SetDevMenu_SurvivalLoot( var categories )
{
	thread ChangeToThisMenu_WithOpParm( SetupSurvivalLoot, categories )
}


void function SetDevMenu_SurvivalIncapShieldBots( var _ )
{
	thread ChangeToThisMenu( SetupSurvivalIncapShieldBot )
}



void function ChangeToThisMenu_PrecacheWeapons( void functionref() menuFunc )
{
	if ( file.initializingCodeDevMenu )
	{
		menuFunc()
		return
	}

	waitthread PrecacheWeaponsIfNecessary()

	PushPageHistory()
	file.currentPage.devMenuFunc = menuFunc
	file.currentPage.devMenuFuncWithOpParm = null
	file.currentPage.devMenuOpParm = null
	UpdateDevMenuButtons()
}


void function ChangeToThisMenu_PrecacheWeapons_WithOpParm( void functionref( var ) menuFuncWithOpParm, opParm = null )
{
	if ( file.initializingCodeDevMenu )
	{
		menuFuncWithOpParm( opParm )
		return
	}

	waitthread PrecacheWeaponsIfNecessary()

	PushPageHistory()
	file.currentPage.devMenuFunc = null
	file.currentPage.devMenuFuncWithOpParm = menuFuncWithOpParm
	file.currentPage.devMenuOpParm = opParm
	UpdateDevMenuButtons()
}


void function PrecacheWeaponsIfNecessary()
{
	if ( file.precachedWeapons )
		return

	file.precachedWeapons = true
	CloseAllMenus()

	DisablePrecacheErrors()
	wait 0.1
	ClientCommand( "script PrecacheSPWeapons()" )
	wait 0.1
	ClientCommand( "script_client PrecacheSPWeapons()" )
	wait 0.1
	RestorePrecacheErrors()

	AdvanceMenu( GetMenu( "DevMenu" ) )
}


void function UpdatePrecachedSPWeapons()
{
	file.precachedWeapons = true
}

void function SetDevMenu_RespawnPlayers( var _ )
{
	ChangeToThisMenu( SetupRespawnPlayersDevMenu )
}


void function SetupRespawnPlayersDevMenu()
{
	SetupDevCommand( "Respawn me", "respawn" )
	SetupDevCommand( "Respawn all players", "respawn all" )
	SetupDevCommand( "Respawn all dead players", "respawn alldead" )
	SetupDevCommand( "Respawn random player", "respawn random" )
	SetupDevCommand( "Respawn random dead player", "respawn randomdead" )
	SetupDevCommand( "Respawn bots", "respawn bots" )
	SetupDevCommand( "Respawn dead bots", "respawn deadbots" )
	SetupDevCommand( "Respawn my teammates", "respawn allies" )
	SetupDevCommand( "Respawn my enemies", "respawn enemies" )
	//foreach ( player in GetPlayerArray() )
	//{
	//	SetupDevCommand( "Respawn player: " + player.GetPlayerName(), "respawn " + player.GetEntIndex() )
	//}
}
void function SetupTDMweapsons()
{
	SetupDevCommand( "2x R99", "tgive p mp_weapon_r97 optic_cq_hcog_bruiser stock_tactical_l3 barrel_stabilizer_l4_flash_hider bullets_mag_l3" )
	SetupDevCommand( "3x G7 ", "tgive p mp_weapon_g2 optic_ranged_hcog stock_sniper_l3 barrel_stabilizer_l4_flash_hider bullets_mag_l3 hopup_double_tap" )
	SetupDevCommand( "2x re45", "tgive p mp_weapon_autopistol optic_cq_hcog_bruiser barrel_stabilizer_l4_flash_hider bullets_mag_l3" )
	SetupDevCommand( "1x Volt SMG", "tgive p mp_weapon_volt_smg optic_cq_hcog_classic barrel_stabilizer_l4_flash_hider bullets_mag_l3" )
	SetupDevCommand( "2x r301", "tgive p mp_weapon_rspn101 optic_cq_hcog_bruiser stock_tactical_l3 barrel_stabilizer_l4_flash_hider bullets_mag_l3" )
	SetupDevCommand( "1x p2020", "tgive p mp_weapon_semipistol optic_cq_hcog_classic bullets_mag_l3 hopup_unshielded_dmg" )
	SetupDevCommand( "2x Alternator", "tgive p mp_weapon_alternator_smg optic_cq_hcog_bruiser stock_tactical_l3 barrel_stabilizer_l4_flash_hider bullets_mag_l3" )
	SetupDevCommand( "2x hemlok", "tgive p mp_weapon_hemlok optic_cq_hcog_bruiser stock_tactical_l3 barrel_stabilizer_l4_flash_hider highcal_mag_l3" )
	SetupDevCommand( "2x flatline", "tgive p mp_weapon_vinson optic_cq_hcog_bruiser stock_tactical_l3 highcal_mag_l3")
	SetupDevCommand( "2x Spitfire", "tgive p mp_weapon_lmg optic_cq_hcog_bruiser stock_tactical_l3 barrel_stabilizer_l4_flash_hider highcal_mag_l3" )
	SetupDevCommand( "1x Prowler", "tgive p mp_weapon_pdw optic_cq_hcog_classic stock_tactical_l3 highcal_mag_l3" )
	SetupDevCommand( "1x wingman", "tgive p mp_weapon_wingman optic_cq_hcog_classic highcal_mag_l3" )
	SetupDevCommand( "4-8x longbow", "tgive p mp_weapon_dmr optic_sniper_variable barrel_stabilizer_l4_flash_hider stock_sniper_l3 highcal_mag_l3" )
	SetupDevCommand( "4-10x Charge Rifle", "tgive p mp_weapon_defender optic_sniper_threat stock_sniper_l3" )
	SetupDevCommand( "2x Devotion", "tgive p mp_weapon_esaw optic_cq_hcog_bruiser stock_tactical_l3 barrel_stabilizer_l4_flash_hider energy_mag_l3 hopup_turbocharger" )
	SetupDevCommand( "2x Havoc", "tgive p mp_weapon_energy_ar optic_cq_hcog_bruiser stock_tactical_l3 energy_mag_l3 hopup_turbocharger" )
	SetupDevCommand( "1x EVA8", "tgive s mp_weapon_shotgun shotgun_bolt_l3 optic_cq_hcog_classic hopup_double_tap" )
	SetupDevCommand( "1x Mozambique", "tgive s mp_weapon_shotgun_pistol shotgun_bolt_l3 optic_cq_hcog_classic hopup_unshielded_dmg" )
	SetupDevCommand( "1x Peacekeeper", "tgive s mp_weapon_energy_shotgun shotgun_bolt_l3 optic_cq_hcog_classic hopup_energy_choke" )
	SetupDevCommand( "3x Triple Take", "tgive p mp_weapon_doubletake energy_mag_l3 optic_ranged_hcog stock_sniper_l3 hopup_energy_choke" )
	SetupDevCommand( "Kraber", "tgive p mp_weapon_sniper" )
	SetupDevCommand( "Lstar", "tgive p mp_weapon_lstar" )
	SetupDevCommand( "Mastiff","tgive s mp_weapon_mastiff")



	//foreach ( player in GetPlayerArray() )
	//{
	//	SetupDevCommand( "Respawn player: " + player.GetPlayerName(), "respawn " + player.GetEntIndex() )
	//}
}

void function SetDevMenu_RespawnOverride( var _ )
{
	ChangeToThisMenu( SetupRespawnOverrideDevMenu )
}


void function SetupRespawnOverrideDevMenu()
{
	SetupDevCommand( "Use gamemode behaviour", "set_respawn_override off" )
	SetupDevCommand( "Override: Allow all respawning", "set_respawn_override allow" )
	SetupDevCommand( "Override: Deny all respawning", "set_respawn_override deny" )
	SetupDevCommand( "Override: Allow bot respawning", "set_respawn_override allowbots" )
}


void function SetDevMenu_ThreatTracker( var _ )
{
	ChangeToThisMenu( SetupThreatTrackerDevMenu )
}


void function SetupThreatTrackerDevMenu()
{
	SetupDevCommand( "Reload Threat Data", "fs_report_sync_opens 0; script ReloadScripts(); script ThreatTracker_ReloadThreatData()" )
	SetupDevCommand( "Threat Tracking ON", "script ThreatTracker_SetActive( true )" )
	SetupDevCommand( "Threat Tracking OFF", "script ThreatTracker_SetActive( false )" )
	SetupDevCommand( "Overhead Debug ON", "script ThreatTracker_DrawDebugOverheadText( true )" )
	SetupDevCommand( "Overhead Debug OFF", "script ThreatTracker_DrawDebugOverheadText( false )" )
	SetupDevCommand( "Console Debug Level 0", "script ThreatTracker_SetDebugLevel( 0 )" )
	SetupDevCommand( "Console Debug Level 1", "script ThreatTracker_SetDebugLevel( 1 )" )
	SetupDevCommand( "Console Debug Level 2", "script ThreatTracker_SetDebugLevel( 2 )" )
	SetupDevCommand( "Console Debug Level 3", "script ThreatTracker_SetDebugLevel( 3 )" )
}


void function SetDevMenu_HighVisNPCTest( var _ )
{
	ChangeToThisMenu( SetupHighVisNPCTest )
}


void function SetupHighVisNPCTest()
{
	SetupDevCommand( "Spawn at Crosshair", "script PROTO_SpawnHighVisNPCs()" )
	SetupDevCommand( "Delete Test NPCs", "script PROTO_DeleteHighVisNPCs()" )
	SetupDevCommand( "Use R5 Art Settings", "script PROTO_HighVisNPCs_SetTestEnv( \"r5\" )" )
	SetupDevCommand( "Use R2 Art Settings", "script PROTO_HighVisNPCs_SetTestEnv( \"r2\" )" )
}

void function SetDevMenu_Prototypes( var _ )
{
	thread ChangeToThisMenu( SetupPrototypesDevMenu )
}

void function SetupPrototypesDevMenu()
{
	SetupDevCommand( "Toggle Akimbo With Current Weapon", "script DEV_ToggleAkimboWeapon(gp()[0])" )
	SetupDevCommand( "Toggle Akimbo With Holstered Weapon", "script DEV_ToggleAkimboWeaponAlt(gp()[0])" )
	// SetupDevCommand( "Change to Shadow Squad", "script Dev_ShadowFormEnable( GP() )" )
}


void function RunCodeDevCommandByAlias( string alias )
{
	RunDevCommand( file.codeDevMenuCommands[alias], false )
}


void function SetupDevCommand( string label, string command )
{
	if ( command.slice( 0, 5 ) == "give " )
		command = "give_server " + command.slice( 5 )

	DevCommand cmd
	cmd.label = label
	cmd.command = command

	file.devCommands.append( cmd )
	if ( file.initializingCodeDevMenu )
	{
		string codeDevMenuAlias = file.codeDevMenuPrefix + label
		//string codeDevMenuCommand = format( "script_ui RunCodeDevCommandByAlias( \"%s\" )", codeDevMenuAlias )
		//file.codeDevMenuCommands[codeDevMenuAlias] <- cmd
		DevMenu_Alias_DEV( codeDevMenuAlias, command )
	}
}


void function SetupDevFunc( string label, void functionref( var ) func, var opParm = null )
{
	DevCommand cmd
	cmd.label = label
	cmd.func = func
	cmd.opParm = opParm

	file.devCommands.append( cmd )
	if ( file.initializingCodeDevMenu )
	{
		string codeDevMenuAlias   = file.codeDevMenuPrefix + label
		string codeDevMenuCommand = format( "script_ui RunCodeDevCommandByAlias( \"%s\" )", codeDevMenuAlias )
		file.codeDevMenuCommands[codeDevMenuAlias] <- cmd
		DevMenu_Alias_DEV( codeDevMenuAlias, codeDevMenuCommand )
	}
}


void function SetupDevMenu( string label, void functionref( var ) func, var opParm = null )
{
	DevCommand cmd
	cmd.label = (label + "  ->")
	cmd.func = func
	cmd.opParm = opParm
	cmd.isAMenuCommand = true

	file.devCommands.append( cmd )

	if ( file.initializingCodeDevMenu )
	{
		string codeDevMenuPrefix = file.codeDevMenuPrefix
		file.codeDevMenuPrefix += label + "/"
		cmd.func( cmd.opParm )
		file.codeDevMenuPrefix = codeDevMenuPrefix
	}
}


void function OnDevButton_Activate( var button )
{
	if ( level.ui.disableDev )
	{
		Warning( "Dev commands disabled on matchmaking servers." )
		return
	}

	int buttonID   = int( Hud_GetScriptID( button ) )
	DevCommand cmd = file.devCommands[buttonID]

	RunDevCommand( cmd, false )
}


void function OnDevButton_GetFocus( var button )
{
	file.focusedCmdIsAssigned = false

	int buttonID = int( Hud_GetScriptID( button ) )
	if ( buttonID >= file.devCommands.len() )
		return

	if ( file.devCommands[buttonID].isAMenuCommand )
		return

	file.focusedCmd = file.devCommands[buttonID]
	file.focusedCmdIsAssigned = true
}


void function OnDevButton_LoseFocus( var button )
{
}


void function RunDevCommand( DevCommand cmd, bool isARepeat )
{
	if ( !isARepeat )
	{
		if ( file.lastDevCommandLabelInProgress.len() > 0 )
			file.lastDevCommandLabelInProgress += "  "
		file.lastDevCommandLabelInProgress += cmd.label

		if ( !cmd.isAMenuCommand )
		{
			file.lastDevCommand = cmd
			file.lastDevCommandAssigned = true
			file.lastDevCommandLabel = file.lastDevCommandLabelInProgress
		}
	}

	if ( cmd.command != "" )
	{
		ClientCommand( cmd.command )
		if ( IsLobby() )
		{
			CloseAllMenus()
			AdvanceMenu( GetMenu( "R5RLobbyMenu" ) )
		}
		else
		{
			CloseAllMenus()
		}
	}
	else
	{
		cmd.func( cmd.opParm )
	}
}


void function RepeatLastDevCommand( var _ )
{
	if ( !file.lastDevCommandAssigned )
		return

	RunDevCommand( file.lastDevCommand, true )
}


void function RepeatLastCommand_Activate( var button )
{
	RepeatLastDevCommand( null )
}


void function PushPageHistory()
{
	DevMenuPage page = file.currentPage
	if ( page.devMenuFunc != null || page.devMenuFuncWithOpParm != null )
		file.pageHistory.push( clone page )
}


void function BackOnePage_Activate()
{
	if ( file.pageHistory.len() == 0 )
	{
		CloseActiveMenu( true )
		return
	}

	file.currentPage = file.pageHistory.pop()
	UpdateDevMenuButtons()
}


void function RefreshRepeatLastDevCommandPrompts()
{
	string newText = ""
	//if ( AreOnDefaultDevCommandMenu() )
	{
		if ( file.lastDevCommandAssigned )
			newText = file.lastDevCommandLabel    // file.lastDevCommand.label
		else
			newText = "<none>"
	}

	if ( AreOnDefaultDevCommandMenu() )
		file.lastDevCommandLabelInProgress = ""

	Hud_SetText( file.footerHelpTxtLabel, newText )
}


bool function AreOnDefaultDevCommandMenu()
{
	if ( file.currentPage.devMenuFunc == SetupDefaultDevCommandsMP )
		return true

	return false
}


void function BindCommandToGamepad_Activate( var button )
{
	if ( !BindCommandToGamepad_ShouldShow() )
		return

	// Binding:
	{
		string cmdText = "bind back \"script_ui DEV_ExecBoundDevMenuCommand()\""
		ClientCommand( cmdText )
	}

	file.boundCmd.command = file.focusedCmd.command
	file.boundCmd.isAMenuCommand = file.focusedCmd.isAMenuCommand
	file.boundCmd.label = file.focusedCmd.label
	file.boundCmd.func = file.focusedCmd.func
	file.boundCmd.opParm = file.focusedCmd.opParm
	file.boundCmdIsAssigned = true

	// Feedback:
	{
		string fullName = ""
		if ( file.lastDevCommandLabelInProgress.len() > 0 )
			fullName = file.lastDevCommandLabelInProgress + " -> "
		fullName += file.focusedCmd.label

		string prompt = "Bound to gamepad BACK: " + fullName
		printt( prompt )
		//string cmdText = "script Dev_PrintMessage( gp()[0], \"" + prompt + "\" )"
		//ClientCommand( cmdText )
		EmitUISound( "wpn_pickup_titanweapon_1p" )
	}

	CloseAllMenus()
}


bool function BindCommandToGamepad_ShouldShow()
{
	if ( !file.focusedCmdIsAssigned )
		return false
	if ( file.focusedCmd.command.len() == 0 )
		return false
	return true
}


void function DEV_ExecBoundDevMenuCommand()
{
	if ( !file.boundCmdIsAssigned )
		return

	RunDevCommand( file.boundCmd, true )
}
#endif
