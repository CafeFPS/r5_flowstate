// flowstate spawn system

global function ReturnAllSpawnLocations
global LocPair &waitingRoomPanelLocation

global function CreateLocPairObject
global function AddCallback_FlowstateSpawnsInit
global function SetPreferredSpawnPak

global function GetCurrentSpawnSet
global function GetCurrentSpawnAsset
global function SetCustomSpawnPak
global function SetCustomPlaylist

#if DEVELOPER
	global function DEV_PosType
	global function DEV_AddSpawn
	global function DEV_PrintPosArray
	global function DEV_del_pos
	global function DEV_ClearPos
	global function DEV_tp_to_pos
	global function DEV_WritePosOut
	global function DEV_pos_help
	global function DEV_SetTeamSize
	global function DEV_tp_to_panels
	global function DEV_LoadPak
	global function DEV_HighlightSpawns
#endif 

	global struct LocPairData
	{
		array<LocPair> spawns
		LocPair ornull waitingRoom = null
		LocPair ornull panels = null
		bool bOverrideSpawns = false
	}

	const int MASTER_PANEL_ORIGIN_OFFSET = 400
	
	struct
	{
		array<LocPairData functionref()> onSpawnInitCallbacks
		int preferredSpawnPak = 1
		string currentSpawnPak = ""
		string customSpawnpak = ""
		string customPlaylist = ""
		int teamsize = 2
		bool overrideSpawns = false	
		
		#if DEVELOPER
			LocPair &panelsloc
			array<string> dev_positions = []
			string dev_positions_type = ""
			array<string> validPosTypes = ["sq","csv"]
			array<LocPair> dev_positions_LocPair = []
			bool highlightOn
			array<entity> allBeamEntities
			
			table<string,string> DEV_POS_COMMANDS = {
				
				["script DEV_PosType( string setToType = \"\" )"] = "Converts the current array of print outs to specified type, and further additions are added as the specified type. Returns the current type if no parameters are provided.",
				["script DEV_AddSpawn( string pid, int replace = -1 )"] = "Pass a player name/uid to have the current origin/angles of player appended to spawns array. If replace is specified, replaces the given index with new spawn, otherwise, the operation is append.",
				["script DEV_PrintPosArray()"] = "Prints the current made spawn positions array",
				["script DEV_del_pos( int index )"] = "Deletes a spawn from array by index",
				["script DEV_ClearPos()"] = "Deletes all saved spawns",
				["script DEV_tp_to_pos( string pid, int index )"] = "Teleport specified player by name/uid to a saved spawn by index",
				["script DEV_WritePosOut()"] = "Write current locations to file in the current format, use printt( DEV_PosType() ) to see current type.",
				["script DEV_pos_help()"] = "Prints this help msg...",
				["script DEV_SetTeamSize( int size )"] = "Sets the size of a team formatting the PrintPosArray()",
				["script DEV_HighlightSpawns()"] = "Shows beams of light on all spawns in the PosArray",
				["script DEV_LoadPak( string pak = \"\", string playlist = \"\" )"] = "Loads spawn pak specifying rpak asset and playlist. If custom spawns are wrote into script loads those instead."
			}
		#endif

	} file 

array<LocPair> function ReturnAllSpawnLocations( int eMap, table<string,bool> options = {}  )
{
	string defaultpak = "_set_1";
	string spawnSet = defaultpak
	string customRpak = "";
	
	if ( options.len() >= 5 && ValidateOptions( options ) )
	{	
		if( options.use_custom_rpak )
		{
			customRpak = file.customSpawnpak
		}
		else 
		{
			if( options.use_sets )
			{
				string mapSpawnString = "spawnsets_" + AllMapsArray()[ MapName() ]
				string currentMapSpawnSets = GetCurrentPlaylistVarString( mapSpawnString, "" )
				
				array<string> setpaks = []
				bool success = false
				
				try
				{
					setpaks = StringToArray( currentMapSpawnSets )
					for( int i = 0; i < setpaks.len(); i++ )
					{
						if( !IsNumeric( setpaks[i] ) )
						{
							throw " error: " + setpaks[i] + " is not numeric..";
						}
						setpaks[i] = "_set_" + setpaks[i];
					}
					success = true
				}
				catch(e)
				{
					Warning( "Warning: " + e )
					
					spawnSet = defaultpak
					success = false
				}
				
				if( success )
				{
					string prefferred = "_set_" + string ( file.preferredSpawnPak )
					if( options.prefer && setpaks.contains( prefferred ) )
					{
						int j = setpaks.find( prefferred )			
						if( j == -1 )
						{
							Warning("Preferred spawnpak: " + prefferred + " not found!")
							spawnSet = defaultpak
						}
						else
						{
							spawnSet = setpaks[j]
						}	
					}
					else if( options.use_random )
					{
						spawnSet = setpaks.getrandom()
					}
					else 
					{
						printt("spawnpaks: Use sets was enabeld with no valid options in playlists")
					}
				}
			}
		} //custom rpak override
	}
	
	return FetchReturnAllLocations( eMap, spawnSet, customRpak, file.customPlaylist )
}

LocPairData function CreateLocPairObject( array<LocPair> spawns, bool bOverrideSpawns = false, LocPair ornull waitingRoom = null, LocPair ornull panels = null )
{
	LocPairData data
	
	data.spawns = spawns
	data.bOverrideSpawns = bOverrideSpawns

	if ( waitingRoom != null )
	{
		#if DEVELOPER
			Warning( "LocPairData object set to override waitingroom location in " + FUNC_NAME() + "()" )
		#endif
		
		LocPair varWaitingRoom = expect LocPair ( waitingRoom )
		data.waitingRoom = varWaitingRoom
	}
	
	if( panels != null )
	{
		#if DEVELOPER 
			Warning( "LocPairData object set to override panel location in " + FUNC_NAME() + "()" )
		#endif 
		
		LocPair varPanels = expect LocPair ( panels )
		data.panels = varPanels
	}
	
	return data
}

