[CmdletBinding()]
param (
    [parameter(Mandatory=$true)]
    [System.IO.FileInfo] $HarFile
)
if ($null -eq (Get-Command jq -ErrorAction SilentlyContinue)) {
    throw "'jq' not found in path";
}
jq '[[.log.entries[]] | to_entries[] | {id: .key, url: .value.request.url, method: .value.request.method, resp: .value.response.status}]' (Resolve-Path $HarFile)
