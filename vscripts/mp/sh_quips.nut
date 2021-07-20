global function ShQuips_Init
global function RegisterEquippableQuipsForCharacter

global function CharacterQuip_IsTheEmpty

#if(false)

#endif

#if(false)

#endif

#if CLIENT
global function PerformQuip
global function CharacterQuip_ShortenTextForCommsMenu
#endif

#if(false)

#endif

#if CLIENT || UI 
global function CreateNestedRuiForQuip

#if(false)

#endif

#endif

#if(false)




#endif

global function CharacterQuip_GetCharacterFlavor
global function CharacterQuip_GetAliasSubName
global function Loadout_CharacterQuip
global function ItemFlavor_CanEquipToWheel

#if(false)

#endif

global const int MAX_QUIPS_EQUIPPED = 8

#if SERVER || CLIENT || UI
struct FileStruct_LifetimeLevel
{
	table<ItemFlavor, array<LoadoutEntry> >     loadoutCharacterQuipsSlotListMap

	array<ItemFlavor> universalQuips
	table<ItemFlavor, ItemFlavor> quipCharacterMap
}
FileStruct_LifetimeLevel& fileLevel
#endif

void function ShQuips_Init()
{
	FileStruct_LifetimeLevel newFileLevel
	fileLevel = newFileLevel

#if SERVER
	AddClientCommandCallback( "BroadcastQuip", ClientCommand_BroadcastQuip )
#endif

#if(false)




#endif
}

void function RegisterEquippableQuipsForCharacter( ItemFlavor characterClass, array<ItemFlavor> quipList )
{
	foreach( int index, ItemFlavor quip in quipList )
	{
		fileLevel.quipCharacterMap[quip] <- characterClass
	}

	fileLevel.loadoutCharacterQuipsSlotListMap[characterClass] <- []

	for ( int quipIndex = 0; quipIndex < MAX_QUIPS_EQUIPPED; quipIndex++ )
	{
		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "quips_" + quipIndex, ItemFlavor_GetGUIDString( characterClass ) )
		entry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
		entry.DEV_category = "character_quips"
		entry.DEV_name = ItemFlavor_GetHumanReadableRef( characterClass ) + " Quip " + quipIndex
		entry.validItemFlavorList = quipList
		entry.defaultItemFlavor = entry.validItemFlavorList[0]
		entry.isSlotLocked = bool function( EHI playerEHI ) {
			return !IsLobby()
		}
		entry.isActiveConditions = { [Loadout_CharacterClass()] = { [characterClass] = true, }, }
		entry.networkTo = eLoadoutNetworking.PLAYER_EXCLUSIVE
		//
		fileLevel.loadoutCharacterQuipsSlotListMap[characterClass].append( entry )
	}
}


#if CLIENT
void function PerformQuip( entity player, int index )
{
	// TODO:
	// Quips underwent some change in S3
	// sh_quips.nut and sh_quickchat.gnut
	// needs a refactor in the future.
	// For now i pass invalid arguments.
	if ( !IsAlive( player ) )
		return

	ItemFlavor quip      = GetItemFlavorByGUID( index )

	// int fixAndReplaceMe = 1
	// CommsAction act
	// act.index = eCommsAction.QUIP
	// act.aliasSubname = CharacterQuip_GetAliasSubName( quip )
	// act.hasCalm = false
	// act.hasCalmFar = false
	// act.hasUrgent = false
	// act.hasUrgentFar = false

	// CommsOptions opt
	// opt.isFirstPerson = 
	// opt.isFar = false
	// opt.isUrgent = false
	// opt.pauseQueue = player.GetTeam() == GetLocalViewPlayer().GetTeam()

	// PlaySoundForCommsAction( player, fixAndReplaceMe, opt )
	
	// this is temp until stuff is reworked
	string audio = GetBattleChatterAlias1P3P( player, CharacterQuip_GetAliasSubName( quip ), ( player == GetLocalViewPlayer() ) )
	EmitSoundOnEntity( player, audio )
}
#endif



#if SERVER || CLIENT || UI
LoadoutEntry function Loadout_CharacterQuip( ItemFlavor characterClass, int badgeIndex )
{
	return fileLevel.loadoutCharacterQuipsSlotListMap[characterClass][badgeIndex]
}

