global function Flowstate_LgDuels1v1_Init									//mkos

const string HIT_0 = "UI_Survival_Intro_LaunchCountDown_3Seconds"
const string HIT_1 = "UI_InGame_MarkedForDeath_CountdownToMarked"
const string HIT_2 = "NONE"
const string HIT_3 = "menu_click"
const string HIT_4 = "Weapon_R1_Satchel.ArmedBeep"
const string HIT_5 = "ui_callerid_chime_friendly"
const string HIT_6 = "Wpn_ArcTrap_Beep"
const string HIT_7 = "UI_Menu_accept"
const string HIT_8 = "UI_MapPing_Location_1P"
const string HIT_9 = "UI_DownedAlert_Friendly"
const string HIT_10 = "UI_MapPing_Item_1P"
const string HIT_11 = "UI_MapPing_Undo_1P"
const string HIT_12 = "UI_MapPing_Local_Confirm_1P"
const string HIT_13 = "UI_MapPing_Acknowledge_1P"
const string HIT_14 = "UI_Survival_Intro_PreLegendSelect_Countdown"
const string HIT_15 = "Flesh.Shotgun.BulletImpact_Headshot_3P_vs_1P"
const string HIT_16 = "jackhammer_pickup"

const float VAMP_STEAL_AMOUNT = 3.0

void function Flowstate_LgDuels1v1_Init()
{
	if( MapName() == eMaps.mp_rr_canyonlands_staging && Playlist() == ePlaylists.fs_lgduels_1v1 )
	{
		AddCallback_FlowstateSpawnsSettings( InitPreSpawnSystemSettings)	
		SetCallback_FlowstateSpawnsOffset( LGDuels_Spawns_Offset ) //used to move all spawns by an offset
		AddCallback_FlowstateSpawnsPostInit( Init_LGDuels_Spawns )
	}
	else
	{
		AddCallback_FlowstateSpawnsSettings
		(
			void function()
			{
				SpawnSystem_SetCustomPlaylist( AllPlaylistsArray()[ ePlaylists.fs_1v1 ] ) //override hack
			}
		)
		
	}

	#if TRACKER && HAS_TRACKER_DLL
		if( Flowstate_IsLGDuels() )
		{
			AddCallback_PlayerData( "LgDuelsSetting", LgDuelLoadSettings )
		}	
	#endif
	
	AddCallback_OnClientConnected( INIT_LGDuels_Player )
}

void function ZeroDamage( entity player, var damageInfo )
{
	DamageInfo_SetDamage( damageInfo, 0 )
}

void function InitPreSpawnSystemSettings()
{
	SpawnSystem_SetCustomPak( "datatable/fs_spawns_lgduels.rpak" )
}

void function INIT_LGDuels_Player( entity player )
{
	AddEntityCallback_OnDamaged( player, LGDuel_OnPlayerDamaged )
	
	if( MapName() == eMaps.mp_rr_canyonlands_staging && Playlist() == ePlaylists.fs_lgduels_1v1 )
		AddEntityCalllback_OnPlayerGamestateChange_1v1( player, Player1v1Gamestate )

	// if( !EntityCallback_Exists( player, ZeroDamage ) )
		// AddEntityCallback_OnDamaged( player, ZeroDamage )

	AddClientCommandCallback( "hitsound", ClientCommand_mkos_LGDuel_hitsound )
	AddClientCommandCallback( "handicap", ClientCommand_mkos_LGDuel_p_damage )
	
	#if TRACKER && HAS_TRACKER_DLL
		AddClientCommandCallback( "SaveLgSettings", ClientCommand_mkos_LGDuel_settings )
	#endif
	
	player.p.hitsound = HIT_0
	
	CreatePanelText( player, "", "LG Duels by @CafeFPS and..", < 3450.38, -9592.87, -9888.37 >, < 354.541, 271.209, 0 >, false, 1.5, 1)
	CreatePanelText( player, "mkos ", "", < 3472.44, -9592.87, -9888.37 >, < 354.541, 271.209, 0 >, false, 3, 2)
}

