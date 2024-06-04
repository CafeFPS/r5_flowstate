// flowstate spawn system

global function Flowstate_SpawnSystem_Init

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
	global function DEV_SpawnType
	global function DEV_AddSpawn
	global function DEV_PrintSpawns
	global function DEV_DeleteSpawn
	global function DEV_ClearSpawns
	global function DEV_TeleportToSpawn
	global function DEV_WriteSpawnFile
	global function DEV_SpawnHelp
	global function DEV_SetTeamSize
	global function DEV_TeleportToPanels
	global function DEV_LoadPak
	global function DEV_HighlightAll
	global function DEV_Highlight
	global function DEV_KeepHighlight
	global function DEV_SpawnInfo
	global function DEV_ReloadInfo
	global function DEV_InfoPanelOffset
	global function DEV_RotateInfoPanels
	
	const float HIGHLIGHT_SPAWN_DELAY 	= 7.0
	const int SPAWN_POSITIONS_BUDGET 	= 210
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
			bool highlightToggleAll = false
			bool highlightPersistent = true
			table<int,entity> allBeamEntities = {}
			bool spawnInfoPanels = true
			array< table<vector, string> > savedSpawnInfosExtendedArray
			vector infoPanelOffset = NULL_VEC
			vector infoPanelOffsetAngles = NULL_VEC
			bool bInfoPanelsAreReloading = false
			
			table<string,string> DEV_POS_COMMANDS = 
			{		
				["script DEV_SpawnType( string setToType = \"\" )"] = "Converts the current array of print outs to specified type, and further additions are added as the specified type. Returns the current type if no parameters are provided.",
				["script DEV_AddSpawn( string pid, int replace = -1 )"] = "Pass a player name/uid to have the current origin/angles of player appended to spawns array. If replace is specified, replaces the given index with new spawn, otherwise, the operation is append.",
				["script DEV_PrintSpawns()"] = "Prints the current made spawn positions array",
				["script DEV_DeleteSpawn( int index )"] = "Deletes a spawn from array by index",
				["script DEV_ClearSpawns( bool clearHighlights = true )"] = "Deletes all saved spawns. If passed false, does not remove highlights on map",
				["script DEV_TeleportToSpawn( string pid, int index )"] = "Teleport specified player by name/uid to a saved spawn by index",
				["script DEV_WriteSpawnFile()"] = "Write current locations to file in the current format, use printt( DEV_SpawnType() ) to see current type.",
				["script DEV_SpawnHelp()"] = "Prints this help msg...",
				["script DEV_SetTeamSize( int size )"] = "Sets the size of a team formatting the PrintSpawns() array",
				["script DEV_TeleportToPanels( playerName/uid )"] = "Teleports player to panel locations",
				["script DEV_LoadPak( string pak = \"\", string playlist = \"\" )"] = "Loads spawn pak specifying rpak asset and playlist. If custom spawns are wrote into script loads those instead.",
				["script DEV_HighlightAll()"] = "Shows/Removes beams of light on all spawns in the PosArray",
				["script DEV_Highlight( int index, bool persistent = false )"] = "Highlight a single spawn by spawn index. Called automatically on spawn add. If persistent is not provided beam destroys ater " + HIGHLIGHT_SPAWN_DELAY + " seconds.",
				["script DEV_KeepHighlight( bool setting = true )"] = "Sets whether spawn highlight stays after adding spawn.",
				["script DEV_SpawnInfo( bool setting = true )"] = "true/false, sets whether info panels show or not. On by default.",
				["script DEV_ReloadInfo()"] = "Manually reload all info panels.",
				["script DEV_InfoPanelOffset( vector offset = <0, 0, 600>, vector anglesOffset = <0, 0, 0> )"] = "Modify the offset of info panels. Call with no parameters to raise into sky by 600. Reloads all info panels.",
				["script DEV_RotateInfoPanels( string direction = \"clockwise\" )"] = "Rotate info panels in the event id's are not visible. Reloads panels."
			}
		#endif

	} file 

