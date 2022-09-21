global function EditorModeDelete_Init
#if CLIENT
#endif

struct {
    array<PropInfo> propInfoList
    float offsetZ = 0
	array<var> inputHintRuis	

    // not using player.p.xxx because I already did this using these variables and I am not rewriting everything.
    #if SERVER
    table<entity, float> snapSizes
    table<entity, float> pitches
    table<entity, float> offsets
    #elseif CLIENT
    float snapSize = 64
    float pitch = 0
    entity highlightedEnt
    #endif
} file



EditorMode function EditorModeDelete_Init() 
{
    // INIT FOR WEAPON

    EditorMode mode

    mode.displayName = "Delete"
    mode.description = "Delete props already placed"
    mode.crosshairActive = true
    
    mode.onActivationCallback = EditorModeDelete_Activation
    mode.onDeactivationCallback = EditorModeDelete_Deactivation
    mode.onAttackCallback = EditorModeDelete_Delete

    //
    RegisterSignal("EditorModeDeleteExit")

    return mode
}

void function EditorModeDelete_Activation(entity player)
{
    AddInputHint( "%attack%", "Delete Prop" )

    #if CLIENT
    thread EditorModeDelete_Think(player)
    #endif
}

#if CLIENT
void function EditorModeDelete_Think(entity player) {
    player.EndSignal("EditorModeDeleteExit")
    
    OnThreadEnd(
        function() : (player) {
            if(IsValid(file.highlightedEnt))
            {
                file.highlightedEnt.Destroy()
            }
        }
    )
    
    while( true )
    {
        TraceResults result = GetDeleteLineTrace(player)
        if (IsValid(result.hitEnt) && result.hitEnt.GetScriptName() == "editor_placed_prop")
        {
            if( IsValid( file.highlightedEnt ) && IsValid( result.hitEnt ) )
            {
                if( IsValid(file.highlightedEnt.e.svCounterpart) && file.highlightedEnt.e.svCounterpart == result.hitEnt ) {
                    WaitFrame()
                    continue   
                }
            }
            
            if(IsValid(file.highlightedEnt))
            {
                file.highlightedEnt.Destroy()
            }
            
            if( IsValid(result.hitEnt) )
            {
                file.highlightedEnt = CreateClientSidePropDynamicClone(result.hitEnt, result.hitEnt.GetModelName() )
                file.highlightedEnt.e.svCounterpart = result.hitEnt
                DeployableModelInvalidHighlight( file.highlightedEnt )
            }

        }
        else
        {
            if(IsValid(file.highlightedEnt))
            {
                file.highlightedEnt.Destroy()
            }
        }

        WaitFrame()
    }
    
    

    

    // using worldspawn as default value if ent not found cause using null comes with lots of drawbacks
}
#endif


void function EditorModeDelete_Deactivation(entity player)
{
    RemoveAllHints()
    Signal(player, "EditorModeDeleteExit")
}

void function EditorModeDelete_Delete(entity player)
{
    DeleteProp(player)
}



void function RemoveAllHints()
{
    #if CLIENT
    foreach( rui in file.inputHintRuis )
    {
        RuiDestroy( rui )
    }
    file.inputHintRuis.clear()
    #endif
}

void function AddInputHint( string buttonText, string hintText)
{

    #if CLIENT
    var hintRui = CreateFullscreenRui( $"ui/tutorial_hint_line.rpak" )

	RuiSetString( hintRui, "buttonText", buttonText )
	// RuiSetString( hintRui, "gamepadButtonText", gamePadButtonText )
	RuiSetString( hintRui, "hintText", hintText )
	// RuiSetString( hintRui, "altHintText", altHintText )
	RuiSetInt( hintRui, "hintOffset", file.inputHintRuis.len() )
	// RuiSetBool( hintRui, "hideWithMenus", false )

    file.inputHintRuis.append( hintRui )

    #endif
}


void function DeleteProp(entity player)
{
    #if SERVER
    TraceResults result = GetDeleteLineTrace(player)
    if (IsValid(result.hitEnt))
    {
        if (result.hitEnt.GetScriptName() == "editor_placed_prop")
        {
            result.hitEnt.NotSolid()
            result.hitEnt.Dissolve( ENTITY_DISSOLVE_NORMAL, <0,0,0>, 0 )

            // prints prop info to the console to let the parse know to delete it
            vector myOrigin = result.hitEnt.GetOrigin()
            vector myAngles = result.hitEnt.GetAngles()

            string positionSerialized = myOrigin.x.tostring() + "," + myOrigin.y.tostring() + "," + myOrigin.z.tostring()
            string anglesSerialized = myAngles.x.tostring() + "," + myAngles.y.tostring() + "," + myAngles.z.tostring()
            printl("[delete]" + result.hitEnt.GetModelName() + ";" + positionSerialized + ";" + anglesSerialized)
        }
    }
    #endif
}

TraceResults function GetDeleteLineTrace(entity player)
{
    TraceResults result = TraceLineHighDetail(player.EyePosition() + 5 * player.GetViewForward(), player.GetOrigin() + 1500 * player.GetViewForward(), [player], TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_PLAYER)
    return result
}