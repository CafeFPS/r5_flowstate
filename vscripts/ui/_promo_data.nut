global function InitPromoData
global function UpdatePromoData
global function IsPromoDataProtocolValid
global function GetPromoDataVersion
global function GetPromoDataLayout
global function GetPromoImage

global function GetPromoRpakName
global function GetMiniPromoRpakName

global function UICodeCallback_MainMenuPromosUpdated

#if R5DEV
global function DEV_PrintPromoData
#endif //

//
//
const int PROMO_PROTOCOL = 2

struct
{
	MainMenuPromos&      promoData
	table<string, asset> imageMap
} file

string function GetPromoRpakName()
{
	return file.promoData.promoRpak
}

string function GetMiniPromoRpakName()
{
	return file.promoData.miniPromoRpak
}

void function InitPromoData()
{
	RequestMainMenuPromos() //

	var dataTable = GetDataTable( $"datatable/promo_images.rpak" )
	for ( int i = 0; i < GetDatatableRowCount( dataTable ); i++ )
	{
		string name = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "name" ) ).tolower()
		asset image = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "image" ) )
		if ( name != "" )
			file.imageMap[name] <- image
	}
}


void function UpdatePromoData()
{
	#if R5DEV
		//if ( GetConVarBool( "mainMenuPromos_scriptUpdateDisabled" ) || GetCurrentPlaylistVarBool( "mainMenuPromos_scriptUpdateDisabled", false ) )
		//	return
	#endif //
	file.promoData = GetMainMenuPromos()
}


void function UICodeCallback_MainMenuPromosUpdated()
{
	printt( "Promos updated" )

	#if R5DEV
		//if ( GetConVarInt( "mainMenuPromos_preview" ) == 1 ) // ConVar is not registered in R5Launch
			//UpdatePromoData()
	#endif //
}


bool function IsPromoDataProtocolValid()
{
	return file.promoData.prot == PROMO_PROTOCOL
}


int function GetPromoDataVersion()
{
	return file.promoData.version
}


string function GetPromoDataLayout()
{
	return file.promoData.layout
}


asset function GetPromoImage( string identifier )
{
	identifier = identifier.tolower()

	asset image
	if ( identifier in file.imageMap )
		image = file.imageMap[identifier]
	else
		image = $"rui/promo/apex_title"

	return image
}

#if R5DEV
void function DEV_PrintPromoData()
{
	printt( "protocol:      ", file.promoData.prot )
	printt( "version:       ", file.promoData.version )
	printt( "promoRpak:     ", file.promoData.promoRpak )
	printt( "miniPromoRpak: ", file.promoData.miniPromoRpak )
	printt( "layout:        ", file.promoData.layout )
}
#endif //