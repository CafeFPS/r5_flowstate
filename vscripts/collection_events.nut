//=========================================================
//	collection_events.nut
//=========================================================

#if SERVER || CLIENT || UI
global function CollectionEvents_Init
#endif


#if CLIENT || UI
global function GetActiveCollectionEvent
global function CollectionEvent_GetChallenges
global function CollectionEvent_GetFrontPageRewardBoxTitle
//
//
global function CollectionEvent_GetMainPackFlav
global function CollectionEvent_GetMainPackShortPluralName
global function CollectionEvent_GetMainPackImage
global function CollectionEvent_GetHeirloomPrimaryItemFlav
global function CollectionEvent_GetHeirloomPackFlav
global function CollectionEvent_GetHeirloomPackRewardSequenceName
//
//
global function CollectionEvent_GetFrontPageGRXOfferLocation
//global function CollectionEvent_GetShopGRXOfferLocation
global function CollectionEvent_GetRewardGroups
global function CollectionEvent_GetAboutText
global function CollectionEvent_GetMainIcon
global function CollectionEvent_GetMainThemeCol
global function CollectionEvent_GetFrontPageBGTintCol
global function CollectionEvent_GetFrontPageTitleCol
global function CollectionEvent_GetFrontPageSubtitleCol
global function CollectionEvent_GetFrontPageTimeRemainingCol
//
//
//
global function CollectionEvent_GetTabBGDefaultCol
global function CollectionEvent_GetTabBarDefaultCol
global function CollectionEvent_GetTabBGFocusedCol
global function CollectionEvent_GetTabBarFocusedCol
global function CollectionEvent_GetTabBGSelectedCol
global function CollectionEvent_GetTabBarSelectedCol
global function CollectionEvent_GetAboutPageSpecialTextCol
global function CollectionEvent_GetBGPatternImage
global function CollectionEvent_GetHeaderIcon
global function CollectionEvent_GetHeirloomButtonImage
global function CollectionEvent_GetItemCount
global function CollectionEvent_GetCurrentRemainingItemCount
#endif

#if CLIENT || UI 
global function CollectionEvent_GetFrontTabText
#endif

#if(UI)
global function CollectionEvent_GetCurrentMaxEventPackPurchaseCount
//
#endif

#if(UI)
//
global function CollectionEvent_GetPackOffer
#endif


//////////////////////
//////////////////////
//// Global Types ////
//////////////////////
//////////////////////

#if CLIENT || UI 
global struct CollectionEventRewardGroup
{
	string ref
	int    quality = -1
	//
	//

	array<ItemFlavor> rewards
}
#endif


//
global const table<asset, array<asset> > S03E01_HARD_CODED_BONUS_QUIPS = {

	[$"settings/itemflav/character_skin/bangalore/s03e01_legendary_01.rpak"] = [
		$"settings/itemflav/character_intro_quip/bangalore/s03e01_common_01.rpak",
		$"settings/itemflav/character_kill_quip/bangalore/s03e01_common_01.rpak"
	],

	[$"settings/itemflav/character_skin/bloodhound/s03e01_legendary_01.rpak"] = [
		$"settings/itemflav/character_intro_quip/bloodhound/s03e01_common_01.rpak",
		$"settings/itemflav/character_kill_quip/bloodhound/s03e01_common_01.rpak"
	],

	[$"settings/itemflav/character_skin/caustic/s03e01_legendary_01.rpak"] = [
		$"settings/itemflav/character_intro_quip/caustic/s03e01_common_01.rpak",
		$"settings/itemflav/character_kill_quip/caustic/s03e01_common_01.rpak"
	],

	[$"settings/itemflav/character_skin/crypto/s03e01_legendary_01.rpak"] = [
		$"settings/itemflav/character_intro_quip/crypto/s03e01_common_01.rpak",
		$"settings/itemflav/character_kill_quip/crypto/s03e01_common_01.rpak"
	],

	[$"settings/itemflav/character_skin/gibraltar/s03e01_legendary_01.rpak"] = [
		$"settings/itemflav/character_intro_quip/gibraltar/s03e01_common_01.rpak",
		$"settings/itemflav/character_kill_quip/gibraltar/s03e01_common_01.rpak"
	],

	[$"settings/itemflav/character_skin/lifeline/s03e01_epic_01.rpak"] = [
		$"settings/itemflav/character_intro_quip/lifeline/s03e01_common_01.rpak",
		$"settings/itemflav/character_kill_quip/lifeline/s03e01_common_01.rpak"
	],

	[$"settings/itemflav/character_skin/mirage/s03e01_legendary_01.rpak"] = [
		$"settings/itemflav/character_intro_quip/mirage/s03e01_common_01.rpak",
		$"settings/itemflav/character_kill_quip/mirage/s03e01_common_01.rpak"
	],

	[$"settings/itemflav/character_skin/wattson/s03e01_epic_01.rpak"] = [
		$"settings/itemflav/character_intro_quip/wattson/s03e01_common_01.rpak",
		$"settings/itemflav/character_kill_quip/wattson/s03e01_common_01.rpak"
	],

	[$"settings/itemflav/character_skin/wraith/s03e01_legendary_01.rpak"] = [
		$"settings/itemflav/character_intro_quip/wraith/s03e01_common_01.rpak",
		$"settings/itemflav/character_kill_quip/wraith/s03e01_common_01.rpak"
	],

}


