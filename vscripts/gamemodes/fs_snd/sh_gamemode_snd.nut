// Search and Destroy
// Made by @CafeFPS - Server, Client and UI

// Aeon#0236 - Playtests and ideas
// AyeZee#6969 - Some of the economy system logic from his arenas mode draft - stamina
// @DEAFPS - Shoothouse, de_cache and NCanals maps
// @CafeFPS and Darkes#8647 - de_dust2 map model port and fake collision
// VishnuRajan in https://sketchfab.com/3d-models/time-bomb-efb2e079c31349c1b2bd072f00d8fe79 - Bomb model and textures

global function Sh_GamemodeSND_Init
global function GetSidesSpawns
global function GetBombPlantingLocations
global function CanPlantBombHere

global function AddRoundPointToWinner_IMC
global function AddRoundPointToWinner_Militia
global function AddRoundPointTied

global function ClearMatchPoints
global function ReturnTeamWins

global function Sh_SetAttackingLocations
global function Sh_SetAttackerTeam
global function Sh_GetAttackerTeam
global function Sh_GetDefenderTeam

global function GetAllBuyMenuElements
global function GetWeaponIDFromRef
global function GetWeaponPriceFromRef
global function GetWeaponPriceFromRefAndUpgradeLevel
global function SetCustomLightning

global function SND_GetCurrentLocation
global function SND_GetIMCWins
global function SND_GetMilitiaWins

#if CLIENT
global function SND_HintCatalog
global function SND_HintCatalog_WithEntity
global function SND_ToggleScoreboardVisibility
global function SND_UpdateUIScore
global function ServerCallback_SetBombState
global function ServerCallback_SetBombStateFromfile
global function ServerCallback_ToggleBombUIVisibility
global function ServerCallback_AddPlantZoneInGameHintA
global function ServerCallback_AddPlantZoneInGameHintB
global function ServerCallback_OnBombPlantedInGameHint
global function ServerCallback_ForceZoneHintDestroy
global function SND_QuickHint
global function SND_ToggleMoneyUI
global function RefreshUITestColorsIdk
global function HACK_TrackPlayerPositionOnScript
global function RefreshImageAndScaleOnMinimapAndFullmap
global function SND_UpdateUIScoreOnPlayerConnected
global function Consumable_UseBomb
#endif

#if SERVER
global function SND_DestroyCircleFXEntity
global function SpawnVotePhaseCustomMaps
global function AddHintInPlantZone
global function ToggleBuyMenuBackgroundProps
global function AddBombToMinimap
#endif

global const int SND_AllowedPlantRadius = 118

#if SERVER
global const int SND_ROUNDS_TO_WIN = 6
global bool SND_SUDDEN_DEATH_ROUND = false
global bool SND_SHOULD_START_A_NEW_MATCH = false
#endif

global const int IMC_color = 4
global const int MILITIA_color = 5

//bomb
global const float DEFUSE_BOMB_TIME = 5.0
global const float EXPLODE_BOMB_TIME = 40.0

global array<string> SND_knifeColors = [
	"255, 0, 199",
	"40, 5, 237"
]

global struct sidesSpawns{
	vector Defenders
	vector Attackers
}

global struct bombPlantingLocations{
	vector A
	vector B
}

global struct weaponMenuElement
{
	int menuID
	int weaponID
	asset icon
	int tier
	string text
	string name
	string weaponref
	int price_base
	int price_upgrade1
	int price_upgrade2
	int price_upgrade3
	int price_upgrade4
}

global enum bombState
{
	NONE,
	CARRIED,
	ONGROUND_IDLE,
	ONGROUND_PLANTED,
	ONGROUND_EXPLODED,
	ONGROUND_DEFUSED
}

struct
{
	array<sidesSpawns> sidesSpawns
	array<bombPlantingLocations> bombPlantingLocations
	array<weaponMenuElement> AllMenuElements
	
	int currentAttackerTeam = TEAM_IMC
	int currentRound
	int IMCWins = 0
	int MILITIAWins = 0
	int tiedRounds = 0	
	bool areTied = false
	
	#if SERVER
	array<entity> visualsPlantingLocations
	array<entity> propsToHide
	int currentLocation = -1
	#endif
	
	#if CLIENT
	var activeQuickHint
	int currentBombState
	
	var plantSiteHint1
	var plantSiteHint2
	var plantSiteHint1_Text
	var plantSiteHint2_Text
	
	int currentLocation = -1
	string bombTime
	float bombEndTime
	entity bombEntity

	float currentX_Offset = 0
	float currentY_Offset = 0
	asset currentMapImage
	float mapscale
	#endif
	
} file

void function Sh_GamemodeSND_Init()
{
	SURVIVAL_Loot_All_InitShared()
	SURVIVAL_Loot_InitShared()
	// Consumable_Init()
	
	PrecacheModel($"mdl/fx/ar_edge_sphere_512.rmdl")
	
	AddCallback_EntitiesDidLoad( Sh_EntitiesDidLoad )

	#if SERVER
	AddClientCommandCallback( "CC_ThrowBomb", ClientCommand_ThrowBomb )
	#else
	RegisterConCommandTriggeredCallback( "+scriptCommand5", AttemptThrowBomb )
	#endif
}

#if CLIENT
void function AttemptThrowBomb( entity player )
{
	if( !IsValid(player) ) 
		return
		
	if ( player != GetLocalViewPlayer() )
		return

	if( player.GetTeam() != Sh_GetAttackerTeam() )
		return

	bool hasBomb = SURVIVAL_CountItemsInInventory( player, "snd_bomb" ) == 1

	if( !hasBomb )
		return

	player.ClientCommand( "CC_ThrowBomb" )
	return
}
#endif

#if SERVER
bool function ClientCommand_ThrowBomb(entity player, array<string> args)
{
	if( !IsValid(player) ) 
		return false

	PlayerThrowBomb( player )
	return true
}

void function PlayerThrowBomb( entity player, vector angles = <0, 0, 0> )
{
	if( !player.p.playerHasBomb || 
		SURVIVAL_CountItemsInInventory( player, "snd_bomb" ) == 0 || 
		player.GetTeam() != Sh_GetAttackerTeam() ||
		GetBombState() != bombState.CARRIED	||
		player.p.playerIsPlantingBomb ||
		GetGameState() != eGameState.Playing )
		return

	string ref = "snd_bomb"
	vector origin = GetThrowOrigin( player )
	vector fwd = AnglesToForward( player.EyeAngles() ) * 80

	entity loot

	printt("bomb dropped by " + player)
	player.p.playerHasBomb = false
	
	if(IsValid(GetBombEntity())) 
		GetBombEntity().Destroy()

	SURVIVAL_RemoveFromPlayerInventory( player, ref, 1 )
	loot = SpawnGenericLoot( ref, origin, angles, 1 )
	
	SetBombEntity(loot)

	SetBombState(bombState.ONGROUND_IDLE)
	// loot.SetOrigin(player.GetOrigin())
	FakePhysicsThrow_NewTestBomb( player, loot, fwd ) 
	foreach( sPlayer in GetPlayerArrayOfTeam(Sh_GetAttackerTeam()) )
	{
		if(!IsValid(sPlayer)) continue
		
		Remote_CallFunction_NonReplay( sPlayer, "SND_HintCatalog_WithEntity", 2, player) //a player dropped the bomb
	}
	SetItemSpawnSource( loot, eSpawnSource.PLAYER_DROP, player )
	BroadcastItemDrop( player, ref )

	Remote_CallFunction_Replay( player, "ServerCallback_RefreshInventoryAndWeaponInfo" )
	EmitSoundOnEntityOnlyToPlayer( player, player, "survival_loot_attach_pas_fast_swap" )

}
#endif

void function Sh_EntitiesDidLoad()
{
	FlowstateSND_InitMenuElements()
}

