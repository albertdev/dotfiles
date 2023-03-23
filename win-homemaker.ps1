[CmdletBinding()]
param (
    # Which homemaker task to run. If not passed then default<__variant> is used.
    [parameter()]
    [string] $task
)
$commands = @(Get-Command "homemaker.exe" -ErrorAction SilentlyContinue)
if (-not ($commands)) {
	$commands = @(Join-Path -Resolve "$env:HOME" "bin/homemaker.exe")
    if (-not ($commands)) {
        $commands = @(Resolve-Path ".\homemaker.exe")
    }
    if (-not ($commands)) {
        throw "No homemaker executable found!"
    }
}
$homemakerExe = ($commands | Select-Object -First 1)
#$homemakerExe = "echoargs.exe"

$homemakerargs = @(
    "-dest", (Resolve-Path "$env:HOME"),
    "-verbose",
    "-variant", "windows",
    "homemaker.toml",
    (Resolve-Path .)
)
if ($task) {
    $homemakerargs = @("-task", $task) + $homemakerargs
}
& $homemakerExe $homemakerargs
