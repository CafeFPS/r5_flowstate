// banner assets															//mkos

global function BannerAssets_Init
global function BannerAssets_RegisterGroup			// ( string name, LocPair groupLoc, float width, float height, float alpha = 1.0, bool visible = true, int cycleTime = 10, bool useRandom = false, float intermediateTime = 0.0, int fadeSpeed = SLOWEST )
global function BannerAssets_SetAllGroupsFunc		// ( void functionref() callbackFunc )
global function BannerAssets_SetAllAssetsFunc 		// ( void functionref() callbackFunc )
global function BannerAssets_GroupAppendAsset 		// ( string groupName, int assetIdRef, bool bLoopVideo = false, string assetName = "", string assetResourceRef = "" )
global function BannerAssets_ModifyGroupData 		// ( string groupName, table tbl )
global function BannerAssets_SyncAllPlayers			// ( int assetRefId = -1, bool bLocked = false, int groupId = -1, string assetRef = "",  )
global function BannerAssets_DoesSignalExist    	// ( string signal )
global function BannerAssets_LockGroupsTo			// ( int assetId, int groupId = -1 )
global function BannerAssets_Lock					// ( int groupId )
global function BannerAssets_Unlock					// ( int groupId )
global function BannerAssets_KillAllBanners			// ()
global function BannerAssets_Restart				// ()
global function BannerAssets_IsEnabled				// ()
global function BannerAssets_BannerVisibilityMover 	// ( vector initialPosition, vector initialAngles, float bannerWidth, float bannerHeight, float adjustmentDistance = 5.0, float maxIterations = 1000 ) 
global function BannerAssets_RegisterAudioGroup		// ( string name, bool interupt = true )
global function BannerAssets_PlayAudio				// ( entity player, string assetRef )
global function BannerAssets_PlayAudioID			// ( entity player, int assetId = -1 )
global function BannerAssets_PlayAudioName			// ( entity player, string audioName )
global function BannerAssets_GetAssetRefByName		// ( string assetName )
global function BannerAssets_GetPlayCountForPlayer	// ( entity player, int assetIdRef )
global function BannerAssets_GetLastPlayTime		// ( entity player, int assetIdRef )

global const MAX_VIDEO_CHANNELS = 10 //this must not surpass engine internals.
global const CURRENT_RESERVED_CHANNELS = 5 //this is the limit we start from. (todo: disable systems where posible)

const int SLOWEST	= -4
const int SLOWER	= -3
const int SLOW		= -2
const int MODERATE	= -1
const int NORMAL 	= 0
const int FAST 		= 1
const int FASTER	= 2

const DEBUG_BANNER_ASSET = false

//script local global
bool _bBannerImages_Loaded 	= false
int	 _uniqueGroupId			= -1

struct BannerImageData
{
	int id
	int assetType
	string assetName
	string assetResourceRef //optional for baseasset
	bool loopVideo
	bool isValid
}

struct BannerGroupData
{
	string groupName
	array<BannerImageData> groupBanners
	vector org 
	vector ang
	int groupId			= -1
	float width 		= -1
	float height 		= -1
	float alpha 		= 1
	bool isVisible 		= true
	int cycleTime 		= 10
	bool isValid 		= false
	bool useRandom 		= false
	float intermediateTime = 2.00
	int fadeSpeed 		= SLOWEST
	int videoCount		= 0
	float startDelay	= 0
	bool bLocked		= false 
	int syncToAsset		= -1
	bool videoFinished	= false
	bool isAudioQueue	= false
	bool interupt		= true
}

struct AudioHistory
{
	int playAmount
	int assetIdRef
	float lastPlayTime
	bool isValid = false 
}

struct
{
	table< string, table< int, AudioHistory > > audioHistoryMap
	table< string, BannerGroupData > groupDataMap
	table< string, bool > groupSignals
	array< int > __channelRequiredGroups
	
	void functionref() groupsInitCallbackFunc
	void functionref() runImageAppendtoGroupsFunc
	
	entity dummyEnt
	bool isEnabled
	
} file 

void function BannerAssets_Init()
{
	file.isEnabled = GetCurrentPlaylistVarBool( "enable_banner_assets", false )	
	file.dummyEnt = CreateEntity( "info_target" )

	RegisterSignal( "KillAllBannerGroups" )
	RegisterSignal( "VisibilityChanged" )
	RegisterSignal( "AudioQueue_Once" )
	RegisterSignal( "AudioQueue_Pop" )
	
	if( file.isEnabled && file.groupsInitCallbackFunc != null )
	{
		file.groupsInitCallbackFunc()
		
		if( file.runImageAppendtoGroupsFunc != null )
		{
			file.runImageAppendtoGroupsFunc()
			
			array<int> groups
			foreach( BannerGroupData bannerGroup in file.groupDataMap )
			{
				if( bannerGroup.videoCount > 0 )
					groups.append( bannerGroup.groupId )
			}
			
			foreach( groupId in groups )
			{
				string signal = "VideoFinishedPlaying_" + groupId
				RegisterSignal( signal )
				file.groupSignals[ signal ] <- true
			}
			
			// array<int> invalidAssets = WorldDrawAsset_GetInvalid()
			// foreach( string groupName, BannerGroupData bannerData in file.groupDataMap )
			// {
				// foreach( banner in bannerData.groupBanners )
				// {
					// if( invalidAssets.contains( banner.id ) )
					// {
						// banner.isValid = false
						
						// #if DEVELOPER && DEBUG_BANNER_ASSET
							// printw( "Asset ID:", banner.id, "for group", bannerData.groupId, "ref = ", banner.assetName, "was marked as invalid." )
						// #endif
					// }
				// }
			// }
			
			file.__channelRequiredGroups = groups
			__SetupChannels()	
		}
		
		__SetupThreads()
	}
	
	_bBannerImages_Loaded = true
}

