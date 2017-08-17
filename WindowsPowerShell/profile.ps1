Import-Module PSCX -Arg (Join-Path -Resolve $PSScriptRoot Pscx.UserPreferences.ps1)


New-Alias dirs cd


Function Get-Location-Stack
{
    (Get-Location -Stack).GetEnumerator()
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

Function Load-WinAvr()
{
    $winavrDir = Get-ChildItem -Directory -LiteralPath 'd:\Apps' '*WinAVR*' | Select-Object -ExpandProperty FullName
    $winavrBinDir = Join-Path $winavrDir 'bin'
    $winavrUtilsBinDir = Join-Path $winavrDir 'utils/bin'
    Add-PathVariable -Target Process -value ([string]$winavrBinDir, [string]$winavrUtilsBinDir)
    Write-Host -ForegroundColor 'Yellow' "WinAvr tools have been located"
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

Function Load-AvrToolchain()
{
    Load-MingWTools

    Add-PathVariable -Target Process -value 'd:\Apps\avr8-gnu-toolchain\bin\'

    Write-Host -ForegroundColor 'Yellow' "Avr tools have been located"
}
