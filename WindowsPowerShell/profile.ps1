Import-Module PSCX -Arg (Join-Path -Resolve $PSScriptRoot Pscx.UserPreferences.ps1)

New-Alias dirs cd

# Load local profile for local aliases

$localProfile = Join-Path $HOME ".localprofile.ps1"
If (Test-Path $localProfile)
{
    . "$localProfile"
}

Function Get-Location-Stack
{
    (Get-Location -Stack).GetEnumerator()
}

Function Copy-Path ($file) {
    # Copy absolute path
    if ($file -eq $null) {
        Set-Clipboard -Text (Resolve-Path $PWD)
    } else {
        Set-Clipboard -Text (Resolve-Path $file)
    }
}

Function Lower-ExecutionPolicy
{
    Set-ExecutionPolicy -Scope process -ExecutionPolicy Unrestricted
}

# Spits out grep lines in a format useable by vim's error list functionality
Function vimgrep ($regex, $files, $outfile)
{
    busybox grep -n -H $regex $files | Out-File -Encoding utf8 -Append $outfile
}

# Taken and tweaked from the comments of https://www.gurustop.net/blog/2014/02/01/using-visual-studio-developer-command-prompt-with-powershell/
Function Get-BatchfileEnvironment ($file) {
    $cmd = "`"$file`" && set"
    $vars = @{}
    # Ignore everything which is not of form key=value
    cmd /c $cmd | ? { $_.IndexOf('=') -gt 0} | Foreach-Object {
        $p, $v = $_.split('=', 2)
#        Set-Item -path env:$p -value $v
        $vars[$p] = $v
    }
    return $vars
}

Function Load-VsTools2012()
{
    $batchFile = [System.IO.Path]::Combine($env:VS110COMNTOOLS, "VsDevCmd.bat")
    Get-BatchfileEnvironment -file $batchFile
    Write-Host -ForegroundColor 'Yellow' "VsVars has been loaded from: $batchFile"
}

Function Load-VsTools2013()
{
    $batchFile = [System.IO.Path]::Combine($env:VS120COMNTOOLS, "VsDevCmd.bat")
    Get-BatchfileEnvironment -file $batchFile
    Write-Host -ForegroundColor 'Yellow' "VsVars has been loaded from: $batchFile"
}

Function Load-VsTools2015()
{
    $batchFile = [System.IO.Path]::Combine($env:VS140COMNTOOLS, "VsDevCmd.bat")
    $batchenv = Get-BatchfileEnvironment -file $batchFile

    # Verbose logging
    $batchenv.GetEnumerator() | Sort-Object -Property Key | % {"{0}={1}" -f $_.Key, $_.Value} | Write-Verbose

    $batchenv.GetEnumerator() | % { Set-Item -Path "env:$($_.Key)" -value $_.Value }
    Write-Host -ForegroundColor 'Yellow' "VsVars has been loaded from: $batchFile"
}

Function Load-VsTools2017()
{
    $vsLocation = vswhere -version "[15.0,16.0)" -requires Microsoft.Component.MSBuild -property installationPath
    if ($vsLocation -eq $null) {
        Write-Error "Could not detect Visual Studio 2017 installation"
        return $null
    }
    $batchFile = Join-Path $vsLocation "Common7\Tools\VsDevCmd.bat"
    $batchenv = Get-BatchfileEnvironment -file $batchFile

    # Verbose logging
    $batchenv.GetEnumerator() | Sort-Object -Property Key | % {"{0}={1}" -f $_.Key, $_.Value} | Write-Verbose

    $batchenv.GetEnumerator() | % { Set-Item -Path "env:$($_.Key)" -value $_.Value }
    Write-Host -ForegroundColor 'Yellow' "VsVars has been loaded from: $batchFile"
}

Function Load-VsTools2019()
{
    $vsLocation = vswhere -version "[16.0,17.0)" -requires Microsoft.Component.MSBuild -property installationPath
    if ($vsLocation -eq $null) {
        Write-Error "Could not detect Visual Studio 2019 installation"
        return $null
    }
    $batchFile = Join-Path $vsLocation "Common7\Tools\VsDevCmd.bat"
    $batchenv = Get-BatchfileEnvironment -file $batchFile

    # Verbose logging
    $batchenv.GetEnumerator() | Sort-Object -Property Key | % {"{0}={1}" -f $_.Key, $_.Value} | Write-Verbose

    $batchenv.GetEnumerator() | % { Set-Item -Path "env:$($_.Key)" -value $_.Value }
    Write-Host -ForegroundColor 'Yellow' "VsVars has been loaded from: $batchFile"
}

Function Load-MsDeploy()
{
    $msDeployRegKey = 'HKLM:\SOFTWARE\Microsoft\IIS Extensions\MSDeploy\3'
    if (!(Test-Path $msDeployRegKey)) {
        Write-Error "Could not detect MSDeploy v3 installation"
        return $null
    }
    $msDeployPath = (Get-ItemProperty $msDeployRegKey).InstallPath
    if ($null -eq $msDeployPath -or "" -eq $msDeployPath) {
        Write-Error "Could not detect MSDeploy v3 installation, registry key did not contain install path"
        return $null
    }
    $msDeploy = Join-Path $msDeployPath "msdeploy.exe"
    if (!(Test-Path $msDeploy)) {
        Write-Error "Could not find MSDeploy v3 EXE at $($msDeploy.FullName)"
        return $null
    }
    Add-PathVariable (Resolve-Path $msDeployPath)
}

#Function Load-SqlPackage()
#{
#    # Basically guess the location based on a limited number of search directories
#    $sqlDir = "C:\Program Files\Microsoft SQL Server\"
#    # TODO: Also look in "C:\Program Files (x86)\Microsoft SQL Server\"
#    if (! (Test-Path $sqlDir)) {
#        throw "SQL server dir not found"
#    }
#    if ($vsLocation -eq $null) {
#        Write-Error "Could not detect Visual Studio 2017 installation"
#        return $null
#    }
#
#    # Sample command
#    #sqlpackage.exe /a:Import "/tcs:Data Source=(localdb)\MSSQLLocalDB;Initial Catalog=WebPortal_5_4;Integrated Security=True;Application Name=ESIGNATURES" "/sf:d:\temp\local_webportal54_2019-11-19.bacpac"
#}

Function Load-MingWTools()
{
    $mingwDir = Get-ChildItem -Directory -LiteralPath 'd:\Apps\mingw-w64' | Select-Object -First 1 -ExpandProperty FullName

    $mingwBinDir = Join-Path $mingwDir 'mingw64/bin'
    #Add-PathVariable -Target Process -value $mingwBinDir

    $makeExe = Join-Path $mingwBinDir 'mingw32-make.exe'
    # Use -Force in case we earlier on set this alias for another toolchain
    Set-Alias make $makeExe -Scope Global -Force

    Write-Host -ForegroundColor 'Yellow' "MingW tools have been located"
}

# TF VC aliases
Function TFDiff {
    if ($null -eq (Get-Command tf -ErrorAction SilentlyContinue))
    {
        throw "No TF VC command found in Path";
    }
    tf diff . /recursive /format:unified
}

Function TFGet-LatestId {
    [CmdletBinding()]
    Param(
        $LabelId,
        $Url,
        $RootFolder
    )
    if ($null -eq (Get-Command tf -ErrorAction SilentlyContinue))
    {
        throw "No TF VC command found in Path";
    }
    if ($null -eq $Url -and $null -ne $RootFolder)
    {
        throw "No Url specified although a root folder was given"
    }
    if ($null -ne $Url -and $null -eq $RootFolder)
    {
        $rootFolders = tf vc dir /folders "/collection:$Url" '$/'
        throw "No root folder specified. Try one of the following:`n$([String]::Join("`n", $rootFolders))"
    }

    $cmd = "vc", "history", "/r", "/noprompt", "/stopafter:1"
    if ($null -ne $Url -and $null -ne $RootFolder)
    {
        $cmd += "/collection:$Url"
        $cmd += "`$/$RootFolder"
    }
    else
    {
        $cmd += "."
    }
    if ($null -eq $LabelId)
    {
        #tf history . /r /noprompt /stopafter:1 /version:W
        $cmd += "/version:W"
    }
    else
    {
        #$versionSpec = "/version:L$LabelId" 
        #tf history . /r /noprompt /stopafter:1 $versionSpec
        $cmd += "/version:L$LabelId" 
    }
    & "tf" $cmd
}

