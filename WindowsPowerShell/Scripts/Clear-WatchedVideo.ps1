[CmdletBinding()]
param (
    [parameter(Mandatory=$true)]
    [string] $VideoFileOrArgumentList
)

function Test-VideoExtension($file) {
    $file.Extension -eq ".mp4" -or $file.Extension -eq ".webm" -or $file.Extension -eq ".3gp" -or $file.Extension -eq ".mkv" `
        -or ($file.Directory.Name -ieq "Videos" -and $file.Extension -eq ".json")
}

function Replace-VideoWithMarker($file) {
    $fileDirectory = $file.Directory.FullName
    $marker = $file.BaseName + ".txt"
    $newFile = New-Item -Path $fileDirectory -Name $marker -ItemType File
    # .json file is typically when the "Mark Downloaded" feature of Backup-VideoDescription was used.
    # Set marker date to when the json file was created (last modified is video publishing date, and today's date is not correct)
    if ($file.Extension -eq ".json") {
        $dateWatched = Get-Date -Format "o" $file.CreationTime
    } else {
        $dateWatched = Get-Date -Format "o"
    }
    $dateWatched | Out-File -Encoding ASCII -LiteralPath $newFile
    $newFile.LastWriteTime = $file.LastWriteTime
    Remove-ItemSafely -LiteralPath $file.FullName
    Write-Information -InformationAction Continue "Wrote marker to replace $file" 

    # Find related files and move them to the Recycle Bin
    #$escapedBaseName = [Management.Automation.WildCardPattern]::Escape($file.BaseName)
    $relatedFiles = Get-ChildItem -LiteralPath $fileDirectory -Filter ($file.BaseName + ".*") | ? { $_ -notlike '*.txt' }
    if ($relatedFiles) {
        Remove-ItemSafely -LiteralPath $relatedFiles
    }
    Write-Information -InformationAction Continue "Recycled related files:"
    foreach ($file in $relatedFiles) {
        Write-Information -InformationAction Continue $file
    }
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
                if (Test-VideoExtension $file) {
                    Replace-VideoWithMarker $file
                } else {
                    Write-Error "File $file does not have a known video extension"
                }
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
