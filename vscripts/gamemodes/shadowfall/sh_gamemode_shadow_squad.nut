global function ShGameModeShadowSquad_Init
global function IsShadowVictory
global function IsPlayerShadowSquad
global function Gamemode_ShadowSquad_RegisterNetworking
global function PlayerCanRespawnAsShadow

#if SERVER
global function LegendIsDied
global function ShadowKilled
global function StartShadowFx
global function GivePlayerShadowSkin
global function GivePlayerShadowPowers
#endif

#if CLIENT
global function ServerCallback_ModeShadowSquad_AnnouncementSplash
global function ServerCallback_ModeShadowSquad_RestorePlayerHealthFx
global function ServerCallback_ShadowClientEffectsEnable
global function ServerCallback_PlaySpectatorAudio
global function ServerCallback_PlayerLandedNOCAudio
global function ServerCallback_MoreNOCAudio
global function ShadowClientEffectsEnable

global function Infection_CreateEvacCountdown
global function Infection_DestroyEvacCountdown
global function Infection_CreateEvacShipMinimapIcons

const asset ANNOUNCEMENT_LEGEND_ICON = $"rui/gamemodes/shadow_squad/legend_icon"
const asset ANNOUNCEMENT_SHADOW_ICON = $"rui/gamemodes/shadow_squad/shadow_icon_orange"
#endif

global enum eShadowSquadMessage
{
	BLANK,
	GAME_RULES_INTRO,
	GAME_RULES_LAND,
	RESPAWNING_AS_SHADOW,
	HAPPY_HUNTING,
	FINAL_LEGENDS_DECIDED_SHADOW_MSG,
	FINAL_LEGENDS_DECIDED_LEGEND_MSG,
	EVAC_ARRIVED_SHADOW,
	EVAC_ARRIVED_LEGEND,
	END_LEGENDS_ESCAPED,
	END_LEGENDS_KILLED,
	END_LEGENDS_FAILED_TO_ESCAPE,
	SAFE_ON_EVAC_SHIP,
	EVAC_REMINDER_LEGEND,
	EVAC_REMINDER_SHADOW,
	REVENGE_KILL_KILLER,
	REVENGE_KILL_VICTIM,
	EVAC_ON_APPROACH_LEGEND,
	EVAC_ON_APPROACH_SHADOW,
	YOU_LOSE_FAILED_TO_EVAC,
	YOU_LOSE_ALL_LEGENDS_KILLED,
	YOU_LOSE_NO_ONE_EVACED,
	END_TIMER_EXPIRED,
	//custom
	LEGENDS_WIN_INFECTION,
	LEGENDS_WIN_INFECTION2,
	INFECTION_HAS_STARTED,
	ALPHA_ZOMBIE_START,
	LAST_MAN_STANDING
}

enum eWinConditions
{
	SOME_LEGENDS_ESCAPED,
	ALL_LEGENDS_KILLED,
	ALL_LEGENDS_KILLED_BUT_NO_SHADOWS_LEFT,
	NO_LEGENDS_ESCAPED,
	NO_LEGENDS_ESCAPED_BUT_NO_SHADOWS_LEFT,
	TIMEOUT
}


enum eRespawnForm
{
	LIVING_LEGEND,
	SHADOW_LEGEND
}

enum ePlayerGameState
{
	CONNECTED,
	INITIAL_SKYDIVE_START,
	INITIAL_SKYDIVE_END,
	SHADOW_SKYDIVE_START,
	SHADOW_SKYDIVE_END,
	REBORN_SKYDIVE_START,
	REBORN_SKYDIVE_END
}

enum eShadowSquadGamePhase
{
	FREE_FOR_ALL,
	SHADOWS_GETTING_STRONGER,
	FINAL_LEGENDS_DECIDED_EVAC_TIMER_STARTED,
	EVAC_SHIP_CLOSE_01,
	EVAC_SHIP_CLOSE_02,
	EVAC_SHIP_BEGINNING_APPROACH,
	EVAC_SHIP_DEPARTURE_TIMER_STARTED,
	EVAC_SHIP_DEPARTED,
	WINNER_DETERMINED,
	MATCH_ENDED_IN_DRAW

	_count
}
enum eShadowAnnouncerCustom
{
	PRE_MATCH,
	INITIAL_SKYDIVE_LAND,
	FINAL_LEGENDS_DECIDED,
	EVAC_CLOSE,
	PRE_VICTORY_SHADOWS,
	PRE_VICTORY_LEGENDS_MULTIPLE,
	PRE_VICTORY_LEGENDS_SINGLE,
	SHADOW_RESPAWN_FIRST,
	SHADOW_RESPAWN,
	PLAYER_TOOK_REVENGE

	_count
}

global asset FX_SHADOW_FORM_EYEGLOW 				= $""
global asset FX_SHADOW_TRAIL 					= $""

#if CLIENT
	global asset SHADOW_SCREEN_FX 					= $""
	global asset FX_HEALTH_RESTORE					= $""
	global asset FX_SHIELD_RESTORE					= $""
#endif

const bool DEBUG_SHADOWSPAWNS 					= false
const bool DEBUG_SHADOWEVAC 					= false
const string STRING_SHADOW_SOUNDS				= "ShadowSounds"
const string STRING_SHADOW_FX					= "ShadowFX"
const int MAX_SHADOW_RESPAWNS					= -1

global const int LEGEND_REALM					= 1
global const int SHADOW_REALM					= 2

struct
{

	#if SERVER
#endif //SERVER

	#if CLIENT
		var minimapEvacShipIcon
		var fullmapEvacShipIcon
		var countdownRui
		table< int, array< int > > playerClientFxHandles
	#endif

} file

void function ShGameModeShadowSquad_Init()
{
	if ( !IsFallLTM() || Gamemode() == eGamemodes.fs_infected)
		return

	SurvivalCommentary_SetHost( eSurvivalHostType.NOC )
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
	#if CLIENT
		SetCommsDialogueEnabled( false ) //
		AddCallback_OnPlayerLifeStateChanged( OnPlayerLifeStateChanged )
		AddCallback_OnVictoryCharacterModelSpawned( OnVictoryCharacterModelSpawned )
		thread ShadowVictorySequenceSetup()
		AddCreateCallback( "player", ShadowSquad_OnPlayerCreated )

		Obituary_SetIndexOffset( 2 ) //
	#endif //
}

