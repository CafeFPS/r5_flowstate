global function CodeCallback_MapInit

void function CodeCallback_MapInit()
{
    Canyonlands_MapInit_Common()
    MapZones_RegisterDataTable( $"datatable/map_zones/zones_mp_rr_canyonlands_64k_x_64k.rpak" )
}
