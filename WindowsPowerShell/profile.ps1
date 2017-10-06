Import-Module PSCX -Arg (Join-Path -Resolve $PSScriptRoot Pscx.UserPreferences.ps1)

New-Alias dirs cd


Function Get-Location-Stack
{
    (Get-Location -Stack).GetEnumerator()
}

Function Copy-Path ($file) {
    # Copy absolute path
    if ($file -eq $null) {
        Set-Clipboard -Text (Resolve-Path $PWD)
    } else {
        Set-Clipboard -Text (Resolve-Path $file)
    }
}

Function Lower-ExecutionPolicy
{
    Set-ExecutionPolicy -Scope process -ExecutionPolicy Unrestricted
}

# Taken and tweaked from the comments of https://www.gurustop.net/blog/2014/02/01/using-visual-studio-developer-command-prompt-with-powershell/
Function Get-BatchfileEnvironment ($file) {
    $cmd = "`"$file`" & set"
    $vars = @{}
    cmd /c $cmd | Foreach-Object {
        $p, $v = $_.split('=')
#        Set-Item -path env:$p -value $v
        $vars[$p] = $v
    }
    return $vars
}

Function Load-VsTools2012()
{
    $batchFile = [System.IO.Path]::Combine($env:VS110COMNTOOLS, "VsDevCmd.bat")
    Get-BatchfileEnvironment -file $batchFile
    Write-Host -ForegroundColor 'Yellow' "VsVars has been loaded from: $batchFile"
}

Function Load-VsTools2013()
{
    $batchFile = [System.IO.Path]::Combine($env:VS120COMNTOOLS, "VsDevCmd.bat")
    Get-BatchfileEnvironment -file $batchFile
    Write-Host -ForegroundColor 'Yellow' "VsVars has been loaded from: $batchFile"
}

Function Load-VsTools2015()
{
    $batchFile = [System.IO.Path]::Combine($env:VS140COMNTOOLS, "VsDevCmd.bat")
    $batchenv = Get-BatchfileEnvironment -file $batchFile

    # Verbose logging
    $batchenv.GetEnumerator() | Sort-Object -Property Key | % {"{0}={1}" -f $_.Key, $_.Value} | Write-Verbose

    $batchenv.GetEnumerator() | % { Set-Item -Path "env:$($_.Key)" -value $_.Value }
    Write-Host -ForegroundColor 'Yellow' "VsVars has been loaded from: $batchFile"
}

Function Load-MsDeploy()
{
    $msDeployRegKey = 'HKLM:\SOFTWARE\Microsoft\IIS Extensions\MSDeploy\3'
    if (!(Test-Path $msDeployRegKey)) {
        Write-Error "Could not detect MSDeploy v3 installation"
        return $null
    }
    $msDeployPath = (Get-ItemProperty $msDeployRegKey).InstallPath
    if ($null -eq $msDeployPath -or "" -eq $msDeployPath) {
        Write-Error "Could not detect MSDeploy v3 installation, registry key did not contain install path"
        return $null
    }
    $msDeploy = Join-Path $msDeployPath "msdeploy.exe"
    if (!(Test-Path $msDeploy)) {
        Write-Error "Could not find MSDeploy v3 EXE at $($msDeploy.FullName)"
        return $null
    }
    Add-PathVariable (Resolve-Path $msDeployPath)
}

Function Load-MingWTools()
{
    $mingwDir = Get-ChildItem -Directory -LiteralPath 'd:\Apps\mingw-w64' | Select-Object -First 1 -ExpandProperty FullName

    $mingwBinDir = Join-Path $mingwDir 'mingw64/bin'
    #Add-PathVariable -Target Process -value $mingwBinDir

    $makeExe = Join-Path $mingwBinDir 'mingw32-make.exe'
    # Use -Force in case we earlier on set this alias for another toolchain
    Set-Alias make $makeExe -Scope Global -Force

    Write-Host -ForegroundColor 'Yellow' "MingW tools have been located"
}

# TF VC aliases
Function TFDiff {
    if ($null -eq (Get-Command tf -ErrorAction SilentlyContinue))
    {
        throw "No TF VC command found in Path";
    }
    tf diff . /recursive /format:unified
}

# Git aliases - uses very short names for convenience because definining the functions and aliases immediately after is silly.
Function GitFA() { git fetch --all }
Function GitS() { git status }
Function GitI() { git diff --cached }
Function GitSF() { git svn fetch }
Function GitFA() { git fetch --all }
Function GitFF() { git pull --ff-only }
Function GitMF() { git merge --ff-only $args }

# SVN Rebase: attempt to run it, if it fails we stash the changes and try again
#Function GitSR() { git svn rebase || ( git stash ; git svn rebase ; git stash pop ) }

#TODO: Move to module
# ----> Actually already implemented in PSCX
#Function ConvertFrom-Base64File
#{
#  [CmdletBinding()]
#  Param (
#    [Parameter(Mandatory = $True)] [FileInfo] $InputPath,
#    [Parameter(Mandatory = $True)] $Path
#  )
#}
