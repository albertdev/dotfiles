## General App Preferences

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
    - Time code mode: HH:MM:SS.MS
    - Split behavior: Add gap to the left of split point (focus right)
    - Double-clicking line in main window: Go to video position and pause
- Subtitle formats
    - Default format: SubRip
- Shortcuts:
    (Incomplete)
    - Unbind "Change casing" and bind Ctrl+Shift+C to "Toggle shot change".
    - Unbind "Auto-translate" (Ctrl+Shift+G)
    - Unbind "Go to subtitle line number" and bind Ctrl+G to "Select next subtitle (from video position, keep video pos)"

