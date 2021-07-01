#if(true)//

global function ShGameModeShadowSquad_Init
global function IsShadowVictory
global function IsPlayerShadowSquad
global function Gamemode_ShadowSquad_RegisterNetworking
global function PlayerCanRespawnAsShadow

//

#if(false)




























#endif //

#if(CLIENT)
	global function ServerCallback_ModeShadowSquad_AnnouncementSplash
	global function ServerCallback_ModeShadowSquad_RestorePlayerHealthFx
	global function ServerCallback_ShadowClientEffectsEnable
	global function ServerCallback_PlaySpectatorAudio

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
	END_TIMER_EXPIRED
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
#if(false)






#endif //

#if(CLIENT)
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


#if(false)








#endif //


struct
{

	#if(false)



//








//




#endif //

	#if(CLIENT)
		var countdownRui
		table< int, array< int > > playerClientFxHandles
		//


	#endif //

} file

//
void function ShGameModeShadowSquad_Init()
{
	#if(false)
//
//


#endif //


	if ( !IsFallLTM() )
		return

	AddCallback_EntitiesDidLoad( EntitiesDidLoad )

	//
	//

	#if(CLIENT)
		SetCommsDialogueEnabled( false ) //
		AddCallback_OnPlayerLifeStateChanged( OnPlayerLifeStateChanged )
		AddCallback_OnVictoryCharacterModelSpawned( OnVictoryCharacterModelSpawned )
		thread ShadowVictorySequenceSetup()
		//
		//
		//
		AddCreateCallback( "player", ShadowSquad_OnPlayerCreated )

		Obituary_SetIndexOffset( 2 ) //

	#endif //

	#if(false)



























//
//











//











//
//














//







//



#endif //
}
//


#if(false)








#endif //

#if(false)








#endif //



#if(false)






















#endif //



#if(CLIENT)
void function ShadowVictorySequenceSetup()
{
	wait 1

	SetVictorySequenceLocation( <10472, 30000, 8500>, <0, 60, 0> )
	SetVictorySequenceSunSkyIntensity( 0.8, 0.0 )



}
#endif //

#if(false)




#endif //

#if(false)


//

#endif //


//
void function EntitiesDidLoad()
{
	if ( !IsFallLTM() )
		return

	if ( IsMenuLevel() )
		return

	#if(false)


//

//
//
//

















#endif //

	SurvivalCommentary_SetHost( eSurvivalHostType.NOC )

}
//


#if(false)




#endif //


#if(false)





//
//
//

//





//








//

//
//
//




//
//
//
















//
//
//











#endif //

#if(false)




//


//

















#endif //


//
void function Gamemode_ShadowSquad_RegisterNetworking()
{
	if ( !IsFallLTM() )
	{
		//
		Remote_RegisterClientFunction( "ServerCallback_ShadowClientEffectsEnable", "entity", "bool" )
		return
	}

	RegisterNetworkedVariable( "livingShadowPlayerCount", SNDC_GLOBAL, SNVT_INT )
	Remote_RegisterClientFunction( "ServerCallback_ModeShadowSquad_AnnouncementSplash", "int", 0, 999, "float", 0.0, 5000.0, 16 )
	Remote_RegisterClientFunction( "ServerCallback_ShadowClientEffectsEnable", "entity", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_PlaySpectatorAudio", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_ModeShadowSquad_RestorePlayerHealthFx", "bool" )
	RegisterNetworkedVariable( "playerCanRespawnAsShadow", SNDC_PLAYER_GLOBAL, SNVT_BOOL, false )
	//
	RegisterNetworkedVariable( "shadowSquadGamePhase", SNDC_GLOBAL, SNVT_UNSIGNED_INT, 0, 0, eShadowSquadGamePhase._count )
	RegisterNetworkedVariable( "countdownTimerStart", SNDC_GLOBAL, SNVT_TIME, -1 )
	RegisterNetworkedVariable( "countdownTimerEnd", SNDC_GLOBAL, SNVT_TIME, -1 )
	RegisterNetworkedVariable( "shadowsWonTheMode", SNDC_GLOBAL, SNVT_BOOL, false )



	#if(CLIENT)
		RegisterNetworkedVariableChangeCallback_int( "shadowSquadGamePhase", OnGamePhaseChanged )
	#endif //
}
//

