#SingleInstance force
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode 3  ; Exact matching to avoid confusing T/B with Tab/Backspace.

#Enter::
    WinGet MX, MinMax, A
    If MX
        WinRestore A
    Else
        WinMaximize A
Return

#Tab::
    WinGet MX, MinMax, A
    If MX == -1
	WinRestore A
    Else
        WinMinimize A
Return