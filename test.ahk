; @autoloot item 747
; @autoloot item 748
; @autoloot rate 1
DelayModifier := 1
DoubleStrafing := "F2"
Fly := "F1"
TotalArrows := 500
TotalFlyWings := 30
Color := 0x00FF00
; If we click the same pixel at least N times, the bot will fly.
MaxTries := 0

; ###########
; # Storage #
; ###########
StorageOpen := "!7"
StoragePixelX := 474
StoragePixelY :=  429
StorageCloseButtonPixelX := 576
StorageCloseButtonPixelY := 567

; #################
; # Own Bufs keys #
; #################
TrueSight := "w"
AttentionConcentrate := "e"
WindWalk := "r"

; #############################################
; # Warp to home, heal and go back to dungeon #
; #############################################
; Binded key with <@go [cityName|cityNumber]>
WarpToHome := "!2"
; Healer NPC position.
; go 6
; HealerPixelX := 599
; HealerPixelY := 383
; go 30
HealerPixelX := 655
HealerPixelY := 327
; Warper NPC position.
; go 6
; WarperPixelX := 599
; WarperPixelY := 286
; go 30
WarperPixelX := 706
WarperPixelY := 333

; ##########
; # SP bar #
; ##########
SPPixelX := 53
SPPixelY := 95
SPEmptyColor := 0xCEC6BD

; ##########
; # HP bar #
; ##########
HPPixelX := 65
HPPixelY := 80
HPEmptyColor := 0xCEC6BD

; PLEASE DON'T EDIT THIS.
InventoryArrows := TotalArrows
InventoryFlyWings := TotalFlyWings
TrueSightTime := 30000 ; 30 seconds.

SetKeyDelay 100, 100

x::
ExitApp

z::
Loop
{
    CurrentTries := 0
    PreviousPixelX := null

    Loop
    {
        ; Check SP and HP bar.
        CheckForBuf()

        ; Search the square initial pixel.
        Sleep 400
        PixelSearch, PixelX, PixelY, 2, 192, A_ScreenWidth, A_ScreenHeight, %Color%, 3, Fast

        ; Pixel not found.
        if ( ! PixelX || ! PixelY){
            break
        }

        if (PreviousPixelX = PixelX) {
            ; No arrows are used.
            ; Inventory arrows contains an stadistic standard error x).
            InventoryArrows := InventoryArrows + 1
            CurrentTries := CurrentTries + 1

            if (CurrentTries > MaxTries) {
                break
            }
        }

        ; Attack.
        Send {%DoubleStrafing%}
        Click, %PixelX%, %PixelY%

        ; One arrow used.
        InventoryArrows := InventoryArrows - 1
        PreviousPixelX := PixelX
    }

    CheckForWindArrows()
    Fly()
}

c::
Buf()

ClickOnImage(ImageName, Width, Height)
{
    ImageSearch, PixelX, PixelY, %Width%, %Height%, A_ScreenWidth, A_ScreenHeight, %ImageName%

    if ( ! PixelX || ! PixelY) {
        throw "No image found"
    }

    X := (PixelX + (Width/4))
    Y := (PixelY + Height)

    Click, %X%, %Y%
}

DragAndDropImageToImage(FromImageName, FromWidth, FromHeight, ToImageName, ToWidth, ToHeight)
{
    global

    delay := 200 * DelayModifier

    Sleep, %delay%
    ImageSearch, FromPixelX, FromPixelY, %FromWidth%, %FromHeight%, A_ScreenWidth, A_ScreenHeight, %FromImageName%

    if ( ! FromPixelX || ! FromPixelY) {
        throw "No FROM image found"
    }

    FromX := (FromPixelX + (FromWidth/4))
    FromY := (FromPixelY + FromHeight/2)

    Sleep, %delay%
    ImageSearch, ToPixelX, ToPixelY, %ToWidth%, %ToHeight%, A_ScreenWidth, A_ScreenHeight, %ToImageName%

    if ( ! ToPixelX || ! ToPixelY) {
        throw "No To image found"
    }

    ToX := (ToPixelX + (ToWidth/4))
    ToY := (ToPixelY + ToHeight+30)

    MouseMove, FromX, FromY
    Sleep, %delay%
    Click, down ; Drag.
    Sleep, %delay%
    MouseMove, ToX, ToY
    Click, up ; Drop.
}