# Git aliases - uses very short names for convenience because definining the functions and aliases immediately after is silly.
Function GitFA() { git fetch --all }
Function GitS() { git status }
Function GitB() {
    $currentBranch = git symbolic-ref -q --short HEAD
    if ($LASTEXITCODE -ne 0) {
        $global:LASTEXITCODE = 0
        $currentBranch = "tag " + (git describe --tags --exact-match 2> $null)
        if ($LASTEXITCODE -ne 0) {
            $currentBranch = "detached at " + (git rev-parse --short=9 HEAD)
        }
    }
    $currentBranch
}
Function GitI() { git diff --cached }
Function GitSF() { git svn fetch }
Function GitFA() { git fetch --all }
Function GitFF($targetBranch) {
    $currentBranch = git rev-parse --abbrev-ref HEAD
    if ($LASTEXITCODE) { throw "Cannot determine current branch" }

    # If no target branch is given or requested branch is currently checked out we do a pull to let it check state of index
    if (-not ($targetBranch) -or $currentBranch -eq $targetBranch) {
        git pull --ff-only
        if ($LASTEXITCODE -eq 0) {
            git submodule update
            Write-Output "Branch $currentBranch in sync"
        } elseif ($currentBranch -eq "HEAD") {
            $detachedHeadInfo = git --no-pager log --max-count=1 --pretty=format:"%h%x20%x20%s" HEAD
            Write-Output "Could not fast-forward due to detached head on commit $detachedHeadInfo"
        } else {
            Write-Output "Could not fast-forward head $currentBranch"
        }
    } else {
        $upstreamBranch = git rev-parse --abbrev-ref --symbolic-full-name "$targetBranch@{upstream}"
        if ($LASTEXITCODE -or $null -eq $upstreamBranch) { throw "Failed to find branch '$targetBranch' or it has no configured upstream branch" }
        $remoteSeparator = $upstreamBranch.IndexOf('/')
        $remoteName = $upstreamBranch.Substring(0, $remoteSeparator)
        $remoteBranchName = $upstreamBranch.Substring($remoteSeparator + 1)
        #git fetch $remoteName
        #if ($LASTEXITCODE) { throw "Failed to update remote for '$upstreamBranch'" }

        ## Make sure that local branch can be fast-forwarded (i.e. all local commits have been pushed or upstream hasn't somehow done a forced push)
        #$currentLocalCommit = git rev-parse "refs/heads/$targetBranch"
        #$upstreamCommit = git rev-parse $upstreamBranch
        #git merge-base --is-ancestor $currentLocalCommit $upstreamCommit
        #if ($LASTEXITCODE) { throw "Branch '$targetBranch' has diverged from '$upstreamBranch', needs a merge instead" }

        #git update-ref "refs/heads/$targetBranch" $upstreamCommit $currentLocalCommit

        git fetch $remoteName "$($remoteBranchName):$targetBranch"
        if ($LASTEXITCODE) {
            throw "Branch '$targetBranch' might have diverged from '$upstreamBranch' or fetch failed to connect to remote"
        } else {
            Write-Output "Branch $targetBranch in sync"
        }
    }
}
Function GitMF() { git merge --ff-only $args }
Function GitKD() { gitk.exe --date-order $args }
Function GitKA() { gitk.exe --all $args }
Function GitKAD() { gitk.exe --all --date-order $args }
Function GitKU() {
    <#
        .Description
        Open gitk showing one or more branches, both the local and the upstream branch of each.
        Defaults to HEAD.
        First branch will be selected.
    #>

    # Split off gitk options (if added) by filtering out arguments starting with '-' or '^'
    $gitkArgs = @()
    $branches = @()
    for ($i = 0; $i -lt ($args.length); $i += 1) {
        if ($args[$i] -like '-*' -or $args[$i] -like '^*') {
            $gitkArgs += $args[$i]
        } else {
            $branches += $args[$i]
        }
    }
    if (!($branches)) {
        $branches += "HEAD"
    }
    foreach ($branch in $branches) {
        # Test if branch exists. HEAD is special because it is not a branch but a reference to the current branch or commit.
        if ($branch -cne "HEAD") {
            git show-ref --quiet "refs/heads/$branch" > $null
            if ($LASTEXITCODE -ne 0) {
                Write-Output "Branch $branch does not exist!"
                return
            }
        }
        $upstreamBranch = git rev-parse --abbrev-ref --symbolic-full-name "$($branch)@{upstream}" 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-Output "Branch $branch has no upstream!"
            return
        }
        $gitkArgs += $branch, $upstreamBranch
    }
    $selectedBranch = $branches[0]
    $gitkArgs = @("--select-commit=$selectedBranch") + $gitkArgs
    gitk.exe @gitkArgs
}
Function GitKUD() { GITKU "--date-order" $args }
Function GitKStash([string] $stash) {
    <#
        .Description
        Shows one or more stashes in gitk. It defaults to stash 0, pass * to see them all.
    #>
    if ($stash -eq "*") {
        gitk.exe "--argscmd=git stash list --pretty=format:%gd^!" $args
    } elseif ($stash -and -not ($stash -match "[0-9]+")) {
        throw "Stash argument needs to be empty, a positive number or '*'"
    } elseif (-not $stash) {
        gitk.exe "stash@{0}^!" $args
    } else {
        gitk.exe "stash@{$stash}^!" $args
    }
}
# SVN Rebase: attempt to run it, if it fails we stash the changes and try again
Function GitSR() {
    $undoStash = $False

    git svn rebase
    if ($? -eq $False -or $LASTEXITCODE -ne 0) {
        # There might be pending changes or there was a connection failure. Check index status
        git update-index --refresh > $null
        if ($? -eq $False -or $LASTEXITCODE -ne 0) {
            Write-Warning "Repository not clean, stashing changes before retrying"
            git stash
            $undoStash = $True
        }
        else
        {
            return
        }
        # Try again
        git svn rebase
        if ($undoStash) {
            git stash pop
        }
    }
}
# Based on https://stackoverflow.com/questions/1441010/the-shortest-possible-output-from-git-log-containing-author-and-date
Function GitLH() {
    <#
        .Description
        Prints head of log as commit id <tab> date <tab> message. It has 2 optional parameters: the number of commits to show
        and the branch. It doesn't use regular positional parameters so they can be easily swapped or left out.
    #>
    foreach ($arg in $args) {
        if ($arg -match "^[0-9]+$") {
            $count = [int]$arg
        } else {
            $branch = $arg
        }
    }
    if ($count -le 0) {
        $count = 4
    }
    if (-not ($branch)) {
        $branch = "HEAD"
    }
    git --no-pager log --max-count=$count --pretty=format:"%h%x20%x20%ad%x09%s" --date=format:'%Y-%m-%d %H:%M:%S' $branch
}
Function GitClean() {
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact = 'high')]
    param()

    $pathToClean = Resolve-Path (Get-Location)

    if ($PSCmdlet.ShouldProcess($pathToClean, "Cleaning git repository (forced)")) {
        Write-Output "Cleaning $()"
        git clean -dfx -e "*.review"
        git clean -dfX -e "!*.review"
    } elseif ([bool]$WhatIfPreference.IsPresent) {
        Write-Output "Dry-run of cleaning $()"
        $firstRun = git clean -dnx -e "*.review"
        $secondRun = git clean -dnX -e "!*.review"
        # Remove duplicate removals
        $firstRun + $secondRun | Select-Object -Unique
    }
}

