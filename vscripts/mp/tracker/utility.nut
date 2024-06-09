global function GetAdminList																	//~mkos
global function EnableVoice
global function empty
global function StringToArray
global function trim
global function Concatenate
global function IsNumeric
global function IsNum
global function GetPlayer
global function GetPlayerEntityByUID
global function GetPlayerEntityByName
global function IsValidOID
global function Is_Bool
global function sanitize
global function LineBreak
global function printarray
global function CheckRate
global function ParseWeapon
global function IsWeaponValid
global function ClientCommand_mkos_return_data
global function ClientCommand_mkos_admin
global function ClientCommand_ParseSay
global function Commands
global function INIT_CC_MapNames
global function INIT_CC_GameTypes
global function INIT_CC_playeradmins
global function update
global function TrackerWepTable
global function exclude
global function ReturnValue
global function ReturnKey
global function GetDefaultIBMM
global function SetDefaultIBMM
global function IsTrackerAdmin
global function PlayTime
global function truncate
global function DEV_PrintTrackerWeapons
global function GetTrackerWeaponIdentifierTable
global function ValidateIBMMWaitTime

#if TRACKER && HAS_TRACKER_DLL
	global function PrintMatchIDtoAll
#endif

//const
//global const int SQ_MAX_INT_32 = 2147483647;
//global const int SQ_MIN_INT_32 = -2147483647;

//tables 
table<string, string> player_admins
table<string,int> WeaponIdentifiers = {}

//arrays 
array< array< string > > list_maps
array< array< string > > list_gamemodes

struct {