bool function BannerAssets_DoesSignalExist( string signal )
{
	return ( signal in file.groupSignals )
}

void function BannerAssets_RegisterGroup( string name, LocPair groupLoc, float width, float height, float alpha = -1.0, float startDelay = 0, bool isVisible = true, int cycleTime = 10, bool useRandom = false, float intermediateTime = 2.00, int fadeSpeed = SLOWEST, bool isAudioQueue = false, bool interupt = true )
{	
	mAssert( !_bBannerImages_Loaded, "Tried to register BannerAssets_RegisterGroup [" + name + "] but group registration is already complete." )

	BannerGroupData bannerGroup 
	
	bannerGroup.groupId		= ++_uniqueGroupId
	bannerGroup.groupName 	= name
	bannerGroup.org 		= groupLoc.origin
	bannerGroup.ang 		= groupLoc.angles
	bannerGroup.width 		= width
	bannerGroup.height 		= height
	bannerGroup.alpha 		= alpha
	bannerGroup.isVisible	= isVisible
	bannerGroup.cycleTime	= cycleTime
	bannerGroup.isValid		= true
	bannerGroup.useRandom	= useRandom
	bannerGroup.fadeSpeed	= fadeSpeed
	bannerGroup.startDelay	= startDelay
	bannerGroup.isAudioQueue= isAudioQueue
	bannerGroup.interupt	= interupt
	
	#if DEVELOPER && DEBUG_BANNER_ASSET
		printt
		(
			bannerGroup.groupName,
			bannerGroup.org,
			bannerGroup.ang,
			bannerGroup.width,
			bannerGroup.height,
			bannerGroup.alpha,
			bannerGroup.isVisible,
			bannerGroup.cycleTime,
			bannerGroup.isValid,
			bannerGroup.useRandom,
			bannerGroup.fadeSpeed,
			bannerGroup.startDelay,
			bannerGroup.isAudioQueue
		)
	#endif
	
	bannerGroup.intermediateTime = intermediateTime
	
	mAssert( !(name in file.groupDataMap ), "Tried to add bannerGroup \"" + name + "\" with " + FUNC_NAME() + "()" + " but file.groupDataMap already contains bannerGroup \"" + name + "\"" )
	
	file.groupDataMap[ name ] <- bannerGroup
}

void function BannerAssets_RegisterAudioGroup( string name, bool interupt = true, LocPair ornull groupLocOrNull = null, float width = 0.1, float height = 0.1, float alpha = -1.0, float startDelay = 0, bool isVisible = true, int cycleTime = 10, bool useRandom = false, float intermediateTime = 2.00, int fadeSpeed = SLOWEST, bool isAudioQueue = true )
{
	LocPair groupLoc
	if( groupLocOrNull != null )
		groupLoc = expect LocPair ( groupLocOrNull )
	else 
		groupLoc = NewLocPair( ZERO_VECTOR, ZERO_VECTOR )

	BannerAssets_RegisterGroup
	(
		name, 
		groupLoc, 
		width, 
		height, 
		alpha,
		startDelay,
		isVisible,
		cycleTime,
		useRandom,
		intermediateTime,
		fadeSpeed, 
		isAudioQueue,
		interupt
	)
}

void function BannerAssets_SetAllGroupsFunc( void functionref() callbackFunc )
{
	mAssert( !_bBannerImages_Loaded, "Tried to register BannerAssets_SetAllGroupsFunc [ " + string( callbackFunc ) + "() ] but group registration is already complete." )
	file.groupsInitCallbackFunc = callbackFunc
}

void function BannerAssets_SetAllAssetsFunc( void functionref() callbackFunc )
{
	mAssert( !_bBannerImages_Loaded, "Tried to register " + FUNC_NAME() + "() [ " + string( callbackFunc ) + "() ] but group registration is already complete." )
	file.runImageAppendtoGroupsFunc = callbackFunc
}

BannerGroupData function GetBannerGroup( string groupName )
{
	BannerGroupData group 
	
	if( groupName in file.groupDataMap )
		return file.groupDataMap[ groupName ]

	return group
}