void function Player1v1Gamestate( entity player, int state )
{
	#if DEVELOPER
		Warning( "state called for: " + string( player ) + " state = " + DEV_GetGamestateRef( state ) )
	#endif
	
	switch( state )
	{
		case e1v1State.INVALID:
		case e1v1State.MATCH_START:
		case e1v1State.WAITING:
		
			if( !EntityCallback_Exists( player, ZeroDamage ) )
				AddEntityCallback_OnDamaged( player, ZeroDamage )
			break 
		
		case e1v1State.RESTING:
		case e1v1State.RECAP:

			if( !EntityCallback_Exists( player, ZeroDamage ) )
				AddEntityCallback_OnDamaged( player, ZeroDamage )
			
			//player.SetTakeDamageType( DAMAGE_NO )
			AddEntityCallback_OnPlayerRespawned_FireOnce
			(
				player,
				
				void function( entity player )
				{
					//DeployAndEnableWeapons( player )
					TakeAllWeapons( player )
					
					Gamemode1v1_GiveWeapon( player, "mp_weapon_lightninggun", WEAPON_INVENTORY_SLOT_PRIMARY_0 )
					Gamemode1v1_GiveWeapon( player, "mp_weapon_lightninggun", WEAPON_INVENTORY_SLOT_PRIMARY_1 )
					Survival_SetInventoryEnabled( player, true )
					SetPlayerInventory( player, [] )
			
					EnableOffhandWeapons( player )
					DeployAndEnableWeapons( player )
				}
			)
			break
		
		case e1v1State.MATCHING:
			if( EntityCallback_Exists( player, ZeroDamage ) )
				RemoveEntityCallback_OnDamaged( player, ZeroDamage )	
				
			break
	}	
}

void function LgDuelLoadSettings( entity player, string data )
{
	if( data == "NA" || data == "" )
		return
	
	array<string> values = split( data, "|" )
	
	if( values.len() < 8 )
		return
	
	foreach( str in values )
	{
		if( !IsNumeric( str ) )
		{
			#if DEVELOPER
				sqerror( "Data for lgduel setting not numeric: " + str + ";Data:" + data )
			#endif 
			
			return
		}
	}
	
	Remote_CallFunction_NonReplay
	( 
		player, 
		"ServerCallback_SetLGDuelPesistenceSettings", 
		values[0].tofloat(), 
		values[1].tointeger(), 
		values[2].tointeger(), 
		values[3].tointeger(), 
		values[4].tofloat(), 
		values[5].tointeger(), 
		values[6].tointeger(), 
		values[7].tointeger() 
	)
}


//LGDuel
void function LGDuel_OnPlayerDamaged( entity victim, var damageInfo )
{	
	if ( !IsValid( victim ) || !victim.IsPlayer() || Bleedout_IsBleedingOut( victim ) ) 
		return
	
	entity attacker = InflictorOwner( DamageInfo_GetAttacker(damageInfo) )
	//int sourceId = DamageInfo_GetDamageSourceIdentifier( damageInfo )

	if ( IsValid(attacker) && attacker.IsPlayer() && IsAlive( attacker ) )
	{
		float atthealth = float( attacker.GetHealth() )
		
		if ( atthealth < attacker.GetMaxHealth() )
		{
			attacker.SetHealth( min( atthealth + VAMP_STEAL_AMOUNT, float( attacker.GetMaxHealth() ) ) )
		}
		
		attacker.p.totalLGHits++
		
		if( attacker.p.totalLGShots == 0 )
			return

		attacker.SetPlayerNetInt( "accuracy", int( ( float( attacker.p.totalLGHits ) / float( attacker.p.totalLGShots ) )*100 ) )
	}
}

bool function ClientCommand_mkos_LGDuel_settings( entity player, array<string> args )
{
	if( args.len() == 0 )
		return false
	
	if( !IsSafeString( args[0], 50 ) )
		return false
	
	SavePlayerData( player, "LgDuelsSetting", args[0] )
	
	return true
}