void function AddCallback_FlowstateSpawnsInit( LocPairData functionref() callbackFunc )
{
	if( file.onSpawnInitCallbacks.contains( callbackFunc ) )
	{
		Warning("Tried to add callbackk with " + FUNC_NAME() + " but function " + string( callbackFunc ) + " already exists in [onSpawnInitCallbacks]")
		return
	}
	
	file.onSpawnInitCallbacks.append( callbackFunc )
}


///////////////////////////////////////////////////////////////mkos///////
//																		//
//	All spawn locations are contained in their 							//
//	appropriate paks designated by playlist, mapname, and set.			//
//																		//
// set = a string that differentiates between sets of spawns. _set_#	//
// ( host can cycle spawnsets or choose a static set to always use )	//
//																		//
// The string for a pak should look like:								//
//__________________________________________________________			//
// prefix   | playlist     | map name            |set number|			//
//			|			   |					 |			|			//
// fs_spawns_fs_lgduels_1v1_mp_rr_arena_composite_set_1.rpak|			//
//```````````````````````````````````````````````````````````			//
// 																		//
//////////////////////////////////////////////////////////////////////////

array<LocPair> function GenerateCustomSpawns( int eMap )//waiting room + extra spawns
{														//ideally only default waiting
	array<LocPair> customSpawns = []					// rooms are saved here. use :
														// AddCallback_FlowstateSpawnsInit()
														
	LocPair defaultWaitingRoom
	
	switch( eMap )
	{
		//////////////////////////////////////////////////////////////////////////////////
		case eMaps.mp_rr_aqueduct:
			
			defaultWaitingRoom = NewLocPair( < 705, -5895, 432 >, < 0, 90, 0 > )
			waitingRoomPanelLocation = SetWaitingRoomAndGeneratePanelLocs( defaultWaitingRoom )
			
		break ////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////
		case eMaps.mp_rr_arena_composite:
		
			defaultWaitingRoom = NewLocPair( < -2.46021, 291.152, 129.574 >, < 0, 90, 0 > )
			waitingRoomPanelLocation = SetWaitingRoomAndGeneratePanelLocs( defaultWaitingRoom, <0,0,-5> )
			
		break ////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////
		case eMaps.mp_rr_canyonlands_64k_x_64k:
		
			defaultWaitingRoom = NewLocPair( < -906.22, 20306.5, 4570.03 >, < 0, 45, 0 > )
			waitingRoomPanelLocation = SetWaitingRoomAndGeneratePanelLocs( defaultWaitingRoom )
		
		break ////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////
		case eMaps.mp_rr_canyonlands_staging: 
		
			defaultWaitingRoom = NewLocPair( < 3477.69, -8364.02, -10252 >, < 356.203, 269.459, 0 > )
			waitingRoomPanelLocation = SetWaitingRoomAndGeneratePanelLocs( defaultWaitingRoom )
		
		break ////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////
		case eMaps.mp_rr_party_crasher:
		
			defaultWaitingRoom = NewLocPair( < 1881.75, -4210.87, 626.106 >, < 359.047, 104.246, 0 > )
			waitingRoomPanelLocation = SetWaitingRoomAndGeneratePanelLocs( defaultWaitingRoom, NULL_VEC, 300 )
			
		
		break ////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////	
		case eMaps.mp_rr_arena_phase_runner: //TODO: FIX ME
		
			defaultWaitingRoom = NewLocPair( < 705.502, -5885.31, 432.031 >, < 355.676, 90, 0 > )
			waitingRoomPanelLocation = SetWaitingRoomAndGeneratePanelLocs( defaultWaitingRoom )
			
		break ////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////	
		case eMaps.mp_rr_arena_skygarden:
		
			defaultWaitingRoom = NewLocPair( < -7.8126, -1320.75, 2877.51 >, < 359.849, 270.32, 0 > )
			waitingRoomPanelLocation = SetWaitingRoomAndGeneratePanelLocs( defaultWaitingRoom )
		
		break ////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////
		case eMaps.mp_rr_olympus_mu1:

			defaultWaitingRoom = NewLocPair( < 318.434906, -19474.4141, -4947.88867 > , < 0, 32.8506927, 0 > )
			waitingRoomPanelLocation = SetWaitingRoomAndGeneratePanelLocs( defaultWaitingRoom )
		
			if( is3v3Mode() ) //TODO: abstract into rpak when locations are complete
			{
				customSpawns = [
					NewLocPair( <-20382.9375, 28349.0488, -6379.54199>, <0, 42.8024635, 0> ),
					NewLocPair( <-15628.7354, 33786.6602, -6181.9043>, <0, -144.864426, 0> ),
					NewLocPair( <-21250.4883, 34012.3867, -6383.88867>, <0, -62.3558273, 0> ),

					NewLocPair( <-20105.1855, -1279.15027, -5568.2041>, <0, 149.361572, 0> ),
					NewLocPair( <-26193.8652, 2219.52808, -5573.85596>, <0, -30.5185471, 0> ),
					NewLocPair( <-24378.3047, -1635.08997, -5341.96875>, <0, 59.6698799, 0> ),
					
					NewLocPair( <21201.8613, -14852.7305, -5032.22363>, <0, -78.5065842, 0> ),
					NewLocPair( <21783.9785, -21842.8613, -5032.22363>, <0, 107.717316, 0> ),
					NewLocPair( <17949.0391, -18802.1172, -4923.96875>, <0, 5.94164991, 0> ),

					NewLocPair( <9436.18555, 28426.0469, -4654.91553>, <0, -127.501564, 0> ),
					NewLocPair( <3670.51611, 20282.0215, -5598.02393>, <0, 57.8940849, 0> ),
					NewLocPair( <7840.729, 19089.4102, -5498.23828>, <0, 81.0241699, 0> )
				]
				 

			}
			else
			{
				customSpawns = [
					NewLocPair( <-16998.4922, 11897.5928, -6397.17383>, <0, 69.6194611, 0> ),
					NewLocPair( <-16332.7354, 13246.3271, -6399.63477>, <0, -115.500526, 0> )
				]
			}
		
		
		break ////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////
		case eMaps.mp_rr_desertlands_64k_x_64k:


			defaultWaitingRoom = NewLocPair( < -19830.3633, 14081.7314, -3759.98901 >, < 0, -83.0441132, 0 > )
			waitingRoomPanelLocation = SetWaitingRoomAndGeneratePanelLocs( defaultWaitingRoom )

			if( is3v3Mode() )//TODO: abstract into rpak when locations are complete
			{
				customSpawns = [
					NewLocPair(< 16973.2, -36466, -2303.97 >,< 352.281, 321.33, 0> ),
					NewLocPair(< 19355.4, -41303.7, -2262.45 >,< 353.245, 96.8112, 0> ),
					NewLocPair(< 22282.2, -37600.3, -2290.16 >,< 348.557, 187.095, 0> ),
					NewLocPair(< 18967, -12275.2, -4262.15 >,< 351.624, 26.817, 0> ),
					NewLocPair(< 20979.9, -7873.99, -4215.85 >,< 349.081, 294.925, 0> ),
					NewLocPair(< 24312.2, -9646.61, -4202.4 >,< 349.979, 205.464, 0> ),
					NewLocPair(< 26875.9, -4719.58, -3983.98 >,< 355.814, 298.851, 0> ),
					NewLocPair(< 24108.4, -6797.03, -4024.09 >,< 3.65349, 20.5079, 0> ),
					NewLocPair(< 30206.4, -8214.12, -3694.21 >,< 356.006, 176.584, 0> ),
					NewLocPair(< 19911.5, -210.577, -4136.42 >,< 355.197, 64.552, 0> ),
					NewLocPair(< 21876.2, 1422.47, -4192.97 >,< 358.146, 196.386, 0> ),
					NewLocPair(< 20426.2, 4677.14, -4204.88 >,< 354.775, 282.706, 0> ),
					NewLocPair(< 32507.1, 7385.81, -3399.97 >,< 356.499, 141.602, 0> ),
					NewLocPair(< 29252.5, 10825.3, -3475.97 >,< 353.329, 226.911, 0> ),
					NewLocPair(< 25693, 8663.01, -3119.97 >,< 357.951, 43.6134, 0> ),
					NewLocPair(< 12085.1, 20297.4, -3939.41 >,< 1.44267, 335.301, 0> ),
					NewLocPair(< 11974, 19785.6, -5071.97 >,< 357.776, 22.3127, 0> ),
					NewLocPair(< 10382.3, 20532.9, -4823.94 >,< 356.003, 23.4536, 0> ),
					NewLocPair(< -3797.72, 19492.7, -2674.87 >,< 359.759, 48.6196, 0> ),
					NewLocPair(< 342.943, 18597.2, -2959.97 >,< 1.67727, 178.833, 0> ),
					NewLocPair(< -2240.56, 22829.7, -3028.42 >,< 352.536, 227.366, 0> ),
					NewLocPair(< 14782.8, 6011.98, -3855.97 >,< 0.147082, 179.014, 0> ),
					NewLocPair(< 12332, 5877.66, -4020.17 >,< 358.158, 152.516, 0> ),
					NewLocPair(< 9473.2, 5423.21, -3695.97 >,< 2.95064, 19.8954, 0> ),
					NewLocPair(< -19499.1, 25789.3, -3371.97 >,< 3.86378, 309.852, 0> ),
					NewLocPair(< -19210.9, 22876.9, -3351.97 >,< 359.478, 71.1216, 0> ),
					NewLocPair(< -17119.6, 25106.3, -3896.97 >,< 359.161, 186.302, 0> ),
					NewLocPair(< -9218.37, 29564, -3985.97 >,< 0.19284, 318.947, 0> ),
					NewLocPair(< -8645.08, 29628.9, -3705.97 >,< 9.4465, 194.86, 0> ),
					NewLocPair(< -9473.48, 29860.6, -3497.97 >,< 5.08271, 7.06796, 0> ),
					NewLocPair(< -27773.4, 8762.61, -3168.97 >,< 1.96498, 57.4089, 0> ),
					NewLocPair(< -25410.2, 8411.12, -3364.97 >,< 1.17431, 145.747, 0> ),
					NewLocPair(< -25256.6, 8665.16, -2960.97 >,< 357.893, 179.073, 0> ),
					NewLocPair(< -19964.9, -29592.3, -3749.41 >,< 359.479, 305.852, 0> ),
					NewLocPair(< -16495.9, -29493.9, -3348.54 >,< 7.87215, 153.981, 0> ),
					NewLocPair(< -19946.7, -30409.9, -3749.41 >,< 353.534, 204.183, 0> ),
					NewLocPair(< -7473.88, -29357.8, -3563.79 >,< 358.314, 264.852, 0> ),
					NewLocPair(< -8705.69, -32702.3, -3498.85 >,< 0.533245, 305.132, 0> ),
					NewLocPair(< -5250.25, -33407.4, -3341.1 >,< 359.723, 196.167, 0> )
				]
				 

			}
			else
			{
				customSpawns = [
					NewLocPair( <10035.9492, 6384.8374, -4295.96875>, <0, -91.0993118, 0> ),
					NewLocPair( <10021.5088, 4968.38623, -4303.90625>, <0, 88.8588943, 0> )
				]
			}
		
		
		break ////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////
		case eMaps.mp_rr_canyonlands_mu2:
		
			defaultWaitingRoom = NewLocPair( < -915.356, 20298.4, 4570.03 >, < 3.22824, 44.1054, 0 > )
			waitingRoomPanelLocation = SetWaitingRoomAndGeneratePanelLocs( defaultWaitingRoom )
			
			if( is3v3Mode() )//TODO: abstract into rpak when locations are complete
			{
				customSpawns = [
					NewLocPair( <19356.6816, 8522.87305, 4042.40039> , <0, 55.6736412, 0> ),
					NewLocPair( <26999.6836, 17004.0176, 3332.56128> , <0, -151.621841, 0> ),

					NewLocPair( <-16412.1445, -8597.46973, 3309.15259> , <0, -132.202454, 0> ),
					NewLocPair( <-20556.3535, -13442.3467, 3205.87817> , <0, 61.0804405, 0> ),
					
					NewLocPair( <3425.80518, -10499.7891, 3285.03125> , <0, -175.575607, 0> ),
					NewLocPair( <-2240.12695, -11501.4404, 3167.58057> , <0, 9.96513939, 0> ),

					NewLocPair( <34933.0859, 20244.8984, 4202.85254> , <0, 35.38274, 0> ),
					NewLocPair( <37117.9102, 23769.4707, 4019.0625> , <0, -122.349365, 0> )
				]
				 

			}
			else
			{
				customSpawns = [
					NewLocPair( <-16998.4922, 11897.5928, -6397.17383>, <0, 69.6194611, 0> ),
					NewLocPair( <-16332.7354, 13246.3271, -6399.63477>, <0, -115.500526, 0> )
				]
			}
		
		break ////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////	
	}//: Switch (eMap)
	
	#if DEVELOPER //for timing tests
		printt(" --- CALLING CUSTOM SPAWN CALLBACKS --- ")
	#endif
	//add with AddCallback_FlowstateSpawnsInit( functionref ) 
	//  function ref should return a LocPairData data object
	foreach( callbackFunc in file.onSpawnInitCallbacks )
	{
		LocPairData data = callbackFunc()
		
		if ( data.spawns.len() > 0 )
		{
			if( data.bOverrideSpawns )
			{
				#if DEVELOPER 
					Warning("Spawns overriden with custom spawns - count: [" + string( data.spawns.len() ) + "]" )
				#endif 
				customSpawns = data.spawns
				file.overrideSpawns = true
			}
			else 
			{
				#if DEVELOPER 
					Warning("Spawns extended with custom spawns - count: [" + string( data.spawns.len() ) + "]" )
				#endif 
				customSpawns.extend( data.spawns )
			}	
		}
			
		if( data.waitingRoom != null )
		{
			LocPair varWaitingRoom = expect LocPair( data.waitingRoom )
			getWaitingRoomLocation().origin = varWaitingRoom.origin
			getWaitingRoomLocation().angles = varWaitingRoom.angles
		}
		
		if( data.panels != null )
		{
			LocPair varPanels = expect LocPair( data.panels )
			waitingRoomPanelLocation = NewLocPair( varPanels.origin, varPanels.angles )
		}
	}
	
	return customSpawns
}


