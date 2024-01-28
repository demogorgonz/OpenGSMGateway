<# .SYNOPSIS
    Invoke-Build build script
#>
param (
    # Version/tag of the mm-docs image to use
    [string] $aVersion   = (property MM_DOCS_VERSION '1.1'),

    # Registry and name to use to get mm-docs image
    [string] $aImageName = (property MM_DOCS_IMAGE_NAME 'majkinetor/mm-docs'),

    # Port to use when serving on localhost
    [int]    $aPort      = (property MM_DOCS_PORT 8001),

    # Do not pass proxy environment variables to the docker container
    [switch] $aNoProxy,

    # Top level section to publish judged by the folder name
    [ValidateSet("", "full", "user", 'tech', 'funspec', 'admin')]
    [string] $aSection = ""
)

Enter-Build {
    Write-Host "If you are behind the proxy use http(s)_proxy environment variables"

    $script:ImageFullName = if (!$aVersion) { $aImageName } else { "${aImageName}:$aVersion" }
    $script:ServeAddress  = "0.0.0.0:$aPort"
    $script:ServeAddress  = "0.0.0.0:$aPort"
    $script:ProjectName   = (Split-Path -Leaf $BuildFile).Replace('.build.ps1','')
    $script:ProjectRoot   = git rev-parse --show-toplevel
    $script:ContainerName = $ProjectName
    $script:Url = "http://localhost:$aPort"

    $script:DocsDir = 'source/docs/'
    $script:RevisionPathToRemove  = "$DocsDir"

    if (!$aSection) { $aSection = "full" }
    if ($aSection -ne 'full') {
        Write-Host "Using section '$aSection'"
        $script:ConfigParam = "--config-file " + (Set-MkdocsNavSection -Section $aSection)
    }
}

task . Build

# Synopsis: Serve documentation site on localhost
task Run Stop, GitRevisionDates, {
    $Env:MM_DOCS_URL_PREFIX = $script:Url
    $ContainerName = "$ContainerName-$aPort"
    docker-run mkdocs serve --dev-addr $ServeAddress -Detach -Expose $ConfigParam
}, PingTest

# Synopsis: Build documentation into static site
task Build GitRevisionDates, {
    $ContainerName = "$ContainerName-build"
    docker-run mkdocs build $ConfigParam
}

# Synopsis: Stop docker documentation container that serves documentation
task Stop {
    $docs = docker ps --format '{{json .}}' | ConvertFrom-Json | ? Names -like "${ContainerName}-*"
    if ($docs) {
        Write-Host "Stopping running container:" $docs.Names
        docker stop $docs.Names
    } else { Write-Host "No documentation container found serving content" }
}

# Synopsis: Check internal and external links (requires Run)
task CheckLinks {
    Write-Host "Checking links"
    $ContainerName = "$ContainerName-$aPort"
    $cmd = 'docker exec -t {0} /bin/sh -c "blc -erf --exclude /print_page --exclude /{2}.pdf --filter-level 0 http://localhost:{1}"' -f $ContainerName, $aPort, $ProjectName
    Write-Host $cmd -ForegroundColor yellow
    exec { Invoke-Expression $cmd }
}

# Synopsis: Do basic availability test
task PingTest {
    Wait-Action { Invoke-WebRequest $args[0] } -ArgumentList $Url -Timeout 60 -Message "Testing service response: $url"
}

# Synopsis: Export PDF of entire site (requires Run and print_page plugin)
task ExportPdf {
    Write-Host "Exporting PDF"
    $ContainerName = "$ContainerName-$aPort"
    $pdfPath = "pdf/$ProjectName.pdf"
    Remove-Item $pdfPath -ea 0
    $cmd = 'docker exec -t {0} /bin/sh -c "npm --no-update-notifier link puppeteer; node pdf/print.js {1}/print_page.html {2} {3}"' -f $ContainerName, $Url, $pdfPath, $ProjectName
    Write-Host $cmd -ForegroundColor yellow
    exec { Invoke-Expression $cmd }

    $pdfPath = "source/$pdfPath"
    if (!(Test-Path $pdfPath)) { throw 'PDF was not generated' }
    Write-Host "Copying PDF to site root"
    Copy-Item $pdfPath source/site/
}

# Synopsis: Export standalone HTML of the entire site (requires Build, Run and print_page plugin)
task ExportHTML {
    Write-Host "Exporting HTML"
    $ContainerName = "$ContainerName-$aPort"
    $htmlPath = "$ProjectName.html"
    Remove-Item $htmlPath -ea 0
    $cmd = 'docker exec -t {0} /bin/sh -c "cd site; htmlark print_page.html -o {1}"' -f $ContainerName, $htmlPath
    Write-Host $cmd -ForegroundColor yellow
    exec { Invoke-Expression $cmd }

    $htmlPath = "source/site/$htmlPath"
    if (!(Test-Path $htmlPath)) { throw 'HTML was not generated' }
}