	array <string> ADMINS
	bool stop_update_msg_flag = false

} file


	void function INIT_CC_MapNames()
	{
		list_maps = 
		[
			["dropoff", "mp_rr_arena_composite"],
			["overflow", "mp_rr_aqueduct"],
			["firingrange", "mp_rr_canyonlands_staging"],
			["kingscanyon", "mp_rr_canyonlands_64k_x_64k"],
			["kingscanyons2", "mp_rr_canyonlands_mu1"],
			["kingscanyonafterdark", "mp_rr_canyonlands_mu1_night"],
			["worldsedge", "mp_rr_desertlands_64k_x_64k"],
			["worldsedgeafterdark", "mp_rr_desertlands_64k_x_64k_nx"],
			["miragevoyage", "mp_rr_desertlands_64k_x_64k_tt"],
			["partycrasher", "mp_rr_party_crasher"],
			["skygarden", "mp_rr_arena_skygarden"],
			["ashsredemption", "mp_rr_ashs_redemption"],
			["overflownight", "mp_rr_aqueduct_night"]
		];	
	}
	
	void function INIT_CC_GameTypes()
	{
	
		list_gamemodes = [
			["1v1", "fs_1v1"],
			["dm", "fs_dm"],
			["tdm", "fs_tdm"],
			["prophunt", "fs_prophunt"],
			["duckhunt", "fs_duckhunt"],
			["solobr", "fs_survival_solos"],
			["duobr", "fs_survival_duos"],
			["triobr", "fs_survival_trios"],
			["surf", "fs_surf"],
			["gym", "fs_movementgym"],
			["infected", "fs_infected"],
			["survival", "fs_survival"],
			["survivaldev", "survival_dev"]
		];
	}
	
	//client command: show
		bool function ClientCommand_mkos_return_data(entity player, array<string> args)
		{
			if (!CheckRate( player )) return false
			
			player.p.messagetime = Time()
			
			if ( args.len() < 1)
			{	
				Message( player, "\n\n\nUsage: ", " showdata argument \n\n\n Arguments:\n map - Shows current map name \n round - Shows current round number \n input - Shows a list of players and their current input", 5 )
				return true;	
			}
			
			string requestedData = args[0];
			string param = "";
			
			if ( args.len() >= 2 )
			{
				param = args[1]
			}

			switch(requestedData)
			{

				case "map":
					//sqprint( GetMapName() )
					Message( player, "Mapname:", GetMapName(), 5 )
					return true;
				case "round":
					//sqprint( GetCurrentRound().tostring() )
					Message( player, "Round:", GetCurrentRound().tostring(), 5 )
					return true;
				case "player":
						
						string stringHandicap = "";
						string handicap = "";
						string p_input = "";
						string data = "";
						string inputmsg = "";
						float kd = 0.0
						string kd_string = "";
						int kills = 0;
						int deaths = 0;
						string l_oid = "";
						string l_name = "";
						float l_wait = 0.0
						
						if ( param == "" )
						{
							Message( player, "Failed", " Command 'player' requires playername/oid as first param. ")
							return true;
						}
							
							try
							{	
								
								if ( param.len() > 16 )
								{
									Message( player, "Failed", "Input exceeds char limit. ")
									return true;
								}
								
								entity l_player = GetPlayer( param )
								
								if ( !IsValid( l_player ) )
								{
									Message( player, "Failed", "Player: " + param + " - is invalid. ")
									return true;
								}			
								
								if ( Flowstate_IsLGDuels() )
								{
									handicap = l_player.p.p_damage == 2 ? "On" : "Off";
									stringHandicap = "---- Handicap: " + handicap; 
								}
								
								p_input = l_player.p.input > 0 ? "Controller" : "MnK"; 
								kills = l_player.p.season_kills + player.GetPlayerNetInt( "kills" )
								deaths = l_player.p.season_deaths + player.GetPlayerNetInt( "deaths" )
								l_name = l_player.GetPlayerName()
								l_oid = l_player.GetPlatformUID()
								l_wait = l_player.p.IBMM_grace_period
								inputmsg = "Player: " + l_name + " OID: " + l_oid;
								
								if (deaths > 0) 
								{
									kd = getkd( kills, deaths )
								}
								
								data += "Season Kills: " + kills + " ---- Deaths: " + deaths + " ---- KD: " + kd + "\n"; 
								data += "Input:  " + p_input + stringHandicap + "\n"; 
								data += "wait time:  " + l_wait.tostring() + "\n"; 
								data += GetScore(l_player) + "\n";
								data += "Season playtime: " + PlayTime(l_player.p.season_playtime) + "\n";
								data += "Season games: " + l_player.p.season_gamesplayed + "\n";
								data += "Season score: " + l_player.p.season_score;
								
								if( (inputmsg.len() + data.len()) > 599 )
								{
									Message( player, "Failed", "Cannot execute this command currently due to return data resulting in overflow" )
									return true;
								}
								
								Message( player, inputmsg, data, 15);
								
							} 
							catch (errlookup) 
							{
								Message(player, "Failed", "Command failed because of: \n\n " + errlookup )
								return false
							}
							
							return true;
		
				
				case "input":
						
						
						string handicap = "";
						string p_input = "";					
						string data = "";
						string inputmsg = "Current Player Inputs";
						
						try 
						{
							foreach ( active_player in GetPlayerArray() )
							{	
								handicap = active_player.p.p_damage == 2 ? "On" : "Off";
								p_input = active_player.p.input > 0 ? "Controller" : "MnK"; 
								data += "Player: " + active_player.GetPlayerName() + " is using: " + p_input + " ---- Handicap: " + handicap + "\n"; 
							}
							
							
							if( ( inputmsg.len() + data.len()) > 599 )
							{
								Message( player, "Failed", "Cannot execute this command currently due to return data resulting in overflow" )
								return true;
							}
							
							Message( player, inputmsg, data, 20);	
						} 
						catch (show_err) 
						{
							Message(player, "Failed", "Command failed because of: \n\n " + show_err )
							return false			
						}
						
						
						return true;
						
				case "inputs":
				
						int controllerCount = 0;
						int mnkCount = 0;
						
						foreach ( active_player in GetPlayerArray() )
						{
							if ( active_player.p.input == 0 )
							{
								mnkCount++;
							}
							else if ( active_player.p.input == 1 )
							{
								controllerCount++;
							}
						}
						
						string cplural = controllerCount > 1 || controllerCount == 0 ? "s" : "";
						string mplural = mnkCount > 1 || mnkCount == 0 ? "s" : "";
						
						
						string countMsg = format("%d controller player%s \n %d mnk player%s", controllerCount, cplural, mnkCount, mplural );
						Message( player, "There is currently", countMsg, 7 )
						
						return true;
						
				case "stats":
						
						string data = "";
						string inputmsg = bGlobalStats() ? "Current Player Global Stats" : "Current Player Round Stats";
						float kd = 0.0
						string kd_string = "";
						int kills = 0;
						int deaths = 0;
						string global_stats_msg = bGlobalStats() ? " Season Stats:" : " Current Round Stats:";
						
						try 
						{
						
							foreach ( active_player in GetPlayerArray() )
							{
								kills = active_player.p.season_kills + player.GetPlayerNetInt( "kills" )
								deaths = active_player.p.season_deaths + player.GetPlayerNetInt( "deaths" )
								
								if (deaths > 0) 
								{
									kd = getkd( kills, deaths )
								}
								
								kd_string = kd != 0.0 ? kd.tostring() : "N/A";

								data += "Player: " + active_player.GetPlayerName() + global_stats_msg + " Kills: " + kills + " ---- Deaths: " + deaths + " ---- KD: " + kd + "\n"; 
							}
							
							
							if( (inputmsg.len() + data.len()) > 599 )
							{
								Message( player, "Failed", "Cannot execute this command currently due to return data resulting in overflow" )
								return true;
							}
							
							Message( player, inputmsg, data, 20);
						
						} 
						catch (show_err2) 
						{
		
							Message(player, "Failed", "Command failed because of: \n\n " + show_err2 )
							return false
									
						}
						
						
						return true;
						
				case "aa":
					
						string data = "";
						string inputmsg = "Server AA values:";
						
						try 
						{
							
							data += format("\n Console Aim Assist: %.1f ", GetCurrentPlaylistVarFloat("aimassist_magnet", 0) );
							data += format("\n PC Aim Assist: %.1f", GetCurrentPlaylistVarFloat("aimassist_magnet_pc", 0) );
									
							if( (inputmsg.len() + data.len()) > 599 )
							{	
								Message( player, "Failed", "Cannot execute this command currently due to return data resulting in overflow" )
								return true;		
							}
							
							Message( player, inputmsg, data, 20);
						
						} 
						catch (show_err3) 
						{
		
							Message(player, "Failed", "Command failed because of: \n\n " + show_err3 )
							return false
									
						}
						
						return true
					
				case "id":
				
				#if TRACKER && HAS_TRACKER_DLL
					
					string data = "";
					string inputmsg = ":::: Match ID ::::";
					
					try 
					{
						
						data += format("\n\n %s ", SQMatchID__internal() );
								
						if( (inputmsg.len() + data.len()) > 599 )
						{	
							Message( player, "Failed", "Cannot execute this command currently due to return data resulting in overflow" )
							return true;		
						}
						
						Message( player, inputmsg, data, 20);
					
					} 
					catch (show_err4) 
					{

						Message(player, "Failed", "Command failed because of: \n\n " + show_err4 )
						return false
								
					}
					
				#endif 
				
					return true;

					
				default:
					//sqprint ( "Usage: show argument \n" )
					Message( player, "Failed: ", "Usage: show argument \n", 5 )
					return true;
			}
			return false;
		}
		
		

	void function INIT_CC_playeradmins()
	{	
		string admins_list = "";
		string pair;
		
		#if TRACKER && HAS_TRACKER_DLL
			admins_list = SQ_GetSetting__internal("settings.ADMINS")
		#endif
		
		if( admins_list != "" )
		{
			#if DEVELOPER 
				sqprint("Admins loaded from r5r_dev.json")
			#endif
		}
		else 
		{
			admins_list = GetCurrentPlaylistVarString( "admins_list", "" )
		}
		
		if ( empty( admins_list ) ){ return }
		
		AddCallback_OnClientConnected( CheckAdmin_OnConnect )
		
		try 
		{
			array<string> list = StringToArray( admins_list )
		
			foreach ( admin_pair in list )
			{	
				pair = admin_pair
				array<string> a_format = split( admin_pair, "-")
				player_admins[a_format[0]] <- a_format[1];
				file.ADMINS.append(a_format[1])
			}
			
		}
		catch(erradmin)
		{
			sqerror("Error with adminpair: " + pair + " Error: " + erradmin )
		}
	
	}
	
	array<string> function GetAdminList()
	{
		return file.ADMINS;
	}
	

	string function PlayTime( int iSeconds ) 
	{	
		float seconds = iSeconds.tofloat();
		float hours =  seconds / 3600;
		float minutes = (seconds % 3600) / 60;
		float r_seconds = seconds % 60;
		
		string playtime = format("%d hours, %d minutes, %d seconds", hours, minutes, r_seconds);
		return playtime;
	}

	//////////////////////////////////////////////////////////////////////////
	//cc commands
	bool function ClientCommand_mkos_admin(entity player, array<string> args)
	{	
		
		if (!CheckRate( player )) return false
		
		string PlayerName = player.GetPlayerName();
		string PlayerUID = player.GetPlatformUID();

  
		if (PlayerName in player_admins) {
		
			if ( player_admins[PlayerName] != PlayerUID ) {
				return false;
			}
			
		} else { return false }

		player.p.messagetime = Time()	
		
		string command = "";
		string param = "";
		string param2 = "";
		string param3 = "";
		string param4 = "";
		
		if (args.len() > 0){
			command = args[0];
		}
		
		if (args.len() > 1){
			param = args[1];
		}
		
		if (args.len() > 2){
			param2 = args[2];
		}
		
		if (args.len() > 3){
			param3 = args[3];
		}
		
		if (args.len() > 4){
			param4 = args[4];
		}
		
		switch(command.tolower()){  
			
			case "help":	
			
			
							try 
							{
								Message( player, "Commands:", "A command is entered as: \n\n cc command #param #param2.  \n\n cc kick #name/oid   - Kicks a player by name/oid \n cc afk #0/1   - disabled or enables afk to rest mode \n cc playself #audiofile   - Plays audiofile to self \n cc playall #audiofile    - Plays audiofile to all player \n cc sayall '#title' '#message' #duration   - says to all \n cc ban #name/oid #reason    - Bans a player \n cc unban #oid   - attempts to unban a player by OID \n cc map #name #mode   - reloads map \n cc playerinput #name/oid   - shows players input \n cc playerinfo  - some stats", 20 )
							} 
							catch (err) 
							{ 
								return false 
							}
					
							return true
				
				
			case "kick":	
							
							if ( args.len() < 2 )
							{
								Message( player, "Failed", "kick requires name/id for 1st param of command" )
								return false
							}
			
							try 
							{		
								entity k_player;
								string k_playeroid;
								string reason = param2;	
								
								k_player = GetPlayer( param );
								
								if ( !IsValid(k_player) )
								{
									Message( player, "Failed", "Player: " + param + " - is invalid. ")
									return true;
								}
									
								k_playeroid = k_player.GetPlatformUID()	
								
								if ( IsTrackerAdmin(k_playeroid) ){
									Message( player, "Cannot kick admin")
									return true
								}
							
								KickPlayerById( k_playeroid, reason )
								UpdatePlayerCounts()
								
								Message( player, "Kicked player", "PUID: " + param + " was kicked" )
								return true	
							} 
							catch (erraaarg)
							{
								Message( player, "Error", "Invalid player or argument missing" )
								return true
							}
							
							return true;
				
				
			case "afk":
					
							try {
							
								if ( args[1] == "1" )
								{
									SetAfkToRest( true )
									Message( player, "Command sent", "Afk to rest was ENABLED" )
									return true
								} 
								else if ( args[1] == "0" )
								{
									SetAfkToRest( false )
									Message( player, "Command sent", "Afk to rest was disabled" )
									return true
								} 
							} catch (erroreo){
							
								Message( player, "Error", "argument missing" )
								return false
							}
							
							return true
							
			case "restricted":
			
							try 
							{
							
								if ( args[1] == "1" )
								{
									Tracker_SetRestrictedServer( true )
									Message( player, "Command sent", "restricted_server was ENABLED" )
									return true
								} 
								else if ( args[1] == "0" )
								{
									Tracker_SetRestrictedServer( false )
									Message( player, "Command sent", "restricted_server was disabled" )
									return true
								} 
							} 
							catch (errorres)
							{
								Message( player, "Error", "argument missing" )
								return false
							}
							
							return true
							
			case "playonself": 
			
								
							if ( args.len() < 2 )
							{
								Message( player, "Failed", "playself requires param of audiofile as string" )
								return false
							} 
								
							try 
							{
								EmitSoundOnEntity( player, args[1] )	
							} 
							catch ( erra )
							{
								Message(player, "Failed", "Command failed because of: \n\n " + erra )
								return false	
							}
							
							return true
				
				
			case "playself": 
			
								
							if ( args.len() < 2 )
							{
								Message( player, "Failed", "Command 'playself' requires param of audiofile as string" )
								return false
							} 
								
							try 
							{
								EmitSoundOnEntityOnlyToPlayer( player, player, args[1] )	
							} 
							catch ( erra )
							{			
								Message(player, "Failed", "Command failed because of: \n\n " + erra )
								return false	
							}
							
							return true
							
							
			case "playall":
						
							
							foreach (connected_player in GetPlayerArray())
							{
								try 
								{
									EmitSoundOnEntityOnlyToPlayer( connected_player, connected_player, args[1] )
									return true		
								} 
								catch ( errb )
								{	
									Message(player, "Failed", "Command failed because of: \n\n " + errb )
									return false	
								}
							
							}

							return true
			
							
							
			case "stopplayall":
						
							
							foreach (connected_player in GetPlayerArray())
							{					
								try 
								{
									StopSoundOnEntity( connected_player, args[1] )
									return true	
								} 
								catch ( errb )
								{	
									Message(player, "Failed", "Command failed because of: \n\n " + errb )
									return false
								}
							}

							return true
							
							
					
					
			case "sayall": 
					
							if ( args.len() < 4 )
							{	
								Message( player, "Failed", "Command 'sayall' requires duration for third param of command as float" )
								return false
							} 
							
							foreach ( say_to_player in GetPlayerArray())
							{
								try	
								{	
									Message( say_to_player, param, param2, param3.tofloat())	
								} 
								catch ( errc ){
								
									Message(player, "Failed", "Command failed because of: \n\n " + errc )
									return true
								}
							}
							
					return true
							
			case "sayto": 
		
							if ( param4 == "" || !IsNumeric( param4 ) )
							{			
								param4 = "3"		
							} 	
								try	
								{	
									entity to_player = GetPlayer(param)	
									
									if(IsValid(to_player))
									{
										Message( to_player, param2, param3, param4.tofloat())
									}
									else 
									{
										Message( player, "INVALID PLAYER")
									}
																	
								} 
								catch ( errst )
								{	
									Message(player, "Failed", "Command failed because of: \n\n " + errst )			
								}

							return true
			case "ban":
									
							if ( args.len() < 2 )
							{		
								Message( player, "Failed", "Command 'ban' requires name/id for 1st param of command" )
								return false
							}			
							
							try 
							{		
								entity b_player;
								string b_playeroid;
								string b_reason = param2;	
								
								b_player = GetPlayer( param )
							
								if ( !IsValid( b_player ) )
								{
									Message( player, "Failed", "Player: " + param + " - is invalid. ")
									return true;
								}
								
								b_playeroid = b_player.GetPlatformUID()	
									
								
								if ( IsTrackerAdmin( b_playeroid ) )
								{
									Message( player, "Cannot ban admin")
									return true
								}
							
								BanPlayerById( b_playeroid, b_reason )
								UpdatePlayerCounts()
								
								Message( player, "Success", "Player: " + param + "\n\n was banned for: \n\n" + b_reason )
								return true		
							} 
							catch ( erre )
							{
								Message(player, "Failed", "Command failed because of: \n\n " + erre )
								return false
							}
							
						return true;
			
			case "banid":
			
				#if TRACKER && HAS_TRACKER_DLL
				
						if ( args.len() < 2 )
						{
							Message( player, "Failed", "Command 'banid' requires oid for 1st param of command")
							return false
						}	

							try 
							{
								if ( IsTrackerAdmin(param) )
								{		
									Message( player, "Failed", param + " is an admin. Ban rejected.", 10 )
									return false		
								}
								
								if ( !IsNum(param) )
								{			
									Message( player, "Failed", param + " is not a valid oid format.", 10 )
									return false	
								}
								
								if ( param2 == "")
								{		
									param2 = "0";							
								}
								
								if ( AddBanByID( param2, param ) )
								{					
									Message( player, "Success", param + " was added to the banlist.", 10 )
									return true	
								} 
								else 
								{	
									Message( player, "Failed", "Failed to add player oid: " + param + " to the banlist.", 10 )
									return true		
								}
								
							} 
							catch ( errbanid )
							{
								Message(player, "Failed", "Command failed because of: \n\n " + errbanid )
								return false
							}
							
					#endif 
						return true
					
			case "unban":
			
					
					
						if ( args.len() < 2 )
						{		
							Message( player, "Failed", "Command 'unban' requires id for 1st param of command as string" )
							return false	
						}
						
						try 
						{
							UnbanPlayer( args[1])					
							Message( player, "Success", "ID: " + args[1] + " was supposedly unbanned" )				
							return true
								
						} 
						catch ( erre )
						{	
							Message(player, "Failed", "Command failed because of: \n\n " + erre )
							return false
						}
						
						return true;
								
			case "playerinfo":
			
						try 
						{				
							string nputmsg = "Current Stats:"
							
							string info = Tracker_PrintAllPlayerMetrics( true )
							
							if( (nputmsg.len() + info.len()) > 599 )
							{
								Message( player, "Failed", "Cannot execute this command currently due to return data resulting in overflow" )
								return true;
							}
							
							Message( player, nputmsg, LineBreak(info), 20);
							return true;	
						} 
						catch (errf)
						{	
							Message( player, "Failed", "Command failed because of: \n\n " + errf )
							return false;
						}
						
			//for testing
			
			case "zero":
			#if DEVELOPER && TRACKER && HAS_TRACKER_DLL
						
						if ( args.len() < 1)
						{
							Message( player, "Failed", "Param 1 of command 'zero' requires playername string.")
							return false;	
						}
			
						try 
						{		
							entity z_player = GetPlayerEntityByName(args[1])
							
							if ( !IsValid(z_player) )
							{
								Message( player, "Failed", "Player: " + args[1] + " - is invalid. ")
								return true;
							}
							
							string playeroid = z_player.GetPlatformUID()
							
							int index = DEV_GetPlayerMetricsIndexByUID( playeroid )
							
							if ( index != -1 )
							{	
								foreach ( playerMetrics in Tracker_GetPlayerMetricsArray() ) 
								{
									if ( playerMetrics.playerID == args[1] ) 
									{	
										Tracker_GetPlayerMetricsArray().removebyvalue(playerMetrics);					
									}
								}
								
								Message( player, "Success", "Player " + args[1] + " stats were zeroed. Does not effect kill/death/damage. ")
								return true;	
							}
						
						} 
						catch (errg) 
						{	
							Message( player, "Failed", "Command failed because of: \n\n " + errg )
							return true;	
						}
			#endif
			
			Message( player, "Command only allowed in devmode with tracker" )
					return false
						
			case "playerinput":
						
						if ( args.len() < 1)
						{	
							Message( player, "Failed", "Param 1 of command 'playerinput' requires player name/oid.")
							return true		
						}
						
						try 
						{		
							entity a_player;
							string mode;
							
							a_player = GetPlayer( param )
							
							if ( !IsValid( a_player ) )
							{	
								Message( player, "Failed", "Player: " + param + " -- is invalid" );
								return true
							}
							
							mode = a_player.p.input == 0 ? "Mouse and keyboard" : "Controller";
							
							Message( player, "Success: ", "Current inputmode: " + mode );
							return true
							
						} 
						catch (errh) 
						{		
							Message( player, "Failed", "Command failed because of: \n\n " + errh )
							return true		
						}
					
					return true
		
						
			case "input":	

						if ( args.len() < 1)
						{		
							Message( player, "Failed", "Param 1 of command 'input' requires player name/oid.")
							return true		
						}
						
						
						if ( args.len() < 2)
						{	
							Message( player, "Failed", "Param 2 of command 'input' requires type 0/1.")
							return true		
						}
								
						try 
						{	
							string str = args[2]
							string a_str = str;
							
							if (str == "false"){ a_str = "0" }
							if (str == "true"){ a_str = "1" }
							if (str == "mnk" ){ a_str = "0" }
							if (str == "controller" ) { a_str = "1" }
							
							if ( !Is_Bool(a_str) )
							{	
								Message( player, "Failed", "Incorrect usage, setting input using: " + a_str )
								return false;	
							}
							
							entity select_player =  GetPlayer( param )
							
							if ( !IsValid(select_player) )
							{
								Message( player, "Failed", "Player: " + param + " - is invalid. ")
								return true;
							}
							
							select_player.p.input = a_str.tointeger();
							
							string sayinput = a_str.tointeger() > 0 ? "Controller" : "MnK"; 
							
							Message( player, "Success", "Player " + select_player.GetPlayerName() + "  was changed to input: " + sayinput  )
							return true;
						
						} 
						catch (errj) 
						{		
							Message( player, "Failed", "Command failed because of: \n\n " + errj )
							return false;
						}
						
			case "listhandles":
						
						try 
						{
							string statement = "\n ";
							
							foreach ( list_player in GetPlayerArray() )
							{
								int handle = list_player.GetEncodedEHandle()
								string p_name = list_player.GetPlayerName()
								
								statement += " Player: " + p_name + "   Handle: " + handle + "\n";	
							}
							
							sqprint(statement);
							Message( player, "Handles:", statement, 20)
							
							return true;
						
						} 
						catch (errk) 
						{
							Message( player, "Failed", "Command failed because of: \n\n " + errk )
							return true;		
						}
						
					return true
						
			case "map":
					
						if( GetPlaylistMaps( GetMode(param2) ).contains( GetMap(param) ) )
						{
							GameRules_ChangeMap( GetMap(param) , GetMode(param2) )
						}
						else 
						{	
							Message( player, "MAP NOT IN PLAYLIST" )
							sqerror("Map not in playlist - rejecting load")
						}
						
					return true
					
			case "score":
			
						if ( args.len() < 1)
						{		
							Message( player, "Info", "Param 1 of command 'score' requires player name/oid/*/current/season/difference. \n\n Usage: score player | score * | score current")
							return true			
						}
						
						if ( param == "current" )
						{	
							Message( player, "Success", "'Current KD' server weight setting is:   " + getSbmmSetting( "current_kd_weight" ) )
							return true		
						}
						else if ( param == "season" )
						{	
							Message( player, "Success", "'season KD' server weight setting is:   " + getSbmmSetting( "season_kd_weight" ) )
							return true
						}
						else if ( param == "difference" )
						{	
							Message( player, "Success", "'KD matchmaking difference' server setting is:   " + getSbmmSetting( "SBMM_kd_difference" ) )
							return true
						}
					
						if ( param == "*")
						{			
							try 
							{
								string putmsg = "Success";
								string s_data;
								
								foreach ( score_player in GetPlayerArray() )
								{
									if ( !IsValid( score_player ) ) continue
									
									s_data += GetScore( score_player ) + "\n";
								}
								
								if( ( putmsg.len() + s_data.len() ) > 599 )
								{	
									Message( player, "Failed", "Cannot execute this command currently due to return data resulting in overflow" )
									return true;
								}
							
								Message( player, putmsg, s_data, 20 );
							
							}
							catch (errallscore) 
							{
								Message( player, "Failed", "Command failed because of: \n\n " + errallscore )
								return true;
							}
						
						}
						else
						{
							entity s_player;
									
							s_player = GetPlayer( param )
							
							if ( !IsValid( s_player ) )
							{	
								Message( player, "Failed", "Player: " + param + " -- is invalid" );
								return true
							}
							
							try 
							{
								Message( player, "Success", GetScore( s_player ) );		
							} 
							catch (errscore) 
							{
								Message( player, "Failed", "Command failed because of: \n\n " + errscore )
								return true;			
							}
						
						}
						
					return true
					
			case "scoreconfig":
			
						if ( args.len() < 2)
						{
							Message( player, "Failed", "Param 1 of command 'scoreconfig' requires type: current/season/difference.")
							return true
						}
						
						if ( args.len() < 3)
						{	
							Message( player, "Failed", "Param 2 of command 'scoreconfig' requires float")
							return true	
						}
						
						
						
						try 
						{			
							if ( !IsFloat( param2 ) )
							{
								Message( player, "Failed", "param 3 of command 'scoreconfig' must be numeric type float, \n\n example: 0.8 --            '" + param2 + "' was provided" )
								return true
							}
							
							if ( param == "current" )
							{	
								setSbmmSetting( "current_kd_weight", param2.tofloat() )		
							}
							else if ( param == "season" )
							{		
								setSbmmSetting( "season_kd_weight", param2.tofloat() )				
							}
							else if ( param == "difference" )
							{	
								setSbmmSetting( "SBMM_kd_difference", param2.tofloat() )	
							}
							else
							{
								Message( player, "Failed", "Invalid scoreconfig type: " + param )
								return true
							}	
							
							Message( player, "Success", "Weight for " + param + " KD -- was set to: " + param2 , 5 );
						
						} 
						catch (errsetweight) 
						{
							Message( player, "Failed", "Command failed because of: \n\n " + errsetweight )
							return true;			
						}
						
					return true
					
			case "cleanuplogs":
				
					#if TRACKER && HAS_TRACKER_DLL	
						CleanupLogs__internal()
					#endif
							
						return true
			
			case "reload_config":
			
					#if TRACKER && HAS_TRACKER_DLL	
						SQ_ReloadConfig__internal()
					#endif
						
						return true
						
			case "setting":
						
					#if TRACKER && HAS_TRACKER_DLL	
					
						if ( args.len() < 2)
						{
							Message( player, "Failed", "Param 1 of command 'setting' requires key name")
							return true
						}
						
						
						try 
						{	
							string return_str = "";
							return_str = SQ_GetSetting__internal(param);	
							
							Message( player, param + ":", return_str)
							return true
						} 
						catch (errset) 
						{
							
							Message( player, "Failed", "Command failed because of: \n\n " + errset )
							return true		
						}
					
					#endif
						
					break;
					
			case "spamupdate":
			case "spam":
					
					file.stop_update_msg_flag = false;
					thread RunUpdateMsg()
				
				break;
			
			case "spamstop":
			case "stopspam":
			
					file.stop_update_msg_flag = true;
				
				break;
				
			case "msg":
			
						if ( args.len() < 2)
						{
							Message( player, "Failed", "Param 1 of command 'serversay' requires string")
							return true
						}
						
						
						try 
						{	
							if( !SendServerMessage( param ))
							{
								Message( player, "Error", "Message was truncated")
							}
							
							return true
						} 
						catch (errservermsg) 
						{		
							Message( player, "Failed", "Command failed because of: \n\n " + errservermsg )
							return true		
						}
						
			case "vc":
				
					if ( args.len() < 2)
						{
							Message( player, "Failed", "Param 1 of command 'vc' requires bool: 1/0 true/false on/off enabled/disabled")
							return true
						}
						
						
						try 
						{	
							switch(param)
							{	
								case "1":
								case "true":
								case "on":
								case "enabled":
									SetConVarBool( "sv_voiceenable", true )
									SetConVarBool( "sv_alltalk", true )
									
									if ( GetConVarBool( "sv_voiceenable" ) || GetConVarBool( "sv_alltalk" ) )
									{
										foreach ( active_player in GetPlayerArray() )
										{	
											Message( active_player, "VOICE CHAT ENABLED" )
										}
									}
									else 
									{
										Message( player, "FAILED" )
									}
		
									return true
									
								case "0":
								case "false":
								case "off":
								case "disabled":
									SetConVarBool( "sv_voiceenable", false )
									SetConVarBool( "sv_alltalk", false )
									
									if ( !GetConVarBool( "sv_voiceenable" ) || !GetConVarBool( "sv_alltalk" ) )
									{	
										foreach ( active_player in GetPlayerArray() )
										{	
											Message( active_player, "VOICE CHAT DISABLED" )
										}
									}
									else 
									{
										Message( player, "FAILED" )
									}
									
									return true		
							}
							
							Message( player, "INVALID SETTING" )
							return true
						} 
						catch (errvc) 
						{		
							Message( player, "Failed", "Command failed because of: \n\n " + errvc)
							return true		
						}
				
				
			case "startbr":
					
					SetConVarBool( "sv_cheats", true )
					FlagSet("MinPlayersReached")
					SetConVarBool( "sv_cheats", false )
					
					return true
					
			case "pos":
				
					#if DEVELOPER
					
						if (args.len() < 2)
						{
							Message( player, "NEED TO NAME THE SPAWN" );
							return true
						}
						
						try 
						{
							POS_CC(player,param)
						}
						catch(pos_error)
						{
							Message( player, "Error", "Failed: " + pos_error )
						}
						return true
					#endif
				return false;
			
			case "groups":
			
					Message(player, "\"groupsInProgress\"", getGroupsInProgress().len().tostring())
					return true
					
			case "groupmap":
			
					Message(player, "\"playerToGroupMap\"", getPlayerToGroupMap().len().tostring())
					return true
					
			case "start_interval_thread":

					#if TRACKER
						if( isIntervalThreadRunning() )
						{
							Message( player, "Interval thread is already running." )
							return true 
						}
						
						Message( player, "INTERVAL THREAD STARTING" )
						DEV_StartIntervalThread()
					#endif
					
						return true 
					
			case "kill_interval_thread":
					
					#if TRACKER
						svGlobal.levelEnt.Signal( "KillIntervalThread" ) 
						Message( player, "INTERVAL THREAD STOPPING" )
					#endif
					
					return true
					
			//case "testsend":
			
					//SQ_MsgToClient( param.tointeger(), param2 )
					
					//return true
			case "thumbsup":
				
				SendServerMessage(chat.effects["THUMBSUP"])		
				return true
				
			case "print_chat_effects":
			
				DEV_PrintAllChatEffects()
				return true
				
			case "msgeffect":
					
				SendServerMessage( FindChatEffect( param ) )
				return true
				
			case "nextmap":
			
				RotateMap()
				return true
			
			case "fetchsetting":
			
			#if TRACKER
				entity p = GetPlayer( param )
				
				if ( empty(param2) )
				{
					Message( player, "Parameter 2 was empty" )
					return true 
				}
				
				if( IsValid( p ))
				{
					Message( player, "Data for: " + param, Tracker_FetchPlayerData( p.p.UID, param2 ) )
				}
				else 
				{
					Message( player, "Error", format( "Player: %s was invalid", sanitize(param) ), 7 )
				}
				
			#endif
				return true
				
			case "testremote":
			
				#if DEVELOPER
					Remote_CallFunction_NonReplay( player, "ServerCallback_SetPersistenceSettings", 1, 2, 3, 4)
				#endif
				return true
				
			case "acceptchal":
			
				#if DEVELOPER
					entity p = GetPlayer( param )
					
					if ( !IsValid( p ) )
					{
						printt("Invalid player")
						return true
					}
					
					DEV_acceptchal(p)
				#else 
					printt("Dev mode only")
				#endif 
				
				return true
				
			case "draw":
			
				#if DEVELOPER 
				
					printt("Drawing...")
					foreach( s_player in GetPlayerArray() )
					{
						Remote_CallFunction_NonReplay( s_player, "Minimap_EnableDraw_Internal")
					}
					
				#endif 
				
				return true 
				
			case "disabledraw":
			
				#if DEVELOPER 
				
					printt("Drawing...")
					foreach( s_player in GetPlayerArray() )
					{
						Remote_CallFunction_NonReplay( s_player, "Minimap_DisableDraw_Internal")
					}
					
				#endif 
				
				return true 
				
			case "stoplog":
			
				#if TRACKER && HAS_TRACKER_DLL
				
					bool ship = false 
					
					switch( param )
					{
						case "1":
						case "true":
						case "ship":
							ship = true 
							break
						
						default:
							break
					}
				
					DEV_ManualLogKill( ship )
					Message( player, "TRACKER LOG TERMINATED" )
					
				#endif
				
				return true
				
			case "startlog":
			
				#if TRACKER && HAS_TRACKER_DLL
					if( bLog() )
					{
						DEV_ManualLogStart()
						Message( player, "LOG INITIALIZED" )
					}
					else 
					{
						Message( player, "LOG IS DISABLED IN PLAYLISTS" )
					}
				#endif
				
				return true
				
			case "mute":
			
				entity p = GetPlayer( param )				
				if( !IsValid(p) ){ return true }	
				ToggleMuteForAll( p, true )
				LocalMsg( p, "#FS_MUTED", "", eMsgUI.DEFAULT, 5, "", param2 )
				
				return true
			
			case "unmute":
			
				entity p = GetPlayer( param )				
				if( !IsValid(p) ){ return true }	
				ToggleMuteForAll( p, false )
				LocalMsg( p, "#FS_UNMUTED" )
				
				return true
				
			case "killme":
			
				if( IsAlive( player ) )
				{
					player.Die( null, null, { damageSourceId = eDamageSourceId.damagedef_suicide } )
				}
				return true
				
			case "gamerules":
			
				//TODO: mini framework for parsing valid map/playlist combos
				//CreateServer("","","mp_rr_desertlands_64k_x_64k","fs_survival_solos", 0)		
				
			default:	
						Message( player, "Usage", "cc #command #param1 #param2 #..." )
						return true;
		}
		
		
		return true;
	}