LocPairData function Init_LGDuels_Spawns()
{
	SpawnLGProps()
	SpawnLGProps2()
				
	LocPair panels = NewLocPair( < 3480.92, -9218.92, -10252 >, < 360, 270, 0 > )
	
	Gamemode1v1_SetWaitingRoomRadius( 2400 )
	
	return SpawnSystem_CreateLocPairObject( [], false, null, panels )
}

LocPair function LGDuels_Spawns_Offset()
{
	return NewLocPair( LG_DUELS_OFFSET_ORIGIN, ZERO_VECTOR )
}

string function IntToSound( string num )
{
	switch (num)
	{
		case "0": return HIT_0
		case "1": return HIT_1
		case "2": return HIT_2
		case "3": return HIT_3
		case "4": return HIT_4
		case "5": return HIT_5
		case "6": return HIT_6
		case "7": return HIT_7
		case "8": return HIT_8
		case "9": return HIT_9
		case "10": return HIT_10
		case "11": return HIT_11
		case "12": return HIT_12
		case "13": return HIT_13
		case "14": return HIT_14
		case "15": return HIT_15
		case "16": return HIT_16
		default: return HIT_0;
	}
	
	unreachable	
}
	
	
bool function ClientCommand_mkos_LGDuel_hitsound( entity player, array<string> args )
{
	if ( !CheckRate( player ) ) 
		return false
	
	string param = ""
	
	if ( args.len() > 0 )
	{
		param = args[0]
	}
	
	
		if( args.len() < 1 )
		{
			// Moved to lg duels drop down menu 
			//Message( player, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Hitsounds:", " Type into console: hitsound # \n replacing # with a number below\n\n\n\n 0 = Default \n  1 = CountDown \n 2 = None \n 3 = Click \n 4 = Armed \n 5 = Chime \n 6 = Beep \n 7 = Menu \n 8 = Ping \n 9 = Downed \n 10 = Ping2 \n 11 = Ping3 \n 12 = Ping4 \n 13 = Ping5  \n 14 = Countdown2 \n 15 = Shotgun \n 16 = Pickup ", 15)
			return true
		}				
					
		if( args.len() > 0 && !IsNumeric( param, 0, 16 ) )
		{
			LocalMsg( player, "#FS_FAILED", "#FS_HitsoundNumFail" )
			return true
		} 
			
		try
		{	
			player.p.hitsound = IntToSound( param )
			Remote_CallFunction_ByRef( player, "ForceScoreboardLoseFocus" )
			LocalMsg( player, "#FS_SUCCESS", "#FS_HitsoundChanged", eMsgUI.DEFAULT, 3, "", param )
			return true	
		} 
		catch ( hiterr )
		{
			return true
		}
				
	return false
					
}

//purpose of this client command: allow lg duelers to enable a handicap ( idk quake gods wanted it )
bool function ClientCommand_mkos_LGDuel_p_damage( entity player, array<string> args )
{
	if ( !CheckRate( player ) ) 
		return false
	
	string param = ""
	
	if ( args.len() > 0 )
	{
		param = args[0];
	}
	
	if ( args.len() < 1 || param == "" )
	{
		LocalMsg( player, "#FS_HandicapTitle", "#FS_HandicapSubstr", eMsgUI.DEFAULT, 15 )
		return true
	}				
	
	switch( param.tolower() )
	{
	
		case "on":
		case "1":
					try
					{
						
						player.p.p_damage = 2;
						Remote_CallFunction_ByRef( player, "ForceScoreboardLoseFocus" )
						LocalMsg( player, "#FS_SUCCESS", "#FS_HandicapOnSubstr", eMsgUI.DEFAULT, 3 )
						return true
					
					} 
					catch ( handicap_err_1 )
					{		
						return true					
					}
		
		case "off":
		case "0":
					try
					{
						
						player.p.p_damage = 3;
						Remote_CallFunction_ByRef( player, "ForceScoreboardLoseFocus" );
						LocalMsg( player, "#FS_SUCCESS", "#FS_HandicapOffSubstr", eMsgUI.DEFAULT, 3 )
						return true
					
					} 
					catch ( handicap_err_2 )
					{
						return true
					}
			
	}
		
	return false					
}