LocPair function SetWaitingRoomAndGeneratePanelLocs( LocPair defaultWaitingRoom, vector panelOffset = <0,0,0>, int panelDistance = MASTER_PANEL_ORIGIN_OFFSET, vector originOffset = <0,0,0>, vector anglesOffset = <0,0,0> )
{
	LocPair defaultPanels
	
	vector panelsOffset = < defaultWaitingRoom.origin.x, defaultWaitingRoom.origin.y, defaultWaitingRoom.origin.z > + panelOffset
	vector endPos = defaultWaitingRoom.origin + ( AnglesToForward( defaultWaitingRoom.angles ) * panelDistance ) //ty zee
	
	defaultPanels = NewLocPair( <endPos.x, endPos.y, panelsOffset.z >, defaultWaitingRoom.angles )
	
	#if DEVELOPER
		file.panelsloc = defaultPanels
	#endif
	
	getWaitingRoomLocation().origin = defaultWaitingRoom.origin + originOffset
	getWaitingRoomLocation().angles = defaultWaitingRoom.angles + anglesOffset
	
	return defaultPanels
}

vector function GenerateMapGamemodeBasedOffset( int eMap )
{
	vector baseOffset = <0,0,0>
	
	if( eMap == eMaps.mp_rr_canyonlands_staging && Playlist() == ePlaylists.fs_lgduels_1v1 )
	{
		return LG_DUELS_OFFSET_ORIGIN //prop based map can be moved based on this offset, therefore spawns are dynamically adjusted
	}
	
	//if(){}
	
	return baseOffset
}