void function Flowstate_SpawnSystem_Init()
{
	#if DEVELOPER 
		RegisterSignal( "DelayedHighlightActivate" )
	#endif
}

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
		
		break ////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////
		case eMaps.mp_rr_desertlands_64k_x_64k:

			defaultWaitingRoom = NewLocPair( < -19830.3633, 14081.7314, -3759.98901 >, < 0, -83.0441132, 0 > )
			waitingRoomPanelLocation = SetWaitingRoomAndGeneratePanelLocs( defaultWaitingRoom )	
		
		break ////////////////////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////////////////////////
		case eMaps.mp_rr_canyonlands_mu2:
		
			defaultWaitingRoom = NewLocPair( < -915.356, 20298.4, 4570.03 >, < 3.22824, 44.1054, 0 > )
			waitingRoomPanelLocation = SetWaitingRoomAndGeneratePanelLocs( defaultWaitingRoom )
		
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


//////////////////////////////////////////////////////////////////////
//						  DEVELOPER FUNCTIONS						//
//////////////////////////////////////////////////////////////////////

#if DEVELOPER

bool function IsValidIndex( array<string> haystack, int index )
{
	return index >= 0 && index < haystack.len();
}

void function __RemoveAllPanels()
{
	int toDelete = file.dev_positions_LocPair.len() + 2
	
	for( int i = 0; i < toDelete; i++ )
	{
		foreach( player in GetPlayerArray() )
		{
			RemovePanelText( player, i )
		}
	}
}

void function DEV_ReloadInfo()
{	
	if( !__bCheckReload() )
		return
	
	if( file.spawnInfoPanels )
	{
		printt( "Reloading info panels." )
		printm( "Reloading info panels." )
		__RemoveAllPanels()
		DEV_PrintSpawns( true )
	}
	else 
	{
		printt( "Info panels are disabled." )
		printm( "Info panels are disabled." )
	}
}

void function DEV_InfoPanelOffset( vector offset = <0, 0, 600>, vector angles = NULL_VEC )
{
	file.infoPanelOffset = offset 
	file.infoPanelOffsetAngles = angles
	
	DEV_ReloadInfo()	
}

bool function __bCheckReload()
{
	if( file.bInfoPanelsAreReloading )
	{
		__ReloadWaitMsg()
	}
	else 
	{
		__ReloadingMsg()
	}
	
	return !file.bInfoPanelsAreReloading
}

void function __ReloadWaitMsg()
{
	printt( " PANELS ARE STILL RELOADING \n\n please wait and try again... " )
	printm( " PANELS ARE STILL RELOADING \n\n please wait and try again... " )
	
	foreach( player in GetPlayerArray() )
	{
		LocalEventMsg( player, "", " PANELS ARE STILL RELOADING \n\n please wait and try again... " )
	}
}

void function __ReloadingMsg()
{
	printt( " RELOADING PANELS " )
	printm( " RELOADING PANELS " )
	
	foreach( player in GetPlayerArray() )
	{
		LocalEventMsg( player, "", " RELOADING PANELS " )
	}
}

void function DEV_DeleteSpawn( int index )
{
	if( !__bCheckReload() )
		return
	
	if( IsValidIndex( file.dev_positions, index ) )
	{
		__RemoveAllPanels()
		
		file.dev_positions_LocPair.remove( index )
		file.dev_positions.remove( index )
		printt( "Removed spawn:", index )
		printm( "Removed spawn:", index )
		
		__DestroyHighlight( index )
		DEV_HighlightAll( true )
		DEV_HighlightAll( false )	
		DEV_PrintSpawns( true )
	}
	else 
	{
		printt( "Index", index, "was invalid and could not be removed." )
		printm( "Index", index, "was invalid and could not be removed." )
	}
}

