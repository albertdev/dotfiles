; Inspired by https://autohotkey.com/board/topic/38931-ignoring-mouse-y-axis/
;
; Further changed to use absolute offsets for multi-monitor use and be restricted
; to current monitor offsets instead of just the primary monitor.
;
CoordMode, Mouse, Screen

; Debugging code
;#Z::
;    ;MouseGetPos, SetX, SetY
;    ;MsgBox % "X: " . SetX . ", Y: " . SetY
;
;    ; Absolute height and width of virtual screen (all monitors)
;    ;SysGet, SetX, 78
;    ;SysGet, SetY, 79
;
;    ;MsgBox % CurrentMonitorOfMouse()
;    CurrentMonitor := CurrentMonitorOfMouse()
;    SysGet, area, Monitor, %CurrentMonitor%
;    MsgBox % CurrentMonitor . ": L" . areaLeft . " R" . areaRight . " T" . areaTop . " B" . areaBottom
;Return


; Zero mouse movement, release cursor after releasing Win key
#Z::
    MouseGetPos, SetX, SetY

    ClipCursor( True, SetX, SetY, SetX, SetY )


    KeyWait, LWin
    KeyWait, RWin

    ClipCursor( False, 0, 0, 0, 0 )

    global Confine
    Confine := False

Return

; Toggle mouse to horizontal movement only
#H::
    global Confine
    Confine := !Confine

    MouseGetPos, , SetY

    CurrentMonitor := CurrentMonitorOfMouse()
    SysGet, area, Monitor, %CurrentMonitor%
    ClipCursor( Confine, areaLeft, SetY, areaRight, SetY )
Return

; Toggle mouse to vertical movement only (mnemonic verTical)
#T::
    global Confine
    Confine := !Confine

    MouseGetPos, SetX,

    CurrentMonitor := CurrentMonitorOfMouse()
    SysGet, area, Monitor, %CurrentMonitor%
    ClipCursor( Confine, SetX, areaTop, SetX, areaBottom )

Return

; Restrict mouse to horizontal movement while Win key is pressed
#C::

    MouseGetPos, , SetY

    CurrentMonitor := CurrentMonitorOfMouse()
    SysGet, area, Monitor, %CurrentMonitor%
    ClipCursor( True, areaLeft, SetY, areaRight, SetY )

    KeyWait, LWin
    KeyWait, RWin

    ClipCursor( False, 0, 0, 0, 0 )

    global Confine
    Confine := False

Return

; Restrict mouse to vertical movement only while Win key is pressed
#V::

    MouseGetPos, SetX, SetY

    CurrentMonitor := CurrentMonitorOfMouse()
    SysGet, area, Monitor, %CurrentMonitor%
    ClipCursor( True, SetX, areaTop, SetX, areaBottom )

    KeyWait, LWin
    KeyWait, RWin

    ClipCursor( False, 0, 0, 0, 0 )

    global Confine
    Confine := False

Return

; ----------------- Specialty stuff ---------------


; Jump to vertical taskbar on primary monitor and move only vertically, then jump back to previous location when Win key is released
; (Mnemonic tAskbar)
#A::
    MouseGetPos, SetX, SetY

    ClipCursor( True, 10, 0, 10, A_ScreenHeight )

    KeyWait, LWin
    KeyWait, RWin

    ClipCursor( False, 0, 0, 0, 0 )

    MouseMove, SetX, SetY, 0

    global Confine
    Confine := False

Return


ClipCursor( Confine=True, x1=0 , y1=0, x2=1, y2=1 ) {

    VarSetCapacity(R,16,0),  NumPut(x1,&R+0),NumPut(y1,&R+4),NumPut(x2,&R+8),NumPut(y2,&R+12)
    Return Confine ? DllCall( "ClipCursor", UInt,&R ) : DllCall( "ClipCursor", UInt, 0 )
}

CurrentMonitorOfMouse() {
    MouseGetPos, posX, posY
    SysGet, numberOfMonitors, MonitorCount
    Loop %numberOfMonitors%
    {
        SysGet, monArea, Monitor, %A_Index%
        ;MsgBox % A_Index . ": L" . monAreaLeft . " R" . monAreaRight . " T" . monAreaTop . " B" . monAreaBottom
        If (posX > monAreaLeft && posX < monAreaRight && posY < monAreaBottom && posY > monAreaTop)
        {
            Return %A_Index%
        }
    }
    ; No monitor matched ?!? Return primary monitor number
    SysGet, primaryNum, MonitorPrimary
    Return primaryNum
}
