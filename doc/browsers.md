## Search Engines
Simply see ../searchengines/index.html for scripts to register favourite browser search engines.

There are a few which are not added in that list though because their URL needs to be completed:

### Azure Devops Pull Request search
- Keyword: `pr`
- `https://dev.azure.com/{organization}/_apis/git/PullRequests/%s`
### JIRA Search
- Keyword: `j`
- `https://{organization}.atlassian.net/secure/QuickSearch.jspa?searchString=%s`

## Firefox
Used instead of Iridium.
### Extensions
- environment-marker: to color-code deployment environments. https://addons.mozilla.org/en-US/firefox/addon/environment-marker/ https://github.com/XjSv/environment-marker
- ManicTime URL extractor: to get info about sites on timeline https://addons.mozilla.org/en-US/firefox/addon/manictime-url-extractor/
- Tampermonkey: to customize websites https://addons.mozilla.org/en-US/firefox/addon/tampermonkey/
### Settings
- app.shield.optoutstudies.enabled : false
- browser.download.useDownloadDir : false
- browser.newtabpage.enabled : false
- browser.newtabpage.activity-stream.showSponsoredTopSites
- browser.startup.homepage : chrome://browser/content/blanktab.html
- browser.startup.page : 3
  (Sets to remember tabs from last time)
- browser.toolbars.bookmarks.visibility : always
- browser.translations.automaticallyPopup : false
- browser.translations.panelShown : true
- Dont't forget to hide the Pocket button in the toolbar

## Iridium browser
Chromium port with (allegedly) all the tracking demolished.
### Extensions
- URL in title: great for use with ManicTime. https://chrome.google.com/webstore/detail/url-in-title/ignpacbgnbnkaiooknalneoeladjnfgb
  Configure title as `{title} @@ {protocol}://{hostname}{port}/{path}{hash} @@`
- UBlock Origin: accept no substitute. https://chrome.google.com/webstore/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm
  Don't forget to use "Manage extension" on it and checking "Allow in Incognito"
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
### Settings
- browser.tabs.closeWindowWithLastTab : false
- browser.shell.checkDefaultBrowser : false
- browser.startup.homepage : about:blank
- browser.startup.page : 3
  (Sets to remember tabs from last time)
- browser.tabs.onTop : true

Settings for extensions:
- noscript.autoReload.allTabs : false
- noscript.firstRunRedirection : false
- noscript.notify : false
- extensions.autt@ericgoldman.name.separatorString : @@
### Extensions
- LeechBlock 1.0.9 (technically no longer available, installed using Moon Tester Tool?)
- Adblock Latitude, an ad blocker. https://addons.palemoon.org/addon/adblock-latitude/
- Add URL to Window Title v1.03, to work with ManicTime. https://github.com/erichgoldman/add-url-to-window-title
- Developer Tools 1.0.0a1
- Pale Moon Web Technologies Polyfill Add-On (Palefill), stops GitHub from breaking. https://github.com/martok/palefill
- Guerilla scripting. https://addons.palemoon.org/addon/guerilla-scripting/
- Moon Tester Tool. https://addons.palemoon.org/addon/moon-tester-tool/
- nMatrix, fantastic page breaking utility. https://addons.palemoon.org/addon/ematrix/
- Pentadactyl, Vi-style browsing. https://addons.palemoon.org/addon/pentadactyl-community/
- ScrapBook X, saves pages locally for offline viewing / preserving old content. https://addons.palemoon.org/addon/scrapbook-x/
### UI Layout
(Right-click e.g. the Reload button, click Customize)

- Tabs on top, PM button top left.
- Leechblock counter, NoScript button, ABL button, Reload, Home, Back / Forward, URL bar, Search bar, History dropdown menu, Downloads.
- Bookmarks bar, (on the right) ScrapBookX button, Bookmarks dropdown menu button (dragged from next to History button)



## Chrome
Only used for development and testing.
### Extensions
- Don't Close Window With Last Tab: name couldn't be more obvious.  https://chrome.google.com/webstore/detail/dont-close-window-with-la/dlnpfhfhmkiebpnlllpehlmklgdggbhn
- Connective Browser Plugin
### Setup for development
In Visual Studio, open the "IIS Express (<Browser>)" dropdown. Click "Browse With..." and wait until the build is done. Now you can click "Add...".

In the new window, give the path to Chrome, e.g. `C:\Program Files (x86)\Google\Chrome\Application\chrome.exe`. As argument use `--auto-open-devtools-for-tabs`.

Or here's a command to create an executable shim which passes this argument by itself:

```
C:/ProgramData/chocolatey/tools/shimgen.exe --gui --output="$HOME/bin/chrome-dev.exe" --path="C:/Program Files/Google/Chrome/Application/chrome.exe" --command="--auto-open-devtools-for-tabs"
```

## Firefox Developer Edition
Only used for development and testing. Uses its own profile. Get it from https://www.mozilla.org/en-GB/firefox/developer/
### Extensions
- Connective Browser Plugin
### Setup for development
In Visual Studio, open the "IIS Express (<Browser>)" dropdown. Click "Browse With..." and wait until the build is done. Now you can click "Add...".

In the new window, give the path to this Firefox, e.g. `c:\Program Files\Firefox Developer Edition\firefox.exe`. As argument use `-devtools`.

Or here's a command to create an executable shim which passes this argument by itself:

```
C:/ProgramData/chocolatey/tools/shimgen.exe --gui --output="$HOME/bin/firefox-dev.exe" --path="c:\Program Files\Firefox Developer Edition\firefox.exe" --command="-devtools"
```
