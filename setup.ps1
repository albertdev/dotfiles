$commands = @(Get-Command "homemaker.exe" -ErrorAction Continue)
if (-not ($commands)) {
	$commands = @(Join-Path -Resolve "$env:HOMEDRIVE$env:HOMEPATH" "bin/homemaker.exe")
    if (-not ($commands)) {
        $commands = @(Resolve-Path ".\homemaker.exe")
    }
    if (-not ($commands)) {
        throw "No homemaker executable found!"
    }
}
$homemakerExe = ($commands | Select-Object -First 1)
& $homemakerExe -dest (Resolve-Path "$env:HOMEDRIVE$env:HOMEPATH") -verbose -variant windows homemaker.toml (Resolve-Path .)