string function GetBannerGroupName( int groupId )
{
	foreach( string groupName, BannerGroupData groupData in file.groupDataMap )
	{
		if( groupData.groupId == groupId )
			return groupName
	}
	
	return "_INVALID"
}

BannerGroupData function GetBannerGroupByID( int groupId )
{
	return GetBannerGroup( GetBannerGroupName( groupId ) )
}

void function BannerAssets_GroupAppendAsset( string groupName, int assetIdRef, bool bLoopVideo = false, string assetName = "", string assetResourceRef = "" )
{
	BannerGroupData group = GetBannerGroup( groupName )
	
	if( !group.isValid ) 
	{
		#if DEVELOPER
			Warning( "Group " + groupName + " was invalid." )
		#endif
		
		return
	}
	
	BannerImageData banner
	asset potentialAsset
	int assetType 
	
	if ( !empty( assetResourceRef ) )
	{
		assetType = WorldDrawAsset_GetAssetType( potentialAsset, assetResourceRef )
	}
	else 
	{
		potentialAsset  = WorldDrawAsset_GetAssetByID( assetIdRef )
		assetType		= WorldDrawAsset_GetAssetType( potentialAsset )
	}
	
	if( assetType == eAssetType.VIDEO )
		group.videoCount++
		
	if( empty( assetName ) )
		assetName = !empty( assetResourceRef ) ? assetResourceRef : string( potentialAsset )
	
	banner.id					= assetIdRef
	banner.assetType			= assetType
	banner.assetName			= assetName
	banner.assetResourceRef		= assetResourceRef
	banner.loopVideo			= bLoopVideo
	banner.isValid				= true
	
	file.groupDataMap[ groupName ].groupBanners.append( banner )
}

void function __SetupChannels()
{
	foreach( player in GetPlayerArray() )
	{
		if( !player.p.isConnected )
			continue
			
		BannerAssets_InitPlayerVideoChannels( player )
	}
	
	AddCallback_OnClientConnected( BannerAssets_InitPlayerVideoChannels )
}

void function BannerAssets_InitPlayerVideoChannels( entity player )
{
	foreach( int iter, int groupId in file.__channelRequiredGroups )
	{
		if( iter + CURRENT_RESERVED_CHANNELS > MAX_VIDEO_CHANNELS )
		{
			mAssert( false, "Cannot create any more channels for clients." )
			return
		}
		else 
		{
			Remote_CallFunction_NonReplay( player, "ServerCallback_CreateChannel", groupId )
		}
	}
}

void function BannerAssets_KillAllBanners()
{
	Signal( file.dummyEnt, "KillAllBannerGroups" )
}

void function BannerAssets_LockGroupsTo( int assetId, int groupId = -1 )
{
	BannerAssets_SyncAllPlayers( assetId, true, groupId, "" )
}

void function BannerAssets_Lock( int groupId )
{
	string group = GetBannerGroupName( groupId )
	BannerAssets_ModifyGroupData( group, { bLocked = true } )
}

void function BannerAssets_Restart()
{
	BannerAssets_SyncAllPlayers()
}

void function BannerAssets_Unlock( int groupId )
{
	string group = GetBannerGroupName( groupId )
	BannerAssets_ModifyGroupData( group, { bLocked = false } )
}

BannerImageData function __GetBannerDataForID( array<BannerImageData> banners, int bannerId )
{
	BannerImageData invalidBanner
	
	foreach( bannerData in banners )
	{
		if( bannerData.id == bannerId )
			return bannerData
	}
	
	return invalidBanner
} 

void function BannerAssets_ModifyGroupData( string groupName, table tbl )
{
	BannerGroupData group = GetBannerGroup( groupName )
	
	if( !group.isValid )
		return
		
	foreach( key, value in tbl )
	{
		switch( key )
		{
			case "groupName":
				group.groupName 	= expect string ( value )
				break
				
			case "org":
				group.org 			= expect vector ( value )
				break
				
			case "ang":	
				group.ang 			= expect vector ( value )
				break
				
			case "width":	
				group.width 		= expect float ( value )
				break
				
			case "height":	
				group.height 		= expect float ( value )
				break
				
			case "alpha":	
				group.alpha 		= expect float ( value )
				break
				
			case "visible":	
				
				bool visibility 	= expect bool ( value )	
				
				if( group.isVisible != visibility )
				{
					group.isVisible	= visibility
					Signal( file.dummyEnt, "VisibilityChanged" ) //Todo(mk): potential concurrency issues where thread instances
				}
					
				break
				
			case "cycleTime":	
				group.cycleTime		= expect int ( value )
				break
				
			case "isValid":	
				group.isValid		= expect bool ( value )
				break
				
			case "useRandom":	
				group.useRandom		= expect bool ( value )
				break
				
			case "videoFinished":
				group.videoFinished	= expect bool ( value )
				break
				
			case "bLocked":
				group.bLocked		= expect bool ( value )
				break
				
			default:
				mAssert( false, "key name [" + key + "] does not exist in struct BannerGroupData" )
				return
		}
	}
}


