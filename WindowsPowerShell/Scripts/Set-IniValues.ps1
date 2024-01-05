[CmdletBinding()]
param (
    [parameter(Mandatory=$true)]
    [string] $Path,
    [string] $Encoding,
    [string[]] $Instructions
)

# This script is incomplete in the sense that it doesn't really parse an INI file.
# It looks for a given key instead and assumes that's unique enough.
#
# Input format of the instructions: (Note that '[section]' can be left out)
# "[section]key=value" - replaces whatever is there
# "key+=,value" - appends the given value (TODO!)

if (!(Test-Path $Path)) {
    throw "File $Path not found!"
}
$lines = Get-Content $Path

foreach ($instruction in $Instructions) {
    if ($instruction.StartsWith("[")) {
        $section = 
    }
}
