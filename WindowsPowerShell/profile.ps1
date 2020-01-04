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
Function GitKStash([string] $stash) {
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
        if ($arg -match "[0-9]+") {
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

# Tells you whether the commit pointed to by Needle is in the history of BranchOrCommit.
# Useful to check if a certain commit id was merged before or after the commit on which a certain build is based.
function GitContains ([string]$Needle, [string]$BranchOrCommit)
{
    if (-not ($Needle)) {
        throw "No commit id or object specified"
    }
    if (-not ($BranchOrCommit)) {
        $BranchOrCommit = "*"
    }
    if ($BranchOrCommit -eq "*") {
        $branches = git branch --contains $Needle
        $tags     = git tag --contains $Needle
        if ($null -ne $branches -and $branches.Count -ge 0) {
            Write-Output "Branches:"
            $branches | Write-Output
        }
        if ($null -ne $tags -and $tags.Count -ge 0) {
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