void function Sh_SetAttackingLocations(int map)
{
	sidesSpawns thisMapSides
	bombPlantingLocations thisMapPlantingLocations
	
	file.sidesSpawns.clear()
	file.bombPlantingLocations.clear()
	
	switch( MapName() )
	{
		case eMaps.mp_rr_arena_composite:
			thisMapSides.Defenders = <-3223.99634, 1356.75903, 142.736221>
			thisMapSides.Attackers = <3236.43018, 1352.34058, 142.736221>
			
			thisMapPlantingLocations.A = <-3223.99634, 1356.75903, 142.736221>
			thisMapPlantingLocations.B = <3236.43018, 1352.34058, 142.736221>
		break
		
		case eMaps.mp_rr_desertlands_64k_x_64k:
			thisMapSides.Defenders = <6193.33057, 5437.45313, -4295.96875>
			thisMapSides.Attackers = <2090.76758, 12572.7256, -3336.95386>
			
			thisMapPlantingLocations.A = <6193.33057, 5437.45313, -4295.96875>
			thisMapPlantingLocations.B = <2090.76758, 12572.7256, -3336.95386>
		break
		
		case eMaps.mp_rr_olympus_mu1:
			thisMapSides.Defenders = <-4899.18506, 23100.4492, -5939.96875>
			thisMapSides.Attackers = <-8529.28125, 19642.5215, -5937.96875>

			thisMapPlantingLocations.A = <-7066.11768, 22861.2363, -6043.96875>
			thisMapPlantingLocations.B = <-5436.7666, 19734.5449, -5889.96875>
			
		break
		case eMaps.mp_rr_arena_empty:
			if(file.currentLocation != map)
			{
				switch(map)
				{
					case 0: //Dust 2
					thisMapSides.Defenders = <-878.241699, 762.631714, 8921.96289>
					thisMapSides.Attackers = <2418.02783, -337.723022, 9187.16211>
					
					thisMapPlantingLocations.A = <-1029.61377, 1702.35999, 9163.06055>
					thisMapPlantingLocations.B = <-1292.87451, -1283.91162, 9059.0625>
					
					#if CLIENT
					SetCustomXYOffsetsMapScaleAndImageOnFullmapAndMinimap( $"rui/flowstatecustom/de_dust2_map", 1.15, 1700, -2200 )
					#endif
					break
					
					case 1: //Shoothouse
					thisMapSides.Defenders = <1669.19226, -2879.6311, 7375.0625>
					thisMapSides.Attackers = <4432.47998, -2657.14795, 7375.0625>
					
					thisMapPlantingLocations.A = <2588.84766, -3537.06226, 7368.79297>
					thisMapPlantingLocations.B = <2972.7522, -2134.86328, 7368.79297>
					
					#if CLIENT
					SetCustomXYOffsetsMapScaleAndImageOnFullmapAndMinimap( $"rui/flowstatecustom/shoothouse_map", 1, -900, 800 )
					#endif
					break
					
					case 2: //Cache
					thisMapSides.Defenders = <1930.31421, 3208.92383, 16435>
					thisMapSides.Attackers = <2429.14404, -1330.07703, 16415>

					
					thisMapPlantingLocations.A = <3644.49707, 2061.52881, 16491.0859>
					thisMapPlantingLocations.B = <375.151031, 1383.72168, 16456.1621>
					
					if( MapName() == eMaps.mp_rr_arena_empty )
					{
						thisMapSides.Defenders -= <0,0,10000>
						thisMapSides.Attackers -= <0,0,10000>

						thisMapPlantingLocations.A -= <0,0,10000>
						thisMapPlantingLocations.B -= <0,0,10000>
					}

					#if CLIENT
					SetCustomXYOffsetsMapScaleAndImageOnFullmapAndMinimap( $"rui/flowstatecustom/de_cache_map", 1.51, 700, -2670 )
					#endif
					break

					case 3: //Nuketown
					thisMapSides.Defenders = <-5393.27246, -4322.79834, 19489.7598>
					thisMapSides.Attackers = <-8711.90723, -4807.10107, 19489.7637>
					
					thisMapPlantingLocations.A = <-6018.99854, -4438.81299, 19492.5488>
					thisMapPlantingLocations.B = <-6884.40381, -5176.68994, 19489.7617>
					break

					case 4: //NCanals
					thisMapSides.Defenders = <2776.49658, 9063.43652, 8157.16211>
					thisMapSides.Attackers = <3552.09839, 5331.59717, 8077.50635>
					
					thisMapPlantingLocations.A = <2263.87964, 7088.00293, 8157.16211>
					thisMapPlantingLocations.B = <3814.87622, 7908.92529, 8157.2627>
					break

					case 5: //Killyard
					thisMapSides.Defenders = <-625.669922, -1551.28662, 15005>
					thisMapSides.Attackers = <-522.270874, -3398.98657, 15005>
					
					thisMapPlantingLocations.A = <120.271881, -2186.95874, 14999.8623>
					thisMapPlantingLocations.B = <-1027.39197, -2079.62573, 14999.8623>
					break
					default:
					#if CLIENT
					SetCustomXYOffsetsMapScaleAndImageOnFullmapAndMinimap( $"", 1, 0, 0 )
					#endif
					break
				}
			}
		break
	}
	
	file.sidesSpawns.append(thisMapSides)
	file.bombPlantingLocations.append(thisMapPlantingLocations)
	#if CLIENT
	file.bombTime = "0"
	file.bombEndTime = 0
	#endif
	
	#if SERVER
	entity circle = CreateEntity( "prop_dynamic" )
	circle.SetValueForModelKey( $"mdl/fx/ar_edge_sphere_512.rmdl" )
	circle.kv.rendercolor = "20, 173, 250"
	circle.kv.modelscale = 0.4
	circle.SetOrigin( GetBombPlantingLocations()[0].A + <0.0, 0.0, -25>)
	circle.SetAngles( <0, 0, 0> )
	DispatchSpawn(circle)
	file.visualsPlantingLocations.append(circle)
	
	entity circle2 = CreateEntity( "prop_dynamic" )
	circle2.SetValueForModelKey( $"mdl/fx/ar_edge_sphere_512.rmdl" )
	circle2.kv.rendercolor = "20, 173, 250"
	circle2.kv.modelscale = 0.4
	circle2.SetOrigin( GetBombPlantingLocations()[0].B + <0.0, 0.0, -25>)
	circle2.SetAngles( <0, 0, 0> )
	DispatchSpawn(circle2)
	file.visualsPlantingLocations.append(circle2)

	entity triggerA = CreateEntity( "trigger_cylinder" )
	triggerA.SetRadius( SND_AllowedPlantRadius - 5 )
	triggerA.SetAboveHeight( SND_AllowedPlantRadius )
	triggerA.SetBelowHeight( 1 )
	triggerA.SetOrigin( GetBombPlantingLocations()[0].A )
	triggerA.SetEnterCallback( TriggerEnter )
	triggerA.SetLeaveCallback( TriggerLeave )
	DispatchSpawn( triggerA )

	entity triggerB = CreateEntity( "trigger_cylinder" )
	triggerB.SetRadius( SND_AllowedPlantRadius - 5 )
	triggerB.SetAboveHeight( SND_AllowedPlantRadius )
	triggerB.SetBelowHeight( 1 )
	triggerB.SetOrigin( GetBombPlantingLocations()[0].B )
	triggerB.SetEnterCallback( TriggerEnter )
	triggerB.SetLeaveCallback( TriggerLeave )
	DispatchSpawn( triggerB )
	#endif
}

