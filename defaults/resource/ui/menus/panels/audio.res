"resource/ui/menus/panels/audio.res"
{
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    SldMasterVolume
    {
        ControlName             SliderControl
        InheritProperties       SliderControl
        tabPosition             1
        navDown                 SwchAudioLanguage
        conCommand              "sound_volume"
        minValue                0.0
        maxValue                1.0
        stepSize                0.05
        inverseFill             0
        showLabel               3
        ypos                    0
    }
    SwchAudioLanguage
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        style                   DialogListButton
        navUp                   SldMasterVolume
        navDown                 SwchPushToTalk
        ConVar                  "miles_language"
        list
        {
            "#SETTING_DEFAULT"          ""
            "#GAMEUI_LANGUAGE_ENGLISH"  "english"
        }

        pin_to_sibling          SldMasterVolume
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        visible                 0 //[$ENGLISH || $PORTUGUESE || $TCHINESE]
        //visible                 1 [!$ENGLISH && !$PORTUGUESE && !$TCHINESE]

        childGroupAlways        ChoiceButtonAlways
    }

    VoiceChatHeader
    {
        ControlName				ImagePanel
        InheritProperties		SubheaderBackgroundWide
        xpos					0
        ypos					6
        pin_to_sibling			SldMasterVolume //[$ENGLISH || $PORTUGUESE || $TCHINESE]
        //pin_to_sibling			SwchAudioLanguage [!$ENGLISH && !$PORTUGUESE && !$TCHINESE]
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    VoiceChatHeaderText
    {
        ControlName				Label
        InheritProperties		SubheaderText
        pin_to_sibling			VoiceChatHeader
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	LEFT
        labelText				"#MENU_VOICE_CHAT"
    }

    SwchPushToTalk
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        style                   DialogListButton
        navUp                   SwchAudioLanguage
        navDown                 SldOpenMicSensitivity
        ConVar                  "TalkIsStream"
        list
        {
            "#SETTING_PTT"      0
            "#SETTING_OPENMIC"  1
        }

        pin_to_sibling          VoiceChatHeader
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        childGroupAlways        ChoiceButtonAlways
    }
    SldOpenMicSensitivity
    {
        ControlName             SliderControl
        InheritProperties       SliderControl
        navUp                   SwchPushToTalk
        navDown                 SldVoiceChatVolume
        conCommand              "speex_quiet_threshold"
        minValue                0
        maxValue                10000
        stepSize                50
        inverseFill             0
        showLabel               1

        pin_to_sibling          SwchPushToTalk
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        PrgValue
        {
            ControlName				RuiPanel
            fieldName				PrgValue
            zpos					5
            wide					280
            tall					60
            visible					1
            enabled					1
            tabPosition				0
            rui                     "ui/settings_voice_slider.rpak"
        }
    }
    SldVoiceChatVolume
    {
        ControlName             SliderControl
        InheritProperties       SliderControl
        navUp                   SldOpenMicSensitivity
        navDown                 SldSFXVolume
        conCommand              "sound_volume_voice"
        minValue                0.0
        maxValue                1.0
        stepSize                0.05
        inverseFill             0
        showLabel               3

        pin_to_sibling          SldOpenMicSensitivity
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }

    AdvancedHeader
    {
        ControlName				ImagePanel
        InheritProperties		SubheaderBackgroundWide
        xpos					0
        ypos					6
        pin_to_sibling			SldVoiceChatVolume
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }
    AdvancedHeaderText
    {
        ControlName				Label
        InheritProperties		SubheaderText
        pin_to_sibling			AdvancedHeader
        pin_corner_to_sibling	LEFT
        pin_to_sibling_corner	LEFT
        labelText				"#MENU_ADVANCED"
    }

    SldSFXVolume
    {
        ControlName             SliderControl
        InheritProperties       SliderControl
        navUp                   SldVoiceChatVolume
        navDown                 SldDialogueVolume
        conCommand              "sound_volume_sfx"
        minValue                0.0
        maxValue                1.0
        stepSize                0.05
        inverseFill             0
        showLabel               3

        pin_to_sibling          AdvancedHeader
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }
    SldDialogueVolume
    {
        ControlName             SliderControl
        InheritProperties       SliderControl
        navUp                   SldSFXVolume
        navDown                 SldMusicVolume
        conCommand              "sound_volume_dialogue"
        minValue                0.0
        maxValue                1.0
        stepSize                0.05
        inverseFill             0
        showLabel               3

        pin_to_sibling          SldSFXVolume
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }
    SldMusicVolume
    {
        ControlName             SliderControl
        InheritProperties       SliderControl
        navUp                   SldDialogueVolume
        navDown                 SldLobbyMusicVolume
        conCommand              "sound_volume_music_game"
        minValue                0.0
        maxValue                1.0
        stepSize                0.05
        inverseFill             0
        showLabel               3

        pin_to_sibling          SldDialogueVolume
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }
    SldLobbyMusicVolume
    {
        ControlName             SliderControl
        InheritProperties       SliderControl
        navUp                   SldMusicVolume
        navDown                 SwchSoundWithoutFocus
        conCommand              "sound_volume_music_lobby"
        minValue                0.0
        maxValue                1.0
        stepSize                0.05
        inverseFill             0
        showLabel               3


        pin_to_sibling          SldMusicVolume
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }
    SwchSoundWithoutFocus
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        style                   DialogListButton
        navUp                   SldLobbyMusicVolume
        navDown                 SwchChatTextToSpeech
        ConVar                  "sound_without_focus"
        list
        {
            "#SETTING_OFF"  0
            "#SETTING_ON"   1
        }

        pin_to_sibling          SldLobbyMusicVolume
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
        childGroupAlways        ChoiceButtonAlways
    }

    SwchChatTextToSpeech
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        style                   DialogListButton
        navUp                   SwchSoundWithoutFocus
        navDown                 SwchChatSpeechToText

        pin_to_sibling          SwchSoundWithoutFocus
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        ConVar                  "hudchat_play_text_to_speech"
        list
        {
            "#SETTING_OFF"  0
            "#SETTING_ON"   1
        }

        visible                 1 [$ENGLISH]
        visible                 0 [!$ENGLISH]

        ruiArgs
        {
            buttonText      "#MENU_CHAT_TEXT_TO_SPEECH"
        }
        clipRui                 1
        childGroupAlways        ChoiceButtonAlways
    }

    SwchChatSpeechToText
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        style                   DialogListButton
        navUp                   SwchChatTextToSpeech
        navDown                 SwchSpeakerConfig

        pin_to_sibling          SwchChatTextToSpeech
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        visible                 1 [$ENGLISH]
        visible                 0 [!$ENGLISH]

        ConVar                  "speechtotext_enabled"
        list
        {
            "#SETTING_OFF"  0
            "#SETTING_ON"   1
        }

        ruiArgs
        {
            buttonText      "#MENU_CHAT_SPEECH_TO_TEXT"
        }
        clipRui                 1
        childGroupAlways        ChoiceButtonAlways
    }

    SwchSpeakerConfig
    {
        ControlName             RuiButton
        InheritProperties       SwitchButton
        style                   DialogListButton
        navUp                   SwchChatSpeechToText
        ypos                    40
        ConVar                  "miles_channels"
        visible                 1
        enabled                 0
        list
        {
            "#SETTING_ONE_CHANNEL"      1
            "#SETTING_TWO_CHANNEL"      2
            "#SETTING_FOUR_CHANNEL"     4
            "#SETTING_SIX_CHANNEL"      6
            "#SETTING_SEVEN_CHANNEL"    7
            "#SETTING_EIGHT_CHANNEL"    8
            "#SETTING_NINE_CHANNEL"     9
        }

        pin_to_sibling          SwchChatSpeechToText [$ENGLISH]
        pin_to_sibling			SwchSoundWithoutFocus [!$ENGLISH]
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT
    }
    InputBlocker
    {
        ControlName             Label
        zpos                    10
        wide                    1088
        tall                    40
        labelText               ""

        pin_to_sibling          SwchSpeakerConfig
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_LEFT
    }
}