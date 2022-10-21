[CmdletBinding()]
param (
    [parameter(Mandatory=$true)]
    [string] $VideoFileOrArgumentList
)

function Test-VideoExtension($file) {
    $file.Extension -eq ".mp4" -or $file.Extension -eq ".webm" -or $file.Extension -eq ".3gp"
}

function Replace-VideoWithMarker($file) {
    $fileDirectory = $file.Directory.FullName
    $marker = $file.BaseName + ".txt"
    New-Item -Path $fileDirectory -Name $marker -ItemType File > $null
    Remove-Item -LiteralPath $file.FullName
    Write-Information -InformationAction Continue "Wrote marker to replace $file" 
}

if (Test-Path -LiteralPath $VideoFileOrArgumentList) {
    $file = Get-ChildItem $VideoFileOrArgumentList
    if (Test-VideoExtension $file) {
        Replace-VideoWithMarker $file
    } else {
        # Argument list is stored in a file, something which TotalCommander tends to do
        $argumentList = Get-Content $file.FullName
        foreach ($filePath in $argumentList) {
            if (Test-Path -LiteralPath $filePath) {
                $file = Get-ChildItem -LiteralPath $filePath
                Replace-VideoWithMarker $file
            } else {
                Write-Error "File $file does not have a known video extension or isn't a file list. File $filePath not found"
                break
            }
        }
    }
    Write-Host "Done"
    pause
} else {
    Write-Error "File $VideoFile not found"
    pause
}