void function DEV_PrintSpawns( bool bSyncInfoPanels = false )
{
	string printstring = "\n\n ----- POSITIONS ARRAY ----- \n\n"
	printm( "\n\n ----- POSITIONS ARRAY ----- \n\n" )
	
	array< table<vector,string> > spawnInfosList = []
	
	int spawnSetCount = 0
	
	if( file.dev_positions.len() > 0 )
	{		
		foreach( index, posString in file.dev_positions )
		{	
			table<vector,string> spawnInfos = {}
			string identifier = GetIdentifier( index, file.teamsize )
			
			if( ( index + 1 ) % file.teamsize == 1 )
			{
				string style = index > 1 ? "\n" : "";
				spawnSetCount++; 
				printstring += style + "Spawn set " + spawnSetCount + "\n############\n"
				printm( style + "Spawn set " + spawnSetCount + "\n############\n" )
			}
			
			spawnInfos[ < spawnSetCount, index, 0 > ] <- identifier
			spawnInfosList.append( spawnInfos )
			
			printstring += string( index ) + " = " + posString + " :Team: " + identifier + "\n";
			printm( string( index ) + " = " + posString + " :Team: " + identifier )
		}
	}
	else 
	{
		printstring += "~~none~~";
		printm( "~~none~~" )
	}
	
	if( file.spawnInfoPanels )
	{
		if( spawnInfosList.len() > 0 )
		{
			__LoopPanelDeletion( spawnInfosList, bSyncInfoPanels )
		}
	}
	
	printt( printstring )
}

void function __LoopPanelDeletion( array< table<vector, string> > spawnInfosListRef = [], bool bSyncInfoPanels = false )
{
	file.bInfoPanelsAreReloading = true
	
	thread( void function() : ( spawnInfosListRef, bSyncInfoPanels )
	{		
		array< table<vector, string> > spawnInfosList = []
		
		if( file.savedSpawnInfosExtendedArray.len() > 0 )
		{
			spawnInfosList = clone file.savedSpawnInfosExtendedArray
		}
		else 
		{
			spawnInfosList = clone spawnInfosListRef
		}
		
		array< table<vector, string> > spawnInfosArray
		array< table<vector, string> > spawnInfosExtendedArray
		
		bool bEnd = false
		int last = spawnInfosList.len() - 1
		
		if( spawnInfosList.len() > 10 )
		{
			spawnInfosArray = spawnInfosList.slice( 0, 9 ) //10 items
			file.savedSpawnInfosExtendedArray = spawnInfosList.slice( 9 )
			last = -1
		}
		else 
		{
			spawnInfosArray = spawnInfosList
			bEnd = true
		}
		
		foreach( int index, spawnInfos in spawnInfosArray )
		{	
			if( ( !bSyncInfoPanels && last != -1 && index == last ) || bSyncInfoPanels )
			{
				foreach( vector info, string identifier in spawnInfos )
				{
					//info.x = setcount, info.y = index
					waitthread __CreateInfoPanelForSpawn( int( info.x ), int( info.y ), identifier )
				}
			}
		}
		
		if( !bEnd )
		{
			__LoopPanelDeletionRecursive( bSyncInfoPanels )
		}
		else 
		{
			file.savedSpawnInfosExtendedArray.clear()
			file.bInfoPanelsAreReloading = false
		}
	})()
}

void function __LoopPanelDeletionRecursive( bool bSyncInfoPanels = false )
{
	__LoopPanelDeletion( [], bSyncInfoPanels )
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
	DEV_PrintSpawns()
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
	DEV_PrintSpawns()
}

