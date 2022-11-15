untyped
global function CustomCrosshair_Init

const RUI_TEXT_CENTER = $"ui/cockpit_console_text_center.rpak"
const RUI_TEXT_LEFT = $"ui/cockpit_console_text_top_left.rpak"
const RUI_TEXT_RIGHT = $"ui/cockpit_console_text_top_right.rpak"

enum eDotEnabled
{
    No,
    WingmanDot,
    CustomDot,
    CustomNoDot,
    CustomT,
    CustomHoriz,
    CustomPulseBlade
}
struct CrosshairSettings
{
    bool setADSFrac = false
    int dotEnabled = 2
    float spreadMultiplier = 1.0
    float scaleMultiplier = 1.0
    float dotScaleMultiplier = 1.0
    float spreadOffset = 0.0
    float rotation = 0.0
    vector crosshairMovement = <0,0,0>
    vector topoOffset = <0,0,0>
    bool crosshairBeat = false
    bool chargeFracIsHeat = false
    bool triEnabled = false
    bool forceDisableProjPrediction = false

    float length = -1.0
    float thicknessX = -1.0
    float thicknessY = -1.0
    float minThicknessX = -1.0
    float minThicknessY = -1.0
    float dotThickness = -1.0
    float verticalSpreadOverride = -1.0
    float horizontalSpreadOverride = -1.0
}

struct {
    var rui
    var dot
    var aspectRatioFixTopo
    var aspectRatioFixTopoDot
    asset curRuiAsset
    asset curDotAsset
    bool posOutOfView = false
    CrosshairSettings& settings
    entity selectedWeapon = null
} file

enum eCrosshairIndex
{
    outlineTopo,
    outline,
    topo,
    rui
}
struct {
    // [outlineTopo, outline, topo, rui]
    array<var> left
    array<var> right
    array<var> top
    array<var> bottom
    array<var> dot
    array<var> outlines
    array<var> ruis
} custCrosshair

float scale = 0.8
float inverseScale = 1.2
float rotation = 45.0