#if SERVER
void function TriggerEnter( entity trigger, entity ent )
{
	if ( !IsValid( ent ) || 
		!ent.IsPlayer() || 
		ent.p.playerIsPlantingBomb || 
		ent.GetTeam() != Sh_GetAttackerTeam() || 
		GetBombState() != bombState.CARRIED || 
		!ent.p.playerHasBomb )
		return

	Remote_CallFunction_NonReplay( ent, "SND_HintCatalog", 12, 0)

	thread function( ) : ( trigger, ent )
	{
		while( IsValid( ent ) && IsValid( trigger ) && trigger.IsTouching( ent ) )
		{
			WaitFrame()
			
			if( ent.p.playerIsPlantingBomb )
			{
				Remote_CallFunction_NonReplay( ent, "SND_HintCatalog", 13, 0)
				break
			}
		}
	}()
	// Remote_CallFunction_NonReplay( ent, "Consumable_UseBomb" )
	
	Remote_CallFunction_ByRef( ent, "Consumable_UseBomb" )
}

void function TriggerLeave( entity trigger, entity ent )
{
	if ( !IsValid( ent ) || 
		!ent.IsPlayer() || 
		ent.p.playerIsPlantingBomb || 
		ent.GetTeam() != Sh_GetAttackerTeam() || 
		GetBombState() != bombState.CARRIED || 
		!ent.p.playerHasBomb )
		return

	Remote_CallFunction_NonReplay( ent, "SND_HintCatalog", 13, 0)
}
#endif

#if CLIENT
void function Consumable_UseBomb()
{
	entity player = GetLocalClientPlayer()
	ConsumableInfo info = GetConsumableInfoFromRef( "snd_bomb" )
	thread AddModAndFireWeapon_Thread( player, info.modName )
}
#endif

int function SND_GetCurrentLocation()
{
	return file.currentLocation
}

void function SetCustomLightning(int map)
{
	switch(map)
	{
		case 0:
			SetConVarFloat( "mat_autoexposure_force_value", 0.8 )
			SetConVarString( "mat_sun_color", "1.0 1.0 1.0 1.0" )
			SetConVarString( "mat_sun_scale", "0.4" )
			SetConVarString( "mat_sky_scale", "0.4" )
			SetConVarString( "mat_sky_color", "1.0 1.0 1.0 1.0" )
		break
		
		case 1:
			SetConVarFloat( "mat_autoexposure_force_value", 0.8 )
			SetConVarString( "mat_sun_color", "1.0 1.0 1.0 1.0" )
			SetConVarString( "mat_sun_scale", "1" )
			SetConVarString( "mat_sky_scale", "1.5" )
			SetConVarString( "mat_sky_color", "1.0 1.0 1.0 1.0" )
		break
		
		case 2:
			SetConVarToDefault( "mat_autoexposure_force_value" )
			SetConVarString( "mat_sun_color", "1.0 1.0 1.0 1.0" )
			SetConVarString( "mat_sun_scale", "0.7" )
			SetConVarString( "mat_sky_scale", "0.7" )
			SetConVarString( "mat_sky_color", "1.0 1.0 1.0 1.0" )
		break
		
		case 3:
			SetConVarToDefault( "mat_autoexposure_force_value" )
			SetConVarString( "mat_sun_color", "1.0 1.0 1.0 1.0" )
			SetConVarString( "mat_sun_scale", "0.7" )
			SetConVarString( "mat_sky_scale", "0.7" )
			SetConVarString( "mat_sky_color", "1.0 1.0 1.0 1.0" )
		break
		
		case 4:
			SetConVarToDefault( "mat_autoexposure_force_value" )
			SetConVarString( "mat_sun_color", "1.0 1.0 1.0 1.0" )
			SetConVarString( "mat_sun_scale", "1" )
			SetConVarString( "mat_sky_scale", "1.5" )
			SetConVarString( "mat_sky_color", "1.0 1.0 1.0 1.0" )
		break
		
		default:
			SetConVarToDefault( "mat_autoexposure_force_value" )
			SetConVarToDefault( "mat_autoexposure_max" )
			SetConVarToDefault( "mat_autoexposure_max_multiplier" )
			SetConVarToDefault( "mat_autoexposure_min" )
			SetConVarToDefault( "mat_autoexposure_min_multiplier" )

			SetConVarToDefault( "mat_sky_scale" )
			SetConVarToDefault( "mat_sky_color" )
			SetConVarToDefault( "mat_sun_scale" )
			SetConVarToDefault( "mat_sun_color" )
		break
	}	
}

#if CLIENT
void function SetCustomXYOffsetsMapScaleAndImageOnFullmapAndMinimap(asset image, float mapscale, float xoffset, float yoffset)
{
	file.currentMapImage = image 
	file.mapscale = mapscale
	
	UpdateImageAndScaleOnFullmapRUI( image, mapscale) //fullmap
	UpdateImageAndScaleOnMinimapRUI( image, mapscale) //minimap
	
	file.currentY_Offset = yoffset * mapscale
	file.currentX_Offset = xoffset * mapscale
}

void function RefreshImageAndScaleOnMinimapAndFullmap()
{
	UpdateImageAndScaleOnFullmapRUI( file.currentMapImage, file.mapscale ) //fullmap
	UpdateImageAndScaleOnMinimapRUI( file.currentMapImage, file.mapscale ) //minimap
}

void function HACK_TrackPlayerPositionOnScript(var rui, entity player, bool isFullmap) //used by fullmap and minimap to show player arrows on them without using RuiTrack so we can add offsets and use it with custom prop maps placed anywhere in the sky. Colombia
{
	if( !IsValid(player) ) return
	
	//EndSignal( player, "OnDeath" )

	string ruiname1
	string ruiname2
	
	if(isFullmap)
	{
		ruiname1 = "objectPos"
		ruiname2 = "objectAngles"
	} else 
	{
		ruiname1 = "playerPos"
		ruiname2 = "playerAngles"
	}
	
	while(IsValid(player))
	{
		RuiSetFloat3( rui, ruiname1, Vector( player.GetOrigin().x + file.currentX_Offset, player.GetOrigin().y + file.currentY_Offset, 0 ) )
		RuiSetFloat3( rui, ruiname2, Vector( player.CameraAngles().x, player.CameraAngles().y, 0 ) )
		
		WaitFrame()
	}
}
#endif

void function FlowstateSND_InitMenuElements()
{
	var dataTable = GetDataTable( $"datatable/flowstate_snd_buy_menu_data.rpak" )
	int numRows   = GetDatatableRowCount( dataTable )

	file.AllMenuElements.clear()

	for ( int i = 0; i < numRows; ++i )
	{
		weaponMenuElement menuElement
		menuElement.menuID = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "menuID" ) )
		menuElement.weaponID = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "weaponID" ) )
		menuElement.icon = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "icon" ) )
		menuElement.tier = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "tier" ) )
		menuElement.text = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "text1" ) )
		menuElement.name = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "name" ) )
		menuElement.price_base = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "price_base" ) )
		menuElement.weaponref = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "weaponref" ) )
		menuElement.price_upgrade1 = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "price_upgrade1" ) )
		menuElement.price_upgrade2 = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "price_upgrade2" ) )
		menuElement.price_upgrade3 = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "price_upgrade3" ) )
		menuElement.price_upgrade4 = GetDataTableInt( dataTable, i, GetDataTableColumnByName( dataTable, "price_upgrade4" ) )
		
		file.AllMenuElements.append( menuElement  )
	}

}

array<weaponMenuElement> function GetAllBuyMenuElements()
{
	return file.AllMenuElements
}

int function GetWeaponIDFromRef(string weaponRef)
{
	for(int i = 0; i < GetAllBuyMenuElements().len(); i++)
	{
		if(GetAllBuyMenuElements()[i].weaponref == weaponRef)
			return GetAllBuyMenuElements()[i].weaponID
	}
	
	return -1
}

int function GetWeaponPriceFromRef(string weaponRef)
{
	for(int i = 0; i < GetAllBuyMenuElements().len(); i++)
	{
		if(GetAllBuyMenuElements()[i].weaponref == weaponRef)
			return GetAllBuyMenuElements()[i].price_base
	}
	
	return -1
}