string function GenerateAssetStringForMapAndGamemode( int eMap, string set, string customRpak = "", string playlistOverride = "" )
{
	string spawnset = ""
	
	if ( !empty( customRpak ) )
	{
		#if DEVELOPER 
			printt("Custom spawns rpak is defined and set to be used: ", customRpak )
		#endif 
		spawnset = customRpak
	}
	else 
	{
		string dtbl_MapRef 			= AllMapsArray()[eMap]
		string dtbl_PlaylistRef 	= AllPlaylistsArray()[Playlist()]
		
		//pre conditionals
		if ( !empty( playlistOverride ) )
		{
			#if DEVELOPER 
				printt( "Using playlist override ref", playlistOverride, "to load spawn set." )
			#endif 
			dtbl_PlaylistRef = playlistOverride
		}
		
		// set spawnset
		spawnset 					= "datatable/fs_spawns_" + dtbl_PlaylistRef + "_" + dtbl_MapRef + set + ".rpak"		
	}
	
	file.currentSpawnPak = spawnset
	return spawnset
}

array<LocPair> function FetchReturnAllLocations( int eMap, string set = "_set_1", string customRpak = "", string customPlaylist = "" )
{
	array<LocPair> allSoloLocations
	
	try
	{
		string spawnset 	= GenerateAssetStringForMapAndGamemode( eMap, set, customRpak, customPlaylist )
		vector originOffset = GenerateMapGamemodeBasedOffset( eMap )
		
		asset fetchasset 	= CastStringToAsset( spawnset )
		var datatable 		= GetDataTable( fetchasset )	
		
		int spawnsCount 	= GetDatatableRowCount( datatable )
		int originCol 		= GetDataTableColumnByName( datatable, "origin" )
		int anglesCol 		= GetDataTableColumnByName( datatable, "angles" )
		
		#if DEVELOPER
			string print_data = "\n\n spawnset: " + spawnset + "\n--- LOCATIONS ---\n\n"
		#endif
		for ( int i = 0; i < spawnsCount; i++ )
		{		
			vector origin = GetDataTableVector( datatable, i, originCol ) + originOffset
			vector angles = GetDataTableVector( datatable, i, anglesCol )
			
			#if DEVELOPER
				print_data += "Found origin: " + VectorToString( origin ) + " angles: " + VectorToString( angles ) + "\n"	
			#endif
			
			allSoloLocations.append( NewLocPair( origin, angles ) )
		}	
		#if DEVELOPER 
			printt( print_data )
			printt("Unpacked [",allSoloLocations.len()," ] spawn locations from locations asset.")
		#endif 
	}
	catch(e)
	{
		sqerror( "Error: " + e )
	}
	
	array<LocPair> extraSpawnLocations = GenerateCustomSpawns( eMap )
	
	if( extraSpawnLocations.len() > 0 )
	{
		if( file.overrideSpawns )
		{
			allSoloLocations = extraSpawnLocations
		}
		else 
		{
			allSoloLocations.extend( extraSpawnLocations )
			#if DEVELOPER
				printt("Added: [",extraSpawnLocations.len(),"] locations from custom spawns.")
			#endif 
		}
		
		#if DEVELOPER
			string print_sdata = ""
				foreach( spawn in extraSpawnLocations )
				{
					print_sdata += "Found origin: " + VectorToString( spawn.origin ) + " angles: " + VectorToString( spawn.angles ) + "\n"	
				}
			printt( "\n\n" + print_sdata )
		#endif
	}
	
	return allSoloLocations
}