//chat commands
void function ClientCommand_ParseSay( entity player, array<string> args )
{		
    if ( !IsValid(player) || args.len() == 0 )
		return
	
	Commands( player, args )
		return		
}

void function Commands( entity player, array<string> args )
{	
	#if DEVELOPER
		//printarray( args )
	#endif 
	
	switch( args[0].tolower() )
	{	
		case "!wait":
		case "/wait":
		case "\\wait":
			args.remove(0)
			ClientCommand_mkos_IBMM_wait( player, args )
			break
			
		case "!rest":
		case "/rest":
		case "\\rest":
			ClientCommand_Maki_SoloModeRest( player, [] )
			break
			
		case "!info":
		case "/info":
		case "\\info":
			args[0] = "player";
			if(args.len() < 2)
			{
				args.append(player.p.name)
			}
			ClientCommand_mkos_return_data( player, args )
			break 
			
		case "!id":
		case "/id":
		case "\\id":
			ClientCommand_mkos_return_data( player, ["id"] )
			break
			
		case "!aa":
		case "/aa":
		case "\\aa":
			ClientCommand_mkos_return_data( player, ["aa"] )
			break
			
		case "!inputs":
		case "/inputs":
		case "\\inputs":
			ClientCommand_mkos_return_data( player, ["inputs"] )
			break
		
		case "!chal":
		case "!chall":
		case "/chall":
		case "\\chall":
		case "!challenge":
		case "/challenge":
		case "\\challenge":
		case "/chal":
		case "\\chal":
			args[0] = "chal";
			ClientCommand_mkos_challenge( player, args )
			break
		
		case "!accept":
		case "/accept":
		case "\\accept":
			args[0] = "accept";
			ClientCommand_mkos_challenge( player, args )
			break
			
		case "!list":
		case "/list":
		case "\\list":
			args[0] = "list";
			ClientCommand_mkos_challenge( player, args )
			break
			
		case "!end":
		case "/end":
		case "\\end":
			args[0] = "end";
			ClientCommand_mkos_challenge( player, args )
			break
			
		case "!remove":
		case "/remove":
		case "\\remove":
			args[0] = "remove";
			ClientCommand_mkos_challenge( player, args )
			break
			
		case "!clear":
		case "/clear":
		case "\\clear":
			args[0] = "clear";
			ClientCommand_mkos_challenge( player, args )
			break
			
		case "!revoke":
		case "/revoke":
		case "\\revoke":
			args[0] = "revoke";
			ClientCommand_mkos_challenge( player, args )
			break
			
		case "!cycle":
		case "/cycle":
		case "\\cycle":
			args[0] = "cycle";
			ClientCommand_mkos_challenge( player, args )
			break
		
		case "!swap":
		case "/swap":
		case "\\swap":
			args[0] = "swap";		
			ClientCommand_mkos_challenge( player, args )
			break
			
		case "!legend":
		case "/legend":
		case "\\legend":
			args[0] = "legend";
			ClientCommand_mkos_challenge( player, args )
			break
			
		case "!outlist":
		case "/outlist":
		case "\\outlist":
			args[0] = "outlist";
			ClientCommand_mkos_challenge( player, args )
			break
			
	}
}