int function GetWeaponPriceFromRefAndUpgradeLevel(int upgradedlvl, string weaponRef)
{
	printt("Getting price for upgrade # " + upgradedlvl)
	
	for(int i = 0; i < GetAllBuyMenuElements().len(); i++)
	{
		if(GetAllBuyMenuElements()[i].weaponref == weaponRef)
		{
			switch(upgradedlvl)
			{
				case -1:	
					return GetAllBuyMenuElements()[i].price_base
				break
				
				case 0:
					return GetAllBuyMenuElements()[i].price_upgrade2
				break
				
				case 1:
					return GetAllBuyMenuElements()[i].price_upgrade3
				break
				
				case 2:
					return GetAllBuyMenuElements()[i].price_upgrade4
				break
			}
		}
	}
	
	return -1
}

#if CLIENT
void function ServerCallback_ToggleBombUIVisibility(bool visible)
{
	// Hud_SetVisible( HudElement( "BombStateText_NewBlur" ), visible)
	Hud_SetVisible( HudElement( "BombStateText_New" ), visible)
	Hud_SetVisible(HudElement( "SNDTempRoundTimer" ), visible)
	Hud_SetVisible(HudElement( "BombStateScreenBlur2" ), visible)
	Hud_SetVisible(HudElement( "BombStateScreenBlur1" ), visible)
}

void function ServerCallback_SetBombState(int bombState)
{
	entity player = GetLocalClientPlayer()
	
	file.currentBombState = bombState
	
	string bombStateText
	var elem = HudElement( "BombStateText_New" )
	
	switch(bombState)
	{
		case 0:
			bombStateText = ""
			return
		break
		
		case 1:
			if(player.GetTeam() == Sh_GetAttackerTeam())
			{
				bombStateText = "BOMB CARRIED"
				if( SURVIVAL_CountItemsInInventory( player, "snd_bomb" ) == 1 )
					bombStateText = "YOU HAVE THE BOMB"
				Hud_ColorOverTime( elem, AIRDROP_R, AIRDROP_G, AIRDROP_B, 255, 0.35 )
				EmitSoundOnEntity(GetLocalViewPlayer(), "HUD_Boost_Card_Earned_1P")
			} else if(player.GetTeam() == Sh_GetDefenderTeam())
			{
				bombStateText = "ENEMY BOMB CARRIED"
				Hud_ColorOverTime( elem, LOCAL_R, LOCAL_G, LOCAL_B, 255, 0.35 )
			}
		break
		
		case 2:
			if(player.GetTeam() == Sh_GetAttackerTeam())
			{
				bombStateText = "PLANT THE BOMB"
				EmitSoundOnEntity(GetLocalViewPlayer(), "HUD_MP_BountyHunt_BankBonusPts_Deposit_End_Unsuccessful_1P")
			}
			else if(player.GetTeam() == Sh_GetDefenderTeam())
				bombStateText = "ENEMY BOMB IDLE"
			
			Hud_ColorOverTime( elem, LOCAL_R, LOCAL_G, LOCAL_B, 255, 0.35 )
		break
		
		case 3:
			bombStateText = "BOMB PLANTED!"
			thread ColorChangeLoop_Test(elem)
			EmitSoundOnEntity(GetLocalViewPlayer(), "HUD_MP_BountyHunt_BankBonusPts_Deposit_End_Successful_3P")
		break
		
		case 4:
			if(player.GetTeam() == Sh_GetAttackerTeam())
			{
				bombStateText = "BOMB EXPLODED!"
				Hud_SetColor( elem, PARTY_R, PARTY_G, PARTY_B, 255)
			} else if(player.GetTeam() == Sh_GetDefenderTeam())
			{
				bombStateText = "ENEMY BOMB EXPLODED!"
				Hud_SetColor( elem, 233, 10, 66, 255 )
			}	
		break
		
		case 5:
			if(player.GetTeam() == Sh_GetAttackerTeam())
			{
				bombStateText = "BOMB DEFUSED!"
				Hud_SetColor( elem, 233, 10, 66, 255 )
			} else if(player.GetTeam() == Sh_GetDefenderTeam())
			{
				bombStateText = "ENEMY BOMB DEFUSED!"
				Hud_SetColor( elem, PARTY_R, PARTY_G, PARTY_B, 255)
			}
			
		break
	}
	
	Hud_SetText( elem, bombStateText)
}

void function ServerCallback_SetBombStateFromfile()
{
	entity player = GetLocalClientPlayer()
	
	int bombState = file.currentBombState
	
	string bombStateText
	var elem = HudElement( "BombStateText_New" )
	
	switch(bombState)
	{
		case 0:
			bombStateText = ""
			return
		break
		
		case 1:
			if(player.GetTeam() == Sh_GetAttackerTeam())
			{
				bombStateText = "BOMB CARRIED"
				if( SURVIVAL_CountItemsInInventory( player, "snd_bomb" ) == 1 )
					bombStateText = "YOU HAVE THE BOMB"
				Hud_ColorOverTime( elem, AIRDROP_R, AIRDROP_G, AIRDROP_B, 255, 0.35 )
				EmitSoundOnEntity(GetLocalViewPlayer(), "HUD_Boost_Card_Earned_1P")
			} else if(player.GetTeam() == Sh_GetDefenderTeam())
			{
				bombStateText = "ENEMY CARRYING BOBM"
				Hud_ColorOverTime( elem, LOCAL_R, LOCAL_G, LOCAL_B, 255, 0.35 )
			}
		break
		
		case 2:
			if(player.GetTeam() == Sh_GetAttackerTeam())
			{
				bombStateText = "PLANT THE BOMB"
				EmitSoundOnEntity(GetLocalViewPlayer(), "HUD_MP_BountyHunt_BankBonusPts_Deposit_End_Unsuccessful_1P")
			}
			else if(player.GetTeam() == Sh_GetDefenderTeam())
				bombStateText = "ENEMY BOMB ON GROUND"
			
			Hud_ColorOverTime( elem, LOCAL_R, LOCAL_G, LOCAL_B, 255, 0.35 )
		break
		
		case 3:
			bombStateText = "BOMB PLANTED!"
			thread ColorChangeLoop_Test(elem)
			EmitSoundOnEntity(GetLocalViewPlayer(), "HUD_MP_BountyHunt_BankBonusPts_Deposit_End_Successful_3P")
		break
		
		case 4:
			if(player.GetTeam() == Sh_GetAttackerTeam())
			{
				bombStateText = "BOMB EXPLODED!"
				Hud_SetColor( elem, PARTY_R, PARTY_G, PARTY_B, 255)
			} else if(player.GetTeam() == Sh_GetDefenderTeam())
			{
				bombStateText = "ENEMY BOMB EXPLODED!"
				Hud_SetColor( elem, 233, 10, 66, 255 )
			}	
		break
		
		case 5:
			if(player.GetTeam() == Sh_GetAttackerTeam())
			{
				bombStateText = "BOMB DEFUSED!"
				Hud_SetColor( elem, 233, 10, 66, 255 )
			} else if(player.GetTeam() == Sh_GetDefenderTeam())
			{
				bombStateText = "ENEMY BOMB DEFUSED!"
				Hud_SetColor( elem, PARTY_R, PARTY_G, PARTY_B, 255)
			}
			
		break
	}
	
	Hud_SetText( elem, bombStateText)
}

void function RefreshUITestColorsIdk(int test)
{
	var elem = HudElement( "BombStateText_New" )
	
	switch(test)
	{
		case 0:
		Hud_SetColor( elem, 255, 88, 33, 255 )
		break
		
		case 1:
		Hud_SetColor( elem, 207, 101, 66, 255 )
		break
		
		case 2:
		Hud_SetColor( elem, 240, 70, 14, 255 )
		break
		
		case 3:
		Hud_SetColor( elem, 171, 67, 7, 255 )
		break
		
		default:
		Hud_SetColor( elem, 233, 10, 66, 255 )
		break
	}
}