//////////////////////////////////////////////////////////////////////
//						  DEVELOPER FUNCTIONS						//
//////////////////////////////////////////////////////////////////////

#if DEVELOPER

bool function IsValidIndex( array<string> haystack, int index )
{
	return index >= 0 && index < haystack.len();
}

void function DEV_del_pos( int index )
{
	if( IsValidIndex( file.dev_positions, index ) )
	{
		file.dev_positions_LocPair.remove( index )
		file.dev_positions.remove( index )
		printt( "Removed element", index )
		printm( "Removed element", index )
		DEV_PrintPosArray()
	}
	else 
	{
		printt( "Index", index, "was invalid and could not be removed." )
		printm( "Index", index, "was invalid and could not be removed." )
	}
}

void function DEV_PrintPosArray( string sFormat = "" )
{
	string printstring = "\n\n ----- POSITIONS ARRAY ----- \n\n"
	printm( "\n\n ----- POSITIONS ARRAY ----- \n\n" )
	
	int spawnSetCount = 0
	if( file.dev_positions.len() > 0 )
	{
		foreach( index, posString in file.dev_positions )
		{		
			
			string identifier = GetIdentifier( index, file.teamsize )
			
			if( ( index + 1 ) % file.teamsize == 1 )
			{
				string style = index > 1 ? "\n" : "";
				spawnSetCount++; 
				printstring += style + "Spawn set " + spawnSetCount + "\n############\n"
				printm( style + "Spawn set " + spawnSetCount + "\n############\n" )
			}
			
			printstring += string( index ) + " = " + posString + ":Player: " + identifier + "\n";
			printm( string( index ) + " = " + posString + ":Player: " + identifier )
		}
	}
	else 
	{
		printstring += "~~none~~";
	}
	
	printt( printstring )
}

array<string> letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
const int LETTER_COUNT = 26

string function GetIdentifier( int index, int teamsize )
{
    int setIndex = index % teamsize
    int letterIndex = setIndex % LETTER_COUNT
    int cycle = setIndex / LETTER_COUNT
    return letters[letterIndex] + ( cycle > 0 ? cycle.tostring() : "" )
}

string function DEV_append_pos_array_squirrel( vector origin, vector angles )
{	
	return "NewLocPair( < " + origin.x + ", " + origin.y + ", " + origin.z + " >, < " + angles.x + ", " + angles.y + ", " + angles.z + " > ),";	
}

string function DEV_append_pos_array_csv( vector origin, vector angles )
{
	return "\"< " + origin.x + ", " + origin.y + ", " + origin.z + " >\",\"< " + angles.x + ", " + angles.y + ", " + angles.z + ">\" ";
}

void function DEV_convert_array_to_csv_from_squirrel()
{
	for( int i = 0; i < file.dev_positions.len(); i++ )
	{
		file.dev_positions[i] = StringReplaceLimited( file.dev_positions[i], "NewLocPair( < ", "\"< ", 1 )
		file.dev_positions[i] = StringReplace( file.dev_positions[i], " >, < ", ">\",\"< " )
		file.dev_positions[i] = StringReplace( file.dev_positions[i], " > ),", ">\" " )
	}
	
	printt("Converted current array to csv.")
	printm("Converted current array to csv.")
	DEV_PrintPosArray()
}


void function DEV_convert_array_to_squirrel_from_csv()
{
	for( int i = 0; i < file.dev_positions.len(); i++ )
	{
		file.dev_positions[i] = StringReplaceLimited( file.dev_positions[i], "\"< ", "NewLocPair( < ", 1 )
		file.dev_positions[i] = StringReplace( file.dev_positions[i], ">\",\"< " , " >, < " )
		file.dev_positions[i] = StringReplace( file.dev_positions[i], ">\" ", " > )," )
	}
	
	printt("Converted current array to squirrel.")
	printm("Converted current array to squirrel.")
	DEV_PrintPosArray()
}

string function DEV_PosType( string setToType = "" )
{
	if ( !empty( setToType ) )
	{
		if ( file.validPosTypes.contains( setToType ) )
		{
			if( setToType == "csv" && DEV_PosType() == "sq" )
			{
				DEV_convert_array_to_csv_from_squirrel()
			}
			else if( setToType == "sq" && DEV_PosType() == "csv" )
			{
				DEV_convert_array_to_squirrel_from_csv()
			}
			else if( !empty( DEV_PosType() ) )
			{
				printt( "Type is already set to ", setToType )
				printm( "Type is already set to ", setToType )
				return file.dev_positions_type
			}
				
			file.dev_positions_type = setToType
			printt("Spawn saving format was set to", "\"" + setToType + "\"" )
			printm("Spawn saving format was set to", "\"" + setToType + "\"" )
		}
		else 
		{
			printt( "Invalid type [", setToType,"] specified." )
			printm( "Invalid type [", setToType,"] specified." )
			return file.dev_positions_type
		}
	}
	return file.dev_positions_type
}

