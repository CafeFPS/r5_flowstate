//=========================================================
//	collection_events.nut
//=========================================================

#if CLIENT || UI
global function CollectionEvents_Init
#endif


#if CLIENT || UI
global function GetActiveCollectionEvent
global function HaveActiveCollectionEventNow
global function CollectionEvent_GetSeasonName
global function CollectionEvent_GetMainPackFlav
global function CollectionEvent_GetHeirloomDisplayItemFlav
global function CollectionEvent_GetHeirloomPurchaseItemFlav
global function CollectionEvent_GetCurrencyFlav
global function CollectionEvent_GetExpectedCurrencyPerPack
global function CollectionEvent_GetFrontPageGRXOfferLocation
global function CollectionEvent_GetShopGRXOfferLocation
global function CollectionEvent_GetRewardGroups
global function CollectionEvent_GetAboutText
global function CollectionEvent_GetMainIcon
global function CollectionEvent_GetKeyColor
global function CollectionEvent_GetBGPatternImage
global function CollectionEvent_GetHeaderIcon
global function CollectionEvent_GetHeirloomButtonImage
#endif

#if CLIENT || UI 
global function CollectionEvent_GetTabBGDefaultCol
global function CollectionEvent_GetFrontTabText
#endif

//////////////////////
//////////////////////
//// Global Types ////
//////////////////////
//////////////////////
global const table<asset, array<asset> > S03E02_HARD_CODED_BONUS_QUIPS = {

	[$"settings/itemflav/character_skin/bangalore/s03e02_legendary_01.rpak"] = [
		$"settings/itemflav/character_kill_quip/bangalore/s03e02_common_01.rpak",
		$"settings/itemflav/character_kill_quip/bangalore/s03e02_common_02.rpak"
	],

	[$"settings/itemflav/character_skin/caustic/s03e02_legendary_01.rpak"] = [
		$"settings/itemflav/character_kill_quip/caustic/s03e02_common_01.rpak",
		$"settings/itemflav/character_kill_quip/caustic/s03e02_common_02.rpak"
	],

	[$"settings/itemflav/character_skin/crypto/s03e02_legendary_01.rpak"] = [
		$"settings/itemflav/character_kill_quip/crypto/s03e02_common_01.rpak",
		$"settings/itemflav/character_kill_quip/crypto/s03e02_common_02.rpak"
	],

	[$"settings/itemflav/character_skin/gibraltar/s03e02_legendary_01.rpak"] = [
		$"settings/itemflav/character_kill_quip/gibraltar/s03e02_common_01.rpak",
		$"settings/itemflav/character_kill_quip/gibraltar/s03e02_common_02.rpak"
	],

	[$"settings/itemflav/character_skin/mirage/s03e02_legendary_01.rpak"] = [
		$"settings/itemflav/character_kill_quip/mirage/s03e02_common_01.rpak",
		$"settings/itemflav/character_kill_quip/mirage/s03e02_common_02.rpak"
	],

	[$"settings/itemflav/character_skin/octane/s03e02_legendary_01.rpak"] = [
		$"settings/itemflav/character_kill_quip/octane/s03e02_common_01.rpak",
		$"settings/itemflav/character_kill_quip/octane/s03e02_common_02.rpak"
	],

	[$"settings/itemflav/character_skin/pathfinder/s03e02_legendary_01.rpak"] = [
		$"settings/itemflav/character_kill_quip/pathfinder/s03e02_common_01.rpak",
		$"settings/itemflav/character_kill_quip/pathfinder/s03e02_common_02.rpak"
	],

	[$"settings/itemflav/character_skin/wattson/s03e02_legendary_01.rpak"] = [
		$"settings/itemflav/character_kill_quip/wattson/s03e02_common_01.rpak",
		$"settings/itemflav/character_kill_quip/wattson/s03e02_common_02.rpak"
	],

	[$"settings/itemflav/character_skin/lifeline/s03e02_epic_01.rpak"] = [
		$"settings/itemflav/character_kill_quip/lifeline/s03e02_common_01.rpak",
		$"settings/itemflav/character_kill_quip/lifeline/s03e02_common_02.rpak"
	],

	[$"settings/itemflav/character_skin/wraith/s03e02_epic_01.rpak"] = [
		$"settings/itemflav/character_kill_quip/wraith/s03e02_common_01.rpak",
		$"settings/itemflav/character_kill_quip/wraith/s03e02_common_02.rpak"
	],

}

#if CLIENT || UI
global struct CollectionEventRewardGroup
{
	string ref
	int quality = -1
	string infoSquareTitle
	string infoSquareSubtitle

	array<ItemFlavor> rewards
}
#endif



///////////////////////
///////////////////////
//// Private Types ////
///////////////////////
///////////////////////
#if CLIENT || UI
struct FileStruct_LifetimeLevel
{
	//
}
#endif
#if CLIENT
FileStruct_LifetimeLevel fileLevel //
#elseif UI
FileStruct_LifetimeLevel& fileLevel //

