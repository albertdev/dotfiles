## Search Engines
Simply see ../searchengines/index.html for scripts to register favourite browser search engines.

## Iridium browser
Chromium port with (allegedly) all the tracking demolished.
### Extensions
- URL in title: great for use with ManicTime. https://chrome.google.com/webstore/detail/url-in-title/ignpacbgnbnkaiooknalneoeladjnfgb
  Configure title as `{title} @@ {protocol}://{hostname}{port}/{path}{hash} @@`
- UBlock Origin: accept no substitute. https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm
### Settings
- Do not save passwords, do not use Auto Sign-In. Do not store payment methods or addresses.
- Cookies: Block third-party cookies in Incognito, Don't clear cookies on exit, Send DNT (as if)
- Security: use Standard protection, no Secure DNS
- Site Settings: ask everything. Content: Block third-party cookies in Incognito, allow some sites to show popups:
    - https://teams.microsoft.com
    - https://outlook.office.com
    - https://outlook.office365.com
- Appearance: Don't show home button, Show the bookmarks bar, default font size and page zoom.
- On startup: Continue where you left off
- Languages: add all those needed, make sure Spellcheck is enabled for them.
- Downloads: always ask.
- System: don't allow running background apps when the browser is closed.

## Palemoon
### Extensions
- LeechBlock 1.0.9 (technically no longer available, installed using Moon Tester Tool?)
- Adblock Latitude, an ad blocker. https://addons.palemoon.org/addon/adblock-latitude/
- Add URL to Window Title v1.03, to work with ManicTime. https://github.com/erichgoldman/add-url-to-window-title
- Developer Tools 1.0.0a1
- Guerilla scripting. https://addons.palemoon.org/addon/guerilla-scripting/
- Moon Tester Tool. https://addons.palemoon.org/addon/moon-tester-tool/
- NoScript, fantastic page breaking utility (the PaleMoon devs hate it for that though). https://noscript.net/getit (see "classic")
- Pentadactyl, Vi-style browsing. https://addons.palemoon.org/addon/pentadactyl-community/
- ScrapBook X, saves pages locally for offline viewing / preserving old content. https://addons.palemoon.org/addon/scrapbook-x/

## Chrome
Only used for development and testing.
### Extensions
- Don't Close Window With Last Tab: name couldn't be more obvious.  https://chrome.google.com/webstore/detail/dont-close-window-with-la/dlnpfhfhmkiebpnlllpehlmklgdggbhn
- Connective Browser Plugin
### Setup for development
In Visual Studio, open the "IIS Express (<Browser>)" dropdown. Click "Browse With..." and wait until the build is done. Now you can click "Add...".

In the new window, give the path to Chrome, e.g. `C:\Program Files (x86)\Google\Chrome\Application\chrome.exe`. As argument use `--auto-open-devtools-for-tabs`.
