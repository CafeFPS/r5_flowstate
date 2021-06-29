untyped


global function MenuUtility_Init

global function GetElem
global function FlashElement
global function FancyLabelFadeIn
global function FancyLabelFadeOut
global function SetTextCountUp
global function LoopSoundForDuration
global function SetPanelAlphaOverTime
global function SetImagesByClassname
global function ShowElementsByClassname
global function HideElementsByClassname
global function SetElementsTextByClassname
global function PulsateElem
global function PlotPointsOnGraph
global function PlotKDPointsOnGraph

global function GetXScale
global function GetYScale

global function RHud_SetText
global function ButtonsSetSelected

global function Hud_SetKeyValue
global function Hud_GetValueForKey

global function TEMP_CursorInElementBounds
global function PointInBounds

global function GetMapImageForMapName

const STICK_DEFLECTION_TRIGGER = 0.35
const STICK_DEFLECTION_DEBOUNCE = 0.3

const MAX_DOTS_ON_GRAPH = 10

const table<asset> mapImages =
{
	mp_forwardbase_kodai = $"loadscreens/mp_forwardbase_kodai_lobby",
	mp_grave = $"loadscreens/mp_grave_lobby",
	mp_homestead = $"loadscreens/mp_homestead_lobby",
	mp_thaw = $"loadscreens/mp_thaw_lobby",
	mp_black_water_canal = $"loadscreens/mp_black_water_canal_lobby",
	mp_eden = $"loadscreens/mp_eden_lobby",
	mp_drydock = $"loadscreens/mp_drydock_lobby",
	mp_crashsite3 = $"loadscreens/mp_crashsite3_lobby",
	mp_complex3 = $"loadscreens/mp_complex3_lobby",
	mp_angel_city = $"loadscreens/mp_angle_city_r2_lobby",
	mp_colony02 = $"loadscreens/mp_colony02_lobby",
	mp_glitch = $"loadscreens/mp_glitch_lobby",
	mp_lf_stacks = $"loadscreens/mp_stacks_lobby",
	mp_lf_meadow = $"loadscreens/mp_meadow_lobby",
	mp_lf_deck = $"loadscreens/mp_lf_deck_lobby",
	mp_lf_traffic = $"loadscreens/mp_lf_traffic_lobby",
	mp_coliseum = $"loadscreens/mp_coliseum_lobby",
	mp_coliseum_column = $"loadscreens/mp_coliseum_column_lobby",
	mp_relic02 = $"loadscreens/mp_relic02_lobby",
	mp_wargames = $"loadscreens/mp_wargames_lobby",
	mp_rise = $"loadscreens/mp_rise_lobby",
	mp_lf_township = $"loadscreens/mp_lf_township_lobby",
	mp_lf_uma = $"loadscreens/mp_lf_uma_lobby",
}

void function MenuUtility_Init()
{
	RegisterSignal( "ElemFlash" )
	RegisterSignal( "StopMenuAnimation" )
	RegisterSignal( "PanelAlphaOverTime" )
	RegisterSignal( "StopLoopUISound" )
}


var function GetElem( var menu, string name )
{
	array<var> elems = GetElementsByClassname( menu, name )
	var elem

	if ( elems.len() == 0 )
	{
		elem = Hud_GetChild( menu, name )
	}
	else
	{
		Assert( elems.len() == 1, "Tried to use GetElem for 1 elem but " + string( elems.len() ) + " were found" )
		elem = elems[0]
	}
	Assert( elem != null, "Could not find elem with name " + name + " on menu " + menu )

	return elem
}


