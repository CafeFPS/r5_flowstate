global function InitSurveys
global function TryOpenSurvey

global enum eSurveyType
{
	POSTGAME
	ENTER_LOBBY
	_COUNT
}

table<int, string> surveyTypeToNameMap = {
	[eSurveyType.POSTGAME] = "postgame",
	[eSurveyType.ENTER_LOBBY] = "enter_lobby",
}


void function InitSurveys()
{
	Assert( surveyTypeToNameMap.len() == eSurveyType._COUNT )
}

float lastSurveyDisplayTime = 0.0
bool function TryOpenSurvey( int surveyType )
{
	if ( !GetConVarBool( "pin_opt_in" ) || !MeetsAgeRequirements() )
		return false

	float sampleRate = GetSurveySampleRateByType( surveyType )
	if ( RandomFloat( 1.0 ) > sampleRate )
		return false

	array<string> surveyList = GetSurveysOfType( surveyType )
	if ( surveyList.len() == 0 )
		return false

	//
	if (Time() - lastSurveyDisplayTime < 30.0 )
		return false

	surveyList.randomize()

	OpenSurveyByRef( surveyList[0], sampleRate )

	return true
}


void function OpenSurveyByRef( string surveyRef, float sampleRate )
{
	ConfirmDialogData data = GetSurveyDialogDataByRef( surveyRef )

	string questionText = data.messageText
	string aAnswerText = data.yesText[1]
	string bAnswerText = data.noText[1]

	data.resultCallback = void function ( int result ) : ( surveyRef, questionText, sampleRate, aAnswerText, bAnswerText )
	{
		string answerText = result == eDialogResult.YES ? aAnswerText : bAnswerText

		#if R5DEV
			if ( !("mid" in uiGlobal.matchPinData) )
			{
				uiGlobal.matchPinData["mid"] <- "[fe80::78dc:e7ef:e13b:68e]:0:37015:1562712876"
				uiGlobal.matchPinData["map"] <- "mp_rr_box"
				uiGlobal.matchPinData["match_type"] <- "survival"
			}
		#endif

		PIN_Survey( GetSurveyTypeForRef( surveyRef ), questionText, aAnswerText, bAnswerText, answerText, sampleRate, result == eDialogResult.CANCEL )
	}

	OpenABDialogFromData( data )
	lastSurveyDisplayTime = Time()
}


ConfirmDialogData function GetSurveyDialogDataByRef( string surveyRef )
{
	surveyRef = surveyRef.tolower()
	string headerText = GetCurrentPlaylistVarString( "survey_" + surveyRef + "_header", "#SURVEY_MATCH_QUALITY_HEADER" )
	string questionText = GetCurrentPlaylistVarString( "survey_" + surveyRef + "_message", "#SURVEY_MATCH_QUALITY_MESSAGE" )

	string aTextKBM = GetCurrentPlaylistVarString( "survey_" + surveyRef + "_a_kbm", "#YES" )
	string bTextKBM = GetCurrentPlaylistVarString( "survey_" + surveyRef + "_b_kbm", "#NO" )

	ConfirmDialogData data

	data.headerText = headerText
	data.messageText = questionText
	data.contextImage = $"ui/menu/common/dialog_question"
	if ( CoinFlip() )
	{
		data.yesText = [Localize( "#X_BUTTON_N", Localize( aTextKBM ) ), aTextKBM]
		data.noText = [Localize( "#Y_BUTTON_N", Localize( bTextKBM ) ), bTextKBM]
	}
	else
	{
		data.yesText = [Localize( "#X_BUTTON_N", Localize( bTextKBM ) ), bTextKBM]
		data.noText = [Localize( "#Y_BUTTON_N", Localize( aTextKBM ) ), aTextKBM]
	}

	return data
}


array<string> function GetSurveysOfType( int surveyType )
{
	Assert( surveyType < eSurveyType._COUNT, "Invalid surveyType " + surveyType )
	if ( surveyType < 0 || surveyType >= eSurveyType._COUNT )
		return []

	string typeString = surveyTypeToNameMap[surveyType]
	array<string> surveyList = split( GetCurrentPlaylistVarString( "survey_list_" + typeString, "" ).tolower(), ";" )

	return surveyList
}


float function GetSurveySampleRateByType( int surveyType )
{
	Assert( surveyType < eSurveyType._COUNT, "Invalid surveyType " + surveyType )
	if ( surveyType < 0 || surveyType >= eSurveyType._COUNT )
		return 0.0

	float sampleRate = GetCurrentPlaylistVarFloat( "survey_sample_rate", 0.0 )

	string typeString = surveyTypeToNameMap[surveyType]
	sampleRate = GetCurrentPlaylistVarFloat( "survey_sample_rate_" + typeString, sampleRate )

	return sampleRate
}


int function GetSurveyTypeForRef( string surveyRef )
{
	for ( int surveyType = 0; surveyType < eSurveyType._COUNT; surveyType++ )
	{
		array<string> surveyList = GetSurveysOfType( surveyType )
		if ( surveyList.contains( surveyRef ) )
			return surveyType
	}

	Assert( false, "Invalid surveyRef " + surveyRef )
	return -1
}

