global function EditorModeToys_Init

EditorMode function EditorModeToys_Init() 
{
    EditorMode mode

    mode.displayName = "Toys"
    mode.description = "Place down various interactive props"
    mode.crosshairActive = true
    
    mode.onActivationCallback = EditorModeToys_Activation
    mode.onDeactivationCallback = EditorModeToys_Deactivation
    mode.onAttackCallback = EditorModeToys_Place


    return mode
}

void function EditorModeToys_Activation(entity player)
{

}

void function EditorModeToys_Deactivation(entity player)
{

}

void function EditorModeToys_Place(entity player)
{

}