void function FlashElement( var menu, var element, int numberFlashes = 4, float speedScale = 1.0, int maxAlpha = 255, float delay = 0.0 )
{
	EndSignal( menu, "StopMenuAnimation" )

	Assert( element != null )

	Signal( element, "ElemFlash" )
	EndSignal( element, "ElemFlash" )

	int startAlpha = Hud_GetAlpha( element )
	float flashInTime = 0.2 / speedScale
	float flashOutTime = 0.4 / speedScale

	OnThreadEnd(
		function() : ( element, startAlpha )
		{
			Hud_SetAlpha( element, startAlpha )
		}
	)

	if ( delay > 0 )
		wait delay

	while ( numberFlashes >= 0 )
	{
		Hud_FadeOverTime( element, maxAlpha, flashInTime )
		wait flashInTime

		if ( numberFlashes == 0 )
			flashOutTime = 1.0    //

		Hud_FadeOverTime( element, 25, flashOutTime )
		numberFlashes--

		if ( numberFlashes > 0 )
			wait flashOutTime
	}

	Hud_FadeOverTime( element, startAlpha, flashInTime )
	wait flashInTime
}


void function FancyLabelFadeIn( var menu, var label, int xOffset = 0, int yOffset = 300, bool flicker = true, float duration = 0.15, bool isPanel = false, float delay = 0.0, string soundAlias = "" )
{
	EndSignal( menu, "StopMenuAnimation" )

	UIPos basePos = REPLACEHud_GetBasePos( label )

	OnThreadEnd(
		function() : ( label )
		{
			Hud_ReturnToBasePos( label )
			Hud_Show( label )
			Hud_ReturnToBaseColor( label )
		}
	)

	if ( delay > 0 )
		wait delay

	//
	Hud_SetPos( label, basePos.x + xOffset, basePos.y + yOffset )
	Hud_SetAlpha( label, 0 )
	Hud_Show( label )

	if ( soundAlias != "" )
		EmitUISound( soundAlias )

	int goalAlpha = Hud_GetBaseAlpha( label )
	//
	if ( isPanel )
		thread SetPanelAlphaOverTime( label, goalAlpha, duration )
	else
		Hud_FadeOverTime( label, goalAlpha, duration, INTERPOLATOR_ACCEL )

	Hud_MoveOverTime( label, basePos.x, basePos.y, duration )

	wait 0.2

	if ( flicker )
		thread FlashElement( menu, label, 3, 3.0 )

	if ( duration - 0.2 > 0 )
		wait duration - 0.2
}


void function FancyLabelFadeOut( var menu, var label, int xOffset = 0, int yOffset = -300, float duration = 0.15, bool isPanel = false )
{
	EndSignal( menu, "StopMenuAnimation" )

	UIPos currentPos = REPLACEHud_GetPos( label )

	OnThreadEnd(
		function() : ( label, currentPos, xOffset, yOffset )
		{
			Hud_SetPos( label, currentPos.x + xOffset, currentPos.y + yOffset )
			Hud_Hide( label )
		}
	)

	//
	if ( isPanel )
		thread SetPanelAlphaOverTime( label, 0, duration )
	else
		Hud_FadeOverTime( label, 0, duration, INTERPOLATOR_ACCEL )

	Hud_MoveOverTime( label, currentPos.x + xOffset, currentPos.y + yOffset, duration )
	wait duration
}


void function SetTextCountUp( var menu, var label, value, string tickAlias = "", float delay = 0.2, string formatString = "", float duration = 0.5, string locString = "", startValue = 0 )
{
	EndSignal( menu, "StopMenuAnimation" )

	OnThreadEnd(
		function() : ( formatString, locString, label, value )
		{
			string str
			if ( formatString != "" )
				str = format( formatString, value )
			else
				str = string( value )

			if ( locString != "" )
				Hud_SetText( label, locString, str )
			else
				Hud_SetText( label, str )
		}
	)

	string str = string( startValue )
	if ( formatString != "" )
		str = format( formatString, startValue )

	if ( locString != "" )
		Hud_SetText( label, locString, str )
	else
		Hud_SetText( label, str )

	if ( delay > 0 )
		wait delay

	float currentTime = Time()
	float startTime   = currentTime
	float endTime     = Time() + duration

	if ( tickAlias != "" )
		thread LoopSoundForDuration( menu, tickAlias, duration )

	while ( currentTime <= endTime )
	{
		int val = int( GraphCapped( currentTime, startTime, endTime, startValue, value ) )
		if ( formatString != "" )
			str = format( formatString, val )
		else
			str = string( val )

		if ( locString != "" )
			Hud_SetText( label, locString, str )
		else
			Hud_SetText( label, str )

		WaitFrame()
		currentTime = Time()
	}
}


