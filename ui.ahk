WindowName := "atom.exe"
shopX := "0000"
shopY := "0000"

; Executable name.
Gui, Font,, Verdana
Gui, Add, Text, x10 y10 w415 h30, % "Executable: " WindowName

; NPCs
Gui, Add, Groupbox, x10 y30 w415 h70, NPCs
Gui, Add, Text, x20 y55, Shop coordinates:
Gui, Add, Text, x130 y55 vShopCoordinatesText, % shopX "," shopY
Gui, Add, Button, x200 y50 gPickShopCoorditates, Pick Shop coordinates

; Display the GUI
Gui, Show, w435 h470, dislike bot

PickShopCoorditates(withInitialMessage := true) {
    MsgBox 64, Information, Press CTRL to obtain the coordinate.

    #IfWinActive, ahk_exe atom.exe
    KeyWait, Control, D
    Mousegetpos, shopX, shopY

    MsgBox 4100, Question, % "Is this the correct position x: " shopX " y: " shopY "?"

    ifMsgBox No
        return PickShopCoorditates(false)

    MsgBox 64, Message, % "x: " shopX " y: " shopY
    GuiControl,, ShopCoordinatesText, % shopX "," shopY
}

GuiClose() {
    MsgBox 4100, Alert, Are you sure you want to close the bot?
    ifMsgBox No
        return true
    else
        ExitApp
}


; ui := new Ui("atom.exe")
; ui.Run()