MoveArrowsFromStorageToInventory()
{
    global

    delay := 300*DelayModifier

    Send %StorageOpen% ; Open storage.
    ; Click on tab "Ammo".
    Sleep, %delay%
    try {
        ClickOnImage("storage-ammo.png", 19, 40)
    } catch e {
        return
    }

    ; Drag and drop arrows to inventory.
    Sleep, %delay%
    try {
        DragAndDropImageToImage("arrow.png", 30, 17, "inventory.png", 275, 16)
    } catch e {
        Sleep, %delay%
        ClickOnImage("close-button.png", 33, 16) ; Close the inventory

        return
    }

    Sleep, %delay%
    SendEvent, %TotalArrows% ; Add N arrows to inventory.
    Sleep, %delay%
    Send, {Enter} ; Confirm arrows quantity.
    Sleep, %delay%

    ; Close the inventory
    try {
        ClickOnImage("close-button.png", 33, 16)
    } catch e {
        return
    }

    Sleep, %delay%
}

CheckForWindArrows()
{
    global

    ; Has arrows into inventory, do nothing
    if (InventoryArrows > 0) {
        return
    }

    Delay := 200 * DelayModifier

    WarpToHome()
    Sleep, %Delay%
    MoveArrowsFromStorageToInventory()
    InventoryArrows := TotalArrows
    Sleep, %Delay%
    WarpToDungeon()
    Sleep, %Delay%
}

InventoryToStorage()
{
    global

    ; Open storage
    Send %StorageOpen%

    XModifier := 10
    YModifier := 20

    ImageSearch, RosePixelX, RosePixelY, 28, 19, A_ScreenWidth, A_ScreenHeight, rose.png

    ; Witherless rose was found, move to storage.
    if (ErrorLevel = 0) {
        ; Drag and drop witherless roses from inventory to storage
        MouseClickDrag, Left, RosePixelX+XModifier, RosePixelY+YModifier, StoragePixelX, StoragePixelY, 50
        Sleep 100 ; Wait for annimation
        Send {Enter}
    }

    ImageSearch, MirrorPixelX, MirrorPixelY, 25, 17, A_ScreenWidth, A_ScreenHeight, mirror.png
    ; Crystal mirror was found, move to storage.
    if (ErrorLevel = 0) {
        ; Drag and drop witherless roses from inventory to storage
        MouseClickDrag, Left, MirrorPixelX+XModifier, MirrorPixelY+YModifier, StoragePixelX, StoragePixelY, 50
        Sleep 100 ; Wait for annimation
        Send {Enter}
    }

    Click, %StorageCloseButtonPixelX%, %StorageCloseButtonPixelY% ; Close the storage.
    Sleep 100 ; Wait for annimation
}

; Do a warp to home.
WarpToHome()
{
    global

    Send %WarpToHome% ; Warp to home.
    Sleep 1000 * DelayModifier ; Wait for warp.
}

; Do a warp to the dungeon, from home.
WarpToDungeon()
{
    global
    Click, %WarperPixelX%, %WarperPixelY% ; Click the Warper NPC.
    Sleep 700 ; Wait for warper chat.
    Send {Enter} ; Use the "Last warp" mode.
    Sleep 1000 ; Wait for warp to dungeon.
}

; Just fly using "Fly wings"
Fly()
{
    global
    ; Remove a fly wing from inventory.
    InventoryFlyWings := InventoryFlyWings - 1
    ; Fly
    Send {%Fly%}
    Sleep 300
}

Buf()
{
    global

    Click, %HealerPixelX%, %HealerPixelY% ; Click the Healer NPC.
    Sleep 300 ; Wait for heal.
    Send %TrueSight%
    Sleep 100 ; Wait for cooldown.
    Send %AttentionConcentrate%
    Sleep 100 ; Wait for cooldown.
    Send %WindWalk%
    Sleep 500 ; Wait for cooldown.

    InventoryToStorage()
}

; Check if the HP or SP bar are empty, if are,
; go to home, take bufs from Healer, use the Warper
; and continue our travel.
CheckForBuf()
{
    global
    ; Check SP and HP bar.
    PixelGetColor, CurrentSPColor, SPPixelX, SPPixelY, SPEmptyColor
    PixelGetColor, CurrentHPColor, HPPixelX, HPPixelY, HPEmptyColor

    ; If SP or HP bar are empty, go to home.
    if (CurrentSPColor = SPEmptyColor || CurrentHPColor = HPEmptyColor) {
        WarpToHome()
        Sleep 300 ; Wait for warp
        Buf()
        WarpToDungeon()
    }
}
