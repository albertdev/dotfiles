## Developer Settings
Just search in Settings for "Developer" or pop `ms-settings:developers` into Windows' Run dialog. That settings page shows some of the most frequent
things to change, at which point you can simply click "Apply".

(BTW: a list of settings URLs can be found at https://docs.microsoft.com/en-us/windows/uwp/launch-resume/launch-settings-app#ms-settings-uri-scheme-reference )

## Set keyboard on lock screen
Loosely based on https://superuser.com/a/960889

- Open Windows' `Run` dialog.
- Enter `intl.cpl` to open the "Region" control panel window.
- Go to the "Administrative" tab.
- In the "Welcome screen and new user accounts" you should click "Copy settings".
- Tick the checkboxes and press OK.

## Set default keyboard to Colemak
When adding the Colemak keyboard to the English language, it might still revert to the default QWERTY layout.

On Windows 11 this seems to be hidden. Go to "Time & Language", pick "Typing" and then click "Advanced keyboard settings". That screen has a
combobox underneath the "Override for default input method" label.

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

## Mouse Settings
- Open Windows' `Run` dialog.
- Enter `ms-settings:mousetouchpad`
- Set cursor speed to 12, scroll multiple lines at a time, scroll 9-11 lines each time, scroll when hovering.

## Notification Settings
- Open windows' `Run` dialog.
- Enter `ms-settings:notifications`
- Scroll down to the bottom, open the "Additional Settings" folding and uncheck "Show the Windows welcome experience ..."
  and "Get tips and suggestions when using Windows"

## Taskbar (Windows 10 and earlier 😢)
- Right-click taskbar and select "Taskbar settings".

Settings of note:
- Lock the taskbar, use small taskbar buttons
- Replace command prompt with Windows Powershell
- Taskbar location on screen: Left
- Combine taskbar buttons: Never.
- Multiple displays:
    - Show taskbar on all displays
    - Don't combine there either.
- News and Interests: Turn it off.
- People: Turn that off as well.

## Taskbar (Windows 11's Limited Setup Since 2023 Update)
- Right-click taskbar and select "Taskbar settings".

Settings of note:
- Disable Search by picking the "Hide" option.
- Turn off Widgets.
- Unfold "Other system tray icons":
    - Turn off "Microsoft OneDrive".
- Unfold "Taskbar behaviors":
    - Taskbar alignment: Left
    - Show badges
    - Show flashing
    - Show my taskbar on all displays
    - Select the far corner of the taskbar to show the desktop
    - Combine taskbar buttons and hide labels: Never
    - Combine taskbar buttons and hide labels on other taskbars: Never

## Multiple desktops
Setup a second one by clicking the Task View button on the taskbar.

Run `ms-settings:multitasking` and configure the following settings:

- Snap windows.
  Automatically fill available space, show what can be snapped next to it, auto-resizing
- Virtual desktops:
    - On the taskbar show windows from all desktops
    - Pressing Alt+Tab should show windows from all desktops

~~On that note, run `ms-settings:easeofaccess-display` and scroll down to "Simplify and personalize Windows":
- Disable "Show animations in Windows".
  It might make things more boring by turning off all animations, but the "Switch desktop" animation is annoying IMHO.
- Disable "Automatically hide scroll bars in Windows".
  It's fine if you're using a tablet, but for precise scroll bar adjustments it's just annoying.~~

On that note, run `ms-settings:easeofaccess-visualeffects`: 
- Enable "Always show scrollbars".
- Disable "Animation effects".

## Styling & Personalization

- Run `ms-settings:personalization-background` and pick a solid color background.

- Go to Colors using `ms-settings:personalization-colors`:
    - ~~Use dark Windows mode, light app mode.~~
    - Choose your mode: "Custom"
        - Choose your default Windows mode: Dark.
        - Choose your default app mode: Light.
    - "Show accent color on the following surfaces" only needs "Title bars and window borders"

- Go to Lock screen using `ms-settings:lockscreen`:
    - Choose a picture, turn off Windows Cortana stuff.

## Sleep And Lock Timeouts

Go to `ms-settings:powersleep`: "System > Power & battery"

Unfold "Screen and sleep".

To change advanced settings, run `powercfg.cpl`. Click on "Change plan settings" for the current power plan.
Then click "Change advanced power settings".

## Enabling Hibernate, Changing Power Button Function

From [the Microsoft documentation](https://support.microsoft.com/en-us/windows/shut-down-sleep-or-hibernate-your-pc-2941d165-7d0a-a5e8-c5ad-8c972e8e6eff#ID0EBD=Windows_11):


1. Select Search on the taskbar, type control panel, and select it from the results.

1. Select System and Security.

1. In the Power Options section, select Change what the power buttons do.

1. Select Change settings that are currently unavailable.

1. In the Shutdown settings section, select Hibernate.

1. Select Save changes.

### Disabling automatic suspend / sleep / lock screen on a Lenovo

PC locking itself while ignoring the sleep settings from Windows? It might be a "feature".

Based on https://forums.lenovo.com/t5/ThinkPad-X-Series-Laptops/System-keeps-going-to-sleep-every-30-seconds/m-p/5094181 :

* Open Lenovo Commercial Vantage.
* Find the Device menu and find the "Smart Assist" option.
* There's only one section, "Intelligent Security". **Disable** the "Zero Touch Lock".

Maybe this feature works better when the camera is not closed, but I don't like to feel watched all the time.

## Windows-Specific Config of Miscellaneous Apps
### Console / Command Prompt / Powershell
- Right-click the default Windows Console and pick "Defaults".
- Check the boxes for the following:
  - QuickEdit mode
  - Enable Ctrl key shortcuts
  - Filter clipboard contents on paste
  - Use Ctrl+Shift+C/V as Copy/Paste
  - Enable line wrapping selection
  - Extended text selection keys

### Powershell
Make sure to download v2.1.0 of PSReadline to get newer features like Ctrl+Space completion.
See https://github.com/microsoft/terminal/issues/879 for troubleshooting.

### Slack
One needs to start chocolatey with specific parameters to make sure that Slack auto-starts:
```
choco install slack -y --install-arguments="'INSTALLLEVEL=2'"
```

Also don't forget to pin it using `choco pin add -n slack`; it auto-updates and the MSI installer might remove Windows taskbar pins when choco runs
the MSI file again.

### Intel HD Graphics
- Don't forget to click "Options and Support"
  - On the "Hot Key Manager" tab, Disable "Manage Hot Keys" - the rotation shortcuts are a doozy


## Windows Subsystem for Linux (WSL)

### Reusing git credentials between Windows host and WSL
From [the Microsoft documentation on starting Git on WSL](https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-git#git-credential-manager-setup):

```
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager-core.exe"
```

### Installing a loopback adapter to have a fixed local IP address

The basic trick is to install a fake network adapter.

- Open Device Manager.
- Do "Action" > "Add legacy hardware".
- Continue manually picking hardware. Select the "Network adapters" category.
- Select "Microsoft" and find the "Microsoft KM-TEST Loopback Adapter". Continue.

### Disabling firewall for loopback adapter
Since the loopback adapter is an actual network interface with dummy routing in the kernel it will pass through the firewall (in contrast with
connections to 127.0.0.1 or ::1 which I believe take a shortcut in the kernel).

First, run this to see which adapter is the loopback adapter:

```
Get-NetAdapter | Where-Object {$_.InterfaceDescription -ieq "Microsoft KM-TEST Loopback Adapter" } | Select-Object -Property Name
```

Based on https://superuser.com/a/1583817:

- Open the "Windows Defender Firewall" MSC snapin.
- Open "Windows Defender Firewall Properties" (right-click the root node, or click the link in the center pane).
- For each of the first three tabs you should click the "Customize" button in the State group, labeled "Protected network connections".
- Uncheck the checkbox corresponding to the adapter name of the loopback adapter.

Note that this might issue a warning "Microsoft Defender Firewall is using settings that may make your device unsafe." in the Settings app.

### Binding WSL ports to host IP or loopback adapter
WSL runs a part of Hyper-V in the background (referred to as "Virtual Machine Platform") and each WSL distribution gets its own IP address, which then
sits behind a NAT to access the outside world.

When you start a program listening on a port then WSL will automatically expose that port to the host by binding it to 127.0.0.1 / ::1 (well, in most
cases, see next section). If you want to reach this service from the outside world then you can setup a port proxy.

See for example https://stackoverflow.com/a/65387586/983949 which links to https://github.com/microsoft/WSL/issues/4150#issuecomment-504209723

These are the most important bit of the script:

````
  iex "netsh interface portproxy delete v4tov4 listenport=$port listenaddress=$addr";
  iex "netsh interface portproxy add v4tov4 listenport=$port listenaddress=$addr connectport=$port connectaddress=$remoteport";
````

The only extra trick is that we can forward to 127.0.0.1 because WSL will often automatically bind that port, even if the most surefire way _is_ to
connect to the distribution's internal IP address (again, see next section).

### Connection Refused errors when connecting from host to WSL
Start e.g. ncat on port 1337 on WSL, then try to connect to it from the host. Sometimes this works, sometimes this doesn't after you rebooted.

[People on Github](https://github.com/microsoft/WSL/issues/4769#issuecomment-667947222) figured out that WSL will sometimes reserve ranges of ports on the host, which then won't be available for automatic forwarding from
the internal WSL network to the host's "localhost". To confirm, run these commands in an elevated terminal:

````
netsh int ipv4 show excludedportrange protocol=tcp
netsh int ipv4 show dynamicport tcp
````

[Others](https://github.com/microsoft/WSL/issues/5306#issuecomment-643603942) figured out that [this might even be a Windows
bug](https://github.com/docker/for-win/issues/3171#issuecomment-554587817) or at least some weird quirk because the dynamic port range is supposed to
start at a rather large number:

https://docs.microsoft.com/en-US/troubleshoot/windows-server/networking/default-dynamic-port-range-tcpip-chang

The easiest way to permanently avoid this problem is thus to update the range of ephemereal / dynamic ports using the following commands:

````
netsh int ipv4 set dynamic tcp start=30000 num=20000
netsh int ipv6 set dynamic tcp start=30000 num=20000
````

## System Tricks

### Unattended sleep timeout
Not sure if this is what's showing the lock screen, but here goes:

https://www.sevenforums.com/tutorials/246364-power-options-add-system-unattended-sleep-timeout-post3256599.html?s=044ca5eb63573e145705cb30cabd164a#post3256599

For Lenovo laptops it's important to check "Smart Assist" in the "Vantage" app as that has a "Human Presence Detection" or "Zero Touch Lock" thing
where it can lock your screen when the computer thinks it is unattended.

### UWP App Shortcuts
- Open Windows' `Run` dialog. Enter `shell:appsFolder`.
- Right click an UWP app and press "Create shortcut"
- Windows will say that no shortcut can be created in the current location but it can be sent to the Desktop. Click Yes.
- Go to the Desktop folder and move the created shortcut.
- In case one wants to script this then you need to find the app id. To do this, open the 'lnk' file with HXD and look for a program id with a `!` character.
- The homemaker.toml file has a few examples of scripts to create such shortcuts. There seems to be more at https://stackoverflow.com/q/38359492

### Disabling Intel HD Screen Dimming
Found instructions on https://mikebattistablog.wordpress.com/2016/05/27/disable-intel-dpst-on-sp4/

Basically open regedit, find the `[HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000]` (or `\0001`)
folder, then edit the `FeatureTestControl` so that the number has its 5th bit set (4th bit if 0-indexed). Reboot and check it again.