void function RunUpdateMsg()
{	
	
	string update_title = GetCurrentPlaylistVarString("update_title","Server about to UPDATE");
	string update_msg = GetCurrentPlaylistVarString("update_msg","Server will go down briefly");
	
	while(true)
	{	
		WaitFrame()
		
		if ( file.stop_update_msg_flag == true )
		{
			break
		}
		
		foreach ( player in GetPlayerArray())
		{
			if (!IsValid( player ))
			{
				continue
			}
			
			Message( player, update_title, update_msg, 3 )
		}
		
		SendServerMessage(update_title)
		
		wait 3.6
		
	}
}

void function update()
{
	file.stop_update_msg_flag = false;
	thread RunUpdateMsg()
	sqerror("Update spam messages started")
}

bool function EnableVoice()
{
	#if DEVELOPER 
		printt("voice enabled")
	#endif 
	if ( !GetConVarBool( "sv_voiceenable" ) || !GetConVarBool( "sv_alltalk" ) )
	{
		SetConVarBool( "sv_voiceenable", true )
		SetConVarBool( "sv_alltalk", true )
		
		if ( GetConVarBool( "sv_voiceenable" ) && GetConVarBool( "sv_alltalk" ) )
		{
			return true
		}
	}
	
	return false
}



/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////					  ///////////////////////////
/////////////////////////////		UTILITY		  ///////////////////////////
/////////////////////////////					  ///////////////////////////
/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