void function CustomCrosshair_Init()
{
    scale = 0.5
    inverseScale = 1 / 0.5
    float right = (GetScreenSize().height / 9.0) * 16.0 * scale
    float down = GetScreenSize().height * scale
    float xOffset = (GetScreenSize().width - right) / 2
    float yOffset = (GetScreenSize().height - down) / 2
    file.aspectRatioFixTopo = RuiTopology_CreatePlane( <xOffset, yOffset, 0>, <right, 0, 0>, <0, down, 0>, true )
    file.aspectRatioFixTopoDot = RuiTopology_CreatePlane( <xOffset, yOffset, 0>, <right, 0, 0>, <0, down, 0>, true )
    file.rui = RuiCreate( $"ui/crosshair_plus.rpak", file.aspectRatioFixTopo, RUI_DRAW_HUD, 9 )
    file.dot = RuiCreate( $"ui/crosshair_dot.rpak", file.aspectRatioFixTopoDot, RUI_DRAW_HUD, 9 )
    file.curRuiAsset = $"ui/crosshair_plus.rpak"

    custCrosshair.left.append(RuiTopology_CreatePlane( <1920, 1080,0>, <right, 0, 0>, <0, down, 0>, true ))
    custCrosshair.left.append(RuiCreate( $"ui/basic_image.rpak", custCrosshair.left[0], RUI_DRAW_HUD, 9 ))
    custCrosshair.outlines.append(custCrosshair.left[1])
    custCrosshair.left.append(RuiTopology_CreatePlane( <1920, 1080,0>, <right, 0, 0>, <0, down, 0>, true ))
    custCrosshair.left.append(RuiCreate( $"ui/basic_image.rpak", custCrosshair.left[2], RUI_DRAW_HUD, 10 ))
    custCrosshair.ruis.append(custCrosshair.left[3])

    custCrosshair.right.append(RuiTopology_CreatePlane( <1920, 1080,0>, <right, 0, 0>, <0, down, 0>, true ))
    custCrosshair.right.append(RuiCreate( $"ui/basic_image.rpak", custCrosshair.right[0], RUI_DRAW_HUD, 9 ))
    custCrosshair.outlines.append(custCrosshair.right[1])
    custCrosshair.right.append(RuiTopology_CreatePlane( <1920, 1080,0>, <right, 0, 0>, <0, down, 0>, true ))
    custCrosshair.right.append(RuiCreate( $"ui/basic_image.rpak", custCrosshair.right[2], RUI_DRAW_HUD, 10 ))
    custCrosshair.ruis.append(custCrosshair.right[3])
    
    custCrosshair.top.append(RuiTopology_CreatePlane( <1920, 1080,0>, <right, 0, 0>, <0, down, 0>, true ))
    custCrosshair.top.append(RuiCreate( $"ui/basic_image.rpak", custCrosshair.top[0], RUI_DRAW_HUD, 9 ))
    custCrosshair.outlines.append(custCrosshair.top[1])
    custCrosshair.top.append(RuiTopology_CreatePlane( <1920, 1080,0>, <right, 0, 0>, <0, down, 0>, true ))
    custCrosshair.top.append(RuiCreate( $"ui/basic_image.rpak", custCrosshair.top[2], RUI_DRAW_HUD, 10 ))
    custCrosshair.ruis.append(custCrosshair.top[3])
    
    custCrosshair.bottom.append(RuiTopology_CreatePlane( <1920, 1080,0>, <right, 0, 0>, <0, down, 0>, true ))
    custCrosshair.bottom.append(RuiCreate( $"ui/basic_image.rpak", custCrosshair.bottom[0], RUI_DRAW_HUD, 9 ))
    custCrosshair.outlines.append(custCrosshair.bottom[1])
    custCrosshair.bottom.append(RuiTopology_CreatePlane( <1920, 1080,0>, <right, 0, 0>, <0, down, 0>, true ))
    custCrosshair.bottom.append(RuiCreate( $"ui/basic_image.rpak", custCrosshair.bottom[2], RUI_DRAW_HUD, 10 ))
    custCrosshair.ruis.append(custCrosshair.bottom[3])
    
    custCrosshair.dot.append(RuiTopology_CreatePlane( <xOffset, yOffset, 0>, <right, 0, 0>, <0, down, 0>, true ))
    custCrosshair.dot.append(RuiCreate( $"ui/basic_image.rpak", custCrosshair.dot[0], RUI_DRAW_HUD, 9 ))
    custCrosshair.outlines.append(custCrosshair.dot[1])
    custCrosshair.dot.append(RuiTopology_CreatePlane( <xOffset, yOffset, 0>, <right, 0, 0>, <0, down, 0>, true ))
    custCrosshair.dot.append(RuiCreate( $"ui/basic_image.rpak", custCrosshair.dot[2], RUI_DRAW_HUD, 10 ))
    custCrosshair.ruis.append(custCrosshair.dot[3])
    thread UpdateCrosshair()
    AddCallback_OnPlayerLifeStateChanged( void function( entity player, int oldLifeState, int newLifeState ) : () { thread DisableCrosshair() } )
}