void function LoopSoundForDuration( var menu, string alias, float duration )
{
	table signaler
	EndSignal( signaler, "StopLoopUISound" )
	EndSignal( menu, "StopMenuAnimation" )

	thread StopSoundDelayed( signaler, alias, duration )
	while ( true )
	{
		var handle = EmitUISound( alias )
		WaitSignal( handle, "OnSoundFinished" )
	}
}


void function StopSoundDelayed( table signaler, string alias, float delay )
{
	wait delay
	Signal( signaler, "StopLoopUISound" )
	StopUISound( alias )
}


void function SetPanelAlphaOverTime( var panel, int alpha, float duration )
{
	Signal( panel, "PanelAlphaOverTime" )
	EndSignal( panel, "PanelAlphaOverTime" )

	float startTime = Time()
	float endTime = startTime + duration
	int startAlpha = Hud_GetPanelAlpha( panel )

	while ( Time() <= endTime )
	{
		float a = GraphCapped( Time(), startTime, endTime, startAlpha, alpha )
		Hud_SetPanelAlpha( panel, a )
		WaitFrame()
	}

	Hud_SetPanelAlpha( panel, alpha )
}


void function SetImagesByClassname( var menu, string className, asset filename )
{
	array<var> images = GetElementsByClassname( menu, className )
	foreach ( img in images )
		Hud_SetImage( img, filename )
}


void function ShowElementsByClassname( var menu, string className )
{
	array<var> elements = GetElementsByClassname( menu, className )
	foreach ( elem in elements )
		Hud_Show( elem )
}


void function HideElementsByClassname( var menu, string className )
{
	array<var> elements = GetElementsByClassname( menu, className )
	foreach ( elem in elements )
		Hud_Hide( elem )
}


void function SetElementsTextByClassname( var menu, string className, string text )
{
	array<var> elements = GetElementsByClassname( menu, className )
	foreach ( element in elements )
		Hud_SetText( element, text )
}


void function PulsateElem( var menu, var element, int startAlpha = 255, int endAlpha = 50, float rate = 1.0 )
{
	EndSignal( menu, "StopMenuAnimation" )

	Assert( element != null )

	Signal( element, "ElemFlash" )
	EndSignal( element, "ElemFlash" )

	float duration = rate * 0.5
	Hud_SetAlpha( element, startAlpha )
	while ( true )
	{
		Hud_FadeOverTime( element, endAlpha, duration, INTERPOLATOR_ACCEL )
		wait duration
		Hud_FadeOverTime( element, startAlpha, duration, INTERPOLATOR_ACCEL )
		wait duration
	}
}