void function ColorChangeLoop_Test( var elem )
{
	WaitFrame()
	
	entity player = GetLocalClientPlayer()
	
	EndSignal( player, "SND_EndTimer")
	
	OnThreadEnd(
		function() : ( elem )
		{
			Hud_SetText( elem, "DEBUG THIS")
			Hud_SetColor( elem, LOCAL_R, LOCAL_G, LOCAL_B, 255 )
			Hud_ColorOverTime( elem, 233, 10, 66, 255, EXPLODE_BOMB_TIME )
			thread AnotherBombTimer(elem)
		}
	)
	
	float endtime = Time() + 3
	
	if(player.GetTeam() == Sh_GetAttackerTeam())
	{
		Hud_SetColor( elem, 91, 255, 31, 255 )
	} else if(player.GetTeam() == Sh_GetDefenderTeam())
	{
		Hud_SetColor( elem, 233, 10, 66, 255 )
	}
	
	while ( Time() <= endtime )
		WaitFrame()
}

void function AnotherBombTimer(var elem)
{
	int elapsedtime = int(file.bombEndTime) - Time().tointeger()
	
	if(elapsedtime == 0) return
	
	entity player = GetLocalClientPlayer()
	EndSignal(file.bombEntity, "OnDestroy")
	string oldendtime
	
	while ( Time() <= file.bombEndTime )
	{
		if(elem == null) break

		string initialString
		if(GetLocalClientPlayer().GetTeam() == Sh_GetAttackerTeam())
			initialString = "BOMB EXPLODING IN " + file.bombTime
		else if(GetLocalClientPlayer().GetTeam() == Sh_GetDefenderTeam())
			initialString = "DEFUSE BOMB IN " + file.bombTime
		
		try{
			if(oldendtime != file.bombTime)
				Hud_SetText( elem, initialString)
		}catch(e420){}
		
		oldendtime = file.bombTime
		WaitFrame()
	}
}
#endif

array<sidesSpawns> function GetSidesSpawns()
{
	return file.sidesSpawns
}

array<bombPlantingLocations> function GetBombPlantingLocations()
{
	return file.bombPlantingLocations
}

bool function CanPlantBombHere(entity player)
{
	if(!IsValid(player)) 
		return false

	if(player.GetTeam() != Sh_GetAttackerTeam())
		return false

	bool hasBomb = SURVIVAL_CountItemsInInventory( player, "snd_bomb" ) == 1

	if( !hasBomb )
		return false

	float playerDistToA = Distance2D( player.GetOrigin(), file.bombPlantingLocations[0].A )
	float playerDistToB = Distance2D( player.GetOrigin(), file.bombPlantingLocations[0].B )

	if ( playerDistToA <= SND_AllowedPlantRadius || playerDistToB <= SND_AllowedPlantRadius)
	{
		printt("player is allowed to plant bomb")
		return true
	}

	#if CLIENT
	if( GetLocalViewPlayer() != GetLocalClientPlayer() ) return false

	SND_QuickHint("Bomb can't be planted here", false)
	#endif
	return false
}

#if SERVER
void function AddHintInPlantZone()
{
	if( file.visualsPlantingLocations.len() < 2 ) return

	foreach( player in GetPlayerArray() )
	{
		if(!IsValid(player)) continue
		
		if( IsValid(file.visualsPlantingLocations[0]) )
		{
			Remote_CallFunction_Replay( player, "ServerCallback_AddPlantZoneInGameHintA", file.visualsPlantingLocations[0], false)
			AddLocationAToMinimap( file.visualsPlantingLocations[0] )
		}
		
		if( IsValid(file.visualsPlantingLocations[1]) )
		{
			Remote_CallFunction_Replay( player, "ServerCallback_AddPlantZoneInGameHintB", file.visualsPlantingLocations[1], false)
			AddLocationBToMinimap( file.visualsPlantingLocations[1] )
		}
	}
}

void function AddBombToMinimap( entity mover )
{
	if(!IsValid(mover)) return
	
	entity minimapObj = CreatePropScript( $"mdl/dev/empty_model.rmdl", mover.GetOrigin() )
	minimapObj.Minimap_SetCustomState( eMinimapObject_prop_script.BOMB )
	minimapObj.SetParent( mover )
	SetTargetName( minimapObj, "hotZone" )
	foreach ( player in GetPlayerArray() )
	{
		minimapObj.Minimap_AlwaysShow( 0, player )
	}
}

void function AddLocationAToMinimap( entity mover )
{
	entity minimapObj = CreatePropScript( $"mdl/dev/empty_model.rmdl", mover.GetOrigin() )
	minimapObj.Minimap_SetCustomState( eMinimapObject_prop_script.SND_A )
	minimapObj.SetParent( mover )
	SetTargetName( minimapObj, "hotZone" )
	foreach ( player in GetPlayerArray() )
	{
		minimapObj.Minimap_AlwaysShow( 0, player )
	}
}

void function AddLocationBToMinimap( entity mover )
{
	entity minimapObj = CreatePropScript( $"mdl/dev/empty_model.rmdl", mover.GetOrigin() )
	minimapObj.Minimap_SetCustomState( eMinimapObject_prop_script.SND_B )
	minimapObj.SetParent( mover )
	SetTargetName( minimapObj, "hotZone" )
	foreach ( player in GetPlayerArray() )
	{
		minimapObj.Minimap_AlwaysShow( 0, player )
	}
}

#endif

void function Sh_SetAttackerTeam( int team, int currentRound ) //Initial attacker team, only used on round start
{
	file.currentAttackerTeam = team
	file.currentRound = currentRound
	
	#if CLIENT
	if(file.currentAttackerTeam == GetLocalClientPlayer().GetTeam())
	{
		Hud_SetText( HudElement( "LocalRoleText" ) , "Attacking" )
		Hud_SetText( HudElement( "EnemyRoleText" ) , "Defending" )
	}
	else
	{
		Hud_SetText( HudElement( "LocalRoleText" ) , "Defending" )
		Hud_SetText( HudElement( "EnemyRoleText" ) , "Attacking" )
	}
	#endif	
}

int function Sh_GetAttackerTeam()
{
	return file.currentAttackerTeam
}

int function Sh_GetDefenderTeam()
{
	if( Sh_GetAttackerTeam() == TEAM_IMC )
		return TEAM_MILITIA
	else if( Sh_GetAttackerTeam() == TEAM_MILITIA )
		return TEAM_IMC
	
	return 5
}

#if SERVER
void function SND_DestroyCircleFXEntity()
{
	foreach(visual in file.visualsPlantingLocations)
		if(IsValid(visual))
			visual.Destroy()
	
	file.visualsPlantingLocations.clear()
}
#endif

#if CLIENT
void function ServerCallback_AddPlantZoneInGameHintA( entity circle, bool pinToEdge )
{
	thread function () : (circle, pinToEdge)
	{
		while ( !IsValid( circle ) )
			WaitFrame()
		
		if(!IsValid(circle)) return
		
		if(file.plantSiteHint1 != null)
		{
			RuiDestroyIfAlive( file.plantSiteHint1 )
			file.plantSiteHint1 = null
		}
		
		var rui = CreateFullscreenRui( $"ui/overhead_icon_generic.rpak", HUD_Z_BASE - 20 )
		asset icon = $""

		if(GetLocalClientPlayer().GetTeam() == Sh_GetAttackerTeam())
			icon = $"rui/flowstatecustom/A_Attack"
		else if(GetLocalClientPlayer().GetTeam() == Sh_GetDefenderTeam())
			icon = $"rui/flowstatecustom/A_Defend"		

		RuiSetImage( rui, "icon", icon )
		RuiSetBool( rui, "isVisible", true )
		RuiSetBool( rui, "pinToEdge", pinToEdge )
		RuiTrackFloat3( rui, "pos", circle, RUI_TRACK_OVERHEAD_FOLLOW )
		RuiSetFloat2( rui, "iconSize", <35,35,0> )
		RuiSetFloat( rui, "distanceFade", 100000 )
		RuiSetBool( rui, "adsFade", true )
		
		string initialString
		
		if(GetLocalClientPlayer().GetTeam() == Sh_GetAttackerTeam())
			initialString = "Plant Bomb"
		else if(GetLocalClientPlayer().GetTeam() == Sh_GetDefenderTeam())
			initialString = "Defend Planting"
			
		RuiSetString( rui, "hint", initialString )
		
		file.plantSiteHint1 = rui
	}()
}

