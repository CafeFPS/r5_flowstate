untyped

global function CarrierTorpedoPoints_Init

global function GetTorpedoOffset


void function CarrierTorpedoPoints_Init()
{
	// verified at run time
	level.carrierTorpedoPoints <- []
	level.redeyeTorpedoPoints  <- []

	AddCarrierTorpedoPoints()
	AddRedeyeTorpedoPoints()
}

table function GetTorpedoOffset( vector origin, vector angles, int indexStart, torpedoPoints )
{
	int index = indexStart % expect int( torpedoPoints.len() )
	table point = expect table( torpedoPoints[ index ] )

	vector forward = AnglesToForward( angles )
	vector right = AnglesToRight( angles )
	vector up = AnglesToUp( angles )
	vector pointOrigin = origin + forward * expect vector( point.origin ).x
	pointOrigin += right * expect vector( -point.origin ).y
	pointOrigin += up * expect vector( point.origin ).z

	vector pointAngles = AnglesCompose( point.angles, angles )

	vector pointForward = AnglesToForward( pointAngles )
	float dist = RandomFloatRange( 1800.0, 5000.0 )
	vector refOrigin = pointOrigin + pointForward * dist

	return { refOrigin = refOrigin, origin = pointOrigin, angles = pointAngles, index = index, sourceAngles = point.angles }
}

void function AddCarrierTorpedoPoint( vector origin, vector angles )
{
	origin.z -= 880 // 830?
	angles = GetAdjustedTorpedoAngles( angles )
	level.carrierTorpedoPoints.append( { origin = origin, angles = angles } )
}

void function AddRedeyeTorpedoPoint( vector origin, vector angles )
{
	origin.z -= 880
	angles = GetAdjustedTorpedoAngles( angles )
	level.redeyeTorpedoPoints.append( { origin = origin, angles = angles } )
}

vector function GetAdjustedTorpedoAngles( vector angles )
{
	angles.y -= 180 // face it outwards
	angles.y = angles.y % 360 // clamp to legal range cause getfreecamangles is wacky
	return angles
}

