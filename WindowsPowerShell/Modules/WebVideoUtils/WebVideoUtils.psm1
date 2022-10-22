#
# Script module for module 'WebVideoUtils'
#
Set-StrictMode -Version Latest

$script:DefaultOutputTemplate = "%(channel)s_%(title)s-%(id)s.%(ext)s"

# Twitter videos don't have a title so YT-DLP tries to use the tweet text - that's annoying
$script:DefaultOutputTemplateSocialMedia = "%(uploader_id)s_NA-%(id)s.%(ext)s"

Function Backup-Video {
    param(
        [Parameter()]
        [switch]$NoDelay,

        [Parameter()]
        [switch]$AudioOnly,

        [Parameter()]
        [switch]$DescriptionIncluded,

        [Parameter(Mandatory = $false)]
        [string]$SubtitleLanguage,

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
            Write-Error "Failed to download $video, yt-dlp exited with status $LASTEXITCODE"
            continue
        }
        if (-not $ytdlpOutput) {
            Write-Warning "Video $video was already marked as downloaded in the download archive"
            continue
        }
        $videoInfo = ConvertFrom-Json $ytdlpOutput

        $outputTemplate = $script:DefaultOutputTemplate
        if ($videoInfo.extractor -ieq "twitter" -or $videoInfo.extractor -ieq "nitter") {
            $outputTemplate = $script:DefaultOutputTemplateSocialMedia
        }

        $downloadArgs = ("--download-archive",$downloadArchive,"--break-on-existing","-o",$outputTemplate)
        if ($AudioOnly) {
            $downloadArgs += ("-f", "bestaudio")
        }
        else
        {
            $downloadArgs += ("-f","18/best*[height<=360]/worst")
        }
        if ($DescriptionIncluded) {
            $downloadArgs += "--write-description"
        }
        if ($SubtitleLanguage) {
            try {
                $subdownloadArgs = CalculateSubtitleDownloadArguments -Language $SubtitleLanguage -VideoInfo $videoInfo
                $downloadArgs += $subdownloadArgs
            } catch {
                Write-Warning "Subtitles for $video could not be found: $_"
            }
        }
        $downloadArgs += $video

        yt-dlp @downloadArgs
        if ($LASTEXITCODE) {
            Write-Error "Failed to download $video, yt-dlp exited with status $LASTEXITCODE"
        }

        if (-not $NoDelay -and $index -lt $VideoUrls.Count) {
            Write-Output "Waiting before next download"
            Start-Sleep -Seconds 10
        }
    }
}

function List-VideoSubtitle {
    param(
        [parameter(Mandatory = $true)]
        [string]$VideoUrl,
        [string]$Format
    )
    $ytdlpOutput = yt-dlp --dump-json $video
    if ($LASTEXITCODE) {
        Write-Error "Failed to download $video, yt-dlp exited with status $LASTEXITCODE"
        return
    }
    $videoInfo = ConvertFrom-Json $ytdlpOutput
}

function Backup-VideoSubtitle {
    param(
        [parameter(Mandatory = $true)]
        [string]$VideoUrl,

        [parameter(Mandatory = $true)]
        [string]$Language,

        [string]$Format
    )
    $ytdlpOutput = yt-dlp --dump-json $VideoUrl
    if ($LASTEXITCODE) {
        Write-Error "Failed to download $VideoUrl, yt-dlp exited with status $LASTEXITCODE"
        return
    }
    $videoInfo = ConvertFrom-Json $ytdlpOutput

    $downloadArgs = CalculateSubtitleDownloadArguments -Language $Language -VideoInfo $videoInfo -Format $Format

    $outputTemplate = $script:DefaultOutputTemplate
    $downloadArgs += ("--skip-download","-o",$outputTemplate, $videoUrl)

    yt-dlp @downloadArgs
    if ($LASTEXITCODE) {
        Write-Error "Failed to download subtitle for $video, yt-dlp exited with status $LASTEXITCODE"
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
