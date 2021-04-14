global function InitSoundPanel
global function RestoreSoundDefaults
global function SoundPanel_GetConVarData

struct
{
	table<var, string> buttonTitles
	table<var, string> buttonDescriptions
	var                detailsPanel
	var                itemDescriptionBox

	#if PC_PROG
	var 			   voiceSensitivityButton
	var 			   voiceSensitivitySliderRui
	#endif

	array<ConVarData>    conVarDataList
} file


void function InitSoundPanel( var panel )
{
	RegisterSignal( "UpdateVoiceMeter" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnSoundPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnSoundPanel_Hide )

	var contentPanel = Hud_GetChild( panel, "ContentPanel" )

	SetupSettingsButton( Hud_GetChild( Hud_GetChild( contentPanel, "SldMasterVolume" ), "BtnDropButton" ), "#MASTER_VOLUME", "#OPTIONS_MENU_MASTER_VOLUME_DESC", $"rui/menu/settings/settings_audio" )
	SetupSettingsButton( Hud_GetChild( Hud_GetChild( contentPanel, "SldDialogueVolume" ), "BtnDropButton" ), "#MENU_DIALOGUE_VOLUME_CLASSIC", "#OPTIONS_MENU_DIALOGUE_VOLUME_DESC", $"rui/menu/settings/settings_audio" )
	SetupSettingsButton( Hud_GetChild( Hud_GetChild( contentPanel, "SldSFXVolume" ), "BtnDropButton" ), "#MENU_SFX_VOLUME_CLASSIC", "#OPTIONS_MENU_SFX_VOLUME_DESC", $"rui/menu/settings/settings_audio" )
	SetupSettingsButton( Hud_GetChild( Hud_GetChild( contentPanel, "SldMusicVolume" ), "BtnDropButton" ), "#MENU_MUSIC_VOLUME_CLASSIC", "#OPTIONS_MENU_MUSIC_VOLUME_DESC", $"rui/menu/settings/settings_audio" )
	SetupSettingsButton( Hud_GetChild( Hud_GetChild( contentPanel, "SldLobbyMusicVolume" ), "BtnDropButton" ), "#MENU_LOBBY_MUSIC_VOLUME", "#OPTIONS_MENU_LOBBY_MUSIC_VOLUME_DESC", $"rui/menu/settings/settings_audio" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchSubtitles" ), "#SUBTITLES", "#OPTIONS_MENU_SUBTITLES_DESC", $"rui/menu/settings/settings_audio" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchChatSpeechToText" ), "#MENU_CHAT_SPEECH_TO_TEXT", "#OPTIONS_MENU_CHAT_SPEECH_TO_TEXT_DESC", $"rui/menu/settings/settings_audio" )
	Hud_SetVisible( Hud_GetChild( contentPanel, "SwchChatSpeechToText" ), IsAccessibilityAvailable() )
	#if PC_PROG
		SetupSettingsButton( Hud_GetChild( contentPanel, "SwchChatTextToSpeech" ), "#MENU_CHAT_TEXT_TO_SPEECH", "#OPTIONS_MENU_CHAT_TEXT_TO_SPEECH_DESC", $"rui/menu/settings/settings_audio" )
		Hud_SetVisible( Hud_GetChild( contentPanel, "SwchChatTextToSpeech" ), IsAccessibilityAvailable() )

		file.voiceSensitivityButton = Hud_GetChild( contentPanel, "SldOpenMicSensitivity" )
		file.voiceSensitivitySliderRui = Hud_GetRui( Hud_GetChild( file.voiceSensitivityButton, "PrgValue" ) )

		HudElem_SetRuiArg( Hud_GetChild( file.voiceSensitivityButton, "PnlDefaultMark" ), "heightScale", 0.7 )

		SetupSettingsButton( Hud_GetChild( Hud_GetChild( contentPanel, "SldOpenMicSensitivity" ), "BtnDropButton" ), "#OPEN_MIC_SENS", "#OPEN_MIC_SENS_DESC", $"rui/menu/settings/settings_audio" )
		SetupSettingsButton( Hud_GetChild( contentPanel, "SwchPushToTalk" ), "#OPTIONS_MENU_VOICE_CHAT_MIC", "#OPTIONS_MENU_VOICE_CHAT_MIC_DESC", $"rui/menu/settings/settings_audio" )
		SetupSettingsButton( Hud_GetChild( Hud_GetChild( contentPanel, "SldVoiceChatVolume" ), "BtnDropButton" ), "#VOICE_CHAT_VOLUME", "#OPTIONS_MENU_VOICE_CHAT_DESC", $"rui/menu/settings/settings_audio" )
		SetupSettingsButton( Hud_GetChild( contentPanel, "SwchSoundWithoutFocus" ), "#SOUND_WITHOUT_FOCUS", "#OPTIONS_MENU_SOUND_WITHOUT_FOCUS", $"rui/menu/settings/settings_audio" )
		SetupSettingsButton( Hud_GetChild( contentPanel, "SwchSpeakerConfig" ), "#WINDOWS_AUDIO_CONFIGURATION", "", $"rui/menu/settings/settings_audio" )
	#endif

	//AddEventHandlerToButtonClass( menu, "LeftRuiFooterButtonClass", UIE_GET_FOCUS, FooterButton_Focused )

	ScrollPanel_InitPanel( panel )
	ScrollPanel_InitScrollBar( panel, Hud_GetChild( panel, "ScrollBar" ) )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_BACK, true, "#BACKBUTTON_RESTORE_DEFAULTS", "#RESTORE_DEFAULTS", OpenConfirmRestoreSoundDefaultsDialog )
	AddPanelFooterOption( panel, LEFT, -1, false, "#FOOTER_CHOICE_HINT", "" )
	//#if DURANGO_PROG
	//AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "#Y_BUTTON_XBOX_HELP", "", OpenXboxHelp )
	//#endif // DURANGO_PROG

	file.conVarDataList.append( CreateSettingsConVarData( "TalkIsStream", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "miles_occlusion", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "closecaption", eConVarType.INT ) )
	file.conVarDataList.append( CreateSettingsConVarData( "speechtotext_enabled", eConVarType.INT ) )
	#if PC_PROG
		file.conVarDataList.append( CreateSettingsConVarData( "hudchat_play_text_to_speech", eConVarType.INT ) )
	#endif
}


