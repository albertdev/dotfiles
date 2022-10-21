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

        if ($AudioOnly) {
            yt-dlp --download-archive $downloadArchive --break-on-existing -f "bestaudio" -o $outputTemplate $video
        }
        else
        {
            yt-dlp --download-archive $downloadArchive --break-on-existing -f "18/best*[height<=360]/worst" -o $outputTemplate $video
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
                Write-Error "Language $Language was found to have an automatic caption but not for format $Format"
                return
            }
            break
        }
        if (!($chosenSubtitle) -and -not $langFound) {
            Write-Error "No automatic captions found in language $Language"
            return
        }
    }
    if ($chosenSubtitle.Target -eq "AutomaticCaption") {
        $outputTemplate = $script:DefaultOutputTemplate
        yt-dlp --skip-download --write-auto-sub --sub-lang $chosenSubtitle.Language --sub-format $Format -o $outputTemplate $VideoUrl
    } else {
        $outputTemplate = $script:DefaultOutputTemplate
        yt-dlp --skip-download --write-sub --sub-lang $chosenSubtitle.Language --sub-format $Format -o $outputTemplate $VideoUrl
    }
}