#if(CLIENT)
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

/*















*/

#if(false)






//


//




//












#endif //


/*





























































































*/

#if(false)








//







//







//



//


//





//





//




//




















#endif //

#if(false)




//
//
//
//
//
//
//















//
//
//












//






//


















//
//
//

//








//







#endif //

#if(false)











#endif //

/*















*/

#if(false)


//
//
//



#endif //


#if(false)


















//
//
//



//















//

//
//
//






//








//


//









//
//
//





//




//







//

//








#endif //



#if(false)















#endif //


#if(CLIENT)
void function ServerCallback_PlaySpectatorAudio( bool playRespawnMusic )
{
	//
	//
	//
	entity clientPlayer = GetLocalClientPlayer()
	if ( !IsValid( clientPlayer ) )
		return


	//
	//
	//
	if ( playRespawnMusic )
	{
		//
		EmitSoundOnEntity( clientPlayer, "Music_LTM_31_RespawnAndDrop" )
		thread SkydiveRespawnCleanup( clientPlayer )
	}
	else
	{
		ServerCallback_PlayMatchEndMusic()
	}

	//
	//
	//
	if ( !playRespawnMusic && GetGameState() == eGameState.Playing )
	{
		//
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
#endif //

//
void function EmitSoundOnEntityDelayed( entity player, string alias, float delay )
{
	wait delay

	if ( !IsValid( player ) )
		return

	if ( GetGameState() != eGameState.Playing )
		return


	EmitSoundOnEntity( player, alias )
}
//

#if(CLIENT)
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


#if(false)





















//




//














//



//






//





#endif //

#if(false)



















//




//







//



//









//





#endif //



#if(false)





//


#endif //

#if(false)





//


#endif //



/*















*/
#if(false)





//
//
//










//
//
//











//
//
//

//



//
//
//


























//
//
//



//


//



#endif //

#if(false)




























#endif //

#if(false)












//












#endif //



#if(false)


//


//











//
//
//



//
//
//







//




#endif //


#if(false)







#endif //

#if(false)




//


//

#endif //

#if(false)







//







//






//




/*






*/



//





#endif //

#if(false)















#endif //


#if(false)















#endif //


#if(CLIENT)
void function ShadowSquadThreatVision( entity player )
{
	/*

















*/
}
#endif //



#if(CLIENT)
void function ServerCallback_ShadowClientEffectsEnable( entity player, bool enableFx )
{
	thread ShadowClientEffectsEnable( player, enableFx )
}
#endif //


#if(CLIENT)
void function ShadowClientEffectsEnable( entity player, bool enableFx, bool isVictorySequence = false )
{
	AssertIsNewThread()
	wait 0.25

	if ( !IsValid( player ) )
		return

	bool isLocalPlayer = ( player == GetLocalViewPlayer() )
	vector playerOrigin = player.GetOrigin()
	int playerTeam = player.GetTeam()

	//
	//
	//
	if ( enableFx )
	{
		//
		//
		//
		if ( isLocalPlayer )
		{
			HealthHUD_StopUpdate( player )

			//
			//
			//
			EmitSoundOnEntity( player, "ShadowLegend_Shadow_Loop_1P" )

			entity cockpit = player.GetCockpit()
			if ( !IsValid( cockpit ) )
				return

			int fxHandle = StartParticleEffectOnEntity( cockpit, GetParticleSystemIndex( SHADOW_SCREEN_FX ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
			EffectSetIsWithCockpit( fxHandle, true )
			vector controlPoint = <1,1,1>
			EffectSetControlPointVector( fxHandle, 1, controlPoint )

			//
			if ( !( playerTeam in file.playerClientFxHandles) )
				file.playerClientFxHandles[ playerTeam ] <- []
			file.playerClientFxHandles[playerTeam].append( fxHandle )

			//
			//
			//
			//

		}

		//
		//
		//
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


		//
		//
		//




		//
		/*











*/

	}

	//
	//
	//
	else
	{
		//
		//
		//
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

		//
		//
		//


		//
		//
		//
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
}
#endif //



#if(false)








//
//
//











//
//

//
//
//




//
//
//




//
//
//
//
//
//
//
//

//
//
//


//
//
//







#endif //

#if(false)













//









#endif //

#if(false)






#endif //



#if(false)








//
//
//











//
//
//




//
//
//




//





//
//
//




//
//
//

//






#endif //



#if(false)





































//
//
//




















//
//
//


//







//











//





//
//
//





















//
//
//
















//
//
//



#endif //

#if(false)











#endif //



#if(CLIENT)
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


#if(CLIENT)
void function DelayedDestroyFx( int fxHandle, float delay )
{
	wait delay

	if ( EffectDoesExist( fxHandle ) )
		EffectStop( fxHandle, true, false )
}

#endif //




#if(false)


//
//
//


















#endif //


//
bool function IsPlayerShadowSquad( entity player )
{
	if ( !IsValid( player ) )
		return false

	if ( !player.IsPlayer() )
		return false

	return player.GetPlayerNetBool( "isPlayerShadowForm" )
}
//

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


#if(false)












//
//
//


//













//
//
//










#endif //



/*















*/



#if(false)

















#endif //




#if(false)





























#endif //



#if(CLIENT)
void function OnVictoryCharacterModelSpawned( entity characterModel, ItemFlavor character, int eHandle )
{
	if ( !IsValid( characterModel ) )
		return

	if ( !IsShadowVictory() )
		return

	//
	//
	//
	ItemFlavor skin = GetDefaultItemFlavorForLoadoutSlot( eHandle, Loadout_CharacterSkin( character ) )
	CharacterSkin_Apply( characterModel, skin )

	//
	//
	//
	if (  characterModel.GetSkinIndexByName( "ShadowSqaud" ) != -1 )
		characterModel.SetSkin( characterModel.GetSkinIndexByName( "ShadowSqaud" ) )
	else
		characterModel.kv.rendercolor = <0, 0, 0>

	//
	//
	//
	int FX_BODY = StartParticleEffectOnEntity( characterModel, GetParticleSystemIndex( FX_SHADOW_TRAIL ), FX_PATTACH_POINT_FOLLOW, characterModel.LookupAttachment( "CHESTFOCUS" ) )
	int FX_EYE_L = StartParticleEffectOnEntity( characterModel, GetParticleSystemIndex( FX_SHADOW_FORM_EYEGLOW ), FX_PATTACH_POINT_FOLLOW, characterModel.LookupAttachment( "EYE_L" ) )
	int FX_EYE_R = StartParticleEffectOnEntity( characterModel, GetParticleSystemIndex( FX_SHADOW_FORM_EYEGLOW ), FX_PATTACH_POINT_FOLLOW, characterModel.LookupAttachment( "EYE_R" ) )

}
#endif //


#if(CLIENT)
void function ShadowSquad_OnPlayerCreated( entity player )
{
	//
	SetCustomPlayerInfoColor( player, GetKeyColor( COLORID_MEMBER_COLOR0, 0 ) )
}
#endif //


#if(CLIENT)
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

	/*















*/

}
#endif //



#if(false)















#endif //


#if(false)














//
//











//






#endif //



#if(false)





//
//
//



//
//
//











//
//
//



//
//
//



#endif //


#if(false)












//



//
//
//






























#endif //

#if(false)












































































#endif //


#if(false)

















#endif //



/*





















*/


/*








*/

/*








*/

/*















*/

#if(false)




#endif //

#if(false)


































#endif //

#if(false)


//
//
//


//


//
//
//
//















//
//
//
/*





*/



#endif //



#if(false)




//




#endif //


#if(false)


//



























#endif //

/*















*/

#if(false)




//
//
//




//



//
//
//
//
//
//
//
//
//
//
//
//
//









//
//
//





//
//
//







//
//
//









//
//
//













//
//
//











//
//
//




//
//


//
//
//




#endif //


/*
























*/

/*



























*/


#if(false)






//










//



//



//



//


//



//



//



//



//



//





#endif


#if(false)




#endif


#if(false)







//





//





#endif //

#if(false)





//
//
//








//
































//
//
//




#endif //


#if(false)

























#endif //



#if(false)




//
//
//


//










//


//


//
//
//


//











//
//
//








//
//






//
//
//






















//
//
//






//
//
//






//
//
//

















//
//
//









//
//
//










//
//
//







//
//
//



//



//
//
//
















//



//
//
//










//
//
//
//








//


































//














#endif //




#if(false)










































//
//












#endif //

#if(false)






//













//



#endif //

#if(false)






//
//
//



















//




//











//
//
//











































































//





//









#endif //


/*











*/

#if(CLIENT)
void function UpdatePlayerHUD( entity player )
{
	//
	//
	//
	if ( player.IsBot() )
		return

	if ( !IsValid( player ) )
		return

	if ( player != GetLocalClientPlayer() )
		return

	int gamePhase = GetCurrentGamePhase()


	if ( gamePhase == eShadowSquadGamePhase.FREE_FOR_ALL )
		return

	//
	//
	//
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

			//
			if ( IsShadowVictory() )
				SetChampionScreenRuiAsset( $"ui/shadowfall_shadow_champion_screen.rpak" )
			else
				SetChampionScreenRuiAsset( $"ui/shadowfall_legend_champion_screen.rpak" )

			return
		default:
			return
	}

	//
	//
	//
	if ( file.countdownRui == null )
		return

	RuiSetString( file.countdownRui, "messageText", countdownText )
	RuiSetGameTime( file.countdownRui, "startTime", countdownTimerStart )
	RuiSetGameTime( file.countdownRui, "endTime", countdownTimerEnd )
	RuiSetColorAlpha( file.countdownRui, "timerColor", SrgbToLinear( <255,233,0> / 255.0 ), 1.0 )

}
#endif //



/*















*/

#if(false)











#endif //

#if(false)











#endif //

#if(false)











#endif //


#if(false)







































//








#endif


#if(false)































#endif //

#if(false)



//
























#endif //

#if(false)















#endif //

#if(false)















#endif //

#if(false)








#endif //

#if(false)







#endif //


#if(false)










#endif //


#if(false)




//
//
//






//
//
//






//
//
//






































//
//
//


//






//

//

//
//

//



//



//




//






//

//


//




//



//








//

















//




//













//
//
//
//
//
//







//






//
//
//



//
//
//






//
//
//


//





//








//








//
//
//


//





//








//







//
//
//







//







//







//











#endif //


#if(false)




#endif //

#if(false)




#endif //



#if(false)


//







//












//
//
//


#endif //

#if(false)





#endif //


/*










*/


#if(false)



























#endif //


#if(false)















#endif //


#if(false)










//




//
//









//
//












//



#endif //


/*








*/



#if(false)























//





/*
















*/

/*












*/





//


#endif //


/*






















*/



#if(false)











#endif //

#if(false)















#endif //



#if(false)





















#endif

#if(false)
























#endif



#if(false)









#endif


#if(false)




















#endif



//
bool function IsShadowVictory()
{
	return GetGlobalNetBool( "shadowsWonTheMode" )
}
//




//
bool function PlayerCanRespawnAsShadow( entity player )
{
	if ( !IsValid( player ) )
		return false

	return player.GetPlayerNetBool( "playerCanRespawnAsShadow" )
}
//

#if(false)

















































#endif //


#if(false)








































#endif //


#if(false)








#endif //


#if(false)








#endif //

#if(false)






#endif //


#if(CLIENT)
void function ServerCallback_ModeShadowSquad_AnnouncementSplash( int messageIndex, float duration )
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
		case eShadowSquadMessage.RESPAWNING_AS_SHADOW:
			messageText = "#SHADOW_SQUAD_RESPAWNING"
			subText = "#SHADOW_SQUAD_RESPAWNING_SUB"
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
			break
		case eShadowSquadMessage.END_LEGENDS_ESCAPED:
			messageText = "#SHADOW_SQUAD_END_LEGENDS_ESCAPED"
			subText = "#SHADOW_SQUAD_END_LEGENDS_ESCAPED_SUB"
			soundAlias = "UI_InGame_ShadowSquad_FinalSquadMessage"
			break
		case eShadowSquadMessage.END_LEGENDS_KILLED:
			messageText = "#SHADOW_SQUAD_END_SHADOWS_WIN"
			subText = "#SHADOW_SQUAD_END_SHADOWS_WIN_SUB_ELIM"
			soundAlias = "UI_InGame_ShadowSquad_FinalSquadMessage"
			leftIcon = ANNOUNCEMENT_SHADOW_ICON
			rightIcon = ANNOUNCEMENT_SHADOW_ICON
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
#endif //


#if(CLIENT)
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



#endif //
