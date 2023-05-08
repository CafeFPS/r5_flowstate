global function _LobbyVM_Init

void function _LobbyVM_Init()
{
    AddCallback_OnClientConnected(OnPlayerConnected)
}

void function OnPlayerConnected(entity player)
{
	LoadoutEntry entry = GetAllLoadoutSlots()[268]
	ItemFlavor itemFlavor = ConvertLoadoutSlotContentsIndexToItemFlavor( entry, 6 )
	SetItemFlavorLoadoutSlot( ToEHI( player ), entry, itemFlavor )
}