void function ServerCallback_AddPlantZoneInGameHintB( entity circle, bool pinToEdge )
{
	thread function () : (circle, pinToEdge)
	{
		while ( !IsValid( circle ) )
			WaitFrame()

		if(!IsValid(circle)) return
			
		if(file.plantSiteHint2 != null)
		{
			RuiDestroyIfAlive( file.plantSiteHint2 )
			file.plantSiteHint2 = null
		}
		
		var rui = CreateFullscreenRui( $"ui/overhead_icon_generic.rpak", HUD_Z_BASE - 20 )
		asset icon = $""

		if(GetLocalClientPlayer().GetTeam() == Sh_GetAttackerTeam())
			icon = $"rui/flowstatecustom/B_Attack"
		else if(GetLocalClientPlayer().GetTeam() == Sh_GetDefenderTeam())
			icon = $"rui/flowstatecustom/B_Defend"		

		RuiSetImage( rui, "icon", icon )
		RuiSetBool( rui, "isVisible", true )
		RuiSetBool( rui, "pinToEdge", pinToEdge )
		RuiTrackFloat3( rui, "pos", circle, RUI_TRACK_OVERHEAD_FOLLOW )
		RuiSetFloat2( rui, "iconSize", <35,35,0> )
		RuiSetFloat( rui, "distanceFade", 100000 )
		RuiSetBool( rui, "adsFade", true )
		
		string initialString
		
		if(GetLocalClientPlayer().GetTeam() == Sh_GetAttackerTeam())
			initialString = "Plant Bomb"
		else if(GetLocalClientPlayer().GetTeam() == Sh_GetDefenderTeam())
			initialString = "Defend Planting"
			
		RuiSetString( rui, "hint", initialString )
		
		file.plantSiteHint2 = rui
	}()
}
void function ServerCallback_OnBombPlantedInGameHint( entity bomb, float endTime)
{
	thread function () : (bomb, endTime)
	{
		while ( !IsValid( bomb ) )
			WaitFrame()
		
		if(!IsValid(bomb)) return

		if(file.plantSiteHint1 == null)
			return
		
		if(file.plantSiteHint2 != null)
		{
			RuiDestroyIfAlive( file.plantSiteHint2 )
			file.plantSiteHint2 = null
		}
		
		file.bombEndTime = endTime
		file.bombEntity = bomb
		
		asset icon = $""
		
		if( Distance2D( bomb.GetOrigin(), file.bombPlantingLocations[0].A ) <= Distance2D( bomb.GetOrigin(), file.bombPlantingLocations[0].B ) )
		{
			if(GetLocalClientPlayer().GetTeam() == Sh_GetAttackerTeam())
				icon = $"rui/flowstatecustom/A_Defend"
			else if(GetLocalClientPlayer().GetTeam() == Sh_GetDefenderTeam())
				icon = $"rui/flowstatecustom/A_Attack"
		} else
		{
			if(GetLocalClientPlayer().GetTeam() == Sh_GetAttackerTeam())
				icon = $"rui/flowstatecustom/B_Defend"	
			else if(GetLocalClientPlayer().GetTeam() == Sh_GetDefenderTeam())
				icon = $"rui/flowstatecustom/B_Attack"
		}

		var rui = file.plantSiteHint1

		RuiTrackFloat3( rui, "pos", bomb, RUI_TRACK_OVERHEAD_FOLLOW )
		RuiSetImage( rui, "icon", icon )
		
		thread Thread_Timer(bomb, endTime, rui)
		
		file.plantSiteHint1 = rui
	}()
}

void function Thread_Timer(entity bomb, float endtime, var rui)
{
	int elapsedtime = int(endtime) - Time().tointeger()
	
	if(elapsedtime == 0) return
	
	entity player = GetLocalClientPlayer()
	EndSignal(bomb, "OnDestroy")
	
	while ( Time() <= endtime )
	{
		if(rui == null) break
		
        elapsedtime = int(endtime) - Time().tointeger()

		DisplayTime dt = SecondsToDHMS( elapsedtime )
		
		file.bombTime = format( "%.2d", dt.seconds )
		
		string initialString
		if(GetLocalClientPlayer().GetTeam() == Sh_GetAttackerTeam())
			initialString = "Defend " + file.bombTime + "s"
		else if(GetLocalClientPlayer().GetTeam() == Sh_GetDefenderTeam())
			initialString = "Defuse " + file.bombTime + "s"
		
		try{
		RuiSetString( rui, "hint", initialString )}catch(e420){}
		
		wait 1
	}
}

void function ServerCallback_ForceZoneHintDestroy(bool isA)
{
	if(isA)
	{
		if(file.plantSiteHint1 != null)
		{
			RuiDestroyIfAlive( file.plantSiteHint1 )
			file.plantSiteHint1 = null
		}
	}
	else
	{
		if(file.plantSiteHint2 != null)
		{
			RuiDestroyIfAlive( file.plantSiteHint2 )
			file.plantSiteHint2 = null
		}
	}
}

void function SND_HintCatalog(int index, int eHandle)
{
	if(!IsValid(GetLocalViewPlayer())) return

	switch(index)
	{
		case 0:
		// SND_QuickHint( "You have the bomb!", true, 4)
		break
		
		case 1:
		// SND_QuickHint( "You dropped the bomb", false, 3)
		break

		case 3:
		// SND_QuickHint( "Bomb planted!", false, 5)
		// EmitSoundOnEntity(GetLocalViewPlayer(), "vdu_on")
		break
		
		case 4:
		SND_QuickHint( "All attackers are dead \nDefuse the bomb before it explodes", true, 5)
		EmitSoundOnEntity(GetLocalViewPlayer(), "vdu_on")
		break

		case 5:
		Obituary_Print_Localized( "Bomb model and textures by VishnuRajan in Sketchfab.com", GetChatTitleColorForPlayer( GetLocalViewPlayer() ), BURN_COLOR )
		Obituary_Print_Localized( "Shoothouse, de_cache and NCanals maps by @DEAFPS_", GetChatTitleColorForPlayer( GetLocalViewPlayer() ), BURN_COLOR )
		Obituary_Print_Localized( "de_dust2 map by @CafeFPS and Darkes", GetChatTitleColorForPlayer( GetLocalViewPlayer() ), BURN_COLOR )
		Obituary_Print_Localized( "%$rui/flowstate_custom/colombia_flag_papa% Made in Colombia with love by @CafeFPS.", GetChatTitleColorForPlayer( GetLocalViewPlayer() ), BURN_COLOR )
		break
		
		case 6:
		SND_QuickHint( "No bomb", false, 2)
		break
		
		case 7:
		SND_QuickHint( "You're not an attacker", false, 2)
		EmitSoundOnEntity(GetLocalViewPlayer(), "vdu_on")
		break
		
		case 8:
		SND_QuickHint( "+$" + eHandle +" Player Killed", true, 3)
		break
		
		case 9:
		SND_QuickHint( "+$" + eHandle +" Bomb Planted", true, 3)
		EmitSoundOnEntity(GetLocalViewPlayer(), "HUD_MP_BountyHunt_BankBonusPts_Deposit_Start_1P")
		break
		
		case 10:
		SND_QuickHint( "Defuse the bomb", false, 4)
		EmitSoundOnEntity(GetLocalViewPlayer(), "HUD_MP_BountyHunt_BankBonusPts_Deposit_Start_1P")
		break

		case 11:
		SND_QuickHint( "Bomb Carrier Disconnected", true, 3)
		Obituary_Print_Localized( "Bomb Carrier Disconnected - Spawning new bomb", GetChatTitleColorForPlayer( GetLocalViewPlayer() ), BURN_COLOR )
		EmitSoundOnEntity(GetLocalViewPlayer(), "HUD_MP_BountyHunt_BankBonusPts_Deposit_End_Unsuccessful_1P")
		break
		
		case 12:
		SND_QuickHint( "Press %scriptCommand4% to plant the bomb", true, 3)
		break
		
		case 13:
		SND_QuickHint( "", true, 3)
		break

		case 14:
		SND_QuickHint( "Press %scriptCommand5% to throw the bomb", true, 30)
		break
	}
}

