[CmdletBinding()]
param (
    # Path to the user directory. We could try to figure this out using $HOME,
    # but since homemaker could be running on a fresh Windows install it is
    # better to be explicit.
    [parameter()]
    [string] $homePath
)
# Add bin folder in user directory so that executables on the system path can be overridden
Add-PathVariable -Prepend -Value (Join-Path -Path $homePath -ChildPath "bin") -Target User

# Find vim install dir, like 'c:\tools\vim\vim90\' to add it to path, but only do it once.
# Chocolatey might create several such directories based on vim version so it is never guaranteed to be a fixed name.

if (-not (Get-PathVariable | Where-Object { $_ -imatch '\\vim\\' })) {
    # Only directories containing gvim.exe count
    $vimPath = Get-ChildItem 'C:\Tools\vim\*' -Directory |
        Where-Object {Test-Path -PathType Leaf -Path (Join-Path -Path $_ -ChildPath "gvim.exe")} |
        Select-Object -First 1

    $absoluteVimPath = Resolve-Path $vimPath
    Write-Output "Adding $absoluteVimPath to PATH"
    Add-PathVariable -Value $absoluteVimPath -Target User
} else {
    Write-Output "Vim already in PATH"
}
