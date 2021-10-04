global function InitSoundPanel
global function RestoreSoundDefaults
global function SoundPanel_GetConVarData

global function InitProcessingDialog

struct
{
	table<var, string> buttonTitles
	table<var, string> buttonDescriptions
	var                detailsPanel
	var				   contentPanel
	var                itemDescriptionBox

	var 			   audioLanguageButton
	#if PC_PROG
	var 			   voiceSensitivityButton
	var 			   voiceSensitivitySliderRui
	#endif

	array<ConVarData>    conVarDataList

	string miles_language

	var processingDialog
} file


void function InitSoundPanel( var panel )
{
	RegisterSignal( "UpdateVoiceMeter" )
	RegisterSignal( "EndRebootMiles" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, OnSoundPanel_Show )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, OnSoundPanel_Hide )

	var contentPanel = Hud_GetChild( panel, "ContentPanel" )
	file.contentPanel = contentPanel

	SetupSettingsSlider( Hud_GetChild( contentPanel, "SldMasterVolume" ), "#MASTER_VOLUME", "#OPTIONS_MENU_MASTER_VOLUME_DESC", $"rui/menu/settings/settings_audio" )

	file.audioLanguageButton = Hud_GetChild( contentPanel, "SwchAudioLanguage" )
	SetupSettingsButton( file.audioLanguageButton, "#AUDIO_LANGUAGE", "#OPTIONS_MENU_AUDIO_LANGUAGE_DESC", $"rui/menu/settings/settings_audio" )
	AddButtonEventHandler( file.audioLanguageButton, UIE_CHANGE, OnAudioLanguageControlChanged )

	file.miles_language = GetConVarString( "miles_language" )

	SetupSettingsSlider( Hud_GetChild( contentPanel, "SldDialogueVolume" ), "#MENU_DIALOGUE_VOLUME_CLASSIC", "#OPTIONS_MENU_DIALOGUE_VOLUME_DESC", $"rui/menu/settings/settings_audio" )
	SetupSettingsSlider( Hud_GetChild( contentPanel, "SldSFXVolume" ), "#MENU_SFX_VOLUME_CLASSIC", "#OPTIONS_MENU_SFX_VOLUME_DESC", $"rui/menu/settings/settings_audio" )
	SetupSettingsSlider( Hud_GetChild( contentPanel, "SldMusicVolume" ), "#MENU_MUSIC_VOLUME_CLASSIC", "#OPTIONS_MENU_MUSIC_VOLUME_DESC", $"rui/menu/settings/settings_audio" )
	SetupSettingsSlider( Hud_GetChild( contentPanel, "SldLobbyMusicVolume" ), "#MENU_LOBBY_MUSIC_VOLUME", "#OPTIONS_MENU_LOBBY_MUSIC_VOLUME_DESC", $"rui/menu/settings/settings_audio" )
	SetupSettingsButton( Hud_GetChild( contentPanel, "SwchChatSpeechToText" ), "#MENU_CHAT_SPEECH_TO_TEXT", "#OPTIONS_MENU_CHAT_SPEECH_TO_TEXT_DESC", $"rui/menu/settings/settings_audio" )
	Hud_SetVisible( Hud_GetChild( contentPanel, "SwchChatSpeechToText" ), IsAccessibilityAvailable() )
	#if PC_PROG
		SetupSettingsButton( Hud_GetChild( contentPanel, "SwchChatTextToSpeech" ), "#MENU_CHAT_TEXT_TO_SPEECH", "#OPTIONS_MENU_CHAT_TEXT_TO_SPEECH_DESC", $"rui/menu/settings/settings_audio" )
		Hud_SetVisible( Hud_GetChild( contentPanel, "SwchChatTextToSpeech" ), IsAccessibilityAvailable() )

		file.voiceSensitivityButton = Hud_GetChild( contentPanel, "SldOpenMicSensitivity" )
		file.voiceSensitivitySliderRui = Hud_GetRui( Hud_GetChild( file.voiceSensitivityButton, "PrgValue" ) )

		HudElem_SetRuiArg( Hud_GetChild( file.voiceSensitivityButton, "PnlDefaultMark" ), "heightScale", 0.7 )

		SetupSettingsSlider( Hud_GetChild( contentPanel, "SldOpenMicSensitivity" ), "#OPEN_MIC_SENS", "#OPEN_MIC_SENS_DESC", $"rui/menu/settings/settings_audio" )
		SetupSettingsButton( Hud_GetChild( contentPanel, "SwchPushToTalk" ), "#OPTIONS_MENU_VOICE_CHAT_MIC", "#OPTIONS_MENU_VOICE_CHAT_MIC_DESC", $"rui/menu/settings/settings_audio" )
		var slider = Hud_GetChild( contentPanel, "SldVoiceChatVolume" )
		SetupSettingsSlider( slider, "#VOICE_CHAT_VOLUME", "#OPTIONS_MENU_VOICE_CHAT_DESC", $"rui/menu/settings/settings_audio" )
		AddButtonEventHandler( slider, UIE_CHANGE, OnVoiceChatVolumeSettingChanged )
		SetupSettingsButton( Hud_GetChild( contentPanel, "SwchSoundWithoutFocus" ), "#SOUND_WITHOUT_FOCUS", "#OPTIONS_MENU_SOUND_WITHOUT_FOCUS", $"rui/menu/settings/settings_audio" )
		SetupSettingsButton( Hud_GetChild( contentPanel, "SwchSpeakerConfig" ), "#WINDOWS_AUDIO_CONFIGURATION", "", $"rui/menu/settings/settings_audio" )
	#elseif(CONSOLE_PROG)
		var button = Hud_GetChild( contentPanel, "SwchMuteVoiceChat" )
		SetupSettingsButton( button, "#OPTIONS_MENU_VOICE_CHAT_DISABLE", "#OPTIONS_MENU_VOICE_CHAT_DISABLE_DESC", $"rui/menu/settings/settings_audio" )
		AddButtonEventHandler( button, UIE_CHANGE, OnDisableVoiceChatSettingChanged )
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
	Hud_SetEnabled( file.audioLanguageButton, IsAudioLanguageChangeAllowed() )

	#if PC_PROG
	OnVoiceChatVolumeSettingChanged( panel )
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