void function SND_HintCatalog_WithEntity(int index, entity playerToShow)
{
	if( !IsValid( playerToShow ) ) return

	switch(index)
	{
		case 0:
		
		SND_QuickHint( playerToShow.GetPlayerName() + " is carrying the bomb", true, 5)
		break
		
		case 1:
		//unused rn
		//SND_QuickHint( "+500 Bomb Planted", true, 4)
		break

		case 2:

		SND_QuickHint( playerToShow.GetPlayerName() + " dropped the bomb", false, 5)
		break
	}
}

void function SND_QuickHint( string hintText, bool blueText = false, float duration = 2.5)
{
	if(file.activeQuickHint != null || hintText == "" && file.activeQuickHint != null)
	{
		RuiDestroyIfAlive( file.activeQuickHint )
		file.activeQuickHint = null
		if( hintText == "" )
			return
	}
	file.activeQuickHint = CreateFullscreenRui( $"ui/announcement_quick_right.rpak" )
	
	RuiSetGameTime( file.activeQuickHint, "startTime", Time() )
	RuiSetString( file.activeQuickHint, "messageText", hintText )
	RuiSetFloat( file.activeQuickHint, "duration", duration.tofloat() )
	
	if(blueText)
		RuiSetFloat3( file.activeQuickHint, "eventColor", SrgbToLinear( <48, 107, 255> / 255.0 ) )
	else
		RuiSetFloat3( file.activeQuickHint, "eventColor", SrgbToLinear( <255, 0, 119> / 255.0 ) )
}

void function SND_ToggleScoreboardVisibility(bool show)
{
    Hud_SetVisible(HudElement( "LocalTeamWinsText" ), show)
	Hud_SetEnabled( HudElement( "LocalTeamWinsText" ), show)
	
    Hud_SetVisible(HudElement( "EnemyTeamWinsText" ), show)
	Hud_SetEnabled( HudElement( "EnemyTeamWinsText" ), show)	

    Hud_SetVisible(HudElement( "RoundNumberText" ), show)
	Hud_SetEnabled( HudElement( "RoundNumberText" ), show)

	// Hud_SetVisible(HudElement( "SNDMoneyBG" ), show)
	Hud_SetVisible(HudElement( "SND_AvailableMoney" ), show)

	Hud_SetVisible(HudElement( "ScoreboardBG" ), show)
	Hud_SetEnabled( HudElement( "ScoreboardBG" ), show)
	
	Hud_SetVisible(HudElement( "RoundTextText" ), show)
	Hud_SetEnabled( HudElement( "RoundTextText" ), show)
	
	Hud_SetVisible(HudElement( "LocalTeamIcon" ), show)
	Hud_SetVisible(HudElement( "EnemyTeamIcon" ), show)

	Hud_SetVisible(HudElement( "LocalRoleText" ), show)
	Hud_SetVisible(HudElement( "EnemyRoleText" ), show)
	
	//Hud_SetVisible(HudElement( "BombStateText_New" ), show)
	
	//var test = HudElement( "BombStateText_New" )
	//Hud_SetColor( test, 130, 130, 155, 255 )
	//Hud_ColorOverTime( test, 255, 0, 0, 255, 5 )	
	//thread ColorChangeLoop_Test(test)
	
	if(!show) return
	
	// var elem = HudElement( "BombStateText_New" )
	// Hud_SetText( elem, "")


	SND_UpdateUIScore()
	
	if( file.currentAttackerTeam == GetLocalClientPlayer().GetTeam() )
	{
		Hud_SetText( HudElement( "LocalRoleText" ) , "Attacking" )
		Hud_SetText( HudElement( "EnemyRoleText" ) , "Defending" )
	}
	else
	{
		Hud_SetText( HudElement( "LocalRoleText" ) , "Defending" )
		Hud_SetText( HudElement( "EnemyRoleText" ) , "Attacking" )
	}
}

void function SND_ToggleMoneyUI(bool show)
{
    // Hud_SetVisible(HudElement( "SNDMoneyBG" ), show)
    Hud_SetVisible(HudElement( "SND_AvailableMoney" ), show)
}

void function SND_UpdateUIScore()
{
	entity player = GetLocalClientPlayer()
	
	int localwins = 0
	int enemywins = 0
	
	if( player.GetTeam() == TEAM_IMC )
	{
		localwins = file.IMCWins
		RuiSetImage( Hud_GetRui( HudElement( "LocalTeamIcon" ) ), "basicImage", $"rui/flowstatecustom/imc" )
		enemywins = file.MILITIAWins
		RuiSetImage( Hud_GetRui( HudElement( "EnemyTeamIcon" ) ), "basicImage", $"rui/flowstatecustom/militia" )
	}
	else if( player.GetTeam() == TEAM_MILITIA )
	{
		RuiSetImage( Hud_GetRui( HudElement( "LocalTeamIcon" ) ), "basicImage", $"rui/flowstatecustom/militia" )
		localwins = file.MILITIAWins
		enemywins = file.IMCWins
		RuiSetImage( Hud_GetRui( HudElement( "EnemyTeamIcon" ) ), "basicImage", $"rui/flowstatecustom/imc" )
	}

	Hud_SetText( HudElement( "LocalTeamWinsText"), localwins.tostring() ) 
	Hud_SetText( HudElement( "EnemyTeamWinsText"), enemywins.tostring() )
	
	//Force destroy quick hint
	if(file.activeQuickHint != null)
	{
		RuiDestroyIfAlive( file.activeQuickHint )
		file.activeQuickHint = null
	}
}

void function SND_UpdateUIScoreOnPlayerConnected(int currentRound, int imcWins, int militiaWins)
{
	file.IMCWins = imcWins
	file.MILITIAWins = militiaWins
	file.currentRound = currentRound
}

#endif

int function SND_GetIMCWins()
{
	return file.IMCWins
}

int function SND_GetMilitiaWins()
{
	return file.MILITIAWins
}

void function AddRoundPointToWinner_IMC()
{
	file.IMCWins++
}

void function AddRoundPointToWinner_Militia()
{
	file.MILITIAWins++
}

void function AddRoundPointTied()
{
	file.tiedRounds++
}

void function ClearMatchPoints()
{
	file.IMCWins = 0
	file.MILITIAWins = 0
}

int function ReturnTeamWins(int team)
{
	if(team == TEAM_IMC)
		return file.IMCWins
	else if(team == TEAM_MILITIA)
		return file.MILITIAWins
	
	return 0
}

