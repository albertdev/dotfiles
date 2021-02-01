## Developer Settings
Just search in Settings for "Developer" or pop `ms-settings:developers` into Windows' Run dialog. That settings page shows some of the most frequent
things to change, at which point you can simply click "Apply".

(BTW: a list of settings URLs can be found at https://docs.microsoft.com/en-us/windows/uwp/launch-resume/launch-settings-app#ms-settings-uri-scheme-reference )

## UWP App Shortcuts
- Open Windows' `Run` dialog. Enter `shell:appsFolder`.
- Right click an UWP app and press "Create shortcut"
- Windows will say that no shortcut can be created in the current location but it can be sent to the Desktop. Click Yes.
- Go to the Desktop folder and move the created shortcut.
- In case one wants to script this then you need to find the app id. To do this, open the 'lnk' file with HXD and look for a program id with a `!` character.
- The homemaker.toml file has a few examples of scripts to create such shortcuts. There seems to be more at https://stackoverflow.com/q/38359492

## Accessibility Settings
While I'm sure these settings are nice for some people, having keys which reconfigure Windows by repeated or long pressing a key are troublesome.
Here's how to disable them.

- Open Windows' `Run` dialog.
- Enter `ms-settings:easeofaccess-keyboard`
- Disable all the "activation key" settings

## Language Switching Keys
The language bar has global keyboard shortcuts to switch the currently active language. Normally one might actively do this using `Win` + `Space`, but
these global shortcuts are defined as e.g. `Left Alt` + `Shift` or `Left Control` + `Shift`.

To change it, either:
- Open settings, go to Devices, in the sidebar pick Typing, scroll down and click "Advanced keyboard settings". On the new screen click "Input
  language hotkeys" to open an entire new dialog with the shortcuts.
- Alternatively just pop `Rundll32 Shell32.dll,Control_RunDLL input.dll,,{C07337D3-DB2C-4D0B-9A93-B722A6C106E2}` into Window's Run dialog and go to
  the "Advanced Key Settings" tab.

Once there you can pick an item from the list and click "Change Key Sequence". Don't forget to press OK twice.
