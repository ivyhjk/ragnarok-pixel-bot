; @autoloot item 747
; @autoloot item 748
; @autoloot rate 1
DoubleStrafing := 1
Fly := "F1"
TotalArrows := 100
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
WarpToHome := "!1"
; Healer NPC position.
HealerPixelX := 599
HealerPixelY := 383
; Warper NPC position.
WarperPixelX := 599
WarperPixelY := 286
; Shop NPC position.
ShopPixelX := 597
ShopPixelY := 489
ShopInitialBuyButtonPixelX := 716
ShopInitialBuyButtonPixelY := 609
ShopScrollDownPixelX := 305
ShopScrollDownPixelY := 478
ShopScrollDownTotal := 4
ShopFlyWingsPixelX := 282
ShopFlyWingsPixelY := 468
ShopFlyWingsDropPixelX := 370
ShopFlyWingsDropPixelY := 400
ShopFinalBuyButtonPielX := 513
ShopFinalBuyButtonPielY := 507

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


; ##############
; # Arrow shop #
; ##############
ArrowShopGo := "!0"
ArrowShopGoDownPixelX := 684
ArrowShopGoDownPixelY := 543
ArrowShopNPCPixelX := 800
ArrowShopNPCPixelY := 504
ArrowShopBuyStartButtonPixelX := 714
ArrowShopBuyStartButtonPixelY := 612
ArrowShopBuyScrollDownPixelX := 304
ArrowShopBuyScrollDownPixelY := 484
ArrowShopScrollDownTotal := 3
ArrowShopWindArrowPixelX := 160
ArrowShopWindArrowPixelY := 466
ArrowShopDropPixelX := 415
ArrowShopDropPixelY := 436
ArrowShopBuyEndButtonPixelX := 505
ArrowShopBuyEndButtonPixelY := 507

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
        Sleep 600
        PixelSearch, PixelX, PixelY, 2, 192, A_ScreenWidth, A_ScreenHeight, %Color%, 3, Fast

        ; Pixel not found.
        if PixelX =
        {
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
    CheckInventoryFlyWings()
    Fly()
}

c::
InventoryArrows := 0
CheckForWindArrows()

CheckForWindArrows()
{
    global

    ; Has arrows into inventory, do nothing
    if (InventoryArrows > 0) {
        return
    }

    Send %ArrowShopGo% ; Go to arrow's shop map.
    Sleep 1000 ; Wait for annimation.
    Click, %ArrowShopGoDownPixelX%, %ArrowShopGoDownPixelY%
    Sleep 2000 ; Wait for movement.
    ; Click on NPC
    Click, %ArrowShopNPCPixelX%, %ArrowShopNPCPixelY%
    Sleep 300 ; Wait for NPC display menu.
    ; Click on "buy" button.
    Click, %ArrowShopBuyStartButtonPixelX%, %ArrowShopBuyStartButtonPixelY%
    Sleep 300 ; Wait for NPC display menu.
    ; Click on scroll down.
    Loop, %ArrowShopScrollDownTotal% {
        Click, %ArrowShopBuyScrollDownPixelX%, %ArrowShopBuyScrollDownPixelY%
        Sleep 200 ; Wait for scroll down refresh.
    }

    ; Drag and drop wind arrows.
    MouseClickDrag, Left, ArrowShopWindArrowPixelX, ArrowShopWindArrowPixelY, ArrowShopDropPixelX, ArrowShopDropPixelY, 100

    SendEvent, %TotalArrows% ; Add N fly wings to purchase.
    Send, {Enter}
    Click, %ArrowShopBuyEndButtonPixelX%, %ArrowShopBuyEndButtonPixelY%
    Sleep 200 ; Wait for menu fade out.
    ; Fill our inventory with fly wings
    InventoryArrows := TotalArrows
    Sleep 200 ; Wait for annimation.
    WarpToHome()
    Sleep 400 ; Wait for warp.
    WarpToDungeon()
    Sleep 400 ; Wait for warp.
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

    Send !1 ; Warp to home.
    Sleep 700 ; Wait for warp.
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

; Check if the inventory contains "Fly wings",
; if not, warp to home, click the Shop NPC, go
; down into the NPC menu, drag and drop the fly wings
; enter the quantity of fly wings to buy, press the
; buy button and continue our travel.
CheckInventoryFlyWings()
{
    global

    ; If we have fly wings, do nothing.
    if (InventoryFlyWings) {
        return
    }

    WarpToHome() ; Go home.
    Sleep 300 ; Wait for warp
    Click, %ShopPixelX%, %ShopPixelY% ; Click the Shop NPC.
    Sleep 300 ; Wait for NPC response.
    ; Click the "buy" button
    Click, %ShopInitialBuyButtonPixelX%, %ShopInitialBuyButtonPixelY%
    Sleep 300 ; Wait for NPC display menu.

    ; Click on scroll down
    Loop, %ShopScrollDownTotal% {
        Click, %ShopScrollDownPixelX%, %ShopScrollDownPixelY%
        Sleep 200 ; Wait for scroll down refresh.
    }

    ; Drag and drop fly wings.
    MouseClickDrag, Left, ShopFlyWingsPixelX, ShopFlyWingsPixelY, ShopFlyWingsDropPixelX, ShopFlyWingsDropPixelY, 20

    SendEvent, %TotalFlyWings% ; Add N fly wings to purchase.
    Send, {Enter}
    Click, %ShopFinalBuyButtonPielX%, %ShopFinalBuyButtonPielY%
    Sleep 200 ; Wait for menu fade out.
    ; Fill our inventory with fly wings
    InventoryFlyWings := TotalFlyWings
    Buf() ; Buf our character.
    WarpToDungeon() ; Go back to dungeon.
}
