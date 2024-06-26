untyped

//////////////////////////////////////////
// placing this here temp (mkos Assert) //
//////////////////////////////////////////
global function mAssert

#if CLIENT
	global function ErrorClientPlayer
#endif

void function mAssert( var condition, string errorMsg = "error" )
{
	if ( !condition )
	{	
		#if UI
			Warning( errorMsg )
			RunClientScript( "ErrorClientPlayer", errorMsg )
		#endif
		
		#if CLIENT
			ErrorClientPlayer( errorMsg )
		#endif
		
		#if SERVER
			string appenderr = "\n\n" + DBG_INFO( 3 )
			appenderr += "\n" + DBG_INFO( 4 )
			
			ErrorServer( errorMsg + appenderr )
		#endif
	}
}

#if CLIENT
void function ErrorClientPlayer( string errorMsg )
{
	entity player = GetLocalClientPlayer()
	thread WaitValidPlayerThenError( player, errorMsg )
}

void function WaitValidPlayerThenError( entity player, string errorMsg )
{
	GetLocalClientPlayer().ClientCommand( "disconnect " + errorMsg )
	waitthread WaitSignalOrTimeout( player, 2, "OnDisconnected" )	
	RunUIScript( "OpenErrorDialog", errorMsg )
}
#endif

#if SERVER
void function ErrorServer( string errorMsg )
{
	thread WaitValidStateThenClose( errorMsg )
}

void function WaitValidStateThenClose( string errorMsg )
{
	if( shGlobalErrorCheck() )
		wait 1 //Todo(dw): Needs proper timing ~mkos
	
	if ( GetPlayerArray().len() > 0 )
	{
		foreach( player in GetPlayerArray() )
		{
			KickPlayerById( player.GetPlatformUID(), errorMsg )
		}
	}
	
	ScriptError( errorMsg, DBG_INFO() )
	//throw errorMsg
}
#endif 
///