void function __SetupThreads()
{
	foreach( string name, BannerGroupData data in file.groupDataMap )
	{		
		#if DEVELOPER && DEBUG_BANNER_ASSET
			Warning( "Spawning banner group: " + name )
		#endif
		
		AddCallback_OnClientConnected
		(
			void function( entity player ) : ( data )
			{			
				thread __Singlethread( player, data )
			}
		)
	}
}

void function BannerAssets_SyncAllPlayers( int assetRefId = -1, bool bLocked = false, int groupId = -1, string assetRef = "" )
{
	if( !empty( assetRef ) )
	{
		assetRefId = WorldDrawAsset_AssetRefToID( assetRef )
		
		if( assetRefId <= -1 )
		{
			Warning( "Asset ref id '" + assetRefId + "' is invalid." )
			return
		}
	}
	
	thread
	(
		void function() : ( assetRefId, bLocked, groupId )
		{
			BannerAssets_KillAllBanners()
			WaitEndFrame() //let banners hide before restarting.
			
			foreach( player in GetPlayerArray() )
			{
				foreach( string name, BannerGroupData data in file.groupDataMap )
				{	
					data = clone data
					data.syncToAsset = assetRefId 
					data.bLocked	 = bLocked
					
					if( groupId > -1 )
					{
						if( data.groupId != groupId )
							continue
					}
					
					thread __Singlethread( player, data )
				}
			}
		}
	)()
}

void function __HideAllBanners( entity player, BannerGroupData groupData )
{
	if( !IsValid( player ) ) //player might have disconnected
		return
		
	array<BannerImageData> banners = groupData.groupBanners
		
	int iter = -1
	foreach( banner in banners )
	{
		++iter
		if( !banners[ iter ].isValid )
			continue 
			
		WorldDrawAsset_SetVisible
		(
			player,
			GetRUIID( player, groupData.groupId, banner.assetType ),
			groupData.groupId,
			false,
			false, 
			false, 
			banners[ iter ].id,
			0,
			false
		)
	}
}


table<int,int> function CreateAssetTbl()
{
	table< int, int > tbl = {}
	
	foreach( keyName, value in eAssetType )
	{
		tbl[ value ] <- -1
	}
	
	return tbl
}

void function SetGroupData( entity player, int groupId, table<int,int> groupData )
{
	player.p.groupTypeToRuiID[ groupId ] <- groupData
}

bool function GroupDataHasRuiSet( table<int, int> tbl )
{
	foreach( k,v in tbl )
	{
		if( v != -1 )
			return true
	}
	
	return false
}

table<int, int> function GetGroupData( entity player, int groupId )
{
	if( !( groupId in player.p.groupTypeToRuiID) )
	{
		table<int,int> tbl = CreateAssetTbl()
		player.p.groupTypeToRuiID[ groupId ] <- tbl
	}
		
	return player.p.groupTypeToRuiID[ groupId ]
}

int function GetRUIID( entity player, int groupId, int assetType )
{
	return player.p.groupTypeToRuiID[ groupId ][ assetType ]
}

void function SetRUIID( entity player, int groupId, int assetType, int RUIID )
{
	player.p.groupTypeToRuiID[ groupId ][ assetType ] = RUIID
}

array<BannerImageData> function DeepCopyBanner( array<BannerImageData> banners )
{
	array<BannerImageData> returnBanners = []
	
	foreach ( BannerImageData banner in banners )
	{
		BannerImageData bannerClone
		
		bannerClone.id = banner.id
		bannerClone.assetType = banner.assetType
		bannerClone.assetName = banner.assetName
		bannerClone.assetResourceRef = banner.assetResourceRef
		bannerClone.loopVideo = banner.loopVideo
		bannerClone.isValid = banner.isValid

		returnBanners.append( bannerClone )
	}

    return returnBanners
}

vector function BannerAssets_BannerVisibilityMover( vector initialPosition, vector initialAngles, float bannerWidth, float bannerHeight, float adjustmentDistance = 5.0, float maxIterations = 1000 ) 
{
	array<vector> corners
	vector forward, right, up, simulateEyePos, playerEyeAngles

	float halfWidth = bannerWidth * 0.5
	float halfHeight = bannerHeight * 0.5

	vector currentPosition = initialPosition
	
	corners.resize(4)
	
	forward 	= AnglesToForward( initialAngles )
	right 		= AnglesToRight( initialAngles )
	up			= AnglesToUp( initialAngles )

	simulateEyePos 	= getWaitingRoomLocation().origin
	playerEyeAngles = getWaitingRoomLocation().angles
	
	int iter = 0
    while ( iter < maxIterations ) 
	{
		#if DEVELOPER && DEBUG_BANNER_ASSET
			Warning( "Adjusting..." )
		#endif

        corners[ 0 ] = currentPosition + ( forward * halfHeight ) - ( right * halfWidth )
        corners[ 1 ] = currentPosition + ( forward * halfHeight ) + ( right * halfWidth )
        corners[ 2 ] = currentPosition - ( forward * halfHeight ) - ( right * halfWidth )
        corners[ 3 ] = currentPosition - ( forward * halfHeight ) + ( right * halfWidth )

        bool allCornersVisible = true

		for ( int i = 0; i < 4; i++ ) 
		{
			vector corner = corners[ i ]
			TraceResults traceResult = TraceLine( simulateEyePos, corner, [], TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )
			
			float distanceToCorner = Distance( simulateEyePos, corner )
			float traceEndDistance = Distance( simulateEyePos, traceResult.endPos )

			if ( traceResult.fraction < 1.0 && traceEndDistance < distanceToCorner ) 
			{
				allCornersVisible = false
				break
			}
		}

        if ( allCornersVisible ) 
		{
			#if DEVELOPER && DEBUG_BANNER_ASSET
				Warning( "FOUND A GOOD POSITION: " + currentPosition )
			#endif
			
            return currentPosition
        }

		currentPosition = AdjustBannerPosition( currentPosition, initialAngles, simulateEyePos, adjustmentDistance )
		adjustmentDistance += 5

		iter++
	}

	return initialPosition
}

