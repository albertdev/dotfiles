[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact = 'high')]
param (

    [parameter(Mandatory=$true)]
    [string] $LinkOutputPath,

    [parameter(Mandatory=$true)]
    [string] $TargetPath,

    [parameter()]
    [string] $Arguments,

    [parameter()]
    [string] $StartPath,

    [parameter()]
    [Switch] $Force
)

## An improved "Create Shell Shortcut" script. PSCX might have New-Shortcut but it doesn't allow to customize the link.

if ($Force) {
    $ConfirmPreference = 'None'
}

# Check the target path exists - unless it's an UWP shortcut, in which case we can't really check it
if (-not (Test-Path $TargetPath) -and -not ($TargetPath -like "shell:appsfolder\*")) {
    # Maybe targetpath uses classic CMD environnmental variables
    $expandedPath = [System.Environment]::ExpandEnvironmentVariables($TargetPath)
    if (-not (Test-Path $expandedPath)) {
        throw "TargetPath [$TargetPath] does not point to an existing executable or script"
    }
}

# Check the start path exists (if indicated)
if ($StartPath) {
    if (-not (Test-Path $StartPath)) {
        # Maybe startpath uses classic CMD environnmental variables
        $expandedPath = [System.Environment]::ExpandEnvironmentVariables($StartPath)
        if (-not (Test-Path $expandedPath)) {
            throw "StartPath [$StartPath] does not point to an existing directory"
        }
    }
}

# Validate that the link doesn't exist yet. If it does, prepare a confirmation prompt (if the user's preference allows it)
if (Test-Path $LinkOutputPath) {
    $LinkOutputPath = Resolve-Path $LinkOutputPath
    if ( -not ($PSCmdlet.ShouldProcess($LinkOutputPath, "Overwrite existing link file"))) {
        exit
    }
    Write-Warning "Overwriting link file $LinkOutputPath"
}
# Validate whether link output directory exists. If not, create it
$outputDirectory = Split-Path -Parent $LinkOutputPath
if (-not (Test-Path -Type Container $outputDirectory)) {
    New-Item -Type Directory $outputDirectory -Force > $null
}

$objShell = New-Object -ComObject WScript.Shell
$lnk = $objShell.CreateShortcut($LinkOutputPath)

if (-not $lnk) {
    throw "Failed to create shortcut $LinkOutputPath"
}


$lnk.TargetPath = $TargetPath

if ($Arguments) {
    $lnk.Arguments = $Arguments
}

if ($StartPath) {
    $lnk.WorkingDirectory = $StartPath
}

$lnk.Save()

# Cargo cult code
$lnk = $null
$objShell = $null
