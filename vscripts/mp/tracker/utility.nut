global function GetAdminList
global function EnableVoice
global function empty
global function StringToArray
global function trim
global function Concatenate
global function IsNumeric
global function IsNum
global function GetPlayer
global function GetPlayerEntityByOID
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

//tables 
table<string, string> player_admins

//arrays 
array< array< string > > list_maps
array< array< string > > list_gamemodes

struct {

	array <string> ADMINS
	bool stop_update_msg_flag = false

} file


	void function INIT_CC_MapNames()
	{
	
		list_maps = [
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

	#if !HAS_TRACKER_DLL		
		void function SendServerMessage( string _ ){}
	#endif 
	
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
								
								if (g_bLGmode)
								{
									handicap = l_player.p.p_damage == 2 ? "On" : "Off";
									stringHandicap = "---- Handicap: " + handicap; 
								}
								
								p_input = l_player.p.input > 0 ? "Controller" : "MnK"; 
								kills = l_player.p.lifetime_kills + player.GetPlayerNetInt( "kills" )
								deaths = l_player.p.lifetime_deaths + player.GetPlayerNetInt( "deaths" )
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
								data += "Season playtime: " + PlayTime(l_player.p.lifetime_playtime) + "\n";
								data += "Season games: " + l_player.p.lifetime_gamesplayed + "\n";
								data += "Season score: " + l_player.p.lifetime_score;
								
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
								kills = active_player.p.lifetime_kills + player.GetPlayerNetInt( "kills" )
								deaths = active_player.p.lifetime_deaths + player.GetPlayerNetInt( "deaths" )
								
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
				
					string data = "";
					string inputmsg = ":::: Match ID ::::";
					
					try 
					{
						
						data += format("\n\n %s ", SQMatchID() );
								
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
			admins_list = SQ_GetSetting("settings.ADMINS")
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
									setRestrictedServer( true )
									Message( player, "Command sent", "restricted_server was ENABLED" )
									return true
								} 
								else if ( args[1] == "0" )
								{
									setRestrictedServer( false )
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
						
							
							foreach (connected_player in GetPlayerArray()){
							
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
							
							
							if ( args.len() < 2 ){
						
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
					
			case "unban":
			
					
					
						if ( args.len() < 2 ){
						
							Message( player, "Failed", "Command 'unban' requires id for 1st param of command as string" )
							return false
						
						}
						
						try {
						
								UnbanPlayer( args[1])
								
								Message( player, "Success", "ID: " + args[1] + " was supposedly unbanned" )
								
								return true
								
							} catch ( erre ){
							
								Message(player, "Failed", "Command failed because of: \n\n " + erre )
								return false
							}
					
						
					
						return true;
						
						
						
			case "playerinfo":
			
						try {
							
							string nputmsg = "Current Stats:"
							
							string info = PrintAllPlayerMetrics(true);
							
							if( (nputmsg.len() + info.len()) > 599 )
							{
						
								Message( player, "Failed", "Cannot execute this command currently due to return data resulting in overflow" )
								return true;
						
							}
							
							Message( player, nputmsg, LineBreak(info), 20);
							return true;
						
						} catch (errf){
							
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
								foreach ( playerMetrics in GetPlayerMetricsArray() ) 
								{
									if ( playerMetrics.playerID == args[1] ) 
									{	
										GetPlayerMetricsArray().removebyvalue(playerMetrics);					
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
						
						if ( args.len() < 1){
						
							Message( player, "Failed", "Param 1 of command 'playerinput' requires player name/oid.")
							return true
							
						}
						
						try {
							
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
							
						} catch (errh) {
							
							Message( player, "Failed", "Command failed because of: \n\n " + errh )
							return true
							
						}
					
					return true
		
						
			case "input":	

						if ( args.len() < 1){
						
							Message( player, "Failed", "Param 1 of command 'input' requires player name/oid.")
							return true
							
						}
						
						
						if ( args.len() < 2){
						
							Message( player, "Failed", "Param 2 of command 'input' requires type 0/1.")
							return true
							
						}
								
						try {	
						
								string str = args[2]
								string a_str = str;
								
								if (str == "false"){ a_str = "0" }
								if (str == "true"){ a_str = "1" }
								if (str == "mnk" ){ a_str = "0" }
								if (str == "controller" ) { a_str = "1" }
								
								if ( !Is_Bool(a_str) ){
								
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
						
						} catch (errj) {
						
							Message( player, "Failed", "Command failed because of: \n\n " + errj )
							return false;
						
						}
						
			case "listhandles":
						
						try {
						
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
						
						} catch (errk) {
						
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
			
						if ( args.len() < 1){
							
								Message( player, "Info", "Param 1 of command 'score' requires player name/oid/*/current/lifetime/difference. \n\n Usage: score player | score * | score current")
								return true
								
						}
						
						if ( param == "current" )
						{
							
							Message( player, "Success", "'Current KD' server weight setting is:   " + getSbmmSetting( "current_kd_weight" ) )
							return true
							
						}
						else if ( param == "lifetime" )
						{
							
							Message( player, "Success", "'lifetime KD' server weight setting is:   " + getSbmmSetting( "lifetime_kd_weight" ) )
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
							
							} catch (errallscore) {
							
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
							Message( player, "Failed", "Param 1 of command 'scoreconfig' requires type: current/lifetime/difference.")
							return true
						}
						
						if ( args.len() < 3)
						{	
							Message( player, "Failed", "Param 2 of command 'scoreconfig' requires float")
							return true	
						}
						
						
						
						try {
						
							if ( !IsFloat( param2 ) )
							{
								Message( player, "Failed", "param 3 of command 'scoreconfig' must be numeric type float, \n\n example: 0.8 --            '" + param2 + "' was provided" )
								return true
							}
							
							if ( param == "current" )
							{
							
								setSbmmSetting( "current_kd_weight", param2.tofloat() )
							
							}
							else if ( param == "lifetime" )
							{
							
								setSbmmSetting( "lifetime_kd_weight", param2.tofloat() )
							
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
						
						} catch (errsetweight) {
						
							Message( player, "Failed", "Command failed because of: \n\n " + errsetweight )
							return true;
						
						}
						
					return true
					
			case "cleanuplogs":
				
						CleanupLogs(); //sdk function 
							
						return true
			
			case "reload_config":
			
						SQ_ReloadConfig() //sdk function
						
						return true
						
			case "setting":
						
			
						if ( args.len() < 2)
						{
							Message( player, "Failed", "Param 1 of command 'setting' requires key name")
							return true
						}
						
						
						try 
						{	
							string return_str = "";
							return_str = SQ_GetSetting(param);	
							
							Message( player, param + ":", return_str)
							return true
						} 
						catch (errset) 
						{
							
							Message( player, "Failed", "Command failed because of: \n\n " + errset )
							return true		
						}
						
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
					Message( player, "Data for: " + param, FetchPlayerData( p.p.UID, param2 ) )
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
				
			default:
			
						Message( player, "Usage", "cc #command #param1 #param2 #..." )
						return true;
		}
		
		
		return true;
	}


//chat commands
bool function ClientCommand_ParseSay( entity player, array<string> args )
{		
    if ( !IsValid(player) || args.len() == 0 )
		return true
	
	Commands( player, args )
		return true 		
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
			ClientCommand_mkos_LGDuel_IBMM_wait( player, args )
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




bool function IsFloat( string str, float min = SQ_MIN_INT_32, float limit = SQ_MAX_INT_32 ) 
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

entity function GetPlayerEntityByOID( string str )
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
		return GetPlayerEntityByOID( str )	
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
	try 
	{
		string test = ""
		
		foreach( arg in args )
		{
			test += format( "%s \n", arg )
		}
		
		sqprint(test)
	}
	catch(badType)
	{
		sqprint("Error: " + badType )
	}
}


bool function CheckRate( entity player )
{	
	if ( !IsValid( player ) ) 
		return false 
			
	if ( Time() - player.p.ratelimit <= COMMAND_RATE_LIMIT )
	{
		Message( player, "COMMANDS COOLDOWN")
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
#endif

int function WeaponToIdentifier( string weaponName )
{
	if( !IsWeaponValid( weaponName ) ) 
	{
		string err = format( "#^ Unknown weaponName !DEBUG IT! -- weapon: %s", weaponName )
		
		#if TRACKER && HAS_TRACKER_DLL
			if( bLog() && isLogging() )
			{
				LogEvent( err, bEnc() )
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

table<string,int> WeaponIdentifiers = {
    ["damagedef_unknown"] = 1,
    ["damagedef_unknownBugIt"] = 2,
    ["damagedef_suicide"] = 3,
    ["damagedef_despawn"] = 4,
    ["damagedef_titan_step"] = 5,
    ["damagedef_crush"] = 6,
    ["damagedef_sonic_blast"] = 7,
    ["damagedef_nuclear_core"] = 8,
    ["damagedef_titan_fall"] = 9,
    ["damagedef_titan_hotdrop"] = 10,
    ["damagedef_reaper_fall"] = 11,
    ["damagedef_trip_wire"] = 12,
    ["damagedef_wrecking_ball"] = 13,
    ["damagedef_reaper_groundslam"] = 14,
    ["damagedef_reaper_nuke"] = 15,
    ["damagedef_frag_drone_explode"] = 16,
    ["damagedef_frag_drone_explode_FD"] = 17,
    ["damagedef_frag_drone_throwable_PLAYER"] = 18,
    ["damagedef_frag_drone_throwable_NPC"] = 19,
    ["damagedef_stalker_powersupply_explosion_small"] = 20,
    ["damagedef_stalker_powersupply_explosion_large"] = 21,
    ["damagedef_stalker_powersupply_explosion_large_at"] = 22,
    ["damagedef_shield_captain_arc_shield"] = 23,
    ["damagedef_fd_explosive_barrel"] = 24,
    ["damagedef_fd_tether_trap"] = 25,
    ["damagedef_pilot_slam"] = 26,
    ["damagedef_ticky_arc_blast"] = 27,
    ["damagedef_grenade_gas"] = 28,
    ["damagedef_gas_exposure"] = 29,
    ["damagedef_dirty_bomb_explosion"] = 30,
    ["damagedef_sonic_boom"] = 31,
    ["damagedef_bangalore_smoke_explosion"] = 32,
    ["damagedef_creeping_bombardment_detcord_explosion"] = 33,
    ["damagedef_tank_bombardment_detcord_explosion"] = 34,
    ["damagedef_defensive_bombardment"] = 35,
    ["damagedef_loot_drone_explosion"] = 36,
    ["damagedef_DocDrone"] = 37,
    ["mp_weapon_grenade_decoyaudio"] = 38,
    ["mp_weapon_grenade_cryonade"] = 39,
    ["mp_weapon_hemlok"] = 40,
    ["mp_weapon_lmg"] = 41,
    ["mp_weapon_rspn101"] = 42,
    ["mp_weapon_vinson"] = 43,
    ["mp_weapon_lstar"] = 44,
    ["mp_weapon_g2"] = 45,
    ["mp_weapon_r97"] = 46,
    ["mp_weapon_dmr"] = 47,
    ["mp_weapon_wingman"] = 48,
    ["mp_weapon_wingmanelite"] = 49,
    ["mp_weapon_semipistol"] = 50,
    ["mp_weapon_autopistol"] = 51,
    ["mp_weapon_sniper"] = 52,
    ["mp_weapon_sentinel"] = 53,
    ["mp_weapon_shotgun"] = 54,
    ["mp_weapon_mastiff"] = 55,
    ["mp_weapon_frag_grenade"] = 56,
    ["mp_weapon_grenade_emp"] = 57,
    ["mp_weapon_arc_blast"] = 58,
    ["mp_weapon_thermite_grenade"] = 59,
    ["mp_weapon_nuke_satchel"] = 60,
    ["mp_extreme_environment"] = 61,
    ["mp_weapon_shotgun_pistol"] = 62,
    ["mp_weapon_doubletake"] = 63,
    ["mp_weapon_alternator_smg"] = 64,
    ["mp_weapon_esaw"] = 65,
    ["mp_weapon_wrecking_ball"] = 66,
    ["mp_weapon_melee_survival"] = 67,
    ["mp_weapon_pdw"] = 68,
    ["mp_weapon_energy_ar"] = 69,
    ["mp_weapon_volt_smg"] = 70,
    ["mp_weapon_defender"] = 71,
    ["mp_weapon_warmachine"] = 72,
    ["mp_weapon_car"] = 73,
    ["mp_weapon_3030"] = 74,
    ["mp_weapon_dragon_lmg"] = 75,
    ["mp_weapon_throwingknife"] = 76,
    ["mp_weapon_grenade_electric_smoke"] = 77,
    ["mp_weapon_grenade_gravity"] = 78,
    // Melee
    ["melee_pilot_emptyhanded"] = 79,
    ["melee_pilot_arena"] = 80,
    ["melee_pilot_sword"] = 81,
    ["melee_titan_punch"] = 82,
    ["melee_titan_punch_ion"] = 83,
    ["melee_titan_punch_tone"] = 84,
    ["melee_titan_punch_legion"] = 85,
    ["melee_titan_punch_scorch"] = 86,
    ["melee_titan_punch_northstar"] = 87,
    ["melee_titan_punch_fighter"] = 88,
    ["melee_titan_punch_vanguard"] = 89,
    ["melee_titan_punch_stealth"] = 90,
    ["melee_titan_punch_rocket"] = 91,
    ["melee_titan_punch_drone"] = 92,
    ["melee_titan_sword"] = 93,
    ["melee_titan_sword_aoe"] = 94,
    ["melee_boxing_ring"] = 95,
    ["mp_weapon_melee_boxing_ring"] = 96,
    ["melee_data_knife"] = 97,
    ["mp_weapon_data_knife_primary"] = 98,
    ["melee_wraith_kunai"] = 99,
    ["mp_weapon_wraith_kunai_primary"] = 100,
	["melee_bolo_sword"] = 101,
	["mp_weapon_bolo_sword_primary"] = 102,
	["melee_bloodhound_axe"] = 103,
	["mp_weapon_bloodhound_axe_primary"] = 104,
	["melee_lifeline_baton"] = 105,
	["mp_weapon_lifeline_baton_primary"] = 106,
	["melee_shadowsquad_hands"] = 107,
	["melee_shadowroyale_hands"] = 108,
	["mp_weapon_shadow_squad_hands_primary"] = 109,
	["mp_weapon_tesla_trap"] = 110,
	// Turret Weapons
	["mp_weapon_yh803"] = 111,
	["mp_weapon_yh803_bullet"] = 112,
	["mp_weapon_yh803_bullet_overcharged"] = 113,
	["mp_weapon_mega_turret"] = 114,
	["mp_weapon_mega_turret_aa"] = 115,
	["mp_turretweapon_rockets"] = 116,
	["mp_turretweapon_blaster"] = 117,
	["mp_turretweapon_plasma"] = 118,
	["mp_turretweapon_sentry"] = 119,
	["mp_weapon_smart_pistol"] = 120,
	// Character Abilities
	["mp_weapon_defensive_bombardment_weapon"] = 121,
	["mp_weapon_creeping_bombardment_weapon"] = 122,
	["mp_ability_octane_stim"] = 123,
	["mp_ability_crypto_drone_emp"] = 124,
	["mp_ability_crypto_drone_emp_trap"] = 125,
	// AI only Weapons
	["mp_weapon_super_spectre"] = 126,
	["mp_weapon_dronebeam"] = 127,
	["mp_weapon_dronerocket"] = 128,
	["mp_weapon_droneplasma"] = 129,
	["mp_weapon_turretplasma"] = 130,
	["mp_weapon_turretrockets"] = 131,
	["mp_weapon_turretplasma_mega"] = 132,
	["mp_weapon_gunship_launcher"] = 133,
	["mp_weapon_gunship_turret"] = 134,
	["mp_weapon_gunship_missile"] = 135,
	// Misc
	["rodeo"] = 136,
	["rodeo_forced_titan_eject"] = 137,
	["rodeo_execution"] = 138,
	["human_melee"] = 139,
	["auto_titan_melee"] = 140,
	["berserker_melee"] = 141,
	["mind_crime"] = 142,
	["charge_ball"] = 143,
	["grunt_melee"] = 144,
	["spectre_melee"] = 145,
	["prowler_melee"] = 146,
	["super_spectre_melee"] = 147,
	["titan_execution"] = 148,
	["human_execution"] = 149,
	["eviscerate"] = 150,
	["wall_smash"] = 151,
	["ai_turret"] = 152,
	["team_switch"] = 153,
	["rocket"] = 154,
	["titan_explosion"] = 155,
	["flash_surge"] = 156,
	["sticky_time_bomb"] = 157,
	["vortex_grenade"] = 158,
	["droppod_impact"] = 159,
	["ai_turret_explosion"] = 160,
	["rodeo_trap"] = 161,
	["round_end"] = 162,
	["bubble_shield"] = 163,
	["evac_dropship_explosion"] = 164,
	["sticky_explosive"] = 165,
	["titan_grapple"] = 166,
	// Environmental
	["fall"] = 167,
	["splat"] = 168,
	["crushed"] = 169,
	["burn"] = 170,
	["lasergrid"] = 171,
	["outOfBounds"] = 172,
	["deathField"] = 173,
	["indoor_inferno"] = 174,
	["submerged"] = 175,
	["switchback_trap"] = 176,
	["floor_is_lava"] = 177,
	["suicideSpectreAoE"] = 178,
	["titanEmpField"] = 179,
	["stuck"] = 180,
	["deadly_fog"] = 181,
	["exploding_barrel"] = 182,
	["electric_conduit"] = 183,
	["turbine"] = 184,
	["harvester_beam"] = 185,
	["toxic_sludge"] = 186,
	["mp_weapon_spectre_spawner"] = 187,
	// development
	["weapon_cubemap"] = 188,
	// Prototype
	["mp_weapon_zipline"] = 189,
	["at_turret_override"] = 190,
	["rodeo_battery_removal"] = 191,
	["phase_shift"] = 192,
	["gamemode_bomb_detonation"] = 193,
	["nuclear_turret"] = 194,
	["proto_viewmodel_test"] = 195,
	["mp_titanweapon_heat_shield"] = 196,
	["mp_titanweapon_sonar_pulse"] = 197,
	["mp_titanability_slow_trap"] = 198,
	["mp_titanability_gun_shield"] = 199,
	["mp_titanability_power_shot"] = 200,
	["mp_titanability_ammo_swap"] = 201,
	["mp_titanability_sonar_pulse"] = 202,
	["mp_titanability_rearm"] = 203,
	["mp_titancore_upgrade"] = 204,
	["mp_titanweapon_xo16_vanguard"] = 205,
	["mp_weapon_arc_trap"] = 206,
	["mp_weapon_arc_launcher"] = 207,
	["core_overload"] = 208,
	["mp_titanweapon_stasis"] = 209,
	["mp_titanweapon_stealth_titan"] = 210,
	["mp_titanweapon_rocket_titan"] = 211,
	["mp_titanweapon_drone_titan"] = 212,
	["mp_titanweapon_stealth_sword"] = 213,
	["mp_ability_consumable"] = 214,
	["snd_bomb"] = 215,
	["bombardment"] = 216,
	["bleedout"] = 217,
	["mp_weapon_energy_shotgun"] = 218,
	["fire"] = 219,
	// Custom
	["mp_weapon_raygun"] = 220,
	["mp_weapon_haloshotgun"] = 221,
	["mp_weapon_halosmg"] = 222,
	["mp_weapon_halomagnum"] = 223,
	["mp_weapon_halobattlerifle"] = 224,
	["mp_weapon_haloassaultrifle"] = 225,
	["mp_weapon_halosniperrifle"] = 226,
	["mp_weapon_haloneedler"] = 227,
	["mp_weapon_energysword"] = 228,
	["mp_weapon_frag_grenade_halomod"] = 229,
	["mp_weapon_plasma_grenade_halomod"] = 230,
	["mp_weapon_oddball_primary"] = 231,
	["melee_oddball"] = 232,
	["mp_weapon_lightninggun"] = 233,
	// lies
	["mp_weapon_grenade_creeping_bombardment"] = 234,
	["mp_ability_area_sonar_scan"] = 235,
	["mp_ability_hunt_mode"] = 236,
	["mp_weapon_dirty_bomb"] = 237,
	["mp_weapon_grenade_gas"] = 238,
	["mp_ability_crypto_drone"] = 239,
	["mp_ability_crypto_drone_emp"] = 240,
	["mp_ability_gibraltar_shield"] = 241,
	["mp_weapon_bubble_bunker"] = 242,
	["mp_weapon_grenade_defensive_bombardment"] = 243,
	["mp_weapon_deployable_medic"] = 244,
	["mp_ability_care_package"] = 245,
	["mp_ability_holopilot"] = 246,
	["mp_ability_mirage_ultimate"] = 247,
	["mp_ability_heal"] = 248,
	["mp_weapon_jump_pad"] = 249,
	["mp_ability_grapple"] = 250,
	["mp_weapon_zipline"] = 251,
	["mp_weapon_tesla_trap"] = 252,
	["mp_weapon_trophy_defense_system"] = 253,
	["mp_ability_phase_walk"] = 254,
	["mp_weapon_phase_tunnel"] = 255,
	["mp_weapon_grenade_bangalore"] = 256
	
	//ADDING TO THIS LIST REQUIRES CHANGES TO EXCLUSION LIST

}

table<string, int> function TrackerWepTable() 
{
    return WeaponIdentifiers
}

array<int> function exclusions()
{
	const array<int> exclude = [
		233,
		234,
		235,
		236,
		237,
		238,
		239,
		240,
		241,
		242,
		243,
		244,
		245,
		246,
		247,
		248,
		249,
		250,
		251,
		252,
		253,
		254,
		255,
		256
	];

	return exclude;
}

bool function exclude( int weaponSource )
{
	if(exclusions().find(weaponSource) != -1)
	{
		return true	
	}
	
	return false
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