vector function AdjustBannerPosition( vector currentPosition, vector currentAngles, vector simulateEyePos, float adjustmentDistance ) 
{
	array<vector> adjustments
	
	//adjustments.append( AnglesToForward( currentAngles ) * -adjustmentDistance )
	adjustments.append( <0, 0, adjustmentDistance> )
	adjustments.append( <0, 0, -adjustmentDistance> )
	adjustments.append( AnglesToRight( currentAngles ) * adjustmentDistance )
	adjustments.append( AnglesToRight( currentAngles ) * -adjustmentDistance )
	adjustments.append( AnglesToForward( currentAngles ) * adjustmentDistance )
    
	int adjustmentsLen = adjustments.len()
	for ( int i = 0; i < adjustmentsLen; i++ ) 
	{
		vector adjustment = adjustments[ i ]
		vector newPosition = currentPosition + adjustment
	
		if ( IsPositionClear( newPosition, simulateEyePos ) )  
			return newPosition
	}

	#if DEVELOPER && DEBUG_BANNER_ASSET
		Warning( "Failed to find a good position" )
	#endif

	return currentPosition
}

bool function IsPositionClear( vector position, vector simulateEyePos ) 
{
	TraceResults traceResult = TraceLine( simulateEyePos, position, [], TRACE_MASK_NPCWORLDSTATIC, TRACE_COLLISION_GROUP_NONE )
	return traceResult.fraction == 1.0
}

bool function BannerAssets_IsEnabled()
{
	return file.isEnabled
}

void function UpdateAudioHistory( entity player, int assetIdRef )
{
	AudioHistory history = GetAudioHistoryForPlayer( player, assetIdRef )
	
	history.playAmount		+= 1
	history.assetIdRef		= assetIdRef
	history.lastPlayTime	= Time()
}

AudioHistory function GetAudioHistoryForPlayer( entity player, int assetIdRef )
{
	CheckAudioTrackingForPlayer( player, assetIdRef )
	return file.audioHistoryMap[ player.p.UID ][ assetIdRef ]
}

int function BannerAssets_GetPlayCountForPlayer( entity player, int assetIdRef )
{
	AudioHistory history = GetAudioHistoryForPlayer( player, assetIdRef )
	return history.playAmount
}

float function BannerAssets_GetLastPlayTime( entity player, int assetIdRef )
{
	AudioHistory history = GetAudioHistoryForPlayer( player, assetIdRef )
	return history.lastPlayTime
}

void function __AudioQueue( entity player, BannerImageData baseBannerVideo, BannerGroupData groupData )
{//thread

	file.dummyEnt.Signal( "AudioQueue_Once" )
	file.dummyEnt.EndSignal( "AudioQueue_Once" )
	player.EndSignal( "OnDestroy", "KillAllBannerGroups" )
	
	if( !groupData.isValid )
	{
		#if DEVELOPER 
			printw( "Invalid group for player: ", string( player ) )
		#endif 	
		
		return
	}	
	
	for( ; ; )
	{		
		if( !groupData.interupt )
		{
			while( IsPlayingAudioForPlayer( player ) )
				WaitFrame()
		}
		
		int bannerImageId
		
		if( AudioQueue_Len( player ) > 0 )
		{
			bannerImageId = AudioQueue_Pop( player )
		}
		else 
		{
			table results = player.WaitSignal( "AudioQueue_Pop" )	
			
			if ( results.len() == 0 )
				continue
				
			if( !( "assetRefId" in results ) )
				continue
		
			bannerImageId = expect int( results.assetRefId )
		}
		
		BannerImageData banner = __GetBannerDataForID( groupData.groupBanners, bannerImageId )	
		
		int clientRUIID = GetRUIID( player, groupData.groupId, banner.assetType )
		//set the server managed ruiid instance to use based on type.
		#if DEVELOPER && DEBUG_BANNER_ASSET
			printw( "playing sound '" + banner.assetName + "' as type:", banner.assetType, "in group:", groupData.groupName, "RUIID = ", clientRUIID )
		#endif 
		
		//change over to next asset.
		WorldDrawAsset_Modify
		(
			player, 
			clientRUIID,
			groupData.groupId,
			ZERO_VECTOR, 
			ZERO_VECTOR, 
			-1.0, 
			-1.0, 
			0, 
			banner.id 
		)
		
		//play it on the client
		WorldDrawAsset_SetVisible
		(
			player,
			clientRUIID, 
			groupData.groupId,
			true,
			true, 
			true, 
			banner.id,
			groupData.fadeSpeed,
			banner.loopVideo
		)
			
		thread AudioMonitor( player, groupData.groupId, banner.id )
		
		if( !groupData.interupt )
		{
			string signal = "VideoFinishedPlaying_" + groupData.groupId
			player.WaitSignal( signal )
			
			if( !IsValid( player ) )
				return
		}	
	}
}

