if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadline
    Set-PSReadlineOption -EditMode Emacs
}

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

Function Set-Title 
{
    Param
    (
        [Parameter(Mandatory=$true)] [string]$WindowTitle
    )

    $Host.UI.RawUI.WindowTitle = $WindowTitle
}