///////////////////////
///////////////////////
//// Private Types ////
///////////////////////
///////////////////////

#if SERVER || CLIENT || UI
struct FileStruct_LifetimeLevel
{
	#if(false)


#endif

	table<ItemFlavor, array<ItemFlavor> > eventChallengesMap
}
#endif
#if SERVER || CLIENT
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

#if SERVER || CLIENT || UI
void function CollectionEvents_Init()
{
	#if UI
		FileStruct_LifetimeLevel newFileLevel
		fileLevel = newFileLevel
	#endif

	AddCallback_OnItemFlavorRegistered( eItemType.calevent_collection, void function( ItemFlavor ev ) {
		fileLevel.eventChallengesMap[ev] <- RegisterReferencedItemFlavorsFromArray( ev, "challenges", "flavor" )
		foreach ( int challengeSortOrdinal, ItemFlavor challengeFlav in fileLevel.eventChallengesMap[ev] )
			RegisterChallengeSource( challengeFlav, ev, challengeSortOrdinal )
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
array<ItemFlavor> function CollectionEvent_GetLoginRewards( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )

	array<ItemFlavor> rewards = []
	foreach ( var rewardBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( event ), "loginRewards" ) )
	{
		asset rewardAsset = GetSettingsBlockAsset( rewardBlock, "flavor" )
		if ( IsValidItemFlavorSettingsAsset( rewardAsset ) )
			rewards.append( GetItemFlavorByAsset( rewardAsset ) )
	}
	return rewards
}
#endif


#if CLIENT || UI 
array<ItemFlavor> function CollectionEvent_GetChallenges( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )

	return fileLevel.eventChallengesMap[event]
}
#endif


#if CLIENT || UI 
string function CollectionEvent_GetFrontPageRewardBoxTitle( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "frontPageRewardBoxTitle" )
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
string function CollectionEvent_GetMainPackShortPluralName( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "mainPackShortPluralName" )
}
#endif


#if CLIENT || UI 
asset function CollectionEvent_GetMainPackImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "mainPackImage" )
}
#endif


#if CLIENT || UI 
ItemFlavor function CollectionEvent_GetHeirloomPrimaryItemFlav( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "heirloomPrimaryItemFlav" ) )
}
#endif


#if CLIENT || UI 
ItemFlavor function CollectionEvent_GetHeirloomPackFlav( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetItemFlavorByAsset( GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "heirloomPackItemFlav" ) )
}
#endif


#if CLIENT || UI 
string function CollectionEvent_GetHeirloomPackRewardSequenceName( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "heirloomPackRewardSeqName" )
}
#endif


//
//
//
//
//
//
//


//
//
//
//
//
//
//


#if CLIENT || UI 
string function CollectionEvent_GetFrontPageGRXOfferLocation( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "frontGRXOfferLocation" )
}
#endif