void function AudioMonitor( entity player, int groupId, int audioId )
{
	IsPlayingAudioForPlayer( player, true )
	UpdateAudioHistory( player, audioId )
		
	OnThreadEnd
	(
		void function() : ( player )
		{
			if( IsValid( player ) )
				IsPlayingAudioForPlayer( player, false )
		}
	)
	
	player.EndSignal( "VideoFinishedPlaying_" + groupId, "OnDestroy" )
	WaitForever()
}

//bool from flag 
bool function IsPlayingAudioForPlayer( entity player, bool ornull isPlayingOrNull = null )
{	
	if( isPlayingOrNull != null )
		player.p.isPlayingFlowstateAudio = expect bool( isPlayingOrNull )
	
	return player.p.isPlayingFlowstateAudio
}

AudioHistory function CheckAudioTrackingForPlayer( entity player, int assetIdRef )
{
	AudioHistory history
	
	if( !( player.p.UID in file.audioHistoryMap ) || !( assetIdRef in file.audioHistoryMap[ player.p.UID ] ) )
		file.audioHistoryMap[ player.p.UID ] <- { [ assetIdRef ] = history }
	
	history.isValid = true	
	return history
}

int function AudioQueue_Pop( entity player )
{
	if( player.p.audioQueue.len() == 0 )
		mAssert( false, "Tried to pop audio queue with no items in it." )
		
	return player.p.audioQueue.pop()
}

void function AudioQueue_Append( entity player, int audio )
{
	player.p.audioQueue.append( audio )
}

void function AudioQueue_Remove( entity player, int audio )
{
	player.p.audioQueue.removebyvalue( audio )
}

void function AudioQueue_Clear( entity player )
{
	player.p.audioQueue.clear()
}

array<int> function AudioQueue_Get( entity player )
{
	return player.p.audioQueue
}

int function AudioQueue_Len( entity player )
{
	return player.p.audioQueue.len()
}

void function HandleAudioQueue( entity player, int audioId )
{
	if( IsPlayingAudioForPlayer( player ) )
		AudioQueue_Append( player, audioId )
}

//Wrapper for playing audio files: 
void function BannerAssets_PlayAudio( entity player, string assetRef )
{
	int assetId = WorldDrawAsset_AssetRefToID( assetRef )
	
	if( assetId != -1 )
	{
		HandleAudioQueue( player, assetId )
		player.Signal( "AudioQueue_Pop", { assetRefId = assetId } )
	}
}

void function BannerAssets_PlayAudioID( entity player, int assetId = -1 )
{
	if( assetId != -1 )
	{
		HandleAudioQueue( player, assetId )
		player.Signal( "AudioQueue_Pop", { assetRefId = assetId } )
	}
}

void function BannerAssets_PlayAudioName( entity player, string audioName )
{
	string assetRef = BannerAssets_GetAssetRefByName( audioName )
	int assetId = WorldDrawAsset_AssetRefToID( assetRef )
	
	if( assetId != -1 )
	{
		HandleAudioQueue( player, assetId )
		player.Signal( "AudioQueue_Pop", { assetRefId = assetId } )
	}
}

string function BannerAssets_GetAssetRefByName( string assetName )
{	
	if( assetName in WorldDrawAsset_GetAssetLookupTable() )
		return WorldDrawAsset_GetAssetLookupTable()[ assetName ]
		
	string retString
	return retString
}

