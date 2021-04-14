
global function GamemodeTdmShared_Init

void function GamemodeTdmShared_Init()
{
	SetScoreEventOverrideFunc( TDM_SetScoreEventOverride )

	#if CLIENT
	SetGameModeSuddenDeathAnnouncementSubtext( "#GAMEMODE_ANNOUNCEMENT_SUDDEN_DEATH_TDM" )
	#endif
}

void function TDM_SetScoreEventOverride()
{
	ScoreEvent_SetGameModeRelevant( GetScoreEvent( "KillPilot" ) )
}