//php my beloved
//trims leading and trialing whitespace from a string
string function trim( string str ) 
{
    int start = 0;
    int end = str.len() - 1;
    string whitespace = " \t\n\r";

    while ( start <= end && whitespace.find( str.slice( start, start + 1 )) != -1 ) 
	{
        start++;
    }

    while (end >= start && whitespace.find( str.slice( end, end + 1 )) != -1 ) 
	{
        end--;
    }

    return str.slice(start, end + 1);
}


//////////////////////////////////////////////////
//												//
//				string to array			 		//
//												//
//	format of:									//												
//					"string1, also string"		//
// 												//
//	into an array:  							//
//					['string1','also string']	//
//												//
//												//
// CALLING FUNCTION responsible for error catch //
//////////////////////////////////////////////////

array<string> function StringToArray( string str, int MAX_LENGTH = 128 ) 
{		
	int item_index = 0;
	int length_check;
	string t_str = trim( str )
	
    if ( t_str == "" )
	{
        throw "Cannot convert empty string to array.";
	}
	
    array<string> arr = split( str, "," )
	array<string> valid = []
	
	/*debug
	foreach (index, item in arr) 
	{
		sqprint("Item #" + (index + 1) + ": '" + item + "'\n");
	}
	*/
	
    foreach ( item in arr ) 
	{		
		item_index++
		item = trim( item )
		length_check = item.len()
	
        if ( item == "" ) 
		{   
            sqerror( "Empty item in the list for item # " + ( item_index ) + " removed. " )			
        } 
		else if ( length_check >= MAX_LENGTH )
		{
			sqerror( "item # " + ( item_index ) + " is too long and was removed. Length: " + length_check + " ; Max: " + MAX_LENGTH + " chars")	
		} 
		else
		{		
			valid.append( item )		
		}	
    }
	
	if ( valid.len() <= 0 ) 
	{
        throw "Array empty after conversion";
    }

    return valid;
}