void function DEV_AddSpawn( string pid, int replace = -1 )
{	
	if( empty( pid ) )
	{
		printt( "No player provided to first param of", FUNC_NAME() + "()" )
		printm( "No player provided to first param of", FUNC_NAME() + "()" )
		return
	}

	entity player = GetPlayer( pid )
	
	if( !IsValid( player ) )
	{
		printt( "Invalid player" )
		printm( "Invalid player" )
		return
	}

	table playerPos = GetPlayerPos( player )
	vector origin = expect vector( playerPos.origin )
	vector angles = expect vector( playerPos.angles )

	string str = ""
	
	switch( DEV_PosType() )
	{
		case "csv":
			if( DEV_PosType() == "sq" )
				DEV_convert_array_to_csv_from_squirrel()
				
			str = DEV_append_pos_array_csv( origin, <angles.x, angles.y, angles.z> )
			
		break
		case "sq":
			if ( DEV_PosType() == "csv" )
				DEV_convert_array_to_squirrel_from_csv()
				
			str = DEV_append_pos_array_squirrel( origin, <angles.x, angles.y, angles.z> )
			
		break
		
		default:
			printt("No type was set. Set type with DEV_PosType(\"csv\") or \"sq\" for squirrel code")
			printm("No type was set. Set type with DEV_PosType(\"csv\") or \"sq\" for squirrel code")
			return
	}
	
	Message( player, "SPAWN ADDED", str )
	#if TRACKER && HAS_TRACKER_DLL
		SendServerMessage( "Spawn added: " + str )
	#endif 
	printt( format( "Pos: %s", str ) )
	printm( format( "Pos: %s", str ) )
	
	LocPair data;
	data.origin = origin 
	data.angles = angles
	
	if( replace > -1 && IsValidIndex( file.dev_positions, replace ) )
	{	
		file.dev_positions_LocPair[replace] = data
		file.dev_positions[replace] = str 
	}
	else 
	{
		file.dev_positions_LocPair.append( data )
		file.dev_positions.append( str )
	}
}

void function DEV_ClearPos()
{
	file.dev_positions.clear()
	file.dev_positions_LocPair.clear()
	printt( "Cleared all saved positions" )
	printm( "Cleared all saved positions" )
}

void function DEV_tp_to_pos( string pid = "", int posIndex = 0 )
{	
	entity player 
	
	if ( !empty( pid ) )
	{
		player = GetPlayer( pid )
	}
	else 
	{
		printt( "No player specified for param 1 of", FUNC_NAME() )
		printm( "No player specified for param 1 of", FUNC_NAME() )
		return
	}
	
	if( !IsValid( player ) )
	{
		printt( "Invalid player" )
		printm( "Invalid player" )
		return 
	}
	
	if( !IsValidIndex( file.dev_positions, posIndex ) )
	{
		printt( "Invalid spawn selected" )
		printm( "Invalid spawn selected" )
		return
	}
	
	if( file.dev_positions_LocPair.len() != file.dev_positions.len() )
	{
		Warning( "LOCPAIR & PRINT POSITIONS DO NOT MATCH" )
		printm( "LOCPAIR & PRINT POSITIONS DO NOT MATCH" )
		return
	}

	printt( "Teleporting to spawnpoint", posIndex )
	printm( "Teleporting to spawnpoint", posIndex )
	printt( file.dev_positions[posIndex] )
	printm( file.dev_positions[posIndex] )
	maki_tp_player( player, file.dev_positions_LocPair[posIndex] )
}

void function DEV_pos_help()
{
	string helpinfo = "\n\n ---- POSITION COMMANDS ----- \n\n"
	
	foreach( command, helpstring in file.DEV_POS_COMMANDS )
	{
		helpinfo += command + " = " + helpstring + "\n";
		printm( command + " = " + helpstring )	
	}
	
	printt( helpinfo )
}

void function DEV_WritePosOut()
{
	if( file.dev_positions.len() <= 0 )
	{
		printt( "No spawn positions to write stdout" )
		printm( "No spawn positions to write stdout" )
		return 
	}
	
	DevTextBufferClear()

	//////////////
	// 	 OPEN	//
	//////////////
	if( DEV_PosType() == "csv" )
		DevTextBufferWrite( "origin,angles\n" )
		
	if( DEV_PosType() == "sq" )
		DevTextBufferWrite( "array<LocPair> spawns = \n[ \n" )
		
	string spacing = DEV_PosType() == "sq" ? TableIndent(15) : "";
	
	foreach( position in file.dev_positions )
	{
		DevTextBufferWrite( spacing + position + "\n" )
	}
	
	//////////////
	//	CLOSURE	//
	//////////////
	if( DEV_PosType() == "csv" )
		DevTextBufferWrite( "vector,vector\n" )
		
	if( DEV_PosType() == "sq" )
		DevTextBufferWrite( "];" )
	
	string fType = ".txt";
	
	if( DEV_PosType() == "csv" )
	{
		fType = ".csv"
	}
	else if( DEV_PosType() == "sq" ) 
	{
		fType = ".nut"
	}

	int uTime 			= GetUnixTimestamp()
	string file 		= "spawns_" + string( uTime ) + fType
	string directory 	= "output/"
	
	DevP4Checkout( file )
	DevTextBufferDumpToFile( directory + file )
	printt("Wrote file to: ", directory + file )
	printm("Wrote file to: ", directory + file )
}

void function DEV_SetTeamSize( int size )
{
	file.teamsize = size
	printt( "Team size set to", size )
	printm( "Team size set to", size )
}