void function UpdateCrosshair()
{
    while ( true )
    {
        wait 0
        entity player = GetLocalViewPlayer()

        if ( !IsValid(player) || !player.IsPlayer() )
            continue

        entity selectedWeapon = player.GetSelectedWeapon( eActiveInventorySlot.mainHand )
        if (file.selectedWeapon == null)
            selectedWeapon = player.GetActiveWeapon(eActiveInventorySlot.mainHand)
        if (selectedWeapon != null)
        {
            file.selectedWeapon = selectedWeapon
        }
        entity weapon = player.GetActiveWeapon(eActiveInventorySlot.mainHand)
        if ( !IsAlive( player ) || player.IsWeaponSlotDisabled(eActiveInventorySlot.mainHand) || !IsValid(weapon) || (selectedWeapon != weapon && selectedWeapon != null) )
        {
            SetNewCrosshair( $"" )
            if (file.dot != null)
                RuiDestroyIfAlive( file.dot )
            file.dot = null

            foreach (var rui in custCrosshair.outlines)
                RuiSetFloat(rui, "basicImageAlpha", 0.0)
            foreach (var rui in custCrosshair.ruis)
                RuiSetFloat(rui, "basicImageAlpha", 0.0)

            continue
        }

        ChangeCrosshairIfNeeded(weapon)

        float fov = player.GetFOV()

        float ratio = (GetScreenSize().width * 9.0) / (GetScreenSize().height * 16.0)
        rotation = file.settings.rotation

        //if (weapon.IsChargeWeapon())
        //    rotation = 90 * weapon.GetWeaponChargeFraction()

        scale = 0.8
        inverseScale = 1.0 / scale


        float right = (GetScreenSize().height / 9.0) * 16.0 * scale * file.settings.scaleMultiplier
        float down = GetScreenSize().height * scale * file.settings.scaleMultiplier
        float xOffset = (GetScreenSize().width - right) / 2
        float yOffset = (GetScreenSize().height - down) / 2
        vector rot = <0,rotation,0>
        bool forceNoCharge = GetWeaponMods_Global( weapon.GetWeaponClassName() ).contains( "hopup_energy_choke" )

        //printt(GetCrosshairPos(player) - RotateVector( <right / 2, down / 2, 0>, rot ))
        //printt(RotateVector( <right, 0, 0>, rot ))
       // printt(RotateVector( <0, down, 0>, rot ))
        RuiTopology_UpdatePos(file.aspectRatioFixTopo, GetCrosshairPos(weapon) - RotateVector( <right / 2, down / 2, 0>, rot ) + RotateVector( file.settings.topoOffset * scale * file.settings.scaleMultiplier, rot ),
            RotateVector( <right, 0, 0>, rot ), RotateVector( <0, down, 0>, rot ) )

        right = (GetScreenSize().height / 9.0) * 16.0 * scale * file.settings.dotScaleMultiplier
        down = GetScreenSize().height * scale * file.settings.dotScaleMultiplier
        xOffset = (GetScreenSize().width - right) / 2
        yOffset = (GetScreenSize().height - down) / 2
        rot = <0,rotation,0>

        RuiTopology_UpdatePos(file.aspectRatioFixTopoDot, GetCrosshairPos(weapon) - RotateVector( <right / 2, down / 2, 0>, rot ),
            RotateVector( <right, 0, 0>, rot ), RotateVector( <0, down, 0>, rot ) )

        //if (ratio - 1 != 0)
        //    ratio /= 1 / ratio - 1
        // 0.75 is camera recoil if viewkick_XXX_weaponFraction is 0.25
        // we need to convert that 0.75 to 0.25
        // 1 / 0.25 = 4
        // 4 - 1 = 3
        Crosshair_SetState( CROSSHAIR_STATE_HIDE_ALL )

        float spread = /*(deg_sin(*/(weapon.GetAttackSpreadAngle() * file.settings.spreadMultiplier) // fov * 90)) 

        bool isChargeWeapon = weapon.IsChargeWeapon() || file.settings.chargeFracIsHeat
        float chargeFrac = 0.0
        float ammoFrac = float(weapon.GetWeaponPrimaryClipCount()) / weapon.GetWeaponPrimaryClipCountMax()
        if (player.GetSharedEnergyTotal() > 0)
        {
            chargeFrac = float( player.GetSharedEnergyCount() ) / float( player.GetSharedEnergyTotal() )
        }
        if (file.settings.chargeFracIsHeat) {
            chargeFrac = 1.0 - ammoFrac
            if (ammoFrac < 0.2 && Time() % 0.1 < 0.05) chargeFrac = 0.0
        }
        if (weapon.IsChargeWeapon()) chargeFrac = weapon.GetWeaponChargeFraction()

        vector rainbow = HSBToRGB(<Time() * 180, 100, 100>)
        if (file.rui != null)
        {
            RuiSetFloat( file.rui, "adjustedSpread", GetAdjustedSpread(spread) * inverseScale - 0.015 + file.settings.spreadOffset)
            RuiSetFloat( file.rui, "crosshairMovementX", file.settings.crosshairMovement.x )
            RuiSetFloat( file.rui, "crosshairMovementY", file.settings.crosshairMovement.y )

            if (file.settings.setADSFrac)
                RuiSetFloat( file.rui, "adsFrac", player.GetZoomFrac() )
            else RuiSetFloat( file.rui, "adsFrac", 0.0 )

            RuiSetBool( file.rui, "isSprinting", player.IsSprinting() && !weapon.GetWeaponSettingBool( eWeaponVar.crosshair_force_sprint_fade_disabled ) )
            RuiSetBool( file.rui, "isReloading", weapon.IsReloading() || file.posOutOfView )
            TryRuiSetBool( file.rui, "isFiring", false )
            RuiSetFloat3( file.rui, "teamColor", rainbow )
            if (weapon.IsChargeWeapon())
            {
                RuiSetFloat3( file.rui, "teamColor", <(1 - chargeFrac),1,1> )
                TryRuiSetFloat( file.rui, "chargeFrac", chargeFrac )
            }
        }


        if (file.dot != null)
        {
            RuiSetFloat( file.dot, "adjustedSpread", 200 )
            RuiSetFloat( file.dot, "crosshairMovementX", 0.0 )
            RuiSetFloat( file.dot, "crosshairMovementY", 0.0 )
            RuiSetBool( file.dot, "isReloading", file.posOutOfView )
            RuiSetFloat3( file.dot, "teamColor", rainbow )
            if (weapon.IsChargeWeapon())
                RuiSetFloat3( file.dot, "teamColor", <(1 - chargeFrac),1,1> )
        }

        if (file.settings.dotEnabled >= eDotEnabled.CustomDot)
        {
            foreach (var rui in custCrosshair.outlines)
            {
                RuiSetFloat( rui, "basicImageAlpha", 0.6 * (1.0 - player.GetZoomFrac()) )
                RuiSetFloat3( rui, "basicImageColor", <0,0,0> )
            }
            foreach (var rui in custCrosshair.ruis)
            {
                RuiSetFloat(rui, "basicImageAlpha", 0.9 * (1.0 - player.GetZoomFrac()))
                RuiSetFloat3( rui, "basicImageColor", <0,1,0> )
                if (isChargeWeapon && forceNoCharge && !file.settings.chargeFracIsHeat)
                    RuiSetFloat3( rui, "basicImageColor", <(1 - chargeFrac),1,1> )
                else if (isChargeWeapon && forceNoCharge)
                    RuiSetFloat3( rui, "basicImageColor", <1,(1 - chargeFrac),(1 - chargeFrac)> )
            }
            
            float spreadX = file.settings.horizontalSpreadOverride == -1 ? (spread * file.settings.spreadMultiplier + file.settings.spreadOffset) : file.settings.horizontalSpreadOverride
            float spreadY = file.settings.verticalSpreadOverride == -1 ? (spread * file.settings.spreadMultiplier + file.settings.spreadOffset) : file.settings.verticalSpreadOverride

            //printt(spreadX,spreadY)

            float adjSpreadPixelsX = GetAdjustedSpread(spreadX) * GetScreenSize().height / 2
            float adjSpreadPixelsY = GetAdjustedSpread(spreadY) * GetScreenSize().height / 2

            float dotThickness = 1
            float length = 10
            if (file.settings.length != -1.0)
                length = file.settings.length
            
            float crosshairGap = 1
            float minThicknessX = dotThickness + adjSpreadPixelsX
            float minThicknessY = dotThickness + adjSpreadPixelsY


            switch (file.settings.dotEnabled)
            {
                case eDotEnabled.CustomNoDot:
                    RuiSetFloat( custCrosshair.dot[1], "basicImageAlpha", 0.0 )
                    RuiSetFloat( custCrosshair.dot[3], "basicImageAlpha", 0.0 )
                    break
                case eDotEnabled.CustomHoriz:
                    RuiSetFloat( custCrosshair.bottom[1], "basicImageAlpha", 0.0 )
                    RuiSetFloat( custCrosshair.bottom[3], "basicImageAlpha", 0.0 )
                    minThicknessY = dotThickness + adjSpreadPixelsY * 2 + crosshairGap
                case eDotEnabled.CustomT:
                    RuiSetFloat( custCrosshair.top[1], "basicImageAlpha", 0.0 )
                    RuiSetFloat( custCrosshair.top[3], "basicImageAlpha", 0.0 )
                    break
                case eDotEnabled.CustomPulseBlade:
                    RuiSetFloat( custCrosshair.top[1], "basicImageAlpha", 0.0 )
                    RuiSetFloat( custCrosshair.top[3], "basicImageAlpha", 0.0 )
                    RuiSetFloat( custCrosshair.left[1], "basicImageAlpha", 0.0 )
                    RuiSetFloat( custCrosshair.left[3], "basicImageAlpha", 0.0 )
                    RuiSetFloat( custCrosshair.right[1], "basicImageAlpha", 0.0 )
                    RuiSetFloat( custCrosshair.right[3], "basicImageAlpha", 0.0 )
                    adjSpreadPixelsY = crosshairGap + 2
                    adjSpreadPixelsX = crosshairGap + 2
                    break
            }
            //printt(adjSpreadPixelsX,adjSpreadPixelsY)


            float thicknessX = min(1, minThicknessY)
            float thicknessY = min(1, minThicknessX)
            
            if (file.settings.thicknessX != -1)
                thicknessX = min( file.settings.thicknessX, minThicknessX )
            if (file.settings.thicknessY != -1)
                thicknessY = min( file.settings.thicknessY, minThicknessY )
            

            adjSpreadPixelsX += crosshairGap
            adjSpreadPixelsY += crosshairGap

            float outlineThickness = 1
            float dotOutlineThickness = dotThickness + outlineThickness * 2
            float outlineTotalThicknessX = thicknessX + outlineThickness * 2
            float outlineTotalThicknessY = thicknessY + outlineThickness * 2
            float outlineLength = length + outlineThickness * 2
            //printt(outlineTotalThicknessX,outlineTotalThicknessY)


            vector crosshairPos = GetCrosshairPos(weapon)

            vector origin = crosshairPos
            float fill = 1.0
            if (isChargeWeapon && !forceNoCharge) fill = chargeFrac

           
            
            // Dot

            RuiTopology_UpdatePos( custCrosshair.dot[0], origin - <dotOutlineThickness / 2, dotOutlineThickness / 2, 0>, <dotOutlineThickness, 0, 0>, <0, dotOutlineThickness, 0> )
            RuiTopology_UpdatePos( custCrosshair.dot[2], origin - <dotThickness / 2, dotThickness / 2, 0>, <dotThickness, 0, 0>, <0, dotThickness, 0> )

            if (thicknessX > length)
            {
                // Left
                RuiTopology_UpdatePos( custCrosshair.left[0], origin - <dotOutlineThickness / 2 + outlineLength + adjSpreadPixelsX, outlineTotalThicknessX / 2, 0>, 
                    <outlineLength, 0, 0>, <0, outlineTotalThicknessX, 0> )
                RuiTopology_UpdatePos( custCrosshair.left[2], origin - <dotOutlineThickness / 2 + outlineLength - outlineThickness + adjSpreadPixelsX, thicknessX / 2 - thicknessX * (1-fill), 0>, 
                    <length, 0, 0>, <0, thicknessX * fill, 0> )
                // Right
                RuiTopology_UpdatePos( custCrosshair.right[0], origin - < -dotOutlineThickness / 2 - adjSpreadPixelsX, outlineTotalThicknessX / 2, 0>, <outlineLength, 0, 0>, 
                    <0, outlineTotalThicknessX, 0> )
                RuiTopology_UpdatePos( custCrosshair.right[2], origin - < -dotOutlineThickness / 2 - outlineThickness - adjSpreadPixelsX, thicknessX / 2 - thicknessX * (1-fill), 0>, <
                    length, 0, 0>, <0, thicknessX * fill, 0> )
            }
            else 
            {
                // Left
                RuiTopology_UpdatePos( custCrosshair.left[0], origin - <dotOutlineThickness / 2 + outlineLength + adjSpreadPixelsX, outlineTotalThicknessX / 2, 0>, 
                    <outlineLength, 0, 0>, <0, outlineTotalThicknessX, 0> )
                RuiTopology_UpdatePos( custCrosshair.left[2], origin - <dotOutlineThickness / 2 + outlineLength - outlineThickness + adjSpreadPixelsX, thicknessX / 2, 0>, 
                    <length * fill, 0, 0>, <0, thicknessX, 0> )
                // Right
                RuiTopology_UpdatePos( custCrosshair.right[0], origin - < -dotOutlineThickness / 2 - adjSpreadPixelsX, outlineTotalThicknessX / 2, 0>, <outlineLength, 0, 0>, 
                    <0, outlineTotalThicknessX, 0> )
                RuiTopology_UpdatePos( custCrosshair.right[2], origin - < -dotOutlineThickness / 2 - outlineThickness - adjSpreadPixelsX - length * (1-fill), thicknessX / 2, 0>, <
                    length * fill, 0, 0>, <0, thicknessX, 0> )
            }
            
            // Top
            RuiTopology_UpdatePos( custCrosshair.top[0], origin - < outlineTotalThicknessY / 2, dotOutlineThickness / 2 + outlineLength + adjSpreadPixelsY, 0>, 
                <outlineTotalThicknessY, 0, 0>, <0, outlineLength, 0> )
            RuiTopology_UpdatePos( custCrosshair.top[2], origin - < thicknessY / 2, dotOutlineThickness / 2 + outlineLength - outlineThickness + adjSpreadPixelsY   , 0>, 
                <thicknessY, 0, 0>, <0, length * fill, 0> )
            // Bottom
            RuiTopology_UpdatePos( custCrosshair.bottom[0], origin - < outlineTotalThicknessY / 2, -dotOutlineThickness / 2 - adjSpreadPixelsY, 0>, 
                <outlineTotalThicknessY, 0, 0>, <0, outlineLength, 0> )
            RuiTopology_UpdatePos( custCrosshair.bottom[2], origin - < thicknessY / 2, -dotOutlineThickness / 2 - outlineThickness - adjSpreadPixelsY - length * (1-fill), 0>, 
                <thicknessY, 0, 0>, <0, length * fill, 0> )
        }
        else
        {
            foreach (var rui in custCrosshair.outlines)
                RuiSetFloat(rui, "basicImageAlpha", 0.0 )
            foreach (var rui in custCrosshair.ruis)
                RuiSetFloat(rui, "basicImageAlpha", 0.0 )
        }
    }
}

