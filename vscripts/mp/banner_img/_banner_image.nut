// banner images															//mkos

global function BannerImages_Init
global function BannerImages_RegisterGroup		// ( string name, LocPair groupLoc, float width, float height, float alpha = 1.0, bool visible = true, int cycleTime = 10, bool useRandom = false, float intermediateTime = 0.0, int fadeSpeed = SLOWEST )
global function BannerImages_SetAllGroupsFunc	// ( void functionref() callbackFunc )
global function BannerImages_SetAllImagesFunc 	// ( void functionref() callbackFunc )
global function BannerImages_GroupAppendImage 	// ( string groupName, int imgIdRef, string imageName = "", string imageResourceRef = "" )
global function BannerImages_ModifyGroupData 	// ( string groupName, table tbl )
global function BannerImages_KillAllBanners

const int SLOWEST	= -4
const int SLOWER	= -3
const int SLOW		= -2
const int MODERATE	= -1
const int NORMAL 	= 0
const int FAST 		= 1
const int FASTER	= 2

//script local global
bool g_bBannerImages_Loaded = false

struct BannerImageData
{
	int id
	string imageName
	string imageResourceRef //optional for baseimg
}

struct BannerGroupData
{
	string groupName
	array<BannerImageData> groupBanners
	vector org 
	vector ang
	float width 	= -1
	float height 	= -1
	float alpha 	= 1
	bool isVisible 	= true
	int cycleTime 	= 10
	bool isValid 	= false
	bool useRandom 	= false
	float intermediateTime = 2.00
	int fadeSpeed 	= SLOWEST
}

struct
{
	table< string, BannerGroupData > groupDataMap
	
	void functionref() groupsInitCallbackFunc
	void functionref() runImageAppendtoGroupsFunc
	
	entity dummyEnt
	
} file 

void function BannerImages_Init()
{	
	file.dummyEnt = CreateEntity( "info_target" )

	RegisterSignal( "KillAllBannerGroups" )
	RegisterSignal( "VisibilityChanged" )
	
	if( file.groupsInitCallbackFunc != null )
	{	
		file.groupsInitCallbackFunc()
		
		if( file.runImageAppendtoGroupsFunc != null )
			file.runImageAppendtoGroupsFunc()
	}
	
	__RunThreads()
	
	g_bBannerImages_Loaded = true
}

void function BannerImages_RegisterGroup( string name, LocPair groupLoc, float width, float height, float alpha = -1.0, bool isVisible = true, int cycleTime = 10, bool useRandom = false, float intermediateTime = 2.00, int fadeSpeed = SLOWEST )
{	
	mAssert( !g_bBannerImages_Loaded, "Tried to register BannerImages_RegisterGroup [" + name + "] but group registration is complete." )

	BannerGroupData bannerGroup 
	
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
	
	#if DEVELOPER
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
			bannerGroup.fadeSpeed
		)
	#endif
	
	bannerGroup.intermediateTime = intermediateTime
	
	mAssert( !(name in file.groupDataMap ), "Tried to add bannerGroup" + name + " with " + FUNC_NAME() + "()" + " but file.groupDataMap already contains it." )
	
	file.groupDataMap[ name ] <- bannerGroup
}

void function BannerImages_SetAllGroupsFunc( void functionref() callbackFunc )
{
	mAssert( !g_bBannerImages_Loaded, "Tried to register BannerImages_SetAllGroupsFunc [ " + string( callbackFunc ) + " ] but group registration is complete." )
	file.groupsInitCallbackFunc = callbackFunc
}

void function BannerImages_SetAllImagesFunc( void functionref() callbackFunc )
{
	mAssert( !g_bBannerImages_Loaded, "Tried to register BannerImages_SetAllImagesFunc [ " + string( callbackFunc ) + " ] but group registration is complete." )
	file.runImageAppendtoGroupsFunc = callbackFunc
}

BannerGroupData function GetBannerGroup( string groupName )
{
	BannerGroupData group 
	
	if( groupName in file.groupDataMap )
		return file.groupDataMap[ groupName ]

	return group
}

