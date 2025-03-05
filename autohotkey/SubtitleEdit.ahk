#SingleInstance force
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode 3  ; Exact matching to avoid confusing T/B with Tab/Backspace.

; IfWinActive will make sure that these hotkeys only work within SubtitleEdit

#IfWinActive ahk_exe SubtitleEdit.exe

Media_Play_Pause::
    SendInput ^p
Return

PgUp::
    SendInput ^+e
Return
PgDn::
    SendInput ^e
Return

PrintScreen::
    SendInput +{Enter}
Return