vector function HSBToRGB(vector hsb) {
    float h = hsb.x
    float s = hsb.y
    float b = hsb.z
    s /= 100;
    b /= 100;
    float functionref(float) k = float function(float n) : (h, s, b) {
        return (n + h / 60) % 6
    } 
    float functionref(float) f = float function(float n) : (h, s, b, k) {
        return b * (1 - s * max(0, min(1, min(k(n), 4 - k(n)))))
    }
    return <f(5), f(3), f(1)>;
}

void function TryRuiSetBool( var rui, string arg, bool val )
{
    try
    {
        RuiSetBool( rui, arg, val )
    }
    catch (ex)
    {

    }
}

void function TryRuiSetFloat( var rui, string arg, float val )
{
    try
    {
        RuiSetFloat( rui, arg, val )
    }
    catch (ex)
    {

    }
}

void function TryRuiSetInt( var rui, string arg, int val )
{
    try
    {
        RuiSetInt( rui, arg, val )
    }
    catch (ex)
    {

    }
}

void function TryRuiSetFloat2( var rui, string arg, vector val )
{
    try
    {
        RuiSetFloat2( rui, arg, val )
    }
    catch (ex)
    {

    }
}

void function TryRuiSetFloat3( var rui, string arg, vector val )
{
    try
    {
        RuiSetFloat3( rui, arg, val )
    }
    catch (ex)
    {

    }
}