void function BannerImages_GroupAppendImage( string groupName, int imgIdRef, string imageName = "", string imageResourceRef = "" )
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
	
	banner.id					= imgIdRef
	banner.imageName			= imageName
	banner.imageResourceRef		= imageResourceRef
	
	file.groupDataMap[ groupName ].groupBanners.append( banner )
}

void function BannerImages_KillAllBanners()
{
	Signal( file.dummyEnt, "KillAllBannerGroups" )
}

void function BannerImages_ModifyGroupData( string groupName, table tbl )
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
					Signal( file.dummyEnt, "VisibilityChanged" )
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
				
			default:
				mAssert( false, "key name [" + key + "] does not exist in struct BannerGroupData" )
				return
		}
	}
}

void function __RunThreads()
{
	foreach( string name, BannerGroupData data in file.groupDataMap )
	{
		#if DEVELOPER 
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

void function __Singlethread( entity player, BannerGroupData groupData )
{
	mAssert( IsNewThread(), "Must be threaded off." )
	
	array<BannerImageData> banners = groupData.groupBanners
	
	if( banners.len() == 0 )
	{
		#if DEVELOPER 
			Warning( "(0) banners were found, returning." )
		#endif 
		return
	}
	else 
	{
		#if DEVELOPER 
			Warning( "Found: " + banners.len() + " banners." )
		#endif 
	}
	
	EndSignal( file.dummyEnt, "KillAllBannerGroups" )
	
	BannerImageData baseBanner = banners[0]
	int refID
	
	#if DEVELOPER 
		printt( "Spawning banner:", baseBanner.imageName )
	#endif
	
	refID = WorldDrawImg_CreateOnClient
	(
		player, 
		baseBanner.imageResourceRef,
		groupData.org,
		groupData.ang,
		groupData.width,
		groupData.height,
		baseBanner.id,
		groupData.alpha,
		groupData.isVisible	
	)
	
	#if DEVELOPER 
		printt
		( 
			refID, "\n",
			player, "\n",
			baseBanner.imageResourceRef, "\n",
			groupData.org, "\n",
			groupData.ang, "\n",
			groupData.width, "\n",
			groupData.height, "\n",
			baseBanner.id, "\n",
			groupData.alpha, "\n",
			groupData.isVisible, "\n"
		)
	#endif
	
	wait groupData.cycleTime
	
	if( !IsValid( player ) )
		return
	
	WorldDrawImg_SetVisible
	(
		player,
		refID, 
		true, 
		true, 
		false, 
		groupData.fadeSpeed
	)
	
	int lastBanner = banners.len() - 1
	int iter = 0
	
	while( IsValid( player ) )
	{
		iter = iter == lastBanner ? 0 : ++iter
		
		if( !groupData.isValid )
			break
		
		if( !groupData.isVisible )
		{
			WaitSignal( file.dummyEnt, "VisibilityChanged" )
			continue
		}
		
		wait groupData.intermediateTime //between fadeins
		
		if( !IsValid( player ) )
			break
		
		BannerImageData banner
		
		if( groupData.useRandom )
			banner = banners.getrandom()
		else
			banner = banners[ iter ]
		
		WorldDrawImg_Modify
		(
			player, 
			refID,
			ZERO_VECTOR, 
			ZERO_VECTOR, 
			-1.0, 
			-1.0, 
			0, 
			banner.id 
		)

		if( !IsValid( player ) )
			break	
		
		WorldDrawImg_SetVisible
		(
			player,
			refID, 
			true,
			true, 
			true, 
			groupData.fadeSpeed
		)
		
		wait groupData.cycleTime
		
		if( !IsValid( player ) )
			continue
		
		WorldDrawImg_SetVisible
		(
			player,
			refID, 
			true,
			true, 
			false,
			groupData.fadeSpeed
		)
	}
	
	#if DEVELOPER 
		Warning( "BannerGroupData: " + groupData.groupName + " was set to invalid for player " + string( player ) + " and shutdown." )
	#endif 
}