void function PlotPointsOnGraph( var menu, int maxPoints, string dotNames, string lineNames, values, graphBounds = null )
{
	int pointCount = minint( maxPoints, expect int( values.len() ) )
	Assert( pointCount >= 2 )

	//
	//

	//
	array<var> dots
	array<var> lines
	for ( int i = 0; i < maxPoints; i++ )
	{
		dots.append( GetElem( menu, dotNames + i ) )
		lines.append( GetElem( menu, lineNames + i ) )
	}

	//
	//
	int graphWidth = REPLACEHud_GetBasePos( dots[1] ).x - REPLACEHud_GetBasePos( dots[0] ).x
	int graphHeight = REPLACEHud_GetBasePos( dots[0] ).y - REPLACEHud_GetBasePos( dots[1] ).y
	UIPos graphOrigin = REPLACEHud_GetBasePos( dots[0] )
	graphOrigin.x += int( Hud_GetBaseWidth( dots[0] ) * 0.5 )
	graphOrigin.y += int( Hud_GetBaseHeight( dots[0] ) * 0.5 )
	float dotSpacing = graphWidth / float( pointCount - 1 )

	//
	//

	//
	/*












*/

	/*



*/

	//
	array<float[2]> dotPositions
	for ( int i = 0; i < maxPoints; i++ )
	{
		var dot = dots[i]
		if ( i >= pointCount )
		{
			Hud_Hide( dot )
			continue
		}

		float dotOffset = GraphCapped( values[i], graphBounds[0], graphBounds[1], 0, graphHeight )

		int posX = graphOrigin.x - int( (Hud_GetBaseWidth( dot ) * 0.5) + (dotSpacing * i) )
		int posY = graphOrigin.y - int( (Hud_GetBaseHeight( dot ) * 0.5) - dotOffset )
		Hud_SetPos( dot, posX, posY )
		Hud_Show( dot )

		float[2] dotPosition
		dotPosition[0] = posX + (Hud_GetBaseWidth( dot ) * 0.5)
		dotPosition[1] = posY + (Hud_GetBaseHeight( dot ) * 0.5)
		dotPositions.append( dotPosition )
	}

	/*















*/

	//
	for ( int i = 1; i < maxPoints; i++ )
	{
		var line = lines[i]

		if ( i >= pointCount )
		{
			Hud_Hide( line )
			continue
		}

		//
		float[2] startPos = dotPositions[i-1]
		float[2] endPos = dotPositions[i]
		float offsetX = endPos[0] - startPos[0]
		float offsetY = endPos[1] - startPos[1]
		float angle = atan( offsetX / offsetY ) * ( 180 / PI )

		//
		float length = sqrt( offsetX * offsetX + offsetY * offsetY )

		//
		int posX = int( endPos[0] - ( offsetX / 2.0 ) - ( length / 2.0 ) )
		int posY = int( endPos[1] - ( offsetY / 2.0 ) - ( Hud_GetBaseHeight( line ) / 2.0 ) )

		//
		Hud_SetWidth( line, int( length ) )
		Hud_SetRotation( line, angle + 90.0 )
		Hud_SetPos( line, posX, posY )
		Hud_Show( line )
	}
}