string function CharacterQuip_GetAliasSubName( ItemFlavor flavor )
{
	AssertEmoteIsValid( flavor )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "quickchatAliasSubName" )
}

bool function CharacterQuip_IsTheEmpty( ItemFlavor flavor )
{
	AssertEmoteIsValid( flavor )

	return ( GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "isTheEmpty" ) )
}

#if(false)






#endif

#if(false)






#endif

void function AssertEmoteIsValid( ItemFlavor flavor )
{
	array<int> allowedList = [
		eItemType.gladiator_card_kill_quip,
		eItemType.gladiator_card_intro_quip,
	#if(false)

#endif
	#if(false)

#endif
	]

	Assert( allowedList.contains( ItemFlavor_GetType( flavor ) ) )
}
#endif

#if SERVER
array<ItemFlavor> function GetAllValidQuipsForPlayer( entity player )
{
	array<ItemFlavor> results = []

	EHI playerEHI = ToEHI( player )

	ItemFlavor character = LoadoutSlot_GetItemFlavor( playerEHI, Loadout_CharacterClass() )

	for ( int i = 0; i < MAX_QUIPS_EQUIPPED; i++ )
	{
		LoadoutEntry entry = Loadout_CharacterQuip( character, i )
		ItemFlavor quip = LoadoutSlot_GetItemFlavor( playerEHI, entry )

		if ( !CharacterQuip_IsTheEmpty( quip ) )
			results.append( quip )
	}

	return results
}

bool function ClientCommand_BroadcastQuip( entity player, array<string> args )
{
	if ( !IsValid( player ) || !IsAlive( player ) )
		return true

	if ( args.len() < 1 )
		return true

	int quipWheelChoice = int( args[0] )

	array<ItemFlavor> availableQuips = GetAllValidQuipsForPlayer( player )
	if ( availableQuips.len() == 0 || quipWheelChoice >= availableQuips.len() )
		return true

	ItemFlavor selectedQuip = availableQuips[quipWheelChoice]

	foreach ( listener in GetPlayerArray() )
		Remote_CallFunction_Replay( listener, "PerformQuip", player, ItemFlavor_GetGUID( selectedQuip ) )

	return true
}
#endif

#if(false)































































#endif

bool function ItemFlavor_CanEquipToWheel( ItemFlavor item )
{
	switch ( ItemFlavor_GetType( item ) )
	{
		case eItemType.gladiator_card_kill_quip:
		case eItemType.gladiator_card_intro_quip:
			return true
	}

	return false
}

#if CLIENT || UI
string function CharacterQuip_ShortenTextForCommsMenu( ItemFlavor flav )
{
	string txt = ""

	int itemType = ItemFlavor_GetType( flav )
	if ( itemType == eItemType.gladiator_card_kill_quip || itemType == eItemType.gladiator_card_intro_quip )
	{
		txt = Localize( ItemFlavor_GetLongName( flav ) )

		int WORD_MAX_LEN = 11
		int TEXT_MAX_LEN = 26
		int TEXT_MAX_LEN_W_DOTS = TEXT_MAX_LEN - 2
#if CLIENT
		txt = CondenseText( txt, WORD_MAX_LEN, TEXT_MAX_LEN )
#endif
	}
	return txt
}

var function CreateNestedRuiForQuip( var baseRui, string argName, EHI ehi, ItemFlavor quip, ItemFlavor ornull character )
{
	asset ruiAsset = $"ui/comms_menu_icon_default.rpak"

	int type = ItemFlavor_GetType( quip )
	switch ( type )
	{
#if(false)





#endif
	}

	var nestedRui = RuiCreateNested( baseRui, argName, ruiAsset )
	asset icon       = ItemFlavor_GetIcon( quip )
	RuiSetImage( nestedRui, "icon", icon )

	string txt = CharacterQuip_ShortenTextForCommsMenu( quip )
	RuiSetString( nestedRui, "centerText", txt )

	return nestedRui
}

#if(false)









//


















#endif

#endif


#if(false)























#endif


ItemFlavor ornull function CharacterQuip_GetCharacterFlavor( ItemFlavor item )
{
	if ( fileLevel.universalQuips.contains( item ) )
		return null

	return fileLevel.quipCharacterMap[ item ]
}