void function DisableCrosshair()
{
    wait 0.25
    //SetCrosshairPriorityState( 5, CROSSHAIR_STATE_HIDE_ALL )
}

const float SIM_DELTA = 0.001
array<string> noGravWeapons = [
    "mp_weapon_smr",
    "mp_titanweapon_flightcore_rockets"
]
vector function GetCrosshairPos(entity weapon = null, bool disablePitchOffset = false)
{
    //array pos = expect array( player.GetCrosshairPos() )

    float pitchOffset = GetLocalViewPlayer().GetActiveWeapon(eActiveInventorySlot.mainHand).GetWeaponSettingFloat( eWeaponVar.projectile_launch_pitch_offset )
    if (GetLocalViewPlayer().CameraAngles().x - pitchOffset * 0.5 < -90.0)
        pitchOffset = (GetLocalViewPlayer().CameraAngles().x + 90.0) * 2
    //printt(GetLocalViewPlayer().CameraAngles().x, pitchOffset)
    if (disablePitchOffset)
        pitchOffset = 0

    vector crosshairPos = GetLocalViewPlayer().CameraPosition() + GetLocalViewPlayer().GetActiveWeapon(eActiveInventorySlot.mainHand).GetAttackDirection() * 500
    
    array pos = expect array( Hud.ToScreenSpace( crosshairPos ) )


    vector result = <float( pos[0] ), float( pos[1] ), 0 >
    return result
}

