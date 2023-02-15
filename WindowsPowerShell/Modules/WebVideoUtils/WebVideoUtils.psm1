#
# Script module for module 'WebVideoUtils'
#
Set-StrictMode -Version Latest

Function Backup-Video {
    [CmdletBinding(PositionalBinding=$false)]
    param(
        [Parameter()]
        [switch]$NoDelay,

        [Parameter()]
        [switch]$AudioOnly,

        [Parameter()]
        [switch]$DescriptionIncluded,

        [Parameter(Mandatory = $false)]
        [string]$SubtitleLanguage,

        [Parameter(Mandatory = $false)]
        [string]$FormatHint,

        [parameter(Mandatory = $true, ValueFromRemainingArguments=$true)]
        [string[]]$VideoUrls
    )
    $downloadArchive = Join-Path (Resolve-Path ([environment]::getfolderpath("mydocuments"))) "YouTube\download-archive.txt"
    if (-not (Test-Path $downloadArchive)) {
        New-Item -Path $downloadArchive -ItemType File -Force > $null
    }

    $index = 0
    foreach ($video in $VideoUrls) {
        $index += 1

        $ytdlpOutput = yt-dlp --dump-json --download-archive $downloadArchive $video
        if ($LASTEXITCODE) {
            Write-Error "Failed to download `"$video`", yt-dlp exited with status $LASTEXITCODE"
            continue
        }
        if (-not $ytdlpOutput) {
            Write-Warning "Video `"$video`" was already marked as downloaded in the download archive"
            continue
        }
        $videoInfo = ConvertFrom-Json $ytdlpOutput
        Write-Information -InformationAction Continue "Video `"$($videoInfo.title)`" is $($videoInfo.duration_string) long"

        $outputTemplatePrefix = $videoInfo.extractor_key + "_" + $videoInfo.id
        $outputTemplate = $outputTemplatePrefix + ".%(ext)s"

        $downloadArgs = ("--download-archive",$downloadArchive,"--break-on-existing","-o",$outputTemplate)
        if ($AudioOnly) {
            $downloadArgs += ("-f", "bestaudio")
        }
        else
        {
            $formatChoices = "18/best*[height<=360]/worst"
            if ($FormatHint)
            {
                $formatChoices = $FormatHint + "/" + $formatChoices
            }
            $downloadArgs += ("-f",$formatChoices)
        }
        if ($DescriptionIncluded) {
            $downloadArgs += "--write-description"
        }
        if ($SubtitleLanguage) {
            try {
                $subdownloadArgs = CalculateSubtitleDownloadArguments -Language $SubtitleLanguage -VideoInfo $videoInfo
                $downloadArgs += $subdownloadArgs
            } catch {
                Write-Warning "Subtitles for `"$video`" could not be found: $_"
            }
        }
        $downloadArgs += $video

        yt-dlp @downloadArgs
        if ($LASTEXITCODE) {
            Write-Error "Failed to download `"$video`", yt-dlp exited with status $LASTEXITCODE"
        }

        $newPrefix = RenameDownloadedItems -Prefix $outputTemplatePrefix -VideoInfo $videoInfo


        if (-not $NoDelay -and $index -lt $VideoUrls.Count) {
            Write-Output "Waiting before next download"
            Start-Sleep -Seconds 10
        }
    }
}

Function Backup-VideoDescription {
    [CmdletBinding(PositionalBinding=$false)]
    param(
        [parameter(Mandatory = $true, ValueFromRemainingArguments=$true)]
        [string[]]$VideoUrls
    )

    foreach ($video in $VideoUrls) {

        $ytdlpOutput = yt-dlp --dump-json $video
        if ($LASTEXITCODE) {
            Write-Error "Failed to download description of `"$video`", yt-dlp exited with status $LASTEXITCODE"
            continue
        }
        $videoInfo = ConvertFrom-Json $ytdlpOutput
        Write-Information -InformationAction Continue "Video `"$($videoInfo.title)`" is $($videoInfo.duration_string) long"

        $outputTemplatePrefix = $videoInfo.extractor_key + "_" + $videoInfo.id

        $videoInfo | ConvertTo-Json -Depth 100 | Out-File -Encoding UTF8 -LiteralPath (Join-Path . ($outputTemplatePrefix + ".json"))
        $videoInfo.description | Out-File -Encoding UTF8 -LiteralPath (Join-Path . ($outputTemplatePrefix + ".description"))

        $newPrefix = RenameDownloadedItems -Prefix $outputTemplatePrefix -VideoInfo $videoInfo
    }
}

function Get-VideoSubtitle {
    [CmdletBinding(PositionalBinding=$false)]
    param(
        [parameter(Mandatory = $true)]
        [string]$VideoUrl,
        [string]$Format
    )
    $ytdlpOutput = yt-dlp --dump-json $video
    if ($LASTEXITCODE) {
        Write-Error "Failed to download `"$video`", yt-dlp exited with status $LASTEXITCODE"
        return
    }
    $videoInfo = ConvertFrom-Json $ytdlpOutput
}