#if SERVER
void function SpawnVotePhaseCustomMaps()
{
    //Starting Origin, Change this to a origin in a map 
    vector startingorg = <-170.155441, 459.880646, 11300.2012>
	
	array<entity> propsToHide
	
    //Props 
    propsToHide.append( MapEditor_CreateProp( $"mdl/beacon/construction_scaff_128_64_64.rmdl", < 73.4395, -207.7539, 432.0925 > + startingorg, < 0, 103.1070, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 344.2891, -503.0156, 270.8157 > + startingorg, < 0.0454, -86.9994, 0.4673 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 239.3594, -56.7344, 439.2305 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/containers/underbelly_cargo_container_128_blue_02.rmdl", < 141.4395, -68.6953, 442.4927 > + startingorg, < 0, 77.9807, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 318.4492, -96.9141, 439.2305 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/grass_icelandic_04.rmdl", < 194.6484, -90.8750, 443.2957 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 354.7988, -560.9941, 436.4436 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 367.5684, -230.1250, 439.1145 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -105.5508, -127.1348, 402.9895 > + startingorg, < -0.1354, 81.7961, -0.4496 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 390.7988, -317.3438, 432.1465 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/grass_icelandic_04.rmdl", < 241.5684, -277.6250, 447.7085 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 126.8184, -30.1445, 439.2305 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 293.9492, -114.3340, 271.0896 > + startingorg, < -0.4695, 8.5525, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 53.4492, -552.1348, 330.9895 > + startingorg, < 0.3032, 138.7758, -0.3585 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 135.8789, -275.7656, 446.0825 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < -6.1504, -73.5742, 439.2305 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 21.7481, 134.1660, 269.1897 > + startingorg, < -0.4695, 8.5525, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 361.0684, -437.5449, 440.0435 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/beacon/construction_scaff_128_64_64.rmdl", < 103.3379, -335.3555, 559.9927 > + startingorg, < 0, 103.1070, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/beacon/construction_scaff_128_64_64.rmdl", < 103.3379, -335.3555, 432.0925 > + startingorg, < 0, 103.1070, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/beacon/construction_scaff_128_64_64.rmdl", < 26.2383, -285.9551, 432.0925 > + startingorg, < 0, 103.1070, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 386.0391, -81.4746, 439.2305 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/grass_icelandic_04.rmdl", < 348.9883, -289.5840, 439.6956 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 204.0488, -151.0352, 439.2305 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/beacon/construction_scaff_128_64_64.rmdl", < 43.7383, -80.0547, 432.0925 > + startingorg, < 0, 103.1070, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 144.1289, -167.1855, 439.2305 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 323.7891, 7.1348, 439.2305 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -239.5508, 94.8652, 266.9895 > + startingorg, < -0.4695, 8.5525, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 267.4492, 60.8652, 271.0896 > + startingorg, < -0.4695, 8.5525, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/beacon/construction_scaff_128_64_64.rmdl", < 41.1387, -349.7539, 560.3926 > + startingorg, < 0, 103.1070, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/beacon/construction_scaff_128_64_64.rmdl", < 26.2383, -285.9551, 560.3926 > + startingorg, < 0, 103.1070, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/beacon/construction_scaff_128_64_64.rmdl", < 103.3379, -335.3555, 688.1926 > + startingorg, < 0, 103.1070, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 330.4492, -239.1348, 270.9895 > + startingorg, < 0.0454, -86.9994, 0.4673 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 220.8496, -569.8340, 286.1897 > + startingorg, < -0.3001, 58.8163, -0.3611 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 295.2188, -233.9551, 439.1145 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 265.4883, -607.8047, 446.1995 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 6.1582, 21.5645, 268.8896 > + startingorg, < -0.4695, 8.5525, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/grass_icelandic_04.rmdl", < 246.7891, -476.5645, 451.5415 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/beacon/construction_scaff_128_64_64.rmdl", < 41.1387, -349.7539, 432.0925 > + startingorg, < 0, 103.1070, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 219.8496, -257.0742, 446.0825 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 200.4492, -365.4238, 446.0825 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -118.5508, -356.0352, 403.0896 > + startingorg, < -0.1354, 81.7961, -0.4496 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 134.8496, -354.1348, 282.6897 > + startingorg, < -0.4695, 8.5525, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 73.0488, -149.8750, 439.2305 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/beacon/construction_scaff_128_64_128_02.rmdl", < 166.5996, -350.7441, 432.0925 > + startingorg, < 0, -76.8930, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 32.6582, -153.6348, 268.8896 > + startingorg, < -0.4695, 8.5525, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 38.3281, -267.0547, 439.2305 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -186.1504, -358.4355, 496.8896 > + startingorg, < -0.4424, 28.1136, -0.1572 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/beacon/construction_scaff_128_64_64.rmdl", < 11.4395, -222.1543, 560.3926 > + startingorg, < 0, 103.1070, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 266.7695, -482.6055, 451.8896 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 286.5078, -352.5352, 433.6565 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/grass_icelandic_04.rmdl", < 325.9980, -143.9551, 442.3667 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/beacon/construction_scaff_128_64_64.rmdl", < 58.5391, -143.9551, 432.0925 > + startingorg, < 0, 103.1070, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/beacon/construction_scaff_128_64_64.rmdl", < 88.2383, -271.5547, 432.0925 > + startingorg, < 0, 103.1070, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 211.7480, -690.4648, 330.9895 > + startingorg, < 0.3032, 138.7758, -0.3585 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 109.7480, -566.4648, 332.3015 > + startingorg, < 0.3032, 138.7758, -0.3585 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 82.8984, -797.6250, 330.9895 > + startingorg, < 0.3032, 138.7758, -0.3585 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -75.4004, -659.2949, 330.9895 > + startingorg, < 0.3032, 138.7758, -0.3585 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < -166.2520, -560.4648, 406.3015 > + startingorg, < 0.3032, 138.7758, -0.3585 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 368.1777, -710.8848, 330.9895 > + startingorg, < 0.3032, 138.7758, -0.3585 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/rocks/rock_sharp_lava_moss_desertlands_06.rmdl", < 239.3184, -818.0449, 330.9895 > + startingorg, < 0.3032, 138.7758, -0.3585 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 427.3887, -859.0352, 506.8425 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 352.8281, -774.0254, 506.8425 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 457.1191, -738.8340, 499.8745 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1.1614 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/grass_icelandic_04.rmdl", < 359.7285, -647.0352, 487.9397 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/grass_icelandic_04.rmdl", < 331.7285, -677.0352, 487.9397 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 124.3789, -649.0645, 500.0366 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 60.1777, -575.8652, 500.0366 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 149.9785, -545.5645, 500.0366 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 387.0781, -542.4355, 439.4185 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/icelandic_moss_grass_02.rmdl", < 389.0781, -436.1348, 442.5186 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/ground_plant_desertlands_01_group_01.rmdl", < 293.0996, -240.4648, 442.5657 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/foliage/ground_plant_desertlands_01_group_01.rmdl", < 313.0996, -434.4648, 446.5657 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/vehicle/goblin_dropship/goblin_dropship.rmdl", < 155.2285, -721.8555, 497.8096 > + startingorg, < 0, 21.4195, 0 >, true, 50000, -1, 1 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/levels_terrain/mp_rr_desertlands/desertlands_godrays_zone_5_01.rmdl", < -248.8613, -334.5547, 793.3926 > + startingorg, < 0, 89.9999, 0 >, true, 50000, -1, 0.15942 ) )
    propsToHide.append( MapEditor_CreateProp( $"mdl/levels_terrain/mp_rr_desertlands/desertlands_godrays_zone_16_01.rmdl", < 25.1387, 89.4453, 469.3926 > + startingorg, < 0, 0, 0 >, true, 50000, -1, 0.03373526 ) )

	file.propsToHide = propsToHide
	
    //PlayerClips 
    array<entity> playerClips 
    playerClips.append( MapEditor_CreateProp( $"mdl/desertlands/highrise_square_top_01.rmdl", < 72, -257.3066, 441.5011 > + startingorg, < 0, 0, -179.9997 >, true, 50000, -1, 1 ) )

    foreach( entity clip in playerClips ) {
        clip.MakeInvisible()
        clip.kv.solid = SOLID_VPHYSICS
        clip.kv.CollisionGroup = TRACE_COLLISION_GROUP_PLAYER
        clip.kv.contents = CONTENTS_PLAYERCLIP
    }
}

void function ToggleBuyMenuBackgroundProps(bool enable)
{
	foreach(prop in file.propsToHide)
		if(IsValid(prop))
		{
			if(!enable)
				prop.MakeInvisible()
			else
				prop.MakeVisible()
		}
}
#endif