# Used to review an Azure Devops Pull Request.
# This depends on the fact that the remote Devops server has a ref for each PR pointing to a merge commit with its contents.
# From this commit we can learn what the target branch is
function GitReviewPR([int] $pullRequest)
{
    # As part of this function we create a tag - see if it exists and if so, trash it to be recreated
    git rev-parse --verify "refs/tags/review/PR$pullRequest" 2> $null > $null
    $tagExists = $?

    # First get access to the remote ref
    git fetch origin refs/pull/$pullRequest/merge > $null
    if ($? -eq $False -or $LASTEXITCODE -ne 0) {
        throw "Failed to fetch changes in pull request $pullRequest"
    }
    $recreateCommit = $true
    $commitInfo = git cat-file commit FETCH_HEAD
    # Parse commit object to find tree id
    $commitTree = $commitInfo | ? { $_.StartsWith("tree ") } | Select-Object -First 1 | % { $_.Substring(5) }
    # This assumes that the PR target branch is the first parent
    $baseCommit = $commitInfo | ? { $_.StartsWith("parent ") } | Select-Object -First 1 | % { $_.Substring(7) }

    if ($tagExists) {
        # Check if the existing tag points to the same commit tree. If so, we do not need to do regenerate the PR commit
        $previousReviewCommitInfo = git cat-file commit "review/PR$pullRequest"
        $previousReviewCommitTree = $previousReviewCommitInfo | ? { $_.StartsWith("tree ") } | Select-Object -First 1 | % { $_.Substring(5) }
        $recreateCommit = $previousReviewCommitTree -ne $commitTree
    }

    if ($recreateCommit) {
        # Create a new commit with the same contents as the PR, but make it only have a single parent to get clear diffs
        # (This would be the same as doing 'git merge --squash PRbranch' onto the target branch)
        # Then make a tag pointing to it for easier retrieval
        $reviewCommit = git commit-tree -p $baseCommit -m "Review PR $pullRequest" $commitTree

        if ($tagExists) {
            git tag -d "review/PR$pullRequest" > $null
            Write-Output "Tag 'review/PR$pullRequest' recreated"
        } else {
            Write-Output "Tag 'review/PR$pullRequest' created"
        }
        $reviewTag = git tag "review/PR$pullRequest" $reviewCommit
    } else {
        Write-Output "Tag 'review/PR$pullRequest' is up to date"
        $reviewCommit = git rev-parse "review/PR$pullRequest"
    }

    $reviewFile = "PR$pullRequest.review"
    if (Test-Path $reviewFile) {
        Write-Warning "Review file '$reviewFile' already exists. Run ' GitReview `"review/PR$pullRequest^`" `"review/PR$pullRequest`" `"PR$pullRequest.review`" -Clobber ' instead"
    } else {
        $reviewHeader = "Subject: Review of PR $pullRequest`nCommit: $reviewCommit`nTree: $commitTree`n"
        $reviewHeader | Out-File -Encoding UTF8 -NoNewline $reviewFile
        # Run diff command using cmd because PowerShell tends to clobber encoding
        $diffCommand = "git diff -u `"review/PR$pullRequest^!`" review/PR$pullRequest >> $reviewFile"
        cmd /c $diffCommand > $null
    }
}

# Used to review changes between two commits.
# Unlike GitReviewPR, no tag will be made (yet).
function GitReviewDiff([string] $baseCommit, [string] $targetCommit)
{
    # Check that both commit parameters actually exist
    $fullBaseCommit = git rev-parse --verify "$baseCommit^{commit}" 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Invalid base commit"
        Write-Error $fullBaseCommit
    }
    $fullTargetCommit = git rev-parse --verify "$targetCommit^{commit}" 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Invalid target commit"
        Write-Error $fullTargetCommit
    }
    $shortBaseCommit = $fullBaseCommit.Substring(0, 8)
    $shortTargetCommit = $fullTargetCommit.Substring(0, 8)
    $reviewDescription = "Review of differences between commit $baseCommit ($shortBaseCommit) and $targetCommit ($shortTargetCommit)"
    $reviewFile = "diff-" + $shortBaseCommit  + "-" + $shortTargetCommit + ".review"

    # Find target commit
    $commitInfo = git cat-file commit $fullTargetCommit
    # Parse commit object to find tree id
    $commitTree = $commitInfo | ? { $_.StartsWith("tree ") } | Select-Object -First 1 | % { $_.Substring(5) }
    # Create a commit which "squashes" all the changes into 1 big commit (needed to later run git difftool from Vim)
    # TODO: Check if target and basecommit are actually parent and child, in which case this extra commit is overhead
    $reviewCommit = git commit-tree -p $fullBaseCommit -m $reviewDescription $commitTree

    if (Test-Path $reviewFile) {
        # This message should really be reworked...
        Write-Warning "Review file '$reviewFile' already exists. Run ' GitReview `"review/PR$pullRequest^`" `"review/PR$pullRequest`" `"PR$pullRequest.review`" -Clobber ' instead"
    } else {
        $reviewHeader = "Subject: $reviewDescription`nCommit: $reviewCommit`nTree: $commitTree`n"
        $reviewHeader | Out-File -Encoding UTF8 -NoNewline $reviewFile
        # Run diff command using cmd because PowerShell tends to clobber encoding.
        $diffCommand = "git diff -u $fullBaseCommit $fullTargetCommit >> $reviewFile"
        cmd /c $diffCommand > $null
    }
}

