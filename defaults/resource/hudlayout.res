"Resource/HudLayout.res"
{
	HudMessage
	{
		fieldName 		HudMessage
		visible 		1
		enabled 		1
		wide	 		1920
		tall	 		1080
	}

	HudMenu
	{
		fieldName 		HudMenu
		visible 		1
		enabled 		1
		wide	 		1920
		tall	 		1080
	}

	HudCloseCaptionSPPositioningProxy
	{
		fieldName		HudCloseCaptionSPPositioningProxy
		xpos			c-425
		ypos			-132	[$WIN32]
		ypos			-222	[$GAMECONSOLE]
		wide			849
		tall			256		[$WIN32]
		tall			346		[$GAMECONSOLE]
	}

	HudCloseCaptionMPPositioningProxy
	{
		fieldName 		HudCloseCaptionMPPositioningProxy
		xpos			c-450
		ypos			621		[$WIN32]
		ypos			531		[$GAMECONSOLE]
		wide			899
		tall			306		[$WIN32]
		tall			396		[$GAMECONSOLE]
	}

	HudCloseCaption
	{
		fieldName 		HudCloseCaption
		visible			1
		enabled			1

		xpos			0
		ypos			0
		zpos			-100000
		wide	 		1920
		tall	 		1080

		bgcolor_override	"0 0 0 192"
		BgAlpha				192

		GrowTime			0.25
		ItemHiddenTime		0.2  	// Nearly same as grow time so that the item doesn't start to show until growth is finished
		ItemFadeInTime		0.15	// Once ItemHiddenTime is finished, takes this much longer to fade in
		ItemFadeOutTime		0.3
		topoffset			0		[$WIN32]
		topoffset			0		[$GAMECONSOLE]
	}

	HudPredictionDump
	{
		fieldName 		HudPredictionDump
		visible 		1
		enabled 		1
		wide	 		1920
		tall	 		1080
	}

	HudTrain
	{
		fieldName 		HudTrain
		visible 		1
		enabled 		1
		wide	 		1920
		tall	 		1080
	}

	AimAssistDebugPanel
	{
		fieldName 		AimAssistDebugPanel
		visible 		1
		enabled 		1
		wide	 		f0
		tall	 		f0
	}

	HUDDevNet
	{
		fieldName 		HUDDevNet
		visible 		1
		enabled 		1

		xpos			c-427
		ypos			225
		wide			854
		tall  			180

		PaintBackgroundType	0
		//paintbackground	1
	}

	HUDUsePrompt
	{
		fieldName 		HUDUsePrompt
		visible 		1
		enabled 		1

		center_x		0	// center text horizontally
		mainFont		HUDPrompt
		xBoxFont		GameUIButtons
	}

	WeaponPickupPrompt
	{
		mainFont		HUDPrompt
		visible			0
		xpos        	c-450
		ypos        	742
		zpos			150
		wide          	899
		tall          	225
		textAlignment	center
	}

	CHudScriptElements
	{
		zpos		100
	}

	HUDCrosshairNames
	{
	}

	HudSubtitles
	{
	}

	HudSaveStatus
	{
	}

	HUDWarnings
	{
	}

	RadialMenu
	{
	}

	PlayerDebugPanel
	{
	}
}
