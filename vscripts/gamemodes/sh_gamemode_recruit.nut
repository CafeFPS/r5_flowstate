global function IsRecruitMode
global function CanRecruitOrRevivePlayer

#if SERVER
global function RecruitMode_ChangeTeams
global function RecruitMode_Init
#endif

#if CLIENT
global function CL_RecruitModeUnitFrames_Init
global function Recruit_OnPlayerTeamChanged

struct
{
	array<var>    recruitModeRuis
} file
#endif

bool function IsRecruitMode()
{
	return GetCurrentPlaylistVarInt( "recruit_mode", 0 ) == 1
}


bool function CanRecruitOrRevivePlayer( entity reviver, entity target )
{
	if ( GetPlayerArrayOfTeam( reviver.GetTeam() ).len() < GetCurrentPlaylistVarInt( "recruit_max_team_size", 3 ) )
		return true

	if ( reviver.GetTeam() == target.GetTeam() )
		return true

	return false
}

#if SERVER
void function RecruitMode_Init()
{
	AddCallback_OnDNAPickupDestroyed( OnDNAPickupDestroyed )
}
#endif

#if CLIENT
void function CL_RecruitModeUnitFrames_Init()
{
	AddCreateCallback( "player", OnPlayerCreated )
	AddCallback_OnPlayerChangedTeam( Recruit_OnPlayerTeamChanged )
}

void function OnPlayerCreated( entity player )
{
	// A team is not guaranteed to be assigned when ClientCodeCallback_OnEntityCreation() calls OnPlayerCreated()
	// There's still an issue where your teammates can show as dead briefly when first shown because their health isn't set initially.
	// Should probably make this work on spawn instead.
	//thread WaitForTeamAssignment( player )
	Recruit_OnPlayerTeamChanged( player, TEAM_UNASSIGNED, player.GetTeam() ) // todo(dw): this setup (OnPlayerCreated calling OnPlayerTeamChanged) would probably be useful elsewhere, so we should make AddCallback_PlayerClassChanged always get call in that situation

	if ( IsRecruitMode() && GetLocalClientPlayer() == player )
		CreateRecruitModeRuis()
}

void function Recruit_OnPlayerTeamChanged( entity player, int oldTeam, int newTeam )
{
	if ( oldTeam == TEAM_INVALID || newTeam == TEAM_INVALID )
		return

	if ( !IsValid( player ) )
		return

	UpdateUnitframePlaceholderVisibility()
	ResetWaypointVisibilities()

	string playerName      = player.GetPlayerName()
	vector playerNameColor = GetKeyColor( COLORID_ENEMY )

	if ( newTeam == GetLocalViewPlayer().GetTeam() )
		playerNameColor = GetKeyColor( COLORID_FRIENDLY )

	if ( GetGameState() > eGameState.Prematch && oldTeam > 1 && newTeam > 1 )
	{
		Obituary_Print_Localized( Localize( "#RECRUIT_MODE_OBIT", playerName ), playerNameColor )
	}
}

void function CreateRecruitModeRuis()
{
	if ( file.recruitModeRuis.len() > 0 ) //OnPlayerCreated is called during spectator
		return

	int maxTeamSize = GetCurrentPlaylistVarInt( "recruit_max_team_size", 3 ) - 1 //Team Unit Frames are 0 - 1 but only for other teammates.
	for ( int i = 0; i < maxTeamSize; i++ )
	{
		var rui = CreatePermanentCockpitPostFXRui( $"ui/unitframe_recruit_mode.rpak", HUD_Z_BASE )
		RuiSetInt( rui, "frameSlot", i )
		RuiSetImage( rui, "icon", $"rui/menu/buttons/lobby_character_select/random" )
		RuiSetBool( rui, "isVisible", true )
		file.recruitModeRuis.append( rui )
	}
}

void function UpdateUnitframePlaceholderVisibility()
{
	entity viewer             = GetLocalViewPlayer()
	array<entity> playerArray = GetPlayerArrayOfTeam( viewer.GetTeam() )
	int teamMembers           = playerArray.len()

	foreach( index, rui in file.recruitModeRuis )
	{
		if ( index >= (teamMembers - 1) )
			RuiSetBool( file.recruitModeRuis[ index ], "isVisible", true )
		else
			RuiSetBool( file.recruitModeRuis[ index ], "isVisible", false )
	}
}
#endif

#if SERVER
void function RecruitMode_ChangeTeams( entity reviver, entity target )
{
	if ( target.GetTeam() == reviver.GetTeam() )
		return

	if ( IsValid( target ) && IsValid( reviver ) )
	{
		int oldTeam  = target.GetTeam()
		int newTeam  = reviver.GetTeam()
		int oldIndex = target.GetTeamMemberIndex()
		SetTeam( target, newTeam )
		int newIndex = GetLowestUnusedMemberIndexForTeam( newTeam )
		target.SetTeamMemberIndex( newIndex )
		UpdateSquadDataForTeamChange( target, oldIndex, newIndex, oldTeam, newTeam )
		if ( GetPlayerArrayOfTeam_Alive( oldTeam ).len() == 0 )
			HandleSquadElimination( oldTeam )
		foreach ( trap in target.e.activeTraps )
		{
			SetTeam( trap, newTeam )
		}
		foreach ( trap in target.e.activeUltimateTraps )
		{
			SetTeam( trap, newTeam )
		}
	}
	UpdatePlayerCounts()
}

void function OnDNAPickupDestroyed( entity player )
{
	thread ClearTeamSlot( player ) //Threading off because HandleSquadElimination doesn't work properly with the delayedDNAPickupDestroyed thread.
}

void function ClearTeamSlot( entity player )
{
	player.EndSignal( "OnDestroy" )

	int newTeam      = -1
	int maxTeamCount = GetCurrentPlaylistVarInt( "max_teams", 75 )
	for ( int i = 2; i < 2 + maxTeamCount; i++ )
	{
		array<entity> playerArray = GetPlayerArrayOfTeam_Alive( i )
		if ( playerArray.len() == 0 )
		{
			newTeam = i
			break
		}
	}
	if ( newTeam == -1 )
		return

	int oldTeam  = player.GetTeam()
	int oldIndex = player.GetTeamMemberIndex()
	SetTeam( player, newTeam )
	int newIndex = GetLowestUnusedMemberIndexForTeam( newTeam )
	player.SetTeamMemberIndex( newIndex )
	UpdateSquadDataForTeamChange( player, oldIndex, newIndex, oldTeam, newTeam )
	UpdatePlayerCounts()
	HandleSquadElimination( newTeam )
}
#endif