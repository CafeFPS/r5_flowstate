global function ClientCodeCallback_MapInit

void function ClientCodeCallback_MapInit()
{
	PrecacheModel( MU1_LEVIATHAN_MODEL )
	Canyonlands_MapInit_Common()
	AddTargetNameCreateCallback( "leviathan_staging", OnLeviathanMarkerCreated )
}

void function OnLeviathanMarkerCreated( entity marker )
{
	string markerTargetName = marker.GetTargetName()
	entity leviathan = CreateClientSidePropDynamic( marker.GetOrigin(), marker.GetAngles(), MU1_LEVIATHAN_MODEL )
	bool stagingOnly = markerTargetName == "leviathan_staging"

	thread LeviathanThink( marker, leviathan, stagingOnly )
}

void function LeviathanThink( entity marker, entity leviathan, bool stagingOnly )
{
	marker.EndSignal( "OnDestroy" )
	leviathan.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function () : ( leviathan )
		{
			if ( IsValid( leviathan ) )
			{
				leviathan.Destroy()
			}
		}
	)

	leviathan.Anim_Play( "ACT_IDLE"  )
	leviathan.SetCycle( RandomFloat(1.0 ) )

	WaitForever()
}