void function OnSoundPanel_Show( var panel )
{
	ScrollPanel_SetActive( panel, true )

	#if PC_PROG
	thread UpdateVoiceMeter()
	#endif
}


void function OnSoundPanel_Hide( var panel )
{
	ScrollPanel_SetActive( panel, false )

	SaveSettingsConVars( file.conVarDataList )
	Signal( uiGlobal.signalDummy, "UpdateVoiceMeter" )

	SavePlayerSettings()
}


array<ConVarData> function SoundPanel_GetConVarData()
{
	return file.conVarDataList
}


void function FooterButton_Focused( var button )
{
}


#if PC_PROG
void function UpdateVoiceMeter()
{
	Signal( uiGlobal.signalDummy, "UpdateVoiceMeter" )
	EndSignal( uiGlobal.signalDummy, "UpdateVoiceMeter" )

	while ( true )
	{
		RuiSetFloat( file.voiceSensitivitySliderRui, "voiceProgress", GetConVarFloat( "speex_audio_value" ) / 10000.0 )
		RuiSetFloat( file.voiceSensitivitySliderRui, "voiceThreshhold", GetConVarFloat( "speex_quiet_threshold" ) / 10000.0 )
		WaitFrame()
	}
}
#endif

void function OpenConfirmRestoreSoundDefaultsDialog( var button )
{
	ConfirmDialogData data
	data.headerText = "#RESTORE_AUDIO_DEFAULTS"
	data.messageText = "#RESTORE_AUDIO_DEFAULTS_DESC"
	data.resultCallback = OnConfirmDialogResult

	OpenConfirmDialogFromData( data )
}


void function OnConfirmDialogResult( int result )
{
	switch ( result )
	{
		case eDialogResult.YES:
			RestoreSoundDefaults()
	}
}


void function RestoreSoundDefaults()
{
	SetConVarToDefault( "speechtotext_enabled" )
	SetConVarToDefault( "sound_volume" )
	SetConVarToDefault( "sound_volume_sfx" )
	SetConVarToDefault( "sound_volume_dialogue" )
	SetConVarToDefault( "sound_volume_music_game" )
	SetConVarToDefault( "sound_volume_music_lobby" )
	SetConVarToDefault( "closecaption" )
	#if PC_PROG
		SetConVarToDefault( "TalkIsStream" )
		SetConVarToDefault( "hudchat_play_text_to_speech" )
		SetConVarToDefault( "sound_volume_voice" )
		SetConVarToDefault( "miles_occlusion" )
		SetConVarToDefault( "sound_without_focus" )
		SetConVarToDefault( "speex_quiet_threshold" )
	#endif

	SaveSettingsConVars( file.conVarDataList )
	SavePlayerSettings()
	EmitUISound( "menu_advocategift_open" )
}