string function DEV_SpawnType( string setToType = "" )
{
	if ( !empty( setToType ) )
	{
		if ( file.validPosTypes.contains( setToType ) )
		{
			if( setToType == "csv" && DEV_SpawnType() == "sq" )
			{
				DEV_convert_array_to_csv_from_squirrel()
			}
			else if( setToType == "sq" && DEV_SpawnType() == "csv" )
			{
				DEV_convert_array_to_squirrel_from_csv()
			}
			else if( !empty( DEV_SpawnType() ) )
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
	
	if( empty( DEV_SpawnType() ) )
	{
		printt( "No type was set. Set type with DEV_SpawnType(\"csv\") or \"sq\" for squirrel code")
		printm( "No type was set. Set type with DEV_SpawnType(\"csv\") or \"sq\" for squirrel code")
		printt( "Setting to squirrel code." )
		printm( "Setting to squirrel code." )
		DEV_SpawnType( "sq" )
	}

	entity player = GetPlayer( pid )
	
	if( !IsValid( player ) )
	{
		printt( "Invalid player" )
		printm( "Invalid player" )
		return
	}
	
	if( file.dev_positions_LocPair.len() > SPAWN_POSITIONS_BUDGET )
	{
		LocalEventMsg( player, "", " SPAWN BUDGET REACHED \n\n Cannot add more spawns " )
		return
	}

	table playerPos = GetPlayerPos( player )
	vector origin = expect vector( playerPos.origin )
	vector angles = expect vector( playerPos.angles )

	string str = ""
	
	switch( DEV_SpawnType() )
	{
		case "csv":
			if( DEV_SpawnType() == "sq" )
				DEV_convert_array_to_csv_from_squirrel()
				
			str = DEV_append_pos_array_csv( origin, <angles.x, angles.y, angles.z> )
			
		break
		case "sq":
			if ( DEV_SpawnType() == "csv" )
				DEV_convert_array_to_squirrel_from_csv()
				
			str = DEV_append_pos_array_squirrel( origin, <angles.x, angles.y, angles.z> )
			
		break
		
		default:
			printt("No type was set. Set type with DEV_SpawnType(\"csv\") or \"sq\" for squirrel code")
			printm("No type was set. Set type with DEV_SpawnType(\"csv\") or \"sq\" for squirrel code")
			return
	}
	
	LocPair data;
	data.origin = origin 
	data.angles = angles
	
	if( replace > -1 && IsValidIndex( file.dev_positions, replace ) )
	{	
		file.dev_positions_LocPair[replace] = data
		file.dev_positions[replace] = str 
		DEV_Highlight( replace, file.highlightPersistent )
	}
	else 
	{
		file.dev_positions_LocPair.append( data )
		file.dev_positions.append( str )
		DEV_Highlight( ( file.dev_positions_LocPair.len() - 1 ), file.highlightPersistent )
	}
	
	DEV_PrintSpawns( false )
	LocalEventMsg( player, "", " SPAWN ADDED \n\n " + " " + str + " " )
	
	#if TRACKER && HAS_TRACKER_DLL
		SendServerMessage( "Spawn added: " + str )
	#endif 
	
	printt( format( "\n\n Newly Added Spawn Pos: %s", str ) )
	printm( format( "\n\n Newly Added spawn Pos: %s", str ) )
	
}

void function DEV_KeepHighlight( bool setting = true )
{
	file.highlightPersistent = setting
	
	printt( "Keep highlights set to:", setting )
	printm( "Keep highlights set to:", setting )
}

void function DEV_ClearSpawns( bool clearHighlights = true )
{
	__RemoveAllPanels()
	
	file.dev_positions.clear()
	file.dev_positions_LocPair.clear()
	printt( "Cleared all saved positions" )
	printm( "Cleared all saved positions" )
	
	if( clearHighlights )
	{
		DEV_HighlightAll( true ) //removes all with true passed
	}
}

void function DEV_TeleportToSpawn( string pid = "", int posIndex = 0 )
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

void function DEV_SpawnHelp()
{
	string helpinfo = "\n\n ---- POSITION COMMANDS ----- \n\n"
	
	foreach( command, helpstring in file.DEV_POS_COMMANDS )
	{
		helpinfo += command + " = " + helpstring + "\n";
		printm( command + " = " + helpstring )	
	}
	
	printt( helpinfo )
}

void function DEV_WriteSpawnFile()
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
	if( DEV_SpawnType() == "csv" )
		DevTextBufferWrite( "origin,angles\n" )
		
	if( DEV_SpawnType() == "sq" )
		DevTextBufferWrite( "array<LocPair> spawns = \n[ \n" )
		
	string spacing = DEV_SpawnType() == "sq" ? TableIndent(15) : "";
	
	foreach( position in file.dev_positions )
	{
		DevTextBufferWrite( spacing + position + "\n" )
	}
	
	//////////////
	//	CLOSURE	//
	//////////////
	if( DEV_SpawnType() == "csv" )
		DevTextBufferWrite( "vector,vector\n" )
		
	if( DEV_SpawnType() == "sq" )
		DevTextBufferWrite( "];" )
	
	string fType = ".txt";
	
	if( DEV_SpawnType() == "csv" )
	{
		fType = ".csv"
	}
	else if( DEV_SpawnType() == "sq" ) 
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

void function DEV_TeleportToPanels( string identifier )
{
	entity player = GetPlayer( identifier )
	
	if( IsValid ( player ) )
	{
		if ( !IsValid( file.panelsloc ) )
		{
			printt("No panel locations")
			printm("No panel locations")
			return
		}
		
		maki_tp_player( player, file.panelsloc )
	}
	else 
	{
		printt("Invalid player.")
		printm("Invalid player.")
	}
}

void function DEV_HighlightAll( bool removeAll = false )
{
	if( file.dev_positions_LocPair.len() == 0 && !removeAll )
	{
		printt( "No spawns in PosArray to highlight" )
		printm( "No spawns in PosArray to highlight" )
		return 
	}
	
	string msg = ""
	if ( removeAll || file.highlightToggleAll )
	{
		foreach( int index, entity beam in file.allBeamEntities )
		{
			if( IsValid ( beam ) )
			{
				beam.Destroy()
			}
		}
		
		file.highlightToggleAll = false 
		msg = "Removed all spawn highlights."
	}
	else 
	{		
		foreach ( int index, LocPair spawn in file.dev_positions_LocPair )
		{
			entity beam = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_ar_titan_droppoint_tall" ), spawn.origin, <0,0,0> )
			EffectSetControlPointVector( beam, 1, Vector( 235, 213, 52 ) )
			__DestroyHighlight( index )
			file.allBeamEntities[ index ] <- beam
		}
		
		file.highlightToggleAll = true 
		msg = "Highlighted all spawns."
	}
	
	printt( msg )
	printm( msg )
}

bool function __DestroyHighlight( int index )
{
	if( index in file.allBeamEntities )
	{
		if( IsValid( file.allBeamEntities[ index ] ) )
		{
			file.allBeamEntities[ index ].Destroy()
			return true
		}
	}
	
	return false
}

void function DEV_RemoveHighlight( int index )
{
	if ( __DestroyHighlight ( index ) )
	{
		printt( "Highlight", index, "was removed" )
		printm( "Highlight", index, "was removed" )
	}
	else
	{
		printt( "No highlight exists for spawn index:", index )
		printm( "No highlight exists for spawn index:", index )
	}
}

void function DEV_Highlight( int index, bool persistent = true )
{
	if( index >= file.dev_positions_LocPair.len() || index < 0 )
	{
		printt( "Location does not exist" )
		printm( "Location does not exist" )
		return
	}
	
	LocPair spawn = file.dev_positions_LocPair[ index ]
	entity beam = StartParticleEffectInWorld_ReturnEntity( GetParticleSystemIndex( $"P_ar_titan_droppoint_tall" ), spawn.origin, <0,0,0> )
	EffectSetControlPointVector( beam, 1, Vector( 63, 72, 204 ) )
	
	if( persistent )
	{
		__DestroyHighlight( index )
		file.allBeamEntities[ index ] <- beam
	}
	else
	{
		thread __HighlightSpawn_DelayedEnd( beam )
	}	
}

void function __HighlightSpawn_DelayedEnd( entity beam )
{
	if ( !IsValid( beam ) )
		return
	
	Signal( svGlobal.levelEnt, "DelayedHighlightActivate" )
	EndSignal( svGlobal.levelEnt, "DelayedHighlightActivate" )
	
	OnThreadEnd( void function() : ( beam )
	{
		if( IsValid( beam ) )
		{
			beam.Destroy()
		}
	})
	
	wait HIGHLIGHT_SPAWN_DELAY	
}

void function DEV_LoadPak( string pak = "", string playlist = "" )
{
	if( !__bCheckReload() )
		return
		
	if( empty( DEV_SpawnType() ) )
	{
		Warning( "No spawn-maker type was set." )
		Warning( "Setting to squirrel code." )
		Warning( "Set type with DEV_SpawnType(\"csv\") or \"sq\" for squirrel code" )
		DEV_SpawnType("sq")
	}

	bool usePlaylist = false
	bool bUsePak = false
	
	if( empty( pak ) )
	{
		printt( "Pak was empty, using current." )
		printm( "Pak was empty, using current." )
		pak = file.currentSpawnPak
	}
	else 
	{
		//pak was specified, use the override 
		bUsePak = true
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
	
	array<LocPair> devLocations = customDevSpawnsList().len() > 0 && !bUsePak ? customDevSpawnsList() : ReturnAllSpawnLocations( MapName(), spawnOptions )
	
	if( devLocations.len() > 0 )
	{
		DEV_ClearSpawns()
		
		string str 
		
		foreach( spawn in devLocations )
		{
			switch( DEV_SpawnType() )
			{
				case "csv":
					if( DEV_SpawnType() == "sq" )
						DEV_convert_array_to_csv_from_squirrel()
						
					str = DEV_append_pos_array_csv( spawn.origin, spawn.angles )
					
				break
				case "sq":
					if ( DEV_SpawnType() == "csv" )
						DEV_convert_array_to_squirrel_from_csv()
						
					str = DEV_append_pos_array_squirrel( spawn.origin, spawn.angles )
					
				break
				
				default:
					Warning("No type was set. Set type with DEV_SpawnType(\"csv\") or \"sq\" for squirrel code")
					printm("No type was set. Set type with DEV_SpawnType(\"csv\") or \"sq\" for squirrel code")
					return
			}
			
			file.dev_positions_LocPair.append( spawn )
			file.dev_positions.append( str )
		}
		
		Warning( "----LOADED PAK: " + pak + "----" )
		printm( "----LOADED PAK: " + pak + "----" )
		DEV_HighlightAll()
		DEV_PrintSpawns( true )
	}
	else 
	{
		Warning("Locations are empty.")
		printm("Locations are empty.")
	}
}

void function __CreateInfoPanelForSpawn( int set, int index, string identifier )
{
	if( index >= file.dev_positions_LocPair.len() )
	{
		sqerror( "Spawn doesn't exist for index: " + index )
		return 
	}
	
	LocPair spawn = file.dev_positions_LocPair[ index ]
	int id = index + 1
	vector faceup = < 90, 360, 0 >
	
	foreach( player in GetPlayerArray() )
	{	
		RemovePanelText( player, id )
		WaitFrame()
		CreatePanelText( player, "SpawnSet: " + set, "index# [ " + index + " ] Team: " + identifier, ( spawn.origin + <0,0,5> + file.infoPanelOffset ), faceup + file.infoPanelOffsetAngles, false, 2, id )
	}
}

void function DEV_SpawnInfo( bool setting = true )
{
	file.spawnInfoPanels = setting
}

void function DEV_RotateInfoPanels( string direction = "clockwise" )
{
	if( !__bCheckReload() )
		return
	
	vector info = file.infoPanelOffsetAngles 
	
	switch( direction )
	{
		case "clockwise":
			if( info.z >= 270 )
			{
				file.infoPanelOffsetAngles = < info.x, info.y, 0 >
			}
			else 
			{
				file.infoPanelOffsetAngles = < info.x, info.y, info.z + 90 >
			}
			
			DEV_ReloadInfo()
			break 
			
		case "counterclockwise":
			if( info.z <= 90 )
			{
				file.infoPanelOffsetAngles = < info.x, info.y, 360 >
			}
			else 
			{
				file.infoPanelOffsetAngles = < info.x, info.y, info.z - 90 >
			}
			
			DEV_ReloadInfo()
			break 
			
		default:
			printt( "Invalid rotation. clockwise/counterclockwise" )
			printm( "Invalid rotation. clockwise/counterclockwise" )
	}
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

#endif //DEVELOPER
//$"P_chamber_beam"