LocPair function DEV_tp_to_panels()
{
	return file.panelsloc
}

array<LocPair> function customDevSpawnsList()
{
	array<LocPair> spawns = 
	[ 
		NewLocPair( < 21571.2, -38315.6, -2220.33 >, < 5.24698, 276.919, 0 > ),
		NewLocPair( < 19886.9, -40480.5, -2220.33 >, < 3.51996, 7.62843, 0 > ),
		NewLocPair( < 21706.7, -40174.5, -2220.3 >, < 4.56219, 142.329, 0 > ),
		NewLocPair( < 20994.1, -10747.6, -4134.61 >, < 2.58227, 114.477, 0 > ),
		NewLocPair( < 20404, -9440, -4130.61 >, < 4.33487, 294.074, 0 > ),
		NewLocPair( < 19168.6, -10683, -4174.59 >, < 359.776, 27.1522, 0 > ),
		NewLocPair( < 27898, -4883.51, -3975.98 >, < 2.27297, 314.628, 0 > ),
		NewLocPair( < 29196, -6981.77, -3620.77 >, < 4.91559, 42.2109, 0 > ),
		NewLocPair( < 30156.8, -8187.79, -3695.4 >, < 359.362, 201.996, 0 > ),
		NewLocPair( < 19568.1, 3619.8, -4083.48 >, < 8.71203, 358.715, 0 > ),
		NewLocPair( < 20440.1, 4088.34, -3935.97 >, < 5.23619, 27.8162, 0 > ),
		NewLocPair( < 21840.5, 3244.21, -4087.97 >, < 3.42291, 179.432, 0 > ),
		NewLocPair( < 30499, 10332.4, -3463.97 >, < 2.19265, 340.815, 0 > ),
		NewLocPair( < 32962, 9651.33, -3595.97 >, < 1.8348, 204.779, 0 > ),
		NewLocPair( < 32303.5, 7670.99, -3399.97 >, < 5.88895, 86.1931, 0 > ),
		NewLocPair( < 27656, 11566.7, -3333.05 >, < 6.70514, 89.4928, 0 > ),
		NewLocPair( < 28169.9, 14017.2, -3096.08 >, < 8.58106, 176.488, 0 > ),
		NewLocPair( < 27055.7, 14253.5, -3121.8 >, < 6.91889, 328.014, 0 > ),
		NewLocPair( < 12028, 19842.8, -5071.97 >, < 7.74917, 61.6774, 0 > ),
		NewLocPair( < 10763.7, 20620.4, -5021.19 >, < 0.721139, 2.94495, 0 > ),
		NewLocPair( < 12422, 20024.9, -3955.5 >, < 6.13481, 37.477, 0 > ),
		NewLocPair( < 12215.7, 6224.99, -4135.97 >, < 2.15493, 301.381, 0 > ),
		NewLocPair( < 13710.8, 5519.57, -4295.97 >, < 3.51585, 135.276, 0 > ),
		NewLocPair( < 13727.8, 6805.13, -4125.45 >, < 7.85658, 207.357, 0 > ),
		NewLocPair( < 9739.9, 5670.5, -3695.97 >, < 6.19938, 206.917, 0 > ),
		NewLocPair( < 9899.33, 5889.62, -4295.97 >, < 0.241581, 226.194, 0 > ),
		NewLocPair( < 8188.41, 6422.55, -4328.97 >, < 4.43221, 343.673, 0 > ),
		NewLocPair( < -3173.09, 19093.4, -2710.9 >, < 3.11988, 328.317, 0 > ),
		NewLocPair( < 44.5532, 18607.7, -2950.61 >, < 1.29781, 134.363, 0 > ),
		NewLocPair( < 170.456, 20832.4, -2998.95 >, < 359.924, 233.759, 0 > ),
		NewLocPair( < -9093.1, 29465.8, -3297.97 >, < 7.87784, 340.927, 0 > ),
		NewLocPair( < -9109.85, 29733.4, -3705.97 >, < 4.4871, 298.136, 0 > ),
		NewLocPair( < -9036.7, 29103.5, -3985.97 >, < 1.55586, 102, 0 > ),
		NewLocPair( < -19067.1, 22952.7, -3351.97 >, < 7.82167, 290.408, 0 > ),
		NewLocPair( < -19354.7, 22662.6, -4039.97 >, < 8.6704, 56.1921, 0 > ),
		NewLocPair( < -20649.8, 23252.1, -4088.94 >, < 358.799, 356.094, 0 > ),
		NewLocPair( < -25572.1, 8425.76, -2960.97 >, < 4.11316, 39.1704, 0 > ),
		NewLocPair( < -25531.3, 8567.46, -3364.97 >, < 0.992981, 225.578, 0 > ),
		NewLocPair( < -27476, 9324.44, -3168.97 >, < 4.99117, 324.014, 0 > ),
		NewLocPair( < -22985, -20526.7, -4080.12 >, < 8.68259, 359.654, 0 > ),
		NewLocPair( < -20570.5, -17410.2, -4043.91 >, < 3.60389, 266.156, 0 > ),
		NewLocPair( < -19860.9, -20718.1, -3187.63 >, < 10.476, 191.576, 0 > ),
		NewLocPair( < -17184.4, -29771.7, -3471.97 >, < 3.20937, 183.963, 0 > ),
		NewLocPair( < -19610.4, -29894.6, -3749.41 >, < 6.02845, 225.983, 0 > ),
		NewLocPair( < -20096.8, -30485.4, -3751.52 >, < 3.42621, 44.4348, 0 > ),
		NewLocPair( < -6612.29, -30421.6, -3559.94 >, < 9.03763, 262.677, 0 > ),
		NewLocPair( < -5476.95, -33721.2, -3337.12 >, < 10.6455, 178.458, 0 > ),
		NewLocPair( < -7238.02, -32846, -3469.78 >, < 3.58117, 356.822, 0 > ),
		NewLocPair( < 12125.6, 1809.22, -3621.78 >, < 12.9427, 91.5103, 0 > ),
		NewLocPair( < 10943.2, 3012.45, -4295.97 >, < 358.444, 317.55, 0 > ),
		NewLocPair( < 14546.3, 3803.29, -4271.99 >, < 359.183, 221.825, 0 > ),
		NewLocPair( < 17412.6, -1700.06, -3466.56 >, < 359.477, 201.463, 0 > ),
		NewLocPair( < 14846.7, -2687.5, -3236.45 >, < 8.30138, 57.1494, 0 > ),
		NewLocPair( < 14109.1, -694.488, -3625.18 >, < 4.55861, 315.723, 0 > ),
		NewLocPair( < -12933.8, 32999.7, -3863.97 >, < 5.53265, 269.791, 0 > ),
		NewLocPair( < -12773.3, 32075.2, -4079.97 >, < 2.5599, 177.638, 0 > ),
		NewLocPair( < -13309.9, 30093, -4039.99 >, < 2.25235, 81.8431, 0 > ),
		NewLocPair( < -10221.7, -26834.7, -2895.19 >, < 8.6499, 332.555, 0 > ),
		NewLocPair( < -7745.85, -26691.1, -4136.14 >, < 1.36961, 209.059, 0 > ),
		NewLocPair( < -9225.73, -28118.5, -3796.55 >, < 349.513, 104.549, 0 > ),
	];
	
	return spawns
}