#if CLIENT
void function ShadowVictorySequenceSetup()
{
	wait 1

	SetVictorySequenceLocation( <10472, 30000, 8500>, <0, 60, 0> )
	SetVictorySequenceSunSkyIntensity( 0.8, 0.0 )
}
#endif //

void function EntitiesDidLoad()
{
	if ( !IsFallLTM() )
		return

	if ( IsMenuLevel() )
		return

	#if SERVER
#endif //
	SurvivalCommentary_SetHost( eSurvivalHostType.NOC )
}

void function Gamemode_ShadowSquad_RegisterNetworking()
{
	SpamWarning( 10, "This is being registered!!!!!!!!!" )
	// if ( !IsFallLTM() )
	// {
		// Remote_RegisterClientFunction( "ServerCallback_ShadowClientEffectsEnable", "entity", "bool"  )
		// return
	// }

	RegisterNetworkedVariable( "livingShadowPlayerCount", SNDC_GLOBAL, SNVT_INT )
	Remote_RegisterClientFunction( "ServerCallback_ModeShadowSquad_AnnouncementSplash", "int", 0, 999, "float", 0.0, 5000.0, 16 )
	Remote_RegisterClientFunction( "ServerCallback_ShadowClientEffectsEnable", "entity", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_PlaySpectatorAudio", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_PlayerLandedNOCAudio", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_MoreNOCAudio", "int", 0, 256)
	Remote_RegisterClientFunction( "ServerCallback_ModeShadowSquad_RestorePlayerHealthFx", "bool" )
	RegisterNetworkedVariable( "playerCanRespawnAsShadow", SNDC_PLAYER_GLOBAL, SNVT_BOOL, false )

	RegisterNetworkedVariable( "shadowSquadGamePhase", SNDC_GLOBAL, SNVT_UNSIGNED_INT, 0, 0, eShadowSquadGamePhase._count )
	RegisterNetworkedVariable( "countdownTimerStart", SNDC_GLOBAL, SNVT_TIME, -1 )
	RegisterNetworkedVariable( "countdownTimerEnd", SNDC_GLOBAL, SNVT_TIME, -1 )
	RegisterNetworkedVariable( "shadowsWonTheMode", SNDC_GLOBAL, SNVT_BOOL, false )

	#if CLIENT
		RegisterNetworkedVariableChangeCallback_int( "shadowSquadGamePhase", OnGamePhaseChanged )
	#endif
}

#if CLIENT
void function OnGamePhaseChanged( entity player, int oldVal, int newVal, bool actuallyChanged )
{
	if ( !actuallyChanged )
		return

	foreach( guy in GetPlayerArray() )
	{
		UpdatePlayerHUD( guy )

		if ( newVal == eShadowSquadGamePhase.FINAL_LEGENDS_DECIDED_EVAC_TIMER_STARTED )
		{
			//
			if ( IsAlive( guy ) && !IsPlayerShadowSquad( player ) )
			{
				//
				TrackingVisionUpdatePlayerConnected( player )

				//
				if ( !IsSquadMuted() )
					SetSquadMuteState( true )
			}
		}

		if ( newVal == eShadowSquadGamePhase.WINNER_DETERMINED )
		{
			//
			if ( IsAlive( guy ) && IsPlayerShadowSquad( guy ) && GetGlobalNetBool( "shadowsWonTheMode" ) )
			{
				//
				if ( !IsSquadMuted() )
					SetSquadMuteState( true )
			}
		}
	}

}
#endif //

int function GetCurrentGamePhase()
{
	return GetGlobalNetInt( "shadowSquadGamePhase" )
}

#if CLIENT
void function ServerCallback_PlaySpectatorAudio( bool playRespawnMusic )
{
	entity clientPlayer = GetLocalClientPlayer()
	if ( !IsValid( clientPlayer ) )
		return

	if ( playRespawnMusic )
	{
		if( Gamemode() != eGamemodes.fs_infected )
			thread SkydiveRespawnCleanup( clientPlayer )

		array <string> dialogueChoices
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_01_01_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_01_02_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_01_03_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_02_01_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_02_02_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_02_03_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_03_01_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_03_02_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_04_01_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_04_02_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_05_01_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_05_02_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_06_01_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_06_02_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_07_01_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_07_02_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_07_03_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_08_01_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_08_02_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerBecomesShadowSquad_08_03_3p" )
		dialogueChoices.randomize()
		thread EmitSoundOnEntityDelayed( clientPlayer, dialogueChoices.getrandom(), 2.0 )
	}
	else
	{
		if( Gamemode() != eGamemodes.fs_infected )
			ServerCallback_PlayMatchEndMusic()

		array <string> dialogueChoices
		dialogueChoices.append( "diag_ap_nocNotify_playerDeathFinal_01_01_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerDeathFinal_01_02_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerDeathFinal_01_03_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerDeathFinal_02_01_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerDeathFinal_02_02_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerDeathFinal_03_01_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_playerDeathFinal_03_02_3p" )
		dialogueChoices.randomize()
		thread EmitSoundOnEntityDelayed( clientPlayer, dialogueChoices.getrandom(), 2.0 )
	}
}

void function ServerCallback_PlayerLandedNOCAudio( bool legendalive )
{
		entity clientPlayer = GetLocalClientPlayer()
		if ( !IsValid( clientPlayer ) )
			return
			
		if ( legendalive )
		{
			array <string> legendlandedsafely
			legendlandedsafely.append( "diag_ap_nocNotify_skydiveTaunt_01_01_3p" )
			legendlandedsafely.append( "diag_ap_nocNotify_skydiveTaunt_01_02_3p" )
			legendlandedsafely.append( "diag_ap_nocNotify_skydiveTaunt_02_01_3p" )
			legendlandedsafely.append( "diag_ap_nocNotify_skydiveTaunt_02_02_3p" )
			legendlandedsafely.randomize()
			thread EmitSoundOnEntityDelayed( clientPlayer, legendlandedsafely.getrandom(), 2.0 )
		}
		else
		{
			array <string> dialogueChoices2
			dialogueChoices2.append( "diag_ap_nocNotify_skydiveTaunt_03_01_3p" )
			dialogueChoices2.append( "diag_ap_nocNotify_skydiveTaunt_03_02_3p" )
			dialogueChoices2.append( "diag_ap_nocNotify_skydiveTaunt_03_03_3p" )
			dialogueChoices2.randomize()
			thread EmitSoundOnEntity( clientPlayer, dialogueChoices2.getrandom())
		}
		
}
void function ServerCallback_MoreNOCAudio( int index )
{
	entity clientPlayer = GetLocalClientPlayer()
	
	if ( !IsValid( clientPlayer ) )
		return
	
	switch(index)
	{
		case 0:
		array <string> dialogueChoices
		dialogueChoices.append( "diag_ap_nocNotify_legendWin_01_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_legendWin_02_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_legendWin_03_3p" )
		thread EmitSoundOnEntity( clientPlayer, dialogueChoices.getrandom())
		break
		
		case 1:
		array <string> dialogueChoices
		dialogueChoices.append( "diag_ap_nocNotify_shadowSquadWin_01_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_shadowSquadWin_02_3p" )
		dialogueChoices.append( "diag_ap_nocNotify_shadowSquadWin_03_3p" )
		thread EmitSoundOnEntity( clientPlayer, dialogueChoices.getrandom())
		break	
	
	// 4390,diag_ap_nocNotify_revengeKill_01_01_3p
// 4391,diag_ap_nocNotify_revengeKill_01_02_3p
// 4392,diag_ap_nocNotify_revengeKill_01_03_3p
// 4393,diag_ap_nocNotify_revengeKill_01_04_3p
// 4394,diag_ap_nocNotify_revengeKill_01_05_3p
// 4395,diag_ap_nocNotify_shadowSquadGrow_01_01_3p
// 4396,diag_ap_nocNotify_shadowSquadGrow_01_02_3p
// 4397,diag_ap_nocNotify_shadowSquadGrow_01_03_3p
// 4398,diag_ap_nocNotify_shadowSquadGrow_02_01_3p
// 4399,diag_ap_nocNotify_shadowSquadGrow_02_02_3p
// 4400,diag_ap_nocNotify_shadowSquadGrow_03_01_3p
// 4401,diag_ap_nocNotify_shadowSquadGrow_03_02_3p
// 4402,diag_ap_nocNotify_shadowSquadGrow_03_03_3p
// 4403,diag_ap_nocNotify_shadowSquadSpawns_01_01_3p
// 4404,diag_ap_nocNotify_shadowSquadSpawns_01_02_3p
// 4405,diag_ap_nocNotify_shadowSquadSpawns_02_01_3p
// 4406,diag_ap_nocNotify_shadowSquadSpawns_02_02_3p
// 4407,diag_ap_nocNotify_shadowSquadSpawns_03_01_3p
// 4408,diag_ap_nocNotify_shadowSquadSpawns_03_02_3p
// 4409,diag_ap_nocNotify_shadowSquadSpawns_03_03_3p
	}
}
#endif //

void function EmitSoundOnEntityDelayed( entity player, string alias, float delay )
{
	wait delay

	if ( !IsValid( player ) )
		return

	if ( GetGameState() != eGameState.Playing )
		return

	EmitSoundOnEntity( player, alias )
}

#if CLIENT
void function SkydiveRespawnCleanup( entity player )
{
	wait ( GetCurrentPlaylistVarFloat( "shadow_squad_respawn_cooldown", 0 ) + 0.25 )

	if ( !IsValid( player ) )
		return

	player.EndSignal( "OnDeath" )
	player.EndSignal( "FreefallEnded" )

	OnThreadEnd(
		function() : ( player )
		{
			if ( !IsValid( player ) )
				return

			FadeOutSoundOnEntity( player, "Music_LTM_31_RespawnAndDrop", 0.5 )
		}
	)

	WaitForever()
}
#endif

#if CLIENT
void function ShadowSquadThreatVision( entity player )
{
}
#endif //

#if CLIENT
void function ServerCallback_ShadowClientEffectsEnable( entity player, bool enableFx )
{
	thread ShadowClientEffectsEnable( player, enableFx )
}
#endif //

void function GivePlayerShadowSkin(entity player)
{
	wait 0.01
	
	if ( !IsValid( player ) )
		return

	player.SetSkin( player.GetSkinIndexByName( "ShadowSqaud" ) )
}

#if SERVER
void function LegendIsDied( entity player, entity enemy )
{
	wait 0.01
	if(!IsValid(player)) return
	
	if ( IsValid(enemy) && IsPlayerShadowSquad( enemy ) )
		enemy.SetHealth( 30 )
	else if ( IsPlayerShadowSquad( player ) )
		thread ShadowKilled( player )

	player.SetPlayerNetInt( "respawnStatus", eRespawnStatus.WAITING_FOR_DELIVERY )
	//Remote_CallFunction_NonReplay( player, "ServerCallback_ShowDeathScreen" )
	Remote_CallFunction_ByRef( player, "ServerCallback_ShowDeathScreen" )
	
	EmitSoundOnEntityOnlyToPlayer( player, player, "Music_LTM_31_RespawnAndDrop" )

	wait 5.0
	if(!IsValid(player)) return
	
	DecideRespawnPlayer( player )
	thread GivePlayerShadowSkin( player )
	thread GivePlayerShadowPowers( player )
	player.SetOrigin( <RandomIntRange( -26000, 26000 ), RandomIntRange( -26000, 26000 ), 26000> )
	player.SetAngles( <24, RandomIntRange( -180, 180 ), 0> )
	thread PlayerSkydiveFromCurrentPosition( player )
	thread StartShadowFx( player )
	
	Remote_CallFunction_NonReplay( player, "ServerCallback_ShadowClientEffectsEnable", player, true )

	wait 0.3
	if(!IsValid(player)) return
	
	Remote_CallFunction_NonReplay( player, "ServerCallback_PlaySpectatorAudio", true )
	Remote_CallFunction_NonReplay( player, "ServerCallback_ModeShadowSquad_AnnouncementSplash", eShadowSquadMessage.RESPAWNING_AS_SHADOW, 10 )
}

void function GivePlayerShadowPowers( entity player )
{
	if ( !IsValid( player ) )
		return

	player.SetPlayerNetBool( "isPlayerShadowForm", true )
	
	TakeAllPassives( player )
	player.TakeOffhandWeapon(OFFHAND_MELEE)
	player.TakeNormalWeaponByIndexNow( WEAPON_INVENTORY_SLOT_PRIMARY_2 )
	player.TakeOffhandWeapon( OFFHAND_TACTICAL )
	player.TakeOffhandWeapon( OFFHAND_ULTIMATE )
	player.TakeOffhandWeapon( OFFHAND_SLOT_FOR_CONSUMABLES )
	GivePassive( player, ePassives.PAS_TRACKING_VISION )
    player.GiveWeapon( "mp_weapon_shadow_squad_hands_primary", WEAPON_INVENTORY_SLOT_PRIMARY_2 )
    player.GiveOffhandWeapon( "melee_shadowsquad_hands", OFFHAND_MELEE )
	player.SetHealth( 30 )
	//SetTeam( player, TEAM_IMC )//TODO: Implement this for champion screen
	StatusEffect_AddEndless( player, eStatusEffect.speed_boost, 0.2 )
}

void function StartShadowFx( entity player )
{
	entity eyeFX
	entity bodyFX
	array<string> attachNames = [ "EYE_L", "EYE_R" ]

	foreach ( attachName in attachNames )
	{
		if ( player.LookupAttachment( attachName ) > 0 )
		{
			eyeFX = StartParticleEffectOnEntity_ReturnEntity( player, PrecacheParticleSystem( $"P_BShadow_eye" ), FX_PATTACH_POINT_FOLLOW, player.LookupAttachment( attachName ) )
			player.p.shadowAttachedEntities.append(eyeFX)
			eyeFX.SetOwner( player )
			eyeFX.kv.VisibilityFlags = (ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY) // Don't show the effects to owner
		}
	}

	bodyFX = StartParticleEffectOnEntity_ReturnEntity( player, PrecacheParticleSystem( $"P_Bshadow_body" ), FX_PATTACH_POINT_FOLLOW, player.LookupAttachment( "CHESTFOCUS" ) )
	player.p.shadowAttachedEntities.append(bodyFX)
	bodyFX.SetOwner( player )
	bodyFX.kv.VisibilityFlags = (ENTITY_VISIBLE_TO_FRIENDLY | ENTITY_VISIBLE_TO_ENEMY) // Don't show the effects to owner
	
	//Find a way to disable ragdolls and death anims on shadows
}

void function ShadowKilled( entity victim )
{
	StartParticleEffectOnEntity_ReturnEntity( victim, PrecacheParticleSystem( $"P_Bshadow_death" ), FX_PATTACH_POINT_FOLLOW, victim.LookupAttachment( "CHESTFOCUS" ) )
}
#endif //

#if CLIENT
void function ShadowClientEffectsEnable( entity player, bool enableFx, bool isVictorySequence = false)
{
	AssertIsNewThread()
	wait 0.25

	if ( !IsValid( player ) )
		return

	bool isLocalPlayer = ( player == GetLocalViewPlayer() )
	vector playerOrigin = player.GetOrigin()
	int playerTeam = player.GetTeam()
	if ( enableFx )
	{
		if ( isLocalPlayer )
		{
			HealthHUD_StopUpdate( player )
			EmitSoundOnEntity( player, "ShadowLegend_Shadow_Loop_1P" )

			entity cockpit = player.GetCockpit()
			if ( !IsValid( cockpit ) )
				return

			int fxHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( SHADOW_SCREEN_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
			player.p.shadowFxHandles.append(fxHandle)
			EffectSetIsWithCockpit( fxHandle, true )
			vector controlPoint = <1,1,1>
			EffectSetControlPointVector( fxHandle, 1, controlPoint )

			//
			if ( !( playerTeam in file.playerClientFxHandles) )
				file.playerClientFxHandles[ playerTeam ] <- []
			file.playerClientFxHandles[playerTeam].append( fxHandle )
		}
		else
		{
			//
			entity clientAG = CreateClientSideAmbientGeneric( player.GetOrigin() + <0,0,16>, "ShadowLegend_Shadow_Loop_3P", 0 )
			SetTeam( clientAG, player.GetTeam() )
			clientAG.SetSegmentEndpoints( player.GetOrigin() + <0,0,16>, playerOrigin + <0, 0, 72> )
			clientAG.SetEnabled( true )
			clientAG.RemoveFromAllRealms()
			clientAG.AddToOtherEntitysRealms( player )
			clientAG.SetParent( player, "", true, 0.0 )
			clientAG.SetScriptName( STRING_SHADOW_SOUNDS )
		}
	}

	else
	{
		if ( isLocalPlayer )
		{
			StopSoundOnEntity( player, "ShadowLegend_Shadow_Loop_1P" )

			if ( !( playerTeam in file.playerClientFxHandles) )
			{
				Warning( "%s() - Unable to find client-side effect table for player: '%s'", FUNC_NAME(), string( player ) )
			}
			else
			{
				foreach( int fxHandle in file.playerClientFxHandles[ playerTeam ] )
				{
					if ( EffectDoesExist( fxHandle ) )
						EffectStop( fxHandle, false, true )
				}
				delete file.playerClientFxHandles[ playerTeam ]
			}
		}
		array<entity> children = player.GetChildren()
		foreach( childEnt in children )
		{
			if ( !IsValid( childEnt ) )
				continue

			if ( childEnt.GetScriptName() == STRING_SHADOW_SOUNDS )
			{
				childEnt.Destroy()
				continue
			}
		}
	}
	thread ShadowSquad_SetHUD( player )
}
#endif

#if CLIENT
void function ServerCallback_ModeShadowSquad_RestorePlayerHealthFx( bool useShieldEffect )
{
	entity player = GetLocalViewPlayer()

	if ( !IsValid( player ) )
		return

	if ( IsSpectating() )
		return

	entity cockpit = player.GetCockpit()
	if ( !IsValid( cockpit ) )
		return

	vector fxColor
	asset healFxAsset
	string healSound
	if ( useShieldEffect )
	{
		healFxAsset = FX_SHIELD_RESTORE
		int armorTier = EquipmentSlot_GetEquipmentTier( GetLocalViewPlayer(), "armor" )
		fxColor = GetFXRarityColorForTier( armorTier )
		healSound = "health_syringe_holster"
	}
	else
	{
		healFxAsset = FX_HEALTH_RESTORE
		fxColor = <192, 192, 192>
		healSound = "health_syringe_holster"
	}

	EmitSoundOnEntity( player, healSound )
	int fxHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( healFxAsset ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	EffectSetControlPointVector( fxHandle, 1, fxColor )
	thread DelayedDestroyFx( fxHandle, 1.0 )
}
#endif //

#if CLIENT
void function DelayedDestroyFx( int fxHandle, float delay )
{
	wait delay

	if ( EffectDoesExist( fxHandle ) )
		EffectStop( fxHandle, true, false )
}
#endif //

bool function IsPlayerShadowSquad( entity player )
{
	if ( !IsValid( player ) )
		return false

	if ( !player.IsPlayer() )
		return false
	
	if( Gamemode() != eGamemodes.fs_infected )
		return false

	return player.GetPlayerNetBool( "isPlayerShadowForm" )
}

bool function IsPlayerShadowSquadFinalLegend( entity player )
{
	if ( !IsValid( player ) )
		return false

	if ( !player.IsPlayer() )
		return false

	if ( !Flag( "FinalLegendsDecided" ) )
		return false

	if ( IsPlayerShadowSquad( player ) )
		return false

	return true
}

#if CLIENT
void function OnVictoryCharacterModelSpawned( entity characterModel, ItemFlavor character, int eHandle )
{
	if ( !IsValid( characterModel ) )
		return

	if ( !IsShadowVictory() )
		return

	ItemFlavor skin = GetDefaultItemFlavorForLoadoutSlot( eHandle, Loadout_CharacterSkin( character ) )
	CharacterSkin_Apply( characterModel, skin )

	if (  characterModel.GetSkinIndexByName( "ShadowSqaud" ) != -1 )
		characterModel.SetSkin( characterModel.GetSkinIndexByName( "ShadowSqaud" ) )
	else
		characterModel.kv.rendercolor = <0, 0, 0>

	int FX_BODY = StartParticleEffectOnEntity( characterModel, GetParticleSystemIndex( FX_SHADOW_TRAIL ), FX_PATTACH_POINT_FOLLOW, characterModel.LookupAttachment( "CHESTFOCUS" ) )
	int FX_EYE_L = StartParticleEffectOnEntity( characterModel, GetParticleSystemIndex( FX_SHADOW_FORM_EYEGLOW ), FX_PATTACH_POINT_FOLLOW, characterModel.LookupAttachment( "EYE_L" ) )
	int FX_EYE_R = StartParticleEffectOnEntity( characterModel, GetParticleSystemIndex( FX_SHADOW_FORM_EYEGLOW ), FX_PATTACH_POINT_FOLLOW, characterModel.LookupAttachment( "EYE_R" ) )
}
#endif //


#if CLIENT
void function ShadowSquad_OnPlayerCreated( entity player )
{
	SetCustomPlayerInfoColor( player, GetKeyColor( COLORID_MEMBER_COLOR0, 0 ) )
}

void function ShadowSquad_SetHUD( entity player )
{
}

void function OnPlayerLifeStateChanged( entity player, int oldState, int newState )
{
	if ( !IsValid( player ) )
		return

	if ( player != GetLocalClientPlayer() )
		return


	if ( newState != LIFE_ALIVE )
		return

	//
	//
	//
	UpdatePlayerHUD( player )

	if ( IsPlayerShadowSquad( player ) )
	{
		//
		//
		//
		SetCustomPlayerInfoCharacterIcon( player, $"rui/gamemodes/shadow_squad/generic_shadow_character" )
		SetCustomPlayerInfoTreatment( player, $"rui/gamemodes/shadow_squad/player_info_custom_treatment" )
		SetCustomPlayerInfoColor( player, <245, 81, 35 > )
	}
}
#endif //

#if CLIENT
void function UpdatePlayerHUD( entity player )
{
	if ( player.IsBot() )
		return

	if ( !IsValid( player ) )
		return

	if ( player != GetLocalClientPlayer() )
		return

	int gamePhase = GetCurrentGamePhase()


	if ( gamePhase == eShadowSquadGamePhase.FREE_FOR_ALL )
		return

	if ( !IsValid( file.countdownRui ) )
		file.countdownRui = CreateFullscreenRui( $"ui/generic_timer.rpak" )

	float countdownTimerStart = GetGlobalNetTime( "countdownTimerStart" )
	float countdownTimerEnd = GetGlobalNetTime( "countdownTimerEnd" )
	string countdownText

	switch ( gamePhase )
	{
		case eShadowSquadGamePhase.MATCH_ENDED_IN_DRAW:
			RuiSetBool( ClGameState_GetRui(), "hideCircleStatus", true ) //
			CircleAnnouncementsEnable( false )
			return
		case eShadowSquadGamePhase.FINAL_LEGENDS_DECIDED_EVAC_TIMER_STARTED:
		case eShadowSquadGamePhase.EVAC_SHIP_CLOSE_01:
		case eShadowSquadGamePhase.EVAC_SHIP_CLOSE_02:
			CircleAnnouncementsEnable( false )
			countdownText = "#SHADOW_SQUAD_TIMER_TXT_INBOUND"
			RuiSetBool( ClGameState_GetRui(), "hideCircleStatus", true ) //
			break
		case eShadowSquadGamePhase.EVAC_SHIP_DEPARTURE_TIMER_STARTED:
			countdownText = "#SHADOW_SQUAD_TIMER_TXT_DEPARTING"
			break
		case eShadowSquadGamePhase.WINNER_DETERMINED:
		case eShadowSquadGamePhase.EVAC_SHIP_DEPARTED:
			if ( file.countdownRui != null )
			{
				RuiDestroyIfAlive( file.countdownRui )
				file.countdownRui = null
			}
			if ( IsShadowVictory() )
				SetChampionScreenRuiAsset( $"ui/shadowfall_shadow_champion_screen.rpak" )
			else
				SetChampionScreenRuiAsset( $"ui/shadowfall_legend_champion_screen.rpak" )

			return
		default:
			return
	}

	if ( file.countdownRui == null )
		return

	RuiSetString( file.countdownRui, "messageText", countdownText )
	RuiSetGameTime( file.countdownRui, "startTime", countdownTimerStart )
	RuiSetGameTime( file.countdownRui, "endTime", countdownTimerEnd )
	RuiSetColorAlpha( file.countdownRui, "timerColor", SrgbToLinear( <255,233,0> / 255.0 ), 1.0 )
}

void function Infection_DestroyEvacCountdown()
{
	if ( file.countdownRui != null )
	{
		RuiDestroyIfAlive( file.countdownRui )
		file.countdownRui = null
	}

	if ( file.minimapEvacShipIcon != null )
	{
		RuiDestroyIfAlive( file.minimapEvacShipIcon )
		file.minimapEvacShipIcon = null
	}
	
	if ( file.fullmapEvacShipIcon != null )
	{
		Fullmap_RemoveRui( file.fullmapEvacShipIcon )
		RuiDestroy( file.fullmapEvacShipIcon )
		file.fullmapEvacShipIcon = null
	}
}

void function Infection_CreateEvacCountdown( int gamePhase)
{
	entity player = GetLocalClientPlayer()
	
	if ( !IsValid( player ) )
		return	
	
	if ( file.countdownRui != null )
	{
		RuiDestroyIfAlive( file.countdownRui )
		file.countdownRui = null
	}
	
	if ( !IsValid( file.countdownRui ) )
		file.countdownRui = CreateFullscreenRui( $"ui/generic_timer.rpak" )

	float countdownTimerStart = GetGlobalNetTime( "countdownTimerStart" )
	float countdownTimerEnd = GetGlobalNetTime( "countdownTimerEnd" )
	string countdownText

	switch ( gamePhase )
	{
		case 0:// case eShadowSquadGamePhase.MATCH_ENDED_IN_DRAW:
			CircleAnnouncementsEnable( false )
			return
		case 1:// case eShadowSquadGamePhase.FINAL_LEGENDS_DECIDED_EVAC_TIMER_STARTED:
			//CircleAnnouncementsEnable( false )
			countdownText = "#SHADOW_SQUAD_TIMER_TXT_INBOUND"
			break
		case 2:// case eShadowSquadGamePhase.EVAC_SHIP_DEPARTURE_TIMER_STARTED:
			countdownText = "#SHADOW_SQUAD_TIMER_TXT_DEPARTING"
			break
		case 3:// case eShadowSquadGamePhase.WINNER_DETERMINED:
			// if ( file.countdownRui != null )
			// {
				// RuiDestroyIfAlive( file.countdownRui )
				// file.countdownRui = null
			// }
			// if ( IsShadowVictory() )
				// SetChampionScreenRuiAsset( $"ui/shadowfall_shadow_champion_screen.rpak" )
			// else
				// SetChampionScreenRuiAsset( $"ui/shadowfall_legend_champion_screen.rpak" )

			return
		default:
			return
	}

	if ( file.countdownRui == null )
		return

	RuiSetString( file.countdownRui, "messageText", countdownText )
	RuiSetGameTime( file.countdownRui, "startTime", countdownTimerStart )
	RuiSetGameTime( file.countdownRui, "endTime", countdownTimerEnd )
	RuiSetColorAlpha( file.countdownRui, "timerColor", SrgbToLinear( <255,233,0> / 255.0 ), 1.0 )
}

#endif

bool function IsShadowVictory()
{
	return GetGlobalNetBool( "shadowsWonTheMode" )
}

bool function PlayerCanRespawnAsShadow( entity player )
{
	if ( !IsValid( player ) )
		return false

	return player.GetPlayerNetBool( "playerCanRespawnAsShadow" )
}

#if CLIENT
void function ServerCallback_ModeShadowSquad_AnnouncementSplash( int messageIndex, float duration)
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	string messageText
	string subText
	vector titleColor = <0, 0, 0>
	asset icon = $""
	asset leftIcon = ANNOUNCEMENT_LEGEND_ICON
	asset rightIcon = ANNOUNCEMENT_LEGEND_ICON
	string soundAlias = SFX_HUD_ANNOUNCE_QUICK

	switch( messageIndex )
	{
		case eShadowSquadMessage.BLANK:
			messageText = ""
			subText = ""
			break
		case eShadowSquadMessage.GAME_RULES_INTRO:
			messageText = "#SHADOW_SQUAD_RULES_TITLE"
			subText = "#SHADOW_SQUAD_RULES_SUB"
			break
		case eShadowSquadMessage.GAME_RULES_LAND:
			messageText = "#SHADOW_SQUAD_RULES_TITLE2"
			subText = "#SHADOW_SQUAD_RULES_SUB2"
			break
		
		case eShadowSquadMessage.ALPHA_ZOMBIE_START:
			array <string> dialogueChoices
			dialogueChoices.append( "THE FIRST INFECTED" )
			dialogueChoices.append( "HARBINGER OF THE APOCALYPSE" )
			dialogueChoices.append( "CHOSEN TO LEAD THE HORDE" )
			dialogueChoices.append( "INFECTED LEGION RISES" )
			dialogueChoices.randomize()
			
			messageText = dialogueChoices.getrandom()
			subText = "Use your unique powers to lead the infected team to the victory"
			leftIcon = ANNOUNCEMENT_SHADOW_ICON
			rightIcon = ANNOUNCEMENT_SHADOW_ICON	
		break

		case eShadowSquadMessage.LAST_MAN_STANDING:
			array <string> dialogueChoices
			dialogueChoices.append( "FINAL SHOWDOWN" )
			dialogueChoices.append( "ALONE IN THE APOCALYPSE" )
			dialogueChoices.append( "AGAINST ALL ODDS" )
			dialogueChoices.append( "OUTLASTING THE INFECTED" )
			dialogueChoices.randomize()
			
			messageText = dialogueChoices.getrandom()
			subText = "You're the Last Survivor Standing, don't die!"
		break
		
		case eShadowSquadMessage.RESPAWNING_AS_SHADOW:
			
			if( Gamemode() == eGamemodes.fs_infected )
			{
				if(GetPlayerArrayOfTeam_Alive(TEAM_IMC).len() == 1)
					subText = "Infect the last Survivor"
				else if(GetPlayerArrayOfTeam_Alive(TEAM_IMC).len() > 1)
					subText = "Infect the Survivors"
				
				messageText = "RESPAWNED ON THE INFECTED SQUAD"
			}
			else
			{
				subText = "#SHADOW_SQUAD_RESPAWNING_SUB"
				messageText = "#SHADOW_SQUAD_RESPAWNING"
			}
			leftIcon = ANNOUNCEMENT_SHADOW_ICON
			rightIcon = ANNOUNCEMENT_SHADOW_ICON
			break
		case eShadowSquadMessage.HAPPY_HUNTING:
			messageText = "#SHADOW_SQUAD_KILL_LEGENDS_TITLE"
			subText = "#SHADOW_SQUAD_KILL_LEGENDS_SUB"
			leftIcon = ANNOUNCEMENT_SHADOW_ICON
			rightIcon = ANNOUNCEMENT_SHADOW_ICON
			break
		case eShadowSquadMessage.FINAL_LEGENDS_DECIDED_LEGEND_MSG:
			messageText = "#SHADOW_SQUAD_YOU_SURVIVED_TOP_10_TITLE"
			subText = "#SHADOW_SQUAD_YOU_SURVIVED_TOP_10_SUB"
			break
		case eShadowSquadMessage.FINAL_LEGENDS_DECIDED_SHADOW_MSG:
			messageText = "#SHADOW_SQUAD_TOP_10_DETERMINED_TITLE"
			subText = "#SHADOW_SQUAD_TOP_10_DETERMINED_SUB"
			leftIcon = ANNOUNCEMENT_SHADOW_ICON
			rightIcon = ANNOUNCEMENT_SHADOW_ICON
			break
		case eShadowSquadMessage.INFECTION_HAS_STARTED:
			messageText = "AN INFECTION IS EMERGING"
			subText = "Remain as survivor to win"
			
			if( Gamemode() == eGamemodes.fs_infected )
				subText = "              Choosing Alpha Infected.\nSurvive and take the EVAC ship to win."

			leftIcon = ANNOUNCEMENT_SHADOW_ICON
			rightIcon = ANNOUNCEMENT_SHADOW_ICON
			break
		case eShadowSquadMessage.LEGENDS_WIN_INFECTION:
			array <string> dialogueChoices
			dialogueChoices.append( "diag_ap_nocNotify_legendWin_01_3p" )
			dialogueChoices.append( "diag_ap_nocNotify_legendWin_02_3p" )
			dialogueChoices.append( "diag_ap_nocNotify_legendWin_03_3p" )
			dialogueChoices.randomize()
			messageText = "YOU SURVIVED THIS TIME"
			subText = ""
			
			soundAlias = dialogueChoices.getrandom()
			break
		case eShadowSquadMessage.LEGENDS_WIN_INFECTION2:
			array <string> dialogueChoices
			dialogueChoices.append( "diag_ap_nocNotify_playerDeathFinal_01_01_3p" )
			dialogueChoices.append( "diag_ap_nocNotify_playerDeathFinal_01_02_3p" )
			dialogueChoices.append( "diag_ap_nocNotify_playerDeathFinal_01_03_3p" )
			dialogueChoices.randomize()
			messageText = "Legends win"
			if(GetPlayerArrayOfTeam_Alive(TEAM_IMC).len() == 1)
				subText = "You failed to infect the last Survivor"
			else if(GetPlayerArrayOfTeam_Alive(TEAM_IMC).len() > 1)
				subText = "You failed to infect the Survivors"
			
			soundAlias = dialogueChoices.getrandom()
			break			
		case eShadowSquadMessage.EVAC_ARRIVED_LEGEND:
			messageText = "#SHADOW_SQUAD_EVAC_HERE_TITLE"
			subText = "#SHADOW_SQUAD_EVAC_HERE_SUB_LEGENDS"
			break
		case eShadowSquadMessage.EVAC_ARRIVED_SHADOW:
			messageText = "#SHADOW_SQUAD_EVAC_HERE_TITLE"
			subText = "#SHADOW_SQUAD_EVAC_HERE_SUB_SHADOWS"
			leftIcon = ANNOUNCEMENT_SHADOW_ICON
			rightIcon = ANNOUNCEMENT_SHADOW_ICON
			break
		case eShadowSquadMessage.EVAC_REMINDER_LEGEND:
			messageText = "#SHADOW_SQUAD_EVAC_REMINDER_LEGEND"
			subText = "#SHADOW_SQUAD_EVAC_REMINDER_LEGEND_SUB"
			break
		case eShadowSquadMessage.EVAC_REMINDER_SHADOW:
			messageText = "#SHADOW_SQUAD_EVAC_REMINDER_SHADOW"
			subText = "#SHADOW_SQUAD_EVAC_REMINDER_SHADOW_SUB"
			leftIcon = ANNOUNCEMENT_SHADOW_ICON
			rightIcon = ANNOUNCEMENT_SHADOW_ICON
			break
		case eShadowSquadMessage.END_LEGENDS_ESCAPED:
			messageText = "#SHADOW_SQUAD_END_LEGENDS_ESCAPED"
			subText = "#SHADOW_SQUAD_END_LEGENDS_ESCAPED_SUB"
			soundAlias = "UI_InGame_ShadowSquad_FinalSquadMessage"
			break
		case eShadowSquadMessage.END_LEGENDS_KILLED:
			array <string> dialogueChoices
			dialogueChoices.append( "diag_ap_nocNotify_shadowSquadWin_01_3p" )
			dialogueChoices.append( "diag_ap_nocNotify_shadowSquadWin_02_3p" )
			dialogueChoices.append( "diag_ap_nocNotify_shadowSquadWin_03_3p" )
			dialogueChoices.randomize()
			messageText = "#SHADOW_SQUAD_END_SHADOWS_WIN"
			subText = "#SHADOW_SQUAD_END_SHADOWS_WIN_SUB_ELIM"
			soundAlias = ""
			if( Gamemode() == eGamemodes.fs_infected )
			{
				messageText = "INFECTED WIN"			
			}
			leftIcon = ANNOUNCEMENT_SHADOW_ICON
			rightIcon = ANNOUNCEMENT_SHADOW_ICON
			soundAlias = dialogueChoices.getrandom()
			break
		case eShadowSquadMessage.END_LEGENDS_FAILED_TO_ESCAPE:
			messageText = "#SHADOW_SQUAD_END_SHADOWS_WIN"
			subText = "#SHADOW_SQUAD_END_SUB_FAILED_TO_ESCAPE"
			soundAlias = "UI_InGame_ShadowSquad_FinalSquadMessage"
			leftIcon = ANNOUNCEMENT_SHADOW_ICON
			rightIcon = ANNOUNCEMENT_SHADOW_ICON
			break
		case eShadowSquadMessage.SAFE_ON_EVAC_SHIP:
			messageText = "#SHADOW_SQUAD_SAFE_ON_EVAC_SHIP"
			subText = "#SHADOW_SQUAD_SAFE_ON_EVAC_SHIP_SUB"
			soundAlias = "UI_InGame_ShadowSquad_FinalSquadMessage"
			break
		case eShadowSquadMessage.REVENGE_KILL_KILLER:
			messageText = "#SHADOW_SQUAD_REVENGE_KILL_KILLER"
			subText = "#SHADOW_SQUAD_REVENGE_KILL_KILLER_SUB"
			soundAlias = "UI_InGame_ShadowSquad_RevengeKill"
			titleColor = <128, 30, 0>
			leftIcon = ANNOUNCEMENT_SHADOW_ICON
			rightIcon = ANNOUNCEMENT_SHADOW_ICON
			break
		case eShadowSquadMessage.REVENGE_KILL_VICTIM:
			messageText = "#SHADOW_SQUAD_REVENGE_KILL_VICTIM"
			subText = "#SHADOW_SQUAD_REVENGE_KILL_VICTIM_SUB"
			titleColor = <128, 30, 0>
			leftIcon = ANNOUNCEMENT_SHADOW_ICON
			rightIcon = ANNOUNCEMENT_SHADOW_ICON
			break
		case eShadowSquadMessage.EVAC_ON_APPROACH_LEGEND:
			messageText = "#SHADOW_SQUAD_EVAC_ON_APPROACH_LEGEND"
			subText = "#SHADOW_SQUAD_EVAC_ON_APPROACH_LEGEND_SUB"
			soundAlias = "UI_InGame_ShadowSquad_ShipIncoming"
			break
		case eShadowSquadMessage.EVAC_ON_APPROACH_SHADOW:
			messageText = "#SHADOW_SQUAD_EVAC_ON_APPROACH_LEGEND"
			subText = "#SHADOW_SQUAD_EVAC_ON_APPROACH_SHADOW_SUB"
			soundAlias = "UI_InGame_ShadowSquad_ShipIncoming"
			leftIcon = ANNOUNCEMENT_SHADOW_ICON
			rightIcon = ANNOUNCEMENT_SHADOW_ICON
			break
		case eShadowSquadMessage.YOU_LOSE_FAILED_TO_EVAC:
			messageText = "#SHADOW_SQUAD_YOU_LOSE"
			subText = "#SHADOW_SQUAD_LOSS_FAILED_EVAC"
			break
		case eShadowSquadMessage.YOU_LOSE_ALL_LEGENDS_KILLED:
			messageText = "#SHADOW_SQUAD_YOU_LOSE"
			subText = "#SHADOW_SQUAD_LOSS_ALL_KILLED"
			break
		case eShadowSquadMessage.YOU_LOSE_NO_ONE_EVACED:
			messageText = "#SHADOW_SQUAD_YOU_LOSE"
			subText = "#SHADOW_SQUAD_LOSS_NO_ONE_EVACED"
			break
		case eShadowSquadMessage.END_TIMER_EXPIRED:
			messageText = "#SHADOW_SQUAD_TIMEOUT"
			subText = "#SHADOW_SQUAD_TIMEOUT_SUB"
			break

		default:
			Assert( 0, "Unhandled messageIndex: " + messageIndex )
	}

	AnnouncementMessageSweepShadowSquad( player, messageText, subText, titleColor, soundAlias, duration, icon, leftIcon, rightIcon )
}

void function Infection_CreateEvacShipMinimapIcons(entity cpoint)
{
	//Minimap Icon
	var rui = Infection_AddMinimapIcon( $"rui/gamemodes/shadow_squad/evac_countdown", 80, <0.5, 0.5, 0>)
	RuiTrackFloat3( rui, "objectPos", cpoint, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiSetImage( rui, "clampedIconImage", $"rui/gamemodes/shadow_squad/evac_countdown" )
	RuiSetFloat3( rui, "objColor", SrgbToLinear( Vector( 235, 213, 52 ) / 255.0 ) )
	file.minimapEvacShipIcon = rui
	
	//Fullmap Icon
	var ruiFullmap = Infection_AddFullmapIcon( $"rui/gamemodes/shadow_squad/evac_countdown", 30, <0.5, 0.5, 0>)
	RuiTrackFloat3( ruiFullmap, "objectPos", cpoint, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiSetFloat3( ruiFullmap, "objColor", SrgbToLinear( Vector( 235, 213, 52 ) / 255.0 ) )
	Fullmap_AddRui( ruiFullmap )
	file.fullmapEvacShipIcon = ruiFullmap
}
#endif


#if CLIENT
void function AnnouncementMessageSweepShadowSquad( entity player, string messageText, string subText, vector titleColor, string soundAlias, float duration, asset icon = $"", asset leftIcon = $"", asset rightIcon = $"" )
{
	AnnouncementData announcement = Announcement_Create( messageText )
	announcement.drawOverScreenFade = true
	Announcement_SetSubText( announcement, subText )
	Announcement_SetHideOnDeath( announcement, true )
	Announcement_SetDuration( announcement, duration )
	Announcement_SetPurge( announcement, true )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_SWEEP )
	Announcement_SetSoundAlias( announcement, soundAlias )
	Announcement_SetTitleColor( announcement, titleColor )
	Announcement_SetIcon( announcement, icon )
	Announcement_SetLeftIcon( announcement, leftIcon )
	Announcement_SetRightIcon( announcement, rightIcon )
	AnnouncementFromClass( player, announcement )
}
#endif //
