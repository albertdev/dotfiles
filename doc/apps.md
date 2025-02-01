## General App Preferences

### Notepad++

#### Fonts
Settings > Style Configurator...

Select Global Styles in the "Language" list and then pick "Default Style" in the Style list.

Set the Font to DejaVu Sans Mono, size 9.

### LibreOffice

Options -> LibreOffice -> Security

Click on "Macro Security". Set it to "Medium".

### VLC
(Setting names in RC will be in parentheses.)
Config file on Windows is ~/AppData/Roaming/vlc/vlcrc

- First of all, switch the "Show settings" radiobox to "All".
  Interface > Main interface > Qt: "Show advanced preferences over simple ones" option to make it permanent.
  Also Interface: "Show advanced options"
- Video > Filters > Rotate: Set angle to 180 or whatever is needed. (rotate-angle)
- Interface > Main interface > Qt:
    - Untick "Activate the updates availibility notification". (qt-updates-notif)
    - Untick "Resize interface to the native video size". (qt-video-autoresize)
- Inputs / Codecs > Audio codecs > FluidSynth: Configure soundfont. (soundfont)
- Video: "Show media title on video" turned off. (video-title-show)
- Video > Output modules: Either "Automatic" or "Direct3D9". (vout)
- Playlist: "Use only one instance when started from file manager" can be turned off. (one-instance-when-started-from-file)
- Interface > Hotkeys settings: "Play/Pause, Global column" can be set to Media Play Pause key. (global-key-play-pause)

#### Show subtitles below video:
Based on https://superuser.com/a/1784269 and https://www.vlchelp.com/how-to-change-subtitle-position-in-vlc/ :

- Open advanced settings.
- Click on Filters.
- Tick the "Video cropping filter" checkbox.
- Go to Filters > Cropadd.
- Add 100 pixels to the bottom.

### gitk

Go to ~/.config/git/gitk and change `set selectbgcolor` to `#aad5ff`. The default might be set to `#0078d7` which is a bit dark.

### Password Safe

- System
    - Open database read-only by default 
    - Allow multiple instances
- Misc
    - Escape key closes application
    - Double click action: copy username
    - Shift Double click action: copy password
    - Autotype:
        - Minimize after autotype
        - Default autotype string: `\p`
- Security
    - Clear clipboard upon minimize
    - Clear clipboard upon exit
    - Exclude from clipboard history
    - (Off) Confirm copy of password to clipboard
    - Exclude from screen capture
    - Lock password database
        - (Off) On minimize
        - On workstation lock
    - Unlock difficulty - specific per database

### SubtitleEdit
See custom profiles.

- General
    - Default frame rate: 30
    - Start with last file loaded: Unticked
    - Time code mode: HH:MM:SS.MS
    - Split behavior: Add gap to the left of split point (focus right)
    - Double-clicking line in main window: Go to video position and pause
- Subtitle formats
    - Default format: SubRip
    - Favorites: SubRip, Youtube SBV, WebVTT
- Shortcuts:
    - Leave "Toggle Play/Pause" to default Ctrl+P.
    - Bind Ctrl+Shift+Return to "Merge with next".
    - Unbind "Go To Next Line" and assign Shift+Return to "Go to current line start".
    - Bind "Go to current line end" as Alt+Shift+Return.
    - Unbind "Change casing" and bind Ctrl+Shift+C to "Toggle shot change".
    - Unbind "Auto-translate" (Ctrl+Shift+G).
    - Unbind "Go to subtitle number..." and bind Ctrl+G to "Select next subtitle (from video position, keep video pos)".
    - Unbind "New File" and bind Ctrl+N to "Small selected time forward".
    - Unbind "Renumber" and bind Ctrl+Shift+N to "Small selected time back".
    - Bind "One frame forward" as Ctrl+E.
    - Unbind "Extend selected lines to next subtitle" and bind Ctrl+Shift+E to "One frame back".
    - Unbind "Extend selected lines to previous subtitle" (Alt+Shift+E).
    - Unbind "Save As" and bind Ctrl+Shift+S to "Spell check" only.
    - Unbind "Play from just before" (Shift+F10).
    - Bind "Five seconds forward" as Ctrl+PageDown.
    - Bind "Five seconds back" as Ctrl+PageUp.
    - Bind "Go to next subtitle (from video position)" as Alt+Shift+Down.
    - Bind "Go to previous subtitle (from video position)" as Alt+Shift+Up.
    - Bind "Split line at cursor/video position" as Ctrl+Alt+S.
    - Bind "Set end minus gap, go to next and start next here" as Shift+F12.
    - Bind "Set start and set end of previous (minus min gap)" as Shift+F11.
    - Bind "Set start time, keep duration" as Ctrl+F11.
    - Bind "Unbreak text" as Ctrl+Back(space).
    - Bind "Toggle focus between list view and subtitle text box" as Ctrl+Tab.
    - Change "Vertical zoom in" to Shift+OemPlus.
    - Change "Vertical zoom out" to Shift+OemMinus.
    - Bind (Waveform) "Zoom in" as OemPlus.
    - Bind (Waveform) "Zoom out" as OemMinus.
- Video player
    - Select "mpv" engine
    - Untick "mpv handles preview text" to show text underneath video, and using all 3 possible lines.
    - Untick "Bold" next to the font dropdown.

- Toolbar:
    Make sure these are ticked as Visible, everything else gets unticked:

    - "New"
    - "Open"
    - "Open Video"
    - "Save"
    - "Find"
    - "Replace"
    - "Spell check"
    - "Help"
    - "Toggle list/source view"
    - "Show framerate in toolbar"

- Misc:
    - Don't forget to click on the "Adjust" tab tab next to the waveform, and modify the "Small selected time" to 0,025 instead of "0,500".
      This affects the Ctrl+N shortcut and is useful for precise movement in audio files (where you can't move a single video frame forward because
      there are is no video).
    - Set the video player's volume to 100%, otherwise it starts at 75%
    - In the waveform view, click the "Center" button next to the zoom and play controls.
    - In the waveform view, check the "Select current subtitle when playing" option.
    - Right click on the list view's columns, enable the "Chars/sec" and "Gap" columns.