# Synopsis: Export entire site (requires Build and offline plugin)
task ExportSite {
    Write-Host "Exporting Site"
    $sitePath = "$ProjectName.zip"
    Remove-Item $sitePath -ea 0
    Compress-Archive source/site/* $sitePath
    if (!(Test-Path $sitePath)) { throw 'Site zip was not generated' }
    Move-Item $sitePath source/site
}

# Synopsis: Clean generated documentation files (not docker images)
task Clean { remove source\site, source\__pycache__ }


# Synopsis: Get the last revision date for all files in the documentation
task GitRevisionDates {
    $mdRevisionPath = "$DocsDir/revision.md"

"# Revisions

**Build Date**: $((get-date -format s).Replace('T',' '))

[View revision.json](../revision.json)

|Date|Path|
|---|---|" | Out-File -Encoding utf8 $mdRevisionPath

    $revisions = Get-GitRevisionDates -Path $DocsDir -Ext '.md'
    $revisions | ConvertTo-Json | Out-File $DocsDir/revision.json
    $revisions.GetEnumerator() | % { "|{0}|{1}" -f $_.Value.Date, $_.Key } | Out-File -Encoding utf8 -Append $mdRevisionPath
    Get-Item $mdRevisionPath
}

function docker-run( [switch] $Interactive, [switch] $Detach, [switch] $Expose) {
    $params = @(
        'run'
        '--rm'
        '-v',    "'${pwd}:/docs'"
        '--name', $ContainerName
        '--env', 'MM_DOCS_ENABLE_PDF_EXPORT'
        '--env', 'MM_DOCS_URL_PREFIX'

        if ($IsLinux)     { '--user {0}:{1}' -f $(id -u), $(id -g)  }
        if ($Interactive) { '--interactive --tty' }
        if ($Detach)      { '--detach' }
        if ($Expose)      { '-p', "${aPort}:${aPort}" }
        if (!$aNoProxy -and $Env:HTTP_PROXY) { '--env', "http_proxy",'--env', "https_proxy" }

        $ImageFullName
    )

    $cmd = "`ndocker $params $args`n"
    Write-Host $cmd -ForegroundColor yellow
    exec { Invoke-Expression $cmd }
}

# NOTE: This doesn't work correctly with shallow clones:
# https://stackoverflow.com/questions/60868897/git-log-dates-incorrect-in-a-github-action
function Get-GitRevisionDates($Path='.', $Ext)
{
    [array] $gitlog = git --no-pager log --format=format:%ai --name-only $Path

    $res = @{}
    $date = Get-Date
    foreach ($line in $gitlog) {
        if ([DateTime]::TryParse($line, [ref]$date)) { $lastdate = $date; continue }
        if (!$line.StartsWith($RevisionPathToRemove)) { continue }
        if (!$line.Trim().EndsWith($Ext)) { continue }
        $line = $line.Replace($RevisionPathToRemove, '')
        if ($line.StartsWith('files')) { continue }
        if ($res.$line) { continue }
        $res.$line = @{ Date = $lastdate.ToString('yyyy-MM-dd HH:mm:ss') }
    }
    $res
}

function Wait-Action ([ScriptBlock]$Action, [int]$Timeout=20, [string] $Message, $ArgumentList) {
    Write-Host "Waiting for action to succeed up to $Timeout seconds"
    Write-Host "|== $Message"

    $start = Get-Date
    while ($true) {
        $elapsed = ((Get-Date) - $start).TotalSeconds
        if ($elapsed -ge $Timeout) {break}

        $j = Start-Job $Action -ArgumentList $ArgumentList
        $maxWait = [int]($Timeout-$elapsed)
        if ($maxWait -lt 1) { $maxWait = 1 }
        Wait-Job $j -Timeout $maxWait | Out-Null

        if ($j.State -eq 'Running') { $err = 'still running'; break }
        if ($j0 = $j.ChildJobs[0]) {
            if ($err = $j0.Error) { continue }
            if ($err = $J0.JobStateInfo.Reason) {continue}
        }
        try { Receive-Job $j -ErrorAction STOP | Out-Null; } catch { $err = "$_"; continue }

        Write-Host "Action succeded"; return
    }

    throw "Action timedout. Last error: $err"
}

# Create mkdocs-<section>.yml file and return its file name
# SectionName is first level nav section and it is specified by folder name
# For function to work, the first item in the section MUST point to to the file (e.g. it can't be submenu)
function Set-MkdocsNavSection ([string] $ConfigPath = "$PSScriptRoot/source/mkdocs.yml", [string]$SectionName)
{
    $conf = Get-Content $ConfigPath
    $navStart = $secStart = $null; $navEnd = $conf.Length; $sections = @()
    $section = for($i=0; $i -lt $conf.Length; $i++) {
        if ( $conf[$i] -eq "nav:" ) { $navStart = $i; continue }
        if (!$navStart) {continue } else { $line = $conf[$i] }
        if ( $line -notmatch '^(\s+|-)') { $navEnd = $i; break }

        if (!$secEnd) { $secEnd = $secStart -and ($line -like '-*') }

        if ($line -match " $SectionName/" ) {
            if (!$secStart) { $secStart = $i; $trimLeftIdx = $line.IndexOf('-') }
            $line.Substring($trimLeftIdx)
        } else {
            if ($secStart -and !$secEnd) { $line.Substring($trimLeftIdx) } else {
                if ($line -match "(?<=: )(.+?)(?=/.+)") {
                    if ($Matches[0].Trim() -notin $sections) { $sections += $Matches[0] }
                }
            }
        }
    }
    if (!$secStart) { throw "Unable to find section '$SectionName'" }
    $res = $conf[0..$navStart], $section, $conf[$navEnd..$conf.Length]

    # Add other sections to excludes or they will got build anyway
    $excludeRegEx = 'regex: [({0})/.+]' -f ($sections -join '|')
    $res = $res.Replace('regex: []', $excludeRegEx )

    $outDir   = Split-Path $ConfigPath
    $fileName = (Split-Path -Leaf $ConfigPath) -replace '\.yml', "-$SectionName.yml"
    $outPath = Join-Path $outDir $fileName
    if (Test-Path $outPath) { Remove-Item $outPath }
    Set-Content $outPath $res
    $fileName
}