string function Concatenate( string str1, string str2 ) 
{	
	int str1_length = str1.len()
	int str2_length = str2.len()
	int dif
	string error
	
    if ( str1 == "" && str2 == "" ) 
	{
        return "";
    }

    if ( str1_length > 1000 ) 
	{
		dif = ( str1_length - 1000 )
		throw ("Error: First string exceeds length limit of 1000 by " + dif.tostring() + " chars")
    }
	
    if ( str2_length > 1000 ) 
	{	
		dif = ( str2_length - 1000 )
        throw ("Error: Second string exceeds length limit of 1000 by " + dif.tostring() + " chars")
    }
	
	if ( str2 != ""  )
	{
		str2 = "," + str2;	
	}
	
    return str1 + str2;
}

float function GetDefaultIBMM()
{
	float f_wait = GetCurrentPlaylistVarFloat("default_ibmm_wait", 0)
	return ValidateIBMMWaitTime( f_wait )
}

float function ValidateIBMMWaitTime( float f_wait )
{
	return f_wait > 0.0 && f_wait < 3.0 ? 3.0 : f_wait;
}

void function SetDefaultIBMM( entity player )
{	
	float f_wait = GetCurrentPlaylistVarFloat("default_ibmm_wait", 0)
	player.p.IBMM_grace_period = f_wait > 0.0 && f_wait < 3.0 ? 3.0 : f_wait;
}