void function OnAudioLanguageControlChanged( var button )
{
	if ( IsAudioLanguageChanged() )
		thread RebootMiles()
}


bool function IsAudioLanguageChanged()
{
	string currentVal = GetConVarString( "miles_language" )
	if ( currentVal == file.miles_language )
		return false

	file.miles_language = currentVal

	return true
}


void function RebootMiles()
{
	Signal( uiGlobal.signalDummy, "EndRebootMiles" )
	EndSignal( uiGlobal.signalDummy, "EndRebootMiles" )

	AdvanceMenu( file.processingDialog )
	WaitFrame()

	ClientCommand( "miles_reboot" )
	ResetKeyRepeater()

	string checkSound = "Music_Lobby"
	var handle = null

	while ( handle == null || !IsUISoundStillPlaying( handle ) )
	{
		WaitFrame()
		handle = EmitUISound( checkSound )
	}
	StopUISoundByName( checkSound )

	Assert( GetActiveMenu() == file.processingDialog )
	CloseActiveMenu()

	UIMusicUpdate()
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
			thread RestoreSoundDefaults()
	}
}

#if PC_PROG
void function OnVoiceChatVolumeSettingChanged( var slider )
{
	bool isVoiceVolumeZero = GetConVarFloat( "sound_volume_voice" ) == 0.0
	LockSpeechToText( isVoiceVolumeZero )
}
#endif

#if CONSOLE_PROG
void function OnDisableVoiceChatSettingChanged( var button )
{
	bool isVoiceChatDisabled = !GetConVarBool( "voice_enabled" )
	var speechToTextButton = Hud_GetChild( file.contentPanel, "SwchChatSpeechToText" )
	LockSpeechToText( isVoiceChatDisabled )
}
#endif

void function LockSpeechToText( bool shouldLock )
{
	var speechToTextButton = Hud_GetChild( file.contentPanel, "SwchChatSpeechToText" )
	Hud_SetLocked( speechToTextButton, shouldLock )
	if( shouldLock )
		SetConVarBool( "speechtotext_enabled", false )
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
	if ( IsAudioLanguageChangeAllowed() )
		SetConVarToDefault( "miles_language" )
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

	if ( IsAudioLanguageChangeAllowed() && IsAudioLanguageChanged() )
		waitthread RebootMiles()

	EmitUISound( "menu_advocategift_open" )
}

bool function IsAudioLanguageChangeAllowed()
{
	return Hud_IsVisible( file.audioLanguageButton ) && IsLobby()
}

void function InitProcessingDialog( var menu )
{
	file.processingDialog = menu
	SetDialog( menu, true )
	SetGamepadCursorEnabled( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, ProcessingDialog_OnNavigateBack )
}

void function ProcessingDialog_OnNavigateBack()
{
}