//
void function PlotKDPointsOnGraph( var menu, int graphIndex, array<float> values, float dottedAverage )
{
	//
	//

	var background = GetElem( menu, "KDRatioLast10Graph" + graphIndex )
	int graphHeight = Hud_GetBaseHeight( background )
	UIPos graphOrigin = REPLACEHud_GetAbsPos( background )
	graphOrigin.y += graphHeight
	float dotSpacing = Hud_GetBaseWidth( background ) / 9.0
	array<float[2]> dotPositions

	//
	float graphMin = 0.0
	float graphMax = max( dottedAverage, 1.0 )
	foreach ( value in values )
	{
		if ( value > graphMax )
			graphMax = value
	}
	graphMax += graphMax * 0.1

	var maxLabel = GetElem( menu, "Graph" + graphIndex + "ValueMax" )
	string maxValueString = format( "%.1f", graphMax )
	Hud_SetText( maxLabel, maxValueString )

	//
	for ( int i = 0; i < MAX_DOTS_ON_GRAPH; i++ )
	{
		var dot = GetElem( menu, "Graph" + graphIndex + "Dot" + i )

		if ( i >= values.len() )
		{
			Hud_Hide( dot )
			continue
		}

		float dotOffset = GraphCapped( values[i], graphMin, graphMax, 0, graphHeight )
		int posX = int( graphOrigin.x - ( Hud_GetBaseWidth( dot ) * 0.5 ) + ( dotSpacing * i ) )
		int posY = int( graphOrigin.y - ( Hud_GetBaseHeight( dot ) * 0.5 ) - dotOffset )
		Hud_SetPos( dot, posX, posY )
		Hud_Show( dot )

		float[2] dotPosition
		dotPosition[0] = posX + ( Hud_GetBaseWidth( dot ) * 0.5 )
		dotPosition[1] = posY + ( Hud_GetBaseHeight( dot ) * 0.5 )
		dotPositions.append( dotPosition )
	}

	{
		//
		var dottedLine = GetElem( menu, "KDRatioLast10Graph" + graphIndex + "DottedLine0" )
		float dottedLineOffset = GraphCapped( dottedAverage, graphMin, graphMax, 0, graphHeight )
		int posX = graphOrigin.x
		int posY = graphOrigin.y - int( ( Hud_GetBaseHeight( dottedLine ) * 0.5 ) - dottedLineOffset )
		Hud_SetPos( dottedLine, posX, posY )
		Hud_Show( dottedLine )
	}

	{
		//
		var dottedLine = GetElem( menu, "KDRatioLast10Graph" + graphIndex + "DottedLine1" )
		float dottedLineOffset = GraphCapped( 0.0, graphMin, graphMax, 0, graphHeight )
		int posX = graphOrigin.x
		int posY = graphOrigin.y - int( ( Hud_GetBaseHeight( dottedLine ) * 0.5 ) - dottedLineOffset )
		Hud_SetPos( dottedLine, posX, posY )
		Hud_Show( dottedLine )
	}

	//
	for ( int i = 1; i < MAX_DOTS_ON_GRAPH; i++ )
	{
		var line = GetElem( menu, "Graph" + graphIndex + "Line" + i )

		if ( i >= values.len() )
		{
			Hud_Hide( line )
			continue
		}

		//
		float[2] startPos = dotPositions[i - 1]
		float[2] endPos = dotPositions[i]
		float offsetX = endPos[0] - startPos[0]
		float offsetY = endPos[1] - startPos[1]
		float angle = atan( offsetX / offsetY ) * (180 / PI)

		//
		float length = sqrt( offsetX * offsetX + offsetY * offsetY )

		//
		int posX = int( endPos[0] - (offsetX / 2.0) - (length / 2.0) )
		int posY = int( endPos[1] - (offsetY / 2.0) - (Hud_GetBaseHeight( line ) / 2.0) )

		//
		Hud_SetWidth( line, int( length ) )
		Hud_SetRotation( line, angle + 90.0 )
		Hud_SetPos( line, posX, posY )
		Hud_Show( line )
	}
}


float function GetXScale()
{
	float xScale = float( GetMenu( "MainMenu" ).GetWidth() ) / 1920.0
	return xScale
}


float function GetYScale()
{
	float yScale = float( GetMenu( "MainMenu" ).GetHeight() ) / 1080.0
	return yScale
}


void function RHud_SetText( var element, string text )
{
	if ( Hud_IsRuiPanel( element ) )
		RuiSetString( Hud_GetRui( element ), "buttonText", text )
	if ( Hud_IsLabel( element ) )
		Hud_SetText( element, text )
}

void function ButtonsSetSelected( array<var> buttons, bool selected )
{
	foreach ( button in buttons )
	{
		Hud_SetSelected( button, selected )
	}
}


void function Hud_SetKeyValue( var element, string keyName, var value )
{
	element.s[keyName] <- value
}


var function Hud_GetValueForKey( var element, string keyName )
{
	return element.s[keyName]
}

bool function TEMP_CursorInElementBounds( var element )
{
	vector cursorPos = GetCursorPosition()
	UISize screenSize = GetScreenSize()
	cursorPos.x *= screenSize.width / 1920.0
	cursorPos.y *= screenSize.height / 1080.0

	UISize elementSize = REPLACEHud_GetSize( element )
	UIPos elementPos = REPLACEHud_GetAbsPos( element )

	return PointInBounds( cursorPos, elementPos, elementSize )
}

bool function PointInBounds( vector point, UIPos pos, UISize size )
{
	if ( point.x < pos.x )
		return false
	if ( point.y < pos.y )
		return false
	if ( point.x > pos.x + size.width )
		return false
	if ( point.y > pos.y + size.height )
		return false

	return true
}

asset function GetMapImageForMapName( string mapName )
{
	if ( mapName in mapImages )
		return mapImages[mapName]

	return $""
}