void function __Singlethread( entity player, BannerGroupData groupData )
{
	//FlagWait( "EntitiesDidLoad" )
	
	#if DEVELOPER
		mAssert( IsNewThread(), "Must be threaded off." )
	#endif
	
	array<BannerImageData> banners = DeepCopyBanner( groupData.groupBanners )
	//groupData.groupBanners = banners //?
	
	if( banners.len() == 0 )
	{
		#if DEVELOPER && DEBUG_BANNER_ASSET
			Warning( "(0) banners were found, returning." )
		#endif 
		return
	}
	else 
	{
		#if DEVELOPER && DEBUG_BANNER_ASSET
			Warning( "Found: " + banners.len() + " banners in group: " + groupData.groupName )
		#endif 
	}
	
	EndSignal( player, "OnDestroy" )
	EndSignal( file.dummyEnt, "KillAllBannerGroups" )
	
	if( !player.p.bannersValidated )
		player.WaitSignal( "BannersValidated" )
		
	if( !IsValid( player ) )
		return
		
	int ogBannersLen = banners.len()
	for( int i = ogBannersLen - 1; i >= 0; i-- )
	{
		if( player.p.invalidAssets.contains( banners[ i ].id ) )
			banners.remove( i )
	}

	BannerImageData baseBannerImage
	BannerImageData baseBannerVideo
	
	bool bFirstRun = !GroupDataHasRuiSet( GetGroupData( player, groupData.groupId ) )
	int clientRUIID = -1
	bool bDontSync
	int iter
	
	WaitEndFrame()
	//////////////
	//	CREATE 	//
	//////////////
	if( bFirstRun )
	{
		#if DEVELOPER && DEBUG_BANNER_ASSET
			printw( "setting group first run for group ", groupData.groupId )
		#endif 
		
		GetGroupData( player, groupData.groupId )[ eAssetType.IMAGE ] <- -1 
		GetGroupData( player, groupData.groupId )[ eAssetType.VIDEO ] <- -1 
		
		bool bFoundImage = false
		bool bFoundVideo = false

		iter = -1
		foreach( banner in banners )
		{
			iter++
			
			switch( banner.assetType )
			{
				case eAssetType.IMAGE:
				
					if( bFoundImage )
						break
					
					#if DEVELOPER && DEBUG_BANNER_ASSET
						printw( "found base bannerIMAGE in group", groupData.groupId, "for banner id", banners[ iter ].id  )
					#endif 
				
					baseBannerImage = banners[ iter ]
					bFoundImage = true
					break 
					
				case eAssetType.VIDEO:
				
					if( bFoundVideo )
						break
						
					#if DEVELOPER && DEBUG_BANNER_ASSET
						printw( "found base bannerVIDEO in group", groupData.groupId, "for banner id", banners[ iter ].id  )
					#endif
					
					baseBannerVideo = banners[ iter ]
					bFoundVideo = true
					break
			}
		}
		
		WaitFrame()
		///////////
		// IMAGE //
		///////////
		if( bFoundImage )
		{
			clientRUIID = WorldDrawAsset_CreateOnClient //returns a single topo+ruiid that will cycle any image
			(
				player, 
				baseBannerImage.assetResourceRef,
				groupData.org,
				groupData.ang,
				groupData.width,
				groupData.height,
				groupData.groupId,
				baseBannerImage.id,
				groupData.alpha,
				groupData.isVisible
			)
			
			GetGroupData( player, groupData.groupId )[ eAssetType.IMAGE ] = clientRUIID
			
			WorldDrawAsset_SetVisible
			(
				player,
				clientRUIID,
				groupData.groupId,
				false,
				false, 
				false, 
				baseBannerImage.id,
				groupData.fadeSpeed
			)
			
			#if DEVELOPER && DEBUG_BANNER_ASSET
				printt( "Spawning base rui for banner:", baseBannerImage.assetName )
			#endif
			
			#if DEVELOPER && DEBUG_BANNER_ASSET
				printt
				(
					"clientRUIID", clientRUIID, "\n",
					"player", player, "\n",
					"baseBannerImage.assetResourceRef", baseBannerImage.assetResourceRef, "\n",
					"groupData.org", groupData.org, "\n",
					"groupData.ang", groupData.ang, "\n",
					"groupData.width", groupData.width, "\n",
					"groupData.height", groupData.height, "\n",
					"baseBannerImage.id", baseBannerImage.id, "\n",
					"groupData.alpha", groupData.alpha, "\n",
					"groupData.isVisible", groupData.isVisible, "\n",
					"groupData.groupId", groupData.groupId, "\n",
					"groupData.isAudioQueue", groupData.isAudioQueue, "\n"
				)
			#endif
		}
		
		WaitFrame() //always wait before creating another rui on the client.
		///////////
		// VIDEO //
		///////////
		if( bFoundVideo )
		{
			clientRUIID = WorldDrawAsset_CreateOnClient //returns a single topo+ruiid that will cycle any video
			(
				player, 
				baseBannerVideo.assetResourceRef,
				groupData.org,
				groupData.ang,
				groupData.width,
				groupData.height,
				groupData.groupId,
				baseBannerVideo.id,
				groupData.alpha,
				groupData.isVisible	
			)
			
			GetGroupData( player, groupData.groupId )[ eAssetType.VIDEO ] = clientRUIID
			
			WorldDrawAsset_SetVisible
			(
				player,
				clientRUIID,
				groupData.groupId,
				false,
				false, 
				false, 
				baseBannerVideo.id,
				groupData.fadeSpeed,
				baseBannerVideo.loopVideo
			)
			
			#if DEVELOPER && DEBUG_BANNER_ASSET
				printt( "Spawning base rui for banner:", baseBannerVideo.assetName )
			#endif
			
			#if DEVELOPER && DEBUG_BANNER_ASSET
				printt
				( 
					"clientRUIID", clientRUIID, "\n",
					"player", player, "\n",
					"baseBannerVideo.assetResourceRef", baseBannerVideo.assetResourceRef, "\n",
					"groupData.org", groupData.org, "\n",
					"groupData.ang", groupData.ang, "\n",
					"groupData.width", groupData.width, "\n",
					"groupData.height", groupData.height, "\n",
					"baseBannerVideo.id", baseBannerVideo.id, "\n",
					"groupData.alpha", groupData.alpha, "\n",
					"groupData.isVisible", groupData.isVisible, "\n",
					"groupData.groupId", groupData.groupId, "\n",
					"groupData.isAudioQueue", groupData.isAudioQueue, "\n"
				)
			#endif
		}
	}
	
	
	if( groupData.isAudioQueue ) //group only needed for audio channel/validation of assets
	{
		if( ogBannersLen != banners.len() )
		{
			//tell server something?
			#if DEVELOPER && DEBUG_BANNER_ASSET
				Warning( "Some audio files were removed from the queue as the client does not have them." )
			#endif
		}
		
		thread __AudioQueue( player, baseBannerVideo, groupData )
		return
	}
	else 
	{
		OnThreadEnd
		(
			void function() : ( player, groupData )
			{
				__HideAllBanners( player, groupData )
			}
		)
	}
	
	if( bFirstRun )
	{
		wait groupData.startDelay
		if( !IsValid( player ) )
			return
	}
	
	//todo: check for rui creation on client or shut down.
	
	////////
	iter = -1
	////////
	
	while( IsValid( player ) )
	{
		if( !groupData.isValid )
			break
			
		int bannerLen = banners.len()
		int lastBanner = bannerLen - 1 //determine current len, as client may have removed assets from queue.
		
		if( bannerLen == 0 )
			break
			
		// iter set //
		iter = iter == lastBanner ? 0 : ++iter
			
		if( !groupData.isVisible )
		{
			WaitSignal( file.dummyEnt, "VisibilityChanged" ) //ortimeout?
			continue
		}
		
		wait groupData.intermediateTime //between fadeins
		
		if( !IsValid( player ) )
			break
		
		BannerImageData banner
		
		if( groupData.syncToAsset == -1 && !groupData.bLocked )
		{
			if( groupData.useRandom )
				banner = banners.getrandom()
			else
				banner = banners[ iter ]
		}
		else
		{
			banner = __GetBannerDataForID( banners, groupData.syncToAsset )	
			groupData.syncToAsset = -1
			
			if( !banner.isValid )		
				continue
		}

		clientRUIID = GetRUIID( player, groupData.groupId, banner.assetType )
		//set the server managed ruiid instance to use based on type.
		#if DEVELOPER && DEBUG_BANNER_ASSET
			printw( "setting next asset '" + banner.assetName + "' as type:", banner.assetType, "in group:", groupData.groupName, "RUIID = ", clientRUIID )
		#endif 
		
		//change over to next asset.
		WorldDrawAsset_Modify
		(
			player, 
			clientRUIID,
			groupData.groupId,
			ZERO_VECTOR, 
			ZERO_VECTOR, 
			-1.0, 
			-1.0, 
			0, 
			banner.id 
		)
		
		//make it fadein/appear based on group settings.
		WorldDrawAsset_SetVisible
		(
			player,
			clientRUIID, 
			groupData.groupId,
			true,
			true, 
			true, 
			banner.id,
			groupData.fadeSpeed,
			banner.loopVideo
		)
		
		//if locked, wait for signals 
		if( groupData.bLocked )
			WaitForever()
		
		//behavior based on asset type.
		bool bKeepShow = true
		switch( banner.assetType )
		{
			case eAssetType.IMAGE:
				wait groupData.cycleTime
				break
				
			case eAssetType.VIDEO:
				bKeepShow = false
				
				// for( ; ; )
				// {
					// table signal = player.WaitSignal( "VideoFinishedPlaying" )			
					
					// if( expect int( signal.group ) != groupData.groupId )
						// continue
					// else 
						// break
				// }
				
				string signal = "VideoFinishedPlaying_" + groupData.groupId
				player.WaitSignal( signal )
				
				break
				
			default:
				#if DEVELOPER && DEBUG_BANNER_ASSET 
					mAssert( false, "Invalid assetType." )
				#endif 
		}
		
		if( !IsValid( player ) ) //recheck from waits.
			break
		
		//fadeout/disappear
		WorldDrawAsset_SetVisible
		(
			player,
			clientRUIID,
			groupData.groupId,			
			bKeepShow, //We want to let fade handle images.
			true,
			false,
			banner.id,
			groupData.fadeSpeed,
			banner.loopVideo
		)
	}
	
	#if DEVELOPER && DEBUG_BANNER_ASSET
		Warning( "BannerGroupData: " + groupData.groupName + " was set to invalid for player " + string( player ) + " and shutdown." )
	#endif 
}