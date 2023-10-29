global function ServerCallback_SetTimer

struct {
    bool isInitialized = false
    var timerRui
    array<var> infoRuis = []
} file

void function ClInitFallingForever() {
    // General Info
    var titleRui = CreateFullscreenRui( $"ui/tutorial_hint_line.rpak" )
    RuiSetString( titleRui, "hintText", "Falling Forever by JayTheYggdrasil" )
    RuiSetInt( titleRui, "hintOffset", file.infoRuis.len() )
    file.infoRuis.append( titleRui )

    file.timerRui = CreateFullscreenRui( $"ui/tutorial_hint_line.rpak" )
    RuiSetString( file.timerRui, "hintText", "Timer - 0.0s" )
    RuiSetInt( file.timerRui, "hintOffset", file.infoRuis.len() )
    file.infoRuis.append( file.timerRui )

    // Button Prompts
    // AddInputHint( "%zoom%", "%offhand4% Save Available Checkpoint" )
    AddInputHint( "%attack%", "Restore to Current Checkpoint" )
    AddInputHint( "%use%", "Restore to Previous Checkpoint" )
    AddInputHint( "%reload%", "Complete Restart" )
}

void function ServerCallback_SetTimer( int currentTime ) {
    if(!file.isInitialized) {
        ClInitFallingForever()
        file.isInitialized = true
    }

    if ( currentTime < 60 ) {
        RuiSetString( file.timerRui, "hintText", format("Timer - %ds", currentTime ) )
    } else {
        int minutes = currentTime / 60
        int seconds = currentTime - 60 * minutes
        RuiSetString( file.timerRui, "hintText", format("Timer - %dm %ds", minutes, seconds ) )
    }
}


void function AddInputHint( string buttonText, string hintText)
{
    var hintRui = CreateFullscreenRui( $"ui/tutorial_hint_line.rpak" )

	RuiSetString( hintRui, "buttonText", buttonText )
	RuiSetString( hintRui, "hintText", hintText )
	RuiSetInt( hintRui, "hintOffset", file.infoRuis.len() )
    file.infoRuis.append( hintRui )
}