bool function empty( string str )
{
	return str == "";
}


bool function IsNum( string str ) 
{
    if ( str.len() == 0 ){ return false }
	
    int start = ( str[0] == '-' && str.len() > 1 ) ? 1 : 0;
    
	bool dot = false
	
	for ( int i = start; i < str.len(); i++ ) 
	{
		if (str[i] == '.')
		{
			if(dot)
			{ 
				return false; 
			}
			else 
			{
				dot = true;
			}
		} 
		else if (str[i] < '0' || str[i] > '9'){ return false }
    }
	
    return true
}

int function stringcmp( string a, string b ) 
{
    if ( a.len() != b.len() ){ return a.len() < b.len() ? -1 : 1; }
	
    for (int i = 0; i < a.len(); ++i) 
	{
		if (a[i] != b[i])
		{
			return a[i] < b[i] ? -1 : 1;
		}
	}

    return 0
}

bool function IsNumeric( string str, int min = -123, int max = -123 ) 
{

	string minStr = min == -123 ? "-2147483647" : min.tostring()
	string maxStr = max == -123 ? "2147483647" : max.tostring()
	
	if ( !IsNum( str ) ) 
	{
        return false;
    }
    
    if ( str[0] == '-' ) 
	{
        if ( stringcmp( str.slice(1), minStr.slice(1) ) > 0 ) 
		{
            return false;
        }
    } 
	else 
	{
        if ( stringcmp(str, maxStr) > 0 ) 
		{
            return false;
        }
    }

    //sqprint( format( "%s", str ) )
	
    return true
}




bool function IsFloat( string str, float min = INT_MAX, float limit = INT_MIN ) 
{
	if (str.len() == 0) 
	{
		return false;
	}
	
	for (int i = 0; i < str.len(); i++) 
	{
		var c = str[i];
		if (!((c >= '0' && c <= '9') || (c == '.' && i != 0) || (c == '-' && i == 0))) 
		{
			return false;
		}
	}
	
	float num = 0.0;
	try { num = str.tofloat(); } catch (outofrange) { return false; }
	
	return ( num >= min && num <= limit );
}

string function LineBreak(string str, int interval = 80) 
{
	string output = "";
	
	for (int i = 0; i < str.len();) 
	{
		int end = i + interval;
		
		if (end >= str.len()) 
		{
			output += str.slice(i) + "\n";
			break;
		}
		
		bool located_space = false;
		
		for (int j = end; j > i; --j) 
		{
			if (str.slice(j-1, j) == " ") 
			{
				end = j;
				located_space = true;
				break;
			}
		}
		
		if (!located_space) 
		{
			end = i + interval;
		}

		output += str.slice(i, end) + "\n";
		i = end;
	}
	
	return output;
}

string function ReturnKey( string str )
{
	array<string> split = split(str , ":")	
	return split[0]
}

string function ReturnValue( string str )
{	
	try {
	
		array<string> split = split(str , ":")
		
		if(split.len() < 2)
		{
			return "";
		}
		
		if (split[1] == "NA")
		{	
			#if DEVELOPER
				sqprint( "Default value was returned for key: " + str )
			#endif
			return "";
		}
		
		return split[1]
	} 
	catch (err)
	{
		#if DEVELOPER 
			sqerror( "ReturnValue() failed for key " + str )
		#endif 
		return "";
	}		
}

bool function Is_Bool(string str)
{
	int num = 0;
	string a_str = str; 
	
	if (a_str.len() == 0 || (a_str[0] < '0' || a_str[0] > '9') && a_str[0] != '-') return false;
	
	try { num = a_str.tointeger(); } catch (outofrange) { return false; }
	
	return ( abs(num) >= 0 && abs(num) <= 1);
}

entity function GetPlayerEntityByName( string name )
{	
	entity p;	
	name = name.tolower()
	
	foreach ( player in GetPlayerArray() )
	{
		if ( player.GetPlayerName().tolower() == name )
		{		
			return player;	
		}	
	}
	
	return p;
}

void function CheckAdmin_OnConnect( entity player )
{
	if( !IsValid( player ) ) 
		return 
	
	if( IsTrackerAdmin( player.GetPlatformUID() ) )
		player.SetPlayerNetBool( "IsAdmin", true )
}