float function GetAdjustedSpread(float spread)
{
    //array pos = expect array( player.GetCrosshairPos() )
    
    float pitchOffset = GetLocalViewPlayer().GetActiveWeapon(eActiveInventorySlot.mainHand).GetWeaponSettingFloat( eWeaponVar.projectile_launch_pitch_offset )
    if (GetLocalViewPlayer().CameraAngles().x - pitchOffset * 0.5 < -89.0)
        pitchOffset = (GetLocalViewPlayer().CameraAngles().x + 89.0) * 2
    array pos = expect array( Hud.ToScreenSpace( GetLocalViewPlayer().CameraPosition() + AnglesToForward( 
        AnglesCompose( VectorToAngles( GetLocalViewPlayer().GetActiveWeapon(eActiveInventorySlot.mainHand).GetAttackDirection() ), < -spread, 0, 0> ) 
    ) * 500 ) )

    vector crosshairPos = GetCrosshairPos(null, true)

    float result = fabs(crosshairPos.y - float( pos[1] )) / GetScreenSize().height
    return result
}

vector function WorldToScreenPos( vector position )
{
    array pos = expect array( Hud.ToScreenSpace( position ) )

    vector result = <float( pos[0] ), float( pos[1] ), 0 >
    return result
}

void function ChangeCrosshairIfNeeded( entity weapon )
{
    asset crosshair = $""

    CrosshairSettings settings
    switch (weapon.GetWeaponClassName())
    {
        case "mp_weapon_mastiff":
            crosshair = $""
            settings.dotEnabled = eDotEnabled.CustomHoriz
            settings.horizontalSpreadOverride = GraphCapped( weapon.GetWeaponOwner().GetZoomFrac(), 0, 1, 7, 3.5 )
            settings.thicknessX = 15
            settings.length = 1
            break
        case "mp_weapon_shotgun":
        case "mp_weapon_energy_shotgun":
            crosshair = $""
            settings.dotEnabled = 2
            settings.thicknessX = 300
            settings.thicknessY = 300
            settings.length = 1
            if (weapon.IsChargeWeapon())
            {
                float spreadChokeFrac = 1.2
                // NOTE uses a switch instead of concatenating the string, so we can search for the same string that is in weaponsettings
                switch( weapon.GetWeaponChargeLevel() )
                {
                    case 1:
                        spreadChokeFrac *= expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_1" ) )
                        break

                    case 2:
                        spreadChokeFrac *= expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_2" ) )
                        break

                    case 3:
                        spreadChokeFrac *= expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_3" ) )
                        break

                    case 4:
                        spreadChokeFrac *= expect float( weapon.GetWeaponInfoFileKeyField( "projectile_spread_choke_frac_4" ) )
                        break

                    default:
                        Assert( false, "chargeLevel " + chargeLevel + " doesn't have matching weaponsetting for projectile_spread_choke_frac_" + chargeLevel )
                }
                settings.spreadMultiplier = spreadChokeFrac
            }
            else settings.spreadMultiplier = 1.5
            break
        case "mp_weapon_shotgun_pistol":
            crosshair = $"ui/crosshair_mozambique.rpak"
            settings.dotEnabled = 0
            settings.rotation = 360.0
            break
            case "mp_weapon_grenade_sonar":
                settings.dotEnabled = eDotEnabled.CustomPulseBlade
                break

        case "mp_weapon_lstar":
            settings.chargeFracIsHeat = true
        case "mp_weapon_pulse_lmg":
        case "mp_weapon_defender":
        //    settings.setADSFrac = false
        //    crosshair = $"ui/crosshair_plus.rpak"
        //    break
            settings.dotScaleMultiplier = GraphCapped( weapon.GetWeaponOwner().GetZoomFrac(), 0, 1, 1, 2 )
            settings.scaleMultiplier = GraphCapped( weapon.GetWeaponOwner().GetZoomFrac(), 0, 1, 0.75, 1.25 )
            crosshair = $""
            settings.crosshairMovement = < -0.5, 0, 0>
            settings.topoOffset = < (GetScreenSize().width * 0.5), 0, 0>
            settings.rotation = 90.0
            settings.dotEnabled = eDotEnabled.CustomHoriz
            settings.spreadOffset = 1.0
            break
        case "mp_weapon_doubletake":
        case "mp_weapon_sniper":
        case "mp_weapon_dmr":
        settings.dotEnabled = 2
            break

        case "mp_weapon_epg":
        case "mp_weapon_softball":
            crosshair = $""
            settings.dotEnabled = 2
            break
        case "mp_weapon_alternator_smg":
        case "mp_weapon_vinson":
            settings.dotEnabled = eDotEnabled.CustomHoriz
            break

        case "mp_weapon_incap_shield":
        case "mp_weapon_melee_survival":
        case "mp_weapon_grenade_emp":
        case "mp_weapon_thermite_grenade":
        case "mp_weapon_frag_grenade":
            crosshair = $""
            settings.dotEnabled = eDotEnabled.CustomHoriz
            settings.spreadMultiplier = 0.0
            break
    }

    if (settings.triEnabled)
    {
        settings.crosshairMovement = < 0, -0.496, 0>
        settings.topoOffset = < 0, (GetScreenSize().height * 0.496), 0>
    }
    if (file.curRuiAsset != crosshair)
    {
        SetNewCrosshair( crosshair )
    }
    if (settings.dotEnabled != 0 && file.dot == null)
    {
        switch (settings.dotEnabled)
        {
            case eDotEnabled.WingmanDot:
                file.dot = RuiCreate( $"ui/crosshair_wingman.rpak", file.aspectRatioFixTopoDot, RUI_DRAW_HUD, 9 )
        }
    }
    else if (settings.dotEnabled == 0 && file.dot != null)
    {
        RuiDestroyIfAlive( file.dot )
        file.dot = null
    }
    file.settings = settings
}

void function SetNewCrosshair( asset rui )
{
    if (file.rui != null) RuiDestroyIfAlive( file.rui )

    if (rui != $"")
        file.rui = RuiCreate( rui, file.aspectRatioFixTopo, RUI_DRAW_HUD, 9)
    else file.rui = null
    file.curRuiAsset = rui
}