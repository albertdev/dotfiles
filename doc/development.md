List of development tools and their most important settings.

## Visual Studio
### Extensions
- Resharper, it's a drug. Download from https://jetbrains.com
- File Path On Footer, because I like to see a more complete path somewhere in the UI. https://marketplace.visualstudio.com/items?itemName=ShemeerNS.FilePathOnFooter
- Editor Guidelines, for the line length OCD programmer. https://marketplace.visualstudio.com/items?itemName=PaulHarrington.EditorGuidelines
- (VS 2017 / 2019) #Regions Are Evil, yes they are. https://marketplace.visualstudio.com/items?itemName=PaulMelia.RegionsAreEvil001
- (VS 2015) I Hate #Regions, so I need this. https://marketplace.visualstudio.com/items?itemName=Shanewho.IHateRegions#overview
- VSVim, because I've got the modal editing brainworm. https://marketplace.visualstudio.com/items?itemName=JaredParMSFT.VsVim
### Settings
- External tools:
    - Add `&Vim` as external tool. Command is `c:\Program Files (x86)\vim\vim81\gvim.exe`, arguments is `--servername VimStudio --remote-silent +"call cursor($(CurLine),$(CurCol))" "$(ItemFileName)$(ItemExt)"`, initial dir is `$(ItemDir)`

## VS Code
### Extensions
- Azure Pipelines, for completion of YAML pipeline descriptors. Id: `ms-azure-devops.azure-pipelines`
- C#, for quickly viewing some sources. Id: `ms-dotnettools.csharp`
- OpenAPI (Swagger) Editor, because it allows for previews and limited checking. Id: `42crunch.vscode-openapi`
- Swagger Viewer, not sure what this one did vs the previous one. Id: `arjun.swagger-viewer`
- PowerShell, the replacement of the ISE. Id: `ms-vscode.powershell`
- Remote - WSL, for better WSL project editing integration. Still experimental. Id: `ms-vscode-remote.remote-wsl`
- Solarized, for its beige light theme. Id: `ryanolsonx.solarized`
- Vim, because I've got the modal editing brainworm. Id: `vscodevim.vim`
- XML Tools, because formatting by hand is overrated. Id: `dotjoshjohnson.xml`
- YAML, for when you're editing raw YAML or Kubernetes descriptors. Id: `redhat.vscode-yaml`

## Notepad++
### Extensions
- JSLint
- JSTool
- Mime Tools (installed by default?)
- Npp Converter (installed by default?)
- NppExporter (installed by default?)
- TextFX Characters (if you can still get this)
- XML Tools