function GitContains ([string]$Needle, [string]$BranchOrCommit, [switch]$Remotes)
{
    <#
        .Description
        Tells you whether the commit pointed to by Needle is in the history of BranchOrCommit.
        Useful to check if a certain commit id was merged before or after the commit on which a certain build is based.
        Pass a -BranchOrCommit value "*" (default) to show all matching. Use the -Remotes switch to also include remote branches in that list.
    #>
    if (-not ($Needle)) {
        throw "No commit id or object specified"
    }
    if (-not ($BranchOrCommit)) {
        $BranchOrCommit = "*"
    }
    if ($BranchOrCommit -eq "*") {
        if ($Remotes) {
            $branches = git branch --all --contains $Needle
        } else {
            $branches = git branch --contains $Needle
        }
        $tags = git tag --contains $Needle
        if ($branches.Count -gt 0) {
            Write-Output "Branches:"
            $branches | Write-Output
        }
        if ($tags.Count -gt 0) {
            Write-Output "Tags:"
            $tags | % { "  "  + $_ } | Write-Output
        }
    } else {
        git merge-base --is-ancestor $Needle $BranchOrCommit > $null 2> $null
        if ($? -or $LASTEXITCODE -eq 0) {
            Write-Output "Commit '$Needle' is part of the history of '$BranchOrCommit'"
        } else {
            Write-Warning "Commit '$Needle' is not part of the history of '$BranchOrCommit'"
        }
    }
}
function Add-ProjectPackages ()
{
    <# .Description
       Restores Nuget and npm packages #>
    $solutions = Get-ChildItem -Recurse "*.sln"
    $npmFiles = Get-ChildItem -Recurse "package.json"
    $currentDir = Get-Location
    try {
        foreach ($solution in $solutions) {
            Set-Location (Split-Path -Parent $solution)
            nuget restore
        }
        foreach ($npmFile in $npmFiles) {
            # Ignore package.json in earlier downloaded node modules
            if (([string]$npmFile).Contains("node_modules")) {
                continue
            }
            Set-Location (Split-Path -Parent $npmFile)
            npm run-script get-frontend
        }
    } finally {
        Set-Location $currentDir
    }
}
# Finds all JSON files in subdirectories and "pretifies" them. It is assumed that they used the UTF8-no-BOM encoding.
Function ReformatJsonFiles() {
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact = 'high')]
    param(
        [string] $Endline
    )

    $jsonFiles = Get-ChildItem -Recurse "*.json"
    $utf8NoBom = New-Object System.Text.UTF8Encoding $false
    $jsonFileNames = $jsonFiles | % { $_.FullName + "`n" }

    if ($PSCmdlet.ShouldProcess($jsonFileNames, "Reformatting $($jsonFiles.Length) JSON files")) {
        foreach ($jsonFile in $jsonFiles) {
            Write-Output "Reformatting $(Resolve-Path $jsonFile)"

            $prettyContent = Get-Content -Encoding UTF8 -Raw $jsonFile | Format-Json -Endline $Endline
            # We explicitly convert to have no BOM, hence Byte encoding to write a byte array
            Set-Content -Path $jsonFile -Encoding Byte -Value $utf8NoBom.GetBytes($prettyContent)
        }
    }
}
# Taken from https://stackoverflow.com/a/56324939 and modified so single quotes are left as-is
# Also allow the endlines to be modified and escape (invisible) punctuation to make changes stand out.
function Format-Json {
    <#
    .SYNOPSIS
        Prettifies JSON output.
    .DESCRIPTION
        Reformats a JSON string so the output looks better than what ConvertTo-Json outputs.
    .PARAMETER Json
        Required: [string] The JSON text to prettify.
    .PARAMETER Minify
        Optional: Returns the json string compressed.
    .PARAMETER Indentation
        Optional: The number of spaces (1..1024) to use for indentation. Defaults to 4.
    .PARAMETER AsArray
        Optional: If set, the output will be in the form of a string array, otherwise a single string is output.
    .EXAMPLE
        $json | ConvertTo-Json  | Format-Json -Indentation 2
    #>
    [CmdletBinding(DefaultParameterSetName = 'Prettify')]
    Param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]$Json,

        [Parameter(ParameterSetName = 'Minify')]
        [switch]$Minify,

        [Parameter(ParameterSetName = 'Prettify')]
        [string]$Endline,

        [Parameter(ParameterSetName = 'Prettify')]
        [ValidateRange(1, 1024)]
        [int]$Indentation = 4,

        [Parameter(ParameterSetName = 'Prettify')]
        [switch]$AsArray
    )

    if ($PSCmdlet.ParameterSetName -eq 'Minify') {
        return ($Json | ConvertFrom-Json) | ConvertTo-Json -Depth 100 -Compress
    }

    # If the input JSON text has been created with ConvertTo-Json -Compress
    # then we first need to reconvert it without compression
    if ($Json -notmatch '\r?\n') {
        $Json = ($Json | ConvertFrom-Json) | ConvertTo-Json -Depth 100
    }

    $indent = 0
    $regexUnlessQuoted = '(?=([^"]*"[^"]*")*[^"]*$)'

    $result = $Json -split '\r?\n' |
        ForEach-Object {
            # If the line contains a ] or } character, 
            # we need to decrement the indentation level unless it is inside quotes.
            if ($_ -match "[}\]]$regexUnlessQuoted") {
                $indent = [Math]::Max($indent - $Indentation, 0)
            }

            # Replace all colon-space combinations by ": " unless it is inside quotes.
            $line = (' ' * $indent) + ($_.TrimStart() -replace ":\s+$regexUnlessQuoted", ': ')

            # Leave single quotes as is instead of outputting them as Unicode escapes
            $line = $line -replace "\\u0027", "'"

            # If the line contains a [ or { character, 
            # we need to increment the indentation level unless it is inside quotes.
            if ($_ -match "[\{\[]$regexUnlessQuoted") {
                $indent += $Indentation
            }

            $line
        }

    if ($AsArray) { return $result }
    if ($Endline) {
        return $result -Join $Endline
    }
    return $result -Join [Environment]::NewLine
}

