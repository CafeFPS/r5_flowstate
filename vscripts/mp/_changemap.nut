global function CodeCallback_MatchIsOver


void function CodeCallback_MatchIsOver()
{
	if ( !IsPrivateMatch() && IsMatchmakingServer() )
		SetUIVar( level, "putPlayerInMatchmakingAfterDelay", true )
	else
		SetUIVar( level, "putPlayerInMatchmakingAfterDelay", false )

#if DEV
	if ( !IsMatchmakingServer() )
		GameRules_ChangeMap( "mp_lobby", GAMETYPE )
#endif // #if DEV
}