//
//
//
//
//
//
//


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
		// group.infoSquareTitle = GetSettingsBlockString( groupBlock, "infoSquareTitle" )
		// group.infoSquareSubtitle = GetSettingsBlockString( groupBlock, "infoSquareSubtitle" )
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
void function CollectionEvent_GetMainIcon( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
}
#endif


#if CLIENT || UI 
vector function CollectionEvent_GetMainThemeCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "mainThemeCol" )
}
#endif


#if CLIENT || UI 
vector function CollectionEvent_GetFrontPageBGTintCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "frontPageBGTintCol" )
}
#endif


#if CLIENT || UI 
vector function CollectionEvent_GetFrontPageTitleCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "frontPageTitleCol" )
}
#endif


#if CLIENT || UI 
vector function CollectionEvent_GetFrontPageSubtitleCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "frontPageSubtitleCol" )
}
#endif


#if CLIENT || UI 
vector function CollectionEvent_GetFrontPageTimeRemainingCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "frontPageTimeRemainingCol" )
}
#endif


//
//
//
//
//
//
//


//
//
//
//
//
//
//


//
//
//
//
//
//
//


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
vector function CollectionEvent_GetTabBarDefaultCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBarDefaultCol" )
}
#endif


#if CLIENT || UI 
vector function CollectionEvent_GetTabBGFocusedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBGFocusedCol" )
}
#endif


#if CLIENT || UI 
vector function CollectionEvent_GetTabBarFocusedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBarFocusedCol" )
}
#endif


#if CLIENT || UI 
vector function CollectionEvent_GetTabBGSelectedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBGSelectedCol" )
}
#endif


#if CLIENT || UI 
vector function CollectionEvent_GetTabBarSelectedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBarSelectedCol" )
}
#endif


#if CLIENT || UI 
vector function CollectionEvent_GetAboutPageSpecialTextCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_collection )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "aboutPageSpecialTextCol" )
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


#if CLIENT || UI 
int function CollectionEvent_GetItemCount( ItemFlavor event, bool onlyOwned, entity player = null, bool dontCheckInventoryReady = false )
{
	Assert( dontCheckInventoryReady || !onlyOwned || (player != null && GRX_IsInventoryReady( player )) )
	array<CollectionEventRewardGroup> rewardGroups = CollectionEvent_GetRewardGroups( event )
	int count                                      = 0
	foreach ( CollectionEventRewardGroup rewardGroup in rewardGroups )
	{
		foreach ( ItemFlavor reward in rewardGroup.rewards )
		{
			if ( !onlyOwned || GRX_IsItemOwnedByPlayer_AllowOutOfDateData( reward, player ) )
				count++
		}
	}
	return count
}
#endif


#if CLIENT || UI 
int function CollectionEvent_GetCurrentRemainingItemCount( ItemFlavor event, entity player )
{
	return CollectionEvent_GetItemCount( event, false ) - CollectionEvent_GetItemCount( event, true, player )
}
#endif


#if(UI)
GRXScriptOffer ornull function CollectionEvent_GetPackOffer( ItemFlavor event )
{
	if ( GRX_IsOfferRestricted() )
		return null

	ItemFlavor packFlav          = CollectionEvent_GetMainPackFlav( event )
	string offerLocation         = CollectionEvent_GetFrontPageGRXOfferLocation( event )
	array<GRXScriptOffer> offers = GRX_GetItemDedicatedStoreOffers( packFlav, offerLocation )
	return offers.len() > 0 ? offers[0] : null
}
#endif


#if(UI)
int function CollectionEvent_GetCurrentMaxEventPackPurchaseCount( ItemFlavor event, entity player )
{
	#if(false)


#elseif(UI)
		if ( CollectionEvent_GetPackOffer( event ) == null )
			return 0
	#endif


	ItemFlavor packFlav = CollectionEvent_GetMainPackFlav( event )
	#if(false)

#elseif(UI)
		int ownedPackCount = GRX_GetPackCount( ItemFlavor_GetGRXIndex( packFlav ) )
	#endif

	return CollectionEvent_GetCurrentRemainingItemCount( event, player ) - ownedPackCount
}
#endif


//
//
//
//
//
//
//
//
//


//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//



//
//
//
//
//

//



//
//
//
//
//

#if(false)











//















//



//

















//








#endif