function Compare-TTML {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $sourceFile,

        [Parameter(Mandatory = $false)]
        $baseFile,

        [Parameter(Mandatory = $true)]
        $destFile,

        [Parameter(Mandatory = $false)]
        [switch] $focusOnText
    )
    if ($null -eq (Get-Command kdiff3 -ErrorAction SilentlyContinue)) {
        throw "KDiff3 not found in path";
    }
    if ($null -eq (Get-Command sed -ErrorAction SilentlyContinue)) {
        throw "sed not found in path";
    }
    $sourceFile = Resolve-Path $sourceFile
    $destFile = Resolve-Path $destFile

    # Create a copy of the kdiff3 config file where we can override any config value we want
    $tempConfig = New-TemporaryFile
    Copy-Item (Join-Path $env:HOME ".kdiff3rc") $tempConfig.FullName > $null

    $diffArgs = @($sourceFile, $destFile, "--config", (Resolve-Path $tempConfig),`
        "--cs", "PreProcessorCmd=sed -e 's/^\\s\\+//;s/ region=\\x22bottom\\x22//g;s/ xml:id=\\x22[^\\x22]\\+\\x22//g'")

    if ($focusOnText) {
        # Strip out the <p start= end=> and </p> tags entirely so line matcher only sees the text. Newline becomes space
        $diffArgs = $diffArgs + @("--cs", `
            "LineMatchingPreProcessorCmd=sed -e 's@<br \\?/>@ @g;s/<p \\([^>]\\+\\)>\\(.*\\)/\\2/g;s@</p>@@g'")
    } else {
        # Newline becomes space during line matching, move <p ..> tag to end of line to make auto-aligning work better
        $diffArgs = $diffArgs + @("--cs", `
            "LineMatchingPreProcessorCmd=sed -e 's@<br \\?/>@ @g;s/<p \\([^>]\\+\\)>\\(.*\\)/\\2<p \\1>/g'")
    }

    if ($baseFile) {
        $baseFile = Resolve-Path $baseFile
        $diffArgs = @($baseFile) + $diffArgs
    }
    kdiff3 @diffArgs
}