struct {
	//
} fileVM //
#endif



/////////////////////////
/////////////////////////
//// Initialiszation ////
/////////////////////////
/////////////////////////
#if CLIENT || UI
void function CollectionEvents_Init()
{
	#if UI
		FileStruct_LifetimeLevel newFileLevel
		fileLevel = newFileLevel
	#endif

	AddCallback_OnItemFlavorRegistered( eItemType.calevent_collection, void function( ItemFlavor ev ) {
		//
	} )
}
#endif



//////////////////////////
//////////////////////////
//// Global functions ////
//////////////////////////
//////////////////////////
#if CLIENT || UI
ItemFlavor ornull function GetActiveCollectionEvent( int t )
{
	Assert( IsItemFlavorRegistrationFinished() )
	ItemFlavor ornull event = null
	foreach ( ItemFlavor ev in GetAllItemFlavorsOfType( eItemType.calevent_collection ) )
	{
		if ( !CalEvent_IsActive( ev, t ) )
			continue

		Assert( event == null, format( "Multiple collection events are active!! (%s, %s)", ItemFlavor_GetHumanReadableRef( expect ItemFlavor(event) ), ItemFlavor_GetHumanReadableRef( ev ) ) )
		event = ev
	}
	return event
}
#endif

#if CLIENT || UI
bool function HaveActiveCollectionEventNow()
{
	return GetActiveCollectionEvent( GetUnixTimestamp() ) != null
}
#endif


#if CLIENT || UI
string function CollectionEvent_GetSeasonName( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "seasonName" )
}
#endif


#if CLIENT || UI
ItemFlavor function CollectionEvent_GetMainPackFlav( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "mainPackFlav" ) )
}
#endif


#if CLIENT || UI
ItemFlavor function CollectionEvent_GetHeirloomDisplayItemFlav( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "heirloomDisplayItemFlav" ) )
}
#endif


#if CLIENT || UI
ItemFlavor function CollectionEvent_GetHeirloomPurchaseItemFlav( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "heirloomPurchaseItemFlav" ) )
}
#endif


#if CLIENT || UI
ItemFlavor function CollectionEvent_GetCurrencyFlav( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "currencyFlav" ) )
}
#endif


#if CLIENT || UI
int function CollectionEvent_GetExpectedCurrencyPerPack( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsInt( ItemFlavor_GetAsset( event ), "expectedCurrencyPerPack" )
}
#endif


#if CLIENT || UI
string function CollectionEvent_GetFrontPageGRXOfferLocation( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "frontGRXOfferLocation" )
}
#endif


#if CLIENT || UI
string function CollectionEvent_GetShopGRXOfferLocation( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "shopGRXOfferLocation" )
}
#endif


#if CLIENT || UI
array<CollectionEventRewardGroup> function CollectionEvent_GetRewardGroups( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )

	array<CollectionEventRewardGroup> groups = []
	foreach ( var groupBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), "rewardGroups" ) )
	{
		CollectionEventRewardGroup group
		group.ref = GetSettingsBlockString( groupBlock, "ref" )
		group.quality = eQuality[GetSettingsBlockString( groupBlock, "quality" )]
		group.infoSquareTitle = GetSettingsBlockString( groupBlock, "infoSquareTitle" )
		group.infoSquareSubtitle = GetSettingsBlockString( groupBlock, "infoSquareSubtitle" )
		foreach ( var rewardBlock in IterateSettingsArray( GetSettingsBlockArray( groupBlock, "rewards" ) ) )
			group.rewards.append( GetItemFlavorByAsset( GetSettingsBlockAsset( rewardBlock, "flavor" ) ) )

		groups.append( group )
	}
	return groups
}
#endif


#if CLIENT || UI
array<string> function CollectionEvent_GetAboutText( ItemFlavor event, bool restricted )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )

	array<string> aboutText = []
	string key              = (restricted ? "aboutTextRestricted" : "aboutTextStandard")
	foreach ( var aboutBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), key ) )
		aboutText.append( GetSettingsBlockString( aboutBlock, "text" ) )
	return aboutText
}
#endif

#if CLIENT || UI
string function CollectionEvent_GetFrontTabText( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return ItemFlavor_GetShortName( event )
}
#endif

#if CLIENT || UI
vector function CollectionEvent_GetTabBGDefaultCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBGDefaultCol" )
}
#endif

#if CLIENT || UI
void function CollectionEvent_GetMainIcon( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
}
#endif


#if CLIENT || UI
vector function CollectionEvent_GetKeyColor( ItemFlavor event, int index )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	Assert( index >= 0 && index < 5 )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), format( "keyCol%d", index ) )
}
#endif


#if CLIENT || UI
asset function CollectionEvent_GetBGPatternImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "bgPatternImage" )
}
#endif


#if CLIENT || UI
asset function CollectionEvent_GetHeaderIcon( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "headerIcon" )
}
#endif


#if CLIENT || UI
asset function CollectionEvent_GetHeirloomButtonImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "heirloomButtonImage" )
}
#endif