void function AddCarrierTorpedoPoints()
{
	level.carrierTorpedoPoints = []

	AddCarrierTorpedoPoint( <-5586,-1502,1134>, <0,-660,0> )
	AddCarrierTorpedoPoint( <-5629,-1472,454>, <0,-665,0> )
	AddCarrierTorpedoPoint( <-4811,-1501,454>, <0,-631,0> )
	AddCarrierTorpedoPoint( <-4289,-1533,1007>, <0,-622,0> )
	AddCarrierTorpedoPoint( <-2950,-2238,582>, <0,-636,0> )
	AddCarrierTorpedoPoint( <-2195,-2205,1091>, <0,-627,0> )
	AddCarrierTorpedoPoint( <-2521,-2442,1674>, <0,-624,0> )
	AddCarrierTorpedoPoint( <-2916,-2480,1958>, <0,-641,0> )
	AddCarrierTorpedoPoint( <-3463,-2161,2558>, <0,-662,0> )
	AddCarrierTorpedoPoint( <-1351,-1179,1631>, <0,-636,0> )
	AddCarrierTorpedoPoint( <-304,-1204,1523>, <0,-646,0> )
	AddCarrierTorpedoPoint( <527,-1137,1873>, <0,-634,0> )
	AddCarrierTorpedoPoint( <399,-774,698>, <0,-631,0> )
	AddCarrierTorpedoPoint( <-135,-779,823>, <0,-623,0> )
	AddCarrierTorpedoPoint( <-1304,-817,665>, <0,-636,0> )
	AddCarrierTorpedoPoint( <-1307,-858,248>, <0,-629,0> )
	AddCarrierTorpedoPoint( <-2188,-923,107>, <0,-633,0> )
	AddCarrierTorpedoPoint( <2056,-2165,732>, <0,-657,0> )
	AddCarrierTorpedoPoint( <1897,-2174,2215>, <0,-683,0> )
	AddCarrierTorpedoPoint( <2681,-2417,1898>, <0,-631,0> )
	AddCarrierTorpedoPoint( <3196,-2389,1865>, <0,-621,0> )
	AddCarrierTorpedoPoint( <3257,-2139,2967>, <0,-591,0> )
	AddCarrierTorpedoPoint( <3428,-2199,815>, <0,-605,0> )
	AddCarrierTorpedoPoint( <4062,-1122,1015>, <0,-602,0> )
	AddCarrierTorpedoPoint( <5387,-917,590>, <0,-601,0> )
	AddCarrierTorpedoPoint( <5510,-51,1166>, <0,-541,0> )
	AddCarrierTorpedoPoint( <5448,941,566>, <0,-469,0> )
	AddCarrierTorpedoPoint( <4199,1171,1014>, <0,-479,0> )
	AddCarrierTorpedoPoint( <3548,2152,1889>, <0,-485,0> )
	AddCarrierTorpedoPoint( <2846,2371,1165>, <0,-457,0> )
	AddCarrierTorpedoPoint( <1854,2222,1740>, <0,-411,0> )
	AddCarrierTorpedoPoint( <529,1180,1615>, <0,-462,0> )
	AddCarrierTorpedoPoint( <-441,1096,1839>, <0,-441,0> )
 	AddCarrierTorpedoPoint( <-1430,878,180>, <0,-447,0> )
 	AddCarrierTorpedoPoint( <-114,801,730>, <0,-452,0> )
 	AddCarrierTorpedoPoint( <1128,688,130>, <0,-439,0> )
 	AddCarrierTorpedoPoint( <-1773,897,107>, <0,-459,0> )
 	AddCarrierTorpedoPoint( <-2085,2261,856>, <0,-479,0> )
 	AddCarrierTorpedoPoint( <-2156,2248,2007>, <0,-470,0> )
 	AddCarrierTorpedoPoint( <-2737,2419,2381>, <0,-452,0> )
 	AddCarrierTorpedoPoint( <-3019,2213,581>, <0,-445,0> )
 	AddCarrierTorpedoPoint( <-3697,2210,1581>, <0,-427,0> )
 	AddCarrierTorpedoPoint( <-3337,2214,2905>, <0,-411,0> )
 	AddCarrierTorpedoPoint( <-4555,1549,1055>, <0,-449,0> )
 	AddCarrierTorpedoPoint( <-5448,1448,305>, <0,-431,0> )
 	AddCarrierTorpedoPoint( <-5763,1180,905>, <0,-352,0> )
 	AddCarrierTorpedoPoint( <-5885,862,580>, <0,-367,0> )
 	AddCarrierTorpedoPoint( <-5642,68,881>, <0,-364,0> )
 	AddCarrierTorpedoPoint( <-5726,-669,881>, <0,-356,0> )
 	AddCarrierTorpedoPoint( <-5885,-1089,456>, <0,-365,0> )
 	AddCarrierTorpedoPoint( <-5788,-1319,933>, <0,-319,0> )
 	AddCarrierTorpedoPoint( <-4688,-1501,1032>, <0,-260,0> )
}

void function AddRedeyeTorpedoPoints()
{
	level.redeyeTorpedoPoints = []

	AddRedeyeTorpedoPoint( <2718,1276,667>, <0,0,0> )
	AddRedeyeTorpedoPoint( <1793,1294,763>, <0,0,0> )
	AddRedeyeTorpedoPoint( <902,1444,790>, <0,0,0> )
	AddRedeyeTorpedoPoint( <-393,1833,664>, <0,0,0> )
	AddRedeyeTorpedoPoint( <-1435,1282,774>, <0,0,0> )
	AddRedeyeTorpedoPoint( <-2595,1309,790>, <0,0,0> )
	AddRedeyeTorpedoPoint( <-2413,1162,1034>, <0,0,0> )
	AddRedeyeTorpedoPoint( <1912,472,298>, <0,0,0> )
	AddRedeyeTorpedoPoint( <1220,461,178>, <0,0,0> )
	AddRedeyeTorpedoPoint( <71,1397,1087>, <0,0,0> )
	AddRedeyeTorpedoPoint( <1251,1496,1032>, <0,0,0> )
	AddRedeyeTorpedoPoint( <-723,1137,1237>, <0,0,0> )
	AddRedeyeTorpedoPoint( <-1418,-524,210>, <0,0,0> )
	AddRedeyeTorpedoPoint( <2241,1301,1044>, <0,0,0> )
}