void function DEV_HighlightSpawns()
{
	if ( file.highlightOn )
	{
		foreach( beam in file.allBeamEntities )
		{
			if( IsValid ( beam ) )
			{
				beam.Destroy()
			}
		}
		
		file.highlightOn = false 
	}
	else 
	{
		file.highlightOn = true 
		
		foreach ( spawn in file.dev_positions_LocPair )
		{
			entity beam = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_chamber_beam" ), spawn.origin, spawn.angles )
			file.allBeamEntities.append( beam )
		}
	}
}

void function DEV_LoadPak( string pak = "", string playlist = "" )
{
	if( empty( DEV_PosType() ) )
	{
		Warning( "No spawn-maker type was set." )
		Warning( "Setting to squirrel code." )
		Warning( "Set type with DEV_PosType(\"csv\") or \"sq\" for squirrel code" )
		DEV_PosType("sq")
	}

	bool usePlaylist = false
	
	if( empty( pak ) )
	{
		printt( "Pak was empty, using current." )
		printm( "Pak was empty, using current." )
		pak = file.currentSpawnPak
	}
	
	if( !empty( playlist ) )
	{
		SetCustomPlaylist( playlist )
		usePlaylist = true
	}

	table<string,bool> spawnOptions = {}
	
	spawnOptions["use_sets"] <- true
	spawnOptions["use_random"] <- false
	spawnOptions["prefer"] <- false
	spawnOptions["use_custom_rpak"] <- SetCustomSpawnPak( pak )
	spawnOptions["use_custom_playlist"] <- usePlaylist
	
	array<LocPair> devLocations = customDevSpawnsList().len() > 0 ? customDevSpawnsList() : ReturnAllSpawnLocations( MapName(), spawnOptions )
	
	if( devLocations.len() > 0 )
	{
		DEV_ClearPos()
		
		string str 
		
		foreach( spawn in devLocations )
		{
			switch( DEV_PosType() )
			{
				case "csv":
					if( DEV_PosType() == "sq" )
						DEV_convert_array_to_csv_from_squirrel()
						
					str = DEV_append_pos_array_csv( spawn.origin, spawn.angles )
					
				break
				case "sq":
					if ( DEV_PosType() == "csv" )
						DEV_convert_array_to_squirrel_from_csv()
						
					str = DEV_append_pos_array_squirrel( spawn.origin, spawn.angles )
					
				break
				
				default:
					Warning("No type was set. Set type with DEV_PosType(\"csv\") or \"sq\" for squirrel code")
					printm("No type was set. Set type with DEV_PosType(\"csv\") or \"sq\" for squirrel code")
					return
			}
			
			file.dev_positions_LocPair.append( spawn )
			file.dev_positions.append( str )
		}
		
		Warning( "----LOADED PAK: " + pak + "----" )
		printm( "----LOADED PAK: " + pak + "----" )
		DEV_PrintPosArray()
	}
	else 
	{
		Warning("Locations are empty.")
		printm("Locations are empty.")
	}
	
}

#endif //DEVELOPER

//util

bool function ValidateOptions( table<string,bool> options )
{
	return ( 
		"use_sets" 				in options &&
		"use_random" 			in options &&
		"prefer"				in options &&
		"use_custom_rpak"		in options &&
		"use_custom_playlist" 	in options
	)
}

void function SetPreferredSpawnPak( int preference )
{
	file.preferredSpawnPak = preference
}

bool function SetCustomSpawnPak( string custom_rpak )
{
	bool success = false 
	
	if( !empty ( custom_rpak ) )
	{
		try 
		{
			asset test = CastStringToAsset( custom_rpak )
			GetDataTable( test )
			success = true
		}
		catch(e)
		{
			Warning( "Custom Rpak Error: " + e )
			Warning( "Skipping custom spawn rpak" )
		}
		
		if( success )
		{
			file.customSpawnpak = custom_rpak
		}
	}
	
	return success
}

void function SetCustomPlaylist( string playlistref )
{
	if( AllPlaylistsArray().contains( playlistref ) )
	{
		file.customPlaylist = playlistref
	}
	else 
	{
		Warning("Specified custom playlist in spawn pak, but playlist \"" + playlistref + "\" doesn't exist.")
	}	
}

string function GetCurrentSpawnSet()
{
	return file.currentSpawnPak
}

asset function GetCurrentSpawnAsset()
{
	asset returnAsset = $""
	
	try 
	{
		returnAsset = CastStringToAsset( file.currentSpawnPak )
		GetDataTable( returnAsset )
	}
	catch(e)
	{
		Warning( "Warning -- cast failed: " + e )
	}
	
	return returnAsset
}