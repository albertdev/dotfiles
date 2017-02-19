;
; Taken from http://stackoverflow.com/a/9235052/983949
;
#Persistent
SetBatchLines, -1
Process, Priority,, High

Gui +LastFound
hWnd := WinExist()

DllCall( "RegisterShellHookWindow", UInt,hWnd )
MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
OnMessage( MsgNum, "ShellMessage" )
Return

ShellMessage( wParam,lParam )
{
    If ( wParam = 1 ) ;  HSHELL_WINDOWCREATED := 1
    {
        ;WinGetTitle, Title, ahk_id %lParam%
        WinGetClass, wclass, ahk_id %lParam%
	WinGet, procName, ProcessName, ahk_id %lParam%
	
        If  ( wclass = "Vim" || wclass = "Console_2_Main" || wclass = "ConsoleWindowClass" || wclass = "PuTTY" || wclass = "KiTTY" || procName = "sublime_text.exe")
            ;WinClose, ahk_id %lParam% ; close it immideately
            WinMaximize, ahk_id %lParam%
    }
}
