#InstallKeybdHook
#UseHook
#SingleInstance force

SetKeyDelay, -1
SetMouseDelay, -1

#MaxHotkeysPerInterval 500

;
; Utility script to turn numpad into a virtual mouse with shortcuts for ManicTime
;

CoordMode, Mouse, Screen
SetTitleMatchMode, RegEx


MouseLeftPressed := 0
MouseRightPressed := 0
MouseMiddlePressed := 0

FastButtonPressed := 0
SlowButtonPressed := 0

IsNavScrollMode := 0

ScrollButton := 0
ScrollRate := 250

MouseButtonsPressed := {}
MouseMoveRate := 50

ScreenshotsRaised := 0

; Start ManicTime focus watcher timer
SetTimer, WinFocusLoop, 500

;;
;; End of auto-execute
;;
Return



; IfWinActive will make sure that these hotkeys only work within ManicTime!

#IfWinActive ahk_exe ManicTimeClient.exe


; Numpad shortcuts which will increase / decrease the mouse or scroll speed.

*Numpad1::
*NumpadEnd::
    FastButtonPressed := 1
Return

*Numpad1 Up::
*NumpadEnd Up::
    FastButtonPressed := 0
Return

*Numpad3::
*NumpadPgDn::
    SlowButtonPressed := 1
Return

*Numpad3 Up::
*NumpadPgDn Up::
    SlowButtonPressed := 0
Return


; These buttons trigger shortcuts in ManicTime 
; Move to previous day
*NumpadDiv:: F7
; Move to next day
*NumpadMult:: F8
; Submit current dialog
*NumpadEnter::
    Send {Ctrl Down}
    Send {Enter}
    Send {Ctrl Up}
Return


; Mouse clicks

*Numpad0::
    if (MouseLeftPressed = 0)
    {
        Click, Down
        MouseLeftPressed := 1
    }
Return

*Numpad0 Up::
        Click, Up
        MouseLeftPressed := 0
Return

*NumpadDel::
*NumpadDot::
    if (MouseRightPressed = 0)
    {
        Click, Down, Right
        MouseRightPressed := 1
    }
Return

*NumpadDel Up::
*NumpadDot Up::
    Click, Up, Right
    MouseRightPressed := 0
Return

*Numpad2::
*NumpadDown::
    if (MouseMiddlePressed = 0)
    {
        Click, Down, Middle
        MouseMiddlePressed := 1
    }
Return

*Numpad2 Up::
*NumpadDown Up::
    Click, Up, Middle
    MouseMiddlePressed := 0
Return

; Scroll wheel

*NumpadAdd::
    If (ScrollButton <> 0) {
        Return
    }
    ScrollButton := "WheelUp"
    SetTimer, DoScrolling, %ScrollRate%
    GoSub, DoScrolling
Return

*NumpadSub::
    If (ScrollButton <> 0) {
        Return
    }
    ScrollButton := "WheelDown"
    SetTimer, DoScrolling, %ScrollRate%
    GoSub, DoScrolling
Return

*NumpadAdd Up::
*NumpadSub Up::
    SetTimer, DoScrolling, Off
    ScrollButton := 0
Return

DoScrolling:
    NewRate := ScrollRate
    if (GetKeyState("Shift", "P") || FastButtonPressed = 1) {
        NewRate := 125
    } else if (GetKeyState("Control", "P") || SlowButtonPressed = 1) {
        NewRate := 500
    } else {
        NewRate := 250
    }
    If (NewRate <> ScrollRate) {
        ScrollRate := NewRate
        SetTimer,, %ScrollRate%
    }
    If (IsNavScrollMode <> 0) {
        SendInput {LControl Down}
    }
    Click, %ScrollButton%

    If (IsNavScrollMode <> 0) {
        SendInput {LControl Up}
    }
Return

; Scroll wheel with Ctrl pressed at same time

*Numpad7::
*NumpadHome::
    If (ScrollButton <> 0) {
        Return
    }
    ScrollButton := "WheelDown"
    IsNavScrollMode := 1
    SetTimer, DoScrolling, %ScrollRate%
    GoSub, DoScrolling
Return

*Numpad9::
*NumpadPgUp::
    If (ScrollButton <> 0) {
        Return
    }
    ScrollButton := "WheelUp"
    IsNavScrollMode := 1
    SetTimer, DoScrolling, %ScrollRate%
    GoSub, DoScrolling
Return

*Numpad7 Up::
*NumpadHome Up::
*Numpad9 Up::
*NumpadPgUp Up::
    SetTimer, DoScrolling, Off
    IsNavScrollMode := 0
    ScrollButton := 0
Return

;;
;; Moving mouse
;;

