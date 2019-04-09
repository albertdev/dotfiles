CoordMode, Mouse, Screen
SetTitleMatchMode, RegEx

;CurrentMonitor := CurrentMonitorOfActiveWindor()
;SysGet, Screen, Monitor, %CurrentMonitor%
;ScreenWidth := ScreenRight - ScreenLeft

Gui, Add, Button, , Done
;Gui, Show, AutoSize Center Minimize ;NoActivate
Gui, Show, AutoSize Center Minimize
Return


; Exit script if helper window gets closed
ButtonDone:
GuiClose:
GuiEscape:

ExitApp

Num0Pressed := 0
NumDotPressed := 0

; Numpad shortcuts for Shift and Control

Numpad1::
NumpadEnd::
    Send {Shift Down}
Return

Numpad1 Up::
NumpadEnd Up::
    Send {Shift Up}
Return

; Mouse clicks

*Numpad0::
    if (Num0Pressed = 0)
    {
        Click, Down
        Num0Pressed := 1
    }
Return
*Numpad0 Up::
        Click, Up
        Num0Pressed := 0
Return

*NumpadDel::
*NumpadDot::
    if (NumDotPressed = 0)
    {
        Click, Down, Right
        NumDotPressed := 1
    }
Return
*NumpadDel Up::
*NumpadDot Up::
    Click, Up, Right
    NumDotPressed := 0
Return

; Scroll wheel

*NumpadAdd Up::
    Click, WheelUp
Return
*NumpadSub Up::
    Click, WheelDown
Return

; Scroll wheel with Ctrl pressed at same time

*Numpad7 Up::
*NumpadHome Up::
    Send {LControl Down}
    Click, WheelDown
    Send {LControl Up}
Return
*Numpad9 Up::
*NumpadPgUp Up::
    Send {LControl Down}
    Click, WheelUp
    Send {LControl Up}
Return

; Moving mouse

*Numpad4::
*NumpadLeft::
    dist := -10
    if (GetKeyState("Shift", "P")) {
        dist *= 3
    } else if (GetKeyState("Control", "P")) {
        dist *= 0.5
    }
    MouseMove, %dist%, 0, 0, R
Return
*Numpad6::
*NumpadRight::
    dist := 10
    if (GetKeyState("Shift", "P")) {
        dist *= 3
    } else if (GetKeyState("Control", "P")) {
        dist *= 0.5
    }
    MouseMove, %dist%, 0, 0, R
Return

*Numpad8::
*NumpadUp::
    dist := -10
    if (GetKeyState("Shift", "P")) {
        dist *= 3
    } else if (GetKeyState("Control", "P")) {
        dist *= 0.5
    }
    MouseMove, 0, %dist%, 0, R
Return

*Numpad5::
*NumpadClear::
    dist := 10
    if (GetKeyState("Shift", "P")) {
        dist *= 3
    } else if (GetKeyState("Control", "P")) {
        dist *= 0.5
    }
    MouseMove, 0, %dist%, 0, R
Return



; [TODO] Adapted from mouse code, doesn't seem to work. Maybe maximized windows are bigger than screen
CurrentMonitorOfActiveWindor() {
    WinGetActiveStats, winTitle, winW, winH, winX, winY
    centerX := (winW / 2) + winX
    centerY := (winH / 2) + winY
    ;MsgBox % "CX" . centerX . " CY" . centerY . " W" . winW . " H" . winH . " X" . winX . " Y" . winY

    SysGet, numberOfMonitors, MonitorCount
    Loop %numberOfMonitors%
    {
        SysGet, monArea, Monitor, %A_Index%
        If (centerX >= monAreaLeft && centerX <= monAreaRight && centerY <= monAreaBottom && centerY >= monAreaTop)
        {
            ;MsgBox % A_Index . ": L" . monAreaLeft . " R" . monAreaRight . " T" . monAreaTop . " B" . monAreaBottom
            Return %A_Index%
        }
    }
    ; No monitor matched ?!? Return primary monitor number
    SysGet, primaryNum, MonitorPrimary
    Return primaryNum
}





; Copied (and modified) from https://autohotkey.com/board/topic/70490-print-array/#entry492815

PrintArray(Array, Level=0)
{
    Global PrintArray

    Loop, % 4 + (Level*8)
        Tabs .= A_Space

    Output := "Array`r`n" . SubStr(Tabs, 5) . "(" 

    For Key, Value in Array
    {
        If (IsObject(Value))
        {
            Level++
            Value := PrintArray(Value, Level)
            Level--
        }

        Output .= "`r`n" . Tabs . "[" . Key . "] => " . Value
    }

    Output .= "`r`n" . SubStr(Tabs, 5) . ")"


    Return Output
}