function Backup-VideoSubtitle {
    [CmdletBinding(PositionalBinding=$false)]
    param(
        [parameter(Mandatory = $true, ValueFromRemainingArguments=$true)]
        [string[]]$VideoUrls,

        [parameter(Mandatory = $true)]
        [string]$Language,

        [parameter()]
        [string]$Format
    )
    foreach ($video in $VideoUrls) {

        $ytdlpOutput = yt-dlp --dump-json $video
        if ($LASTEXITCODE) {
            Write-Error "Failed to download `"$video`", yt-dlp exited with status $LASTEXITCODE"
            return
        }
        $videoInfo = ConvertFrom-Json $ytdlpOutput
        Write-Information -InformationAction Continue "Video `"$($videoInfo.title)`" is $($videoInfo.duration_string) long"

        $downloadArgs = CalculateSubtitleDownloadArguments -Language $Language -VideoInfo $videoInfo -Format $Format

        $outputTemplatePrefix = $videoInfo.extractor_key + "_" + $videoInfo.id
        $outputTemplate = $outputTemplatePrefix + ".%(ext)s"

        $downloadArgs += ("--skip-download","-o",$outputTemplate, $video)

        yt-dlp @downloadArgs
        if ($LASTEXITCODE) {
            Write-Error "Failed to download subtitle for `"$video`", yt-dlp exited with status $LASTEXITCODE"
        }

        $newPrefix = RenameDownloadedItems -Prefix $outputTemplatePrefix -VideoInfo $videoInfo
    }
}

function CalculateSubtitleDownloadArguments {
    <# Validates the input parameters and returns the best available subtitle yt-dlp parameters. Throws an exception if no match is found #>
    param(
        [string]$Language,

        $videoInfo,

        [string]$Format
    )

    if (!($Format)) {
        $Format = "ttml"
    }

    $chosenSubtitle = $null
    $langFound = $false
    foreach ($lang in $videoInfo.subtitles.PSObject.Properties) {
        if ($lang.Name -ne $Language) {
            continue
        }
        $langFound = $true
        foreach ($variant in $lang.Value) {
            if ($variant.ext -eq $Format) {
                $chosenSubtitle = New-Object PSObject -Property @{ Language = $Language; Target = "Subtitle" }
                break
            }
        }
        if (!($chosenSubtitle)) {
            Write-Warning "Language $Language was found to have subtitles but not for format $Format, checking automatic captions"
        }
        break
    }
    if (!($chosenSubtitle)) {
        if (! $langFound) {
            Write-Warning "No subtitles found in language $Language, checking automatic captions"
        }

        $langFound = $false
        foreach ($lang in $videoInfo.automatic_captions.PSObject.Properties) {
            if ($lang.Name -ne $Language) {
                continue
            }
            $langFound = $true
            foreach ($variant in $lang.Value) {
                if ($variant.ext -eq $Format) {
                    $chosenSubtitle = New-Object PSObject -Property @{ Language = $Language; Target = "AutomaticCaption" }
                    break
                }
            }
            if (!($chosenSubtitle)) {
                throw "Language $Language was found to have an automatic caption but not for format $Format"
            }
            break
        }
        if (!($chosenSubtitle) -and -not $langFound) {
            throw "No automatic captions found in language $Language"
        }
    }

    $result = "--sub-lang", $chosenSubtitle.Language, "--sub-format", $Format
    if ($chosenSubtitle.Target -eq "AutomaticCaption") {
        $result += "--write-auto-sub"
    } else {
        $result += "--write-sub"
    }
    return $result
}

function RenameDownloadedItems {
    param(
        $videoInfo,

        [string]$Prefix
    )
    if (-not $Prefix) {
        throw "No filename prefix passed, stopping rename of $videoInfo"
    }
    if (-not $videoInfo) {
        throw "No video info passed, stopping rename $Prefix"
    }
    # Calculate new file metadata
    $id = $videoInfo.id
    $title = $videoInfo.title
    $date = $null
    $authorInformation = $null

    # Conditional rules for e.g. Twitter extractor where these values might not be set
    if ($videoInfo | Get-Member -Name channel) {
        $authorInformation = $videoInfo.channel
    }
    if (!($authorInformation)) {
        $authorInformation = $videoInfo.uploader
    }
    if ($videoInfo | Get-Member -Name release_date) {
        $date = $videoInfo.release_date
    }
    if (!($date)) {
        $date = $videoInfo.upload_date
    }

    if ($title.Length -gt 52) {
        $title = $title.Substring(0, 52) + "..."
    }

    $dateParsed = [datetime]::ParseExact($date, 'yyyyMMdd', $null)
    $newPrefix = "{0}_{1}_{2}-{3}" -f $authorInformation, $date, $title, $id
    if (!($newPrefix)) {
        Write-Error "Failed to calculate new name"
        return
    }

    foreach ($invalidchar in [System.IO.Path]::GetInvalidFileNameChars())
    {
        $newPrefix = $newPrefix.Replace($invalidchar, '_');
    }


    # Look for files and process
    $foundFiles = Get-ChildItem -Filter ($Prefix + '*')
    foreach ($file in $foundFiles) {
        $file.LastWriteTime = $dateParsed
        $newName = Join-Path -Path $file.DirectoryName -ChildPath ($file.Name -Replace $Prefix, $newPrefix) 
        try {
            $file.MoveTo($newName)
        } catch {
            Write-Warning "Cannot move $file to $newName`: $($_.Exception.Message)"
        }
    }

    Write-Information -InformationAction Continue "Moved files to `"$newPrefix`""

    return $newPrefix
}


Export-ModuleMember -Function "Backup-Video", "Get-VideoSubtitle", "Backup-VideoDescription", "Backup-VideoSubtitle"
