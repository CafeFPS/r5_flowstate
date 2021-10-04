#if CLIENT || UI
global function TimeGatedLoginRewards_Init

global const asset BP1_SKIN = $"settings/itemflav/character_skin/pathfinder/bd1.rpak"
#endif

#if UI
global function LocalPlayerHasTimeGatedLoginReward
#endif

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


#if CLIENT || UI
void function TimeGatedLoginRewards_Init()
{
	#if UI
		FileStruct_LifetimeLevel newFileLevel
		fileLevel = newFileLevel
    #endif
}
#endif

#if UI
bool function LocalPlayerHasTimeGatedLoginReward( asset itemAsset )
{
	if ( IsValidItemFlavorSettingsAsset( itemAsset ) && GRX_IsInventoryReady() && GRX_HasItem( ItemFlavor_GetGRXIndex( GetItemFlavorByAsset( itemAsset ) ) ) )
		return true

	return false
}
#endif