bool function IsTrackerAdmin( string CheckPlayer )
{
	foreach ( Player, OID in player_admins) 
	{
		if ( Player == CheckPlayer || OID == CheckPlayer) 
		{
			return true;
		}
	}
	
	return false;
}

bool function IsValidOID( string str )
{
	if ( !IsNum( str ) )
		return false
	
	string oid;
		
	foreach ( player in GetPlayerArray() )
	{
		if ( !IsValid( player ) )
		{
			continue
		}
		
		oid = player.GetPlatformUID()
		
		if ( oid == str )
			return true
	
	}
	
	return false
}

entity function GetPlayerEntityByUID( string str )
{
	entity r_player;
	string oid;
	
	if ( !IsNum( str ) )
		return r_player
		
	foreach ( player in GetPlayerArray() )
	{
		if ( !IsValid( player ) )
		{
			continue
		}
		
		oid = player.GetPlatformUID()
		
		if ( oid == str )
		{
			return player;
		}
	}
	
	return r_player;
}

entity function GetPlayer( string str ) 
{
	entity player;
	
	if ( IsValidOID( str ) )
	{
		return GetPlayerEntityByUID( str )	
	}
	else
	{
		return GetPlayerEntityByName( str )	
	}
	
	return player
}

string function GetMap( string str ) 
{
	foreach ( map in list_maps ) 
	{
		if ( map[0] == str || map[1] == str ) 
		{
			return map[1];
		}
	}
	
	return GetMapName()
}

string function GetMode( string str ) 
{

	foreach ( mode in list_gamemodes ) 
	{
		if ( mode[0] == str || mode[1] == str ) 
		{
			return mode[1];
		}
	}
	
	return GameRules_GetGameMode()
}

bool function IsControlCharacter(string c) 
{
	var byte = c[0];
	return (byte >= 0 && byte <= 31) || byte == 127;	
}

string function sanitize(string str) 
{
	string sanitized = "";

	for (int i = 0; i < str.len(); i++) {
		string c = str.slice(i, i + 1);

		if ( IsControlCharacter(c) ) 
		{
			continue	
		} 
		else 
		{
			sanitized += c;
		}
	}

	return sanitized;	
}

string function truncate( string str, int limit ) 
{
    if ( str.len() > limit ) 
	{
        return str.slice( 0, limit );
    }
    
    return str;
}

void function printarray( array<string> args )
{
	string test = "\n\n------ PRINT ARRAY ------\n\n"
	
	foreach( arg in args )
	{
		test += format( "	\"%s\", \n", arg )
	}
	
	sqprint(test)
}


bool function CheckRate( entity player )
{	
	if ( !IsValid( player ) ) 
		return false 
			
	if ( Time() - player.p.ratelimit <= COMMAND_RATE_LIMIT )
	{
		LocalEventMsg( player, "#FS_CMD", "", 2 )
		return false
	}
	
	player.p.ratelimit = Time()
	
	return true
}

//taken from sh_playlists.gnut
#if SERVER	
array<string> function GetPlaylistMaps( PlaylistName playlistName )
{
	array<string> mapsArray

	int numModes = GetPlaylistGamemodesCount( playlistName )
	for ( int modeIndex = 0; modeIndex < numModes; modeIndex++ )
	{
		int numMaps = GetPlaylistGamemodeByIndexMapsCount( playlistName, modeIndex )
		for ( int mapIndex = 0; mapIndex < numMaps; mapIndex++ )
		{
			string mapName = GetPlaylistGamemodeByIndexMapByIndex( playlistName, modeIndex, mapIndex )
			if ( mapsArray.contains( mapName ) )
				continue

			mapsArray.append( mapName )
		}
	}

	return mapsArray
}
#endif //SERVER

int function WeaponToIdentifier( string weaponName )
{
	if( !IsWeaponValid( weaponName ) ) 
	{
		string err = format( "#^ Unknown weaponName !DEBUG IT! -- weapon: %s", weaponName )
		
		#if TRACKER && HAS_TRACKER_DLL
			if( bLog() && isLogging__internal() )
			{
				LogEvent__internal( err, bEnc() )
			}
		#endif
		
		sqerror(err)
		
		return 2
	}
	
	return WeaponIdentifiers[weaponName]
}

bool function IsWeaponValid( string weaponref )
{
	return ( weaponref in WeaponIdentifiers )
}

table<string,int> function GetTrackerWeaponIdentifierTable()
{
	return WeaponIdentifiers
}

void function DEV_PrintTrackerWeapons()
{
	string prnt = "\n\n ---------- TRACKER WEAPON IDENTIFIERS --------- \n\n";
	
	foreach( weapon, id in WeaponIdentifiers )
	{
		prnt += format( "[\"%s\"] = %d, \n", weapon, id )
	}
	
	printt( prnt )
}

table<string, int> function TrackerWepTable() 
{
    return WeaponIdentifiers
}

bool function exclude( int weaponSource )
{
	return !DamageSourceIDHasString( weaponSource )
}

string function ParseWeapon( string weaponString )
{
	array<string> mods = split( trim( weaponString ), " " )
	
	if( mods.len() < 1 )
	{
		return ""
	}
	
	if( !IsWeaponValid( mods[0] ) || !(SURVIVAL_Loot_IsRefValid( mods[0] )) )
	{
		return ""
	}
	
	bool removed = false
	
	for ( int i = mods.len() - 1 ; i >= 1; i-- )
	{
		if ( !SURVIVAL_Loot_IsRefValid( mods[i] ) 
		|| !IsModValidForWeapon( mods[0], mods[i] ) )
		{
			removed = true
			sqprint("removed: " + mods[i] )		
			mods.remove(i)
		}
	}
	
	if (removed)
	{
		sqprint( PrintSupportedAttachpointsForWeapon( mods[0] ) )
	}
	
	string return_string = ""
	
	foreach( mod in mods )
	{
		return_string += mod + " "
	}
	
	return trim(return_string)
}

bool function IsModValidForWeapon( string weaponref, string mod )
{	
	array<string> attachPoint = GetAttachPointsForAttachment( mod )
	LootData wData = SURVIVAL_Loot_GetLootDataByRef( weaponref )	
	
	return ( wData.supportedAttachments.contains( attachPoint[0] ) 
	&& !wData.disabledAttachments.contains( attachPoint[0] ) )
}

string function PrintSupportedAttachpointsForWeapon( string weaponref )
{
	LootData wData = SURVIVAL_Loot_GetLootDataByRef( weaponref )
	
	string debug = format("\n --- Attachment List for %s --- \n", weaponref)
	int i = 1
	
	foreach( supported in wData.supportedAttachments )
	{
		debug += format( "%d. %s \n", i, supported )
		i++;
	}
	
	return debug
}

#if TRACKER && HAS_TRACKER_DLL
	void function PrintMatchIDtoAll()
	{
		string matchID = format( "\n\n Server stats enabled @ www.r5r.dev, \n round: %d - MatchID: %s \n ", GetCurrentRound(), SQMatchID__internal() )
		CenterPrintAll( matchID )
	}	
#endif