*Numpad4::
*NumpadLeft::
    If (MouseButtonsPressed.HasKey("Left")) {
        Return
    }
    MouseButtonsPressed["Left"] := 1
    MouseButtonsPressed.Delete("Right")
    SetTimer, DoMouseMove, %MouseMoveRate%
    GoSub, DoMouseMove
Return

*Numpad6::
*NumpadRight::
    If (MouseButtonsPressed.HasKey("Right")) {
        Return
    }
    MouseButtonsPressed["Right"] := 1
    MouseButtonsPressed.Delete("Left")
    SetTimer, DoMouseMove, %MouseMoveRate%
    GoSub, DoMouseMove
Return

*Numpad8::
*NumpadUp::
    If (MouseButtonsPressed.HasKey("Up")) {
        Return
    }
    MouseButtonsPressed["Up"] := 1
    MouseButtonsPressed.Delete("Down")
    SetTimer, DoMouseMove, %MouseMoveRate%
    GoSub, DoMouseMove
Return

*Numpad5::
*NumpadClear::
    If (MouseButtonsPressed.HasKey("Down")) {
        Return
    }
    MouseButtonsPressed["Down"] := 1
    MouseButtonsPressed.Delete("Up")
    SetTimer, DoMouseMove, %MouseMoveRate%
    GoSub, DoMouseMove
Return

*Numpad4 Up::
*NumpadLeft Up::
    MouseButtonsPressed.Delete("Left")
Return

*Numpad6 Up::
*NumpadRight Up::
    MouseButtonsPressed.Delete("Right")
Return

*Numpad8 Up::
*NumpadUp Up::
    MouseButtonsPressed.Delete("Up")
Return

*Numpad5 Up::
*NumpadClear Up::
    MouseButtonsPressed.Delete("Down")
Return


DoMouseMove:
    if (MouseButtonsPressed.Count() = 0) {
        ; All buttons released
        SetTimer,, Off
        Return
    }
    distance := 10
    if (GetKeyState("Shift", "P") || FastButtonPressed = 1) {
        distance *= 3
    } else if (GetKeyState("Control", "P") || SlowButtonPressed = 1) {
        distance *= 0.5
    }
    ; Calculate direction (if angled it's using sine / cosine of sqrt(2)/2 )
    distX := 0
    distY := 0
    sineAtAngle := 0.70710678118654752440084436210485
    if (MouseButtonsPressed.HasKey("Right") && MouseButtonsPressed.HasKey("Up")) {
        distX := Round(distance * sineAtAngle)
        distY := Round(distance * sineAtAngle * -1)
    } else if (MouseButtonsPressed.HasKey("Left") && MouseButtonsPressed.HasKey("Up")) {
        distX := Round(distance * sineAtAngle * -1)
        distY := Round(distance * sineAtAngle * -1)
    } else if (MouseButtonsPressed.HasKey("Left") && MouseButtonsPressed.HasKey("Down")) {
        distX := Round(distance * sineAtAngle * -1)
        distY := Round(distance * sineAtAngle)
    } else if (MouseButtonsPressed.HasKey("Right") && MouseButtonsPressed.HasKey("Down")) {
        distX := Round(distance * sineAtAngle)
        distY := Round(distance * sineAtAngle)
    } else if (MouseButtonsPressed.HasKey("Right")) {
        distX := distance
        distY := 0
    } else if (MouseButtonsPressed.HasKey("Up")) {
        distX := 0
        distY := distance * -1
    } else if (MouseButtonsPressed.HasKey("Left")) {
        distX := distance * -1
        distY := 0
    } else if (MouseButtonsPressed.HasKey("Down")) {
        distX := 0
        distY := distance
    }
    MouseMove, %distX%, %distY%, 0, R
Return


;
; Timer handler for ManicTime focus watcher.
; This will make the screenshots window float on top (if open)
;
WinFocusLoop:
    ;ManicWindowActive := WinActive("ManicTime ahk_exe ManicTimeClient.exe")
    ManicWindowActive := WinActive("ahk_exe ManicTimeClient.exe")
    ManicScreenshotWinFound := WinExist("Screenshots ahk_exe ManicTimeClient.exe")

	If (ManicWindowActive && ManicScreenshotWinFound) {
        Winset, Alwaysontop, 1, Screenshots ahk_exe ManicTimeClient.exe
        ScreenshotsRaised := 1
	} else If (ManicScreenshotWinFound) {
        Winset, Alwaysontop, 0, Screenshots ahk_exe ManicTimeClient.exe
        If (ScreenshotsRaised = 1) {
            Winset, Bottom,, Screenshots ahk_exe ManicTimeClient.exe
        }
        ScreenshotsRaised := 0
    }
Return


;
; Utility Methods
;




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
