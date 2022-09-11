[CmdletBinding()]
param (
    [parameter(Mandatory=$true)]
    [string] $InputData
)

$bytes = [Convert]::FromBase64String($InputData)

$outputData = [BitConverter]::ToString($bytes)
Write-Output $outputData.Replace("-", "")