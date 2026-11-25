param(
    [switch]$NoStartup,
    [switch]$ForceBuild
)

$ErrorActionPreference = 'Stop'

if ($args -contains '--ForceBuild' -or $args -contains '-ForceBuild') {
    $ForceBuild = $true
}
if ($args -contains '--NoStartup' -or $args -contains '-NoStartup') {
    $NoStartup = $true
}

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$DaemonJs = Join-Path $RepoRoot 'daemon\theme_daemon.js'
$PayloadJs = Join-Path $RepoRoot 'dist\theme_payload.js'
$ThemesJson = Join-Path $RepoRoot 'themes\themes.json'
$BuildPy = Join-Path $RepoRoot 'scripts\build_payload.py'
$PidFile = Join-Path $RepoRoot 'daemon.pid'
$VbsPath = Join-Path $RepoRoot 'silent-start.vbs'

function Update-SessionPath {
    $MachinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $UserPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $Combined = @($MachinePath, $UserPath, $env:PATH) | Where-Object { $_ }
    $PathParts = ($Combined -join ';') -split ';' | Where-Object { $_ -and $_.Trim() -ne '' }

    $NodeDirs = @(
        (Join-Path $env:ProgramFiles 'nodejs'),
        (Join-Path $env:LOCALAPPDATA 'Programs\nodejs')
    )
    if (${env:ProgramFiles(x86)}) {
        $NodeDirs += (Join-Path ${env:ProgramFiles(x86)} 'nodejs')
    }

    $FinalParts = New-Object System.Collections.Generic.List[string]
    foreach ($Dir in $NodeDirs) {
        if ($Dir -and (Test-Path $Dir)) {
            $FinalParts.Add($Dir)
        }
    }
    foreach ($Part in $PathParts) {
        $Trimmed = $Part.Trim()
        if ($Trimmed -and -not ($FinalParts | Where-Object { $_ -ieq $Trimmed })) {
            $FinalParts.Add($Trimmed)
        }
    }
    $env:PATH = ($FinalParts -join ';')
}

function Get-NodeInfo {
    $Cmd = Get-Command node -ErrorAction SilentlyContinue
    if (-not $Cmd) {
        $FallbackNode = Join-Path $env:ProgramFiles 'nodejs\node.exe'
        if (Test-Path $FallbackNode) {
            return @{ Exe = $FallbackNode; Major = (Get-NodeMajor -Exe $FallbackNode) }
        }
        return @{ Exe = $null; Major = 0 }
    }
    return @{ Exe = $Cmd.Source; Major = (Get-NodeMajor -Exe $Cmd.Source) }
}

function Get-NodeMajor {
    param([string]$Exe)
    if (-not $Exe -or -not (Test-Path $Exe)) { return 0 }
    try {
        $PrevEap = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        $Raw = (& $Exe -p "process.versions.node.split('.')[0]" 2>$null)
        $ErrorActionPreference = $PrevEap
        $Parsed = 0
        if ($Raw -and [int]::TryParse(($Raw | Select-Object -First 1).ToString().Trim(), [ref]$Parsed)) {
            return $Parsed
        }
    } catch {
        # Ignore probe errors
    }
    return 0
}

function Find-WorkingPython {
    foreach ($Name in @('python', 'python3')) {
        $Cmd = Get-Command $Name -ErrorAction SilentlyContinue
        if ($Cmd -and $Cmd.Source -and ($Cmd.Source -notmatch '\\WindowsApps\\python')) {
            try {
                $PrevEap = $ErrorActionPreference
                $ErrorActionPreference = 'Continue'
                $Out = (& $Cmd.Source -c "import sys; print(sys.version_info[0])" 2>$null)
                $Exit = $LASTEXITCODE
                $ErrorActionPreference = $PrevEap
                if ($Exit -eq 0 -and ($Out -match '^3')) {
                    return $Cmd.Source
                }
            } catch {
                # Ignore broken alias
            }
        }
    }
    return $null
}

Update-SessionPath
$NodeInfo = Get-NodeInfo

if (-not $NodeInfo.Exe -or $NodeInfo.Major -lt 22) {
    $FoundDesc = if ($NodeInfo.Exe) { "v$($NodeInfo.Major) at $($NodeInfo.Exe)" } else { "missing" }
    Write-Host "[install-win] Node.js >= 22 is required (currently $FoundDesc). Attempting install via winget..."
    $WingetCmd = Get-Command winget -ErrorAction SilentlyContinue
    if (-not $WingetCmd) {
        Write-Error "Node.js >= 22 not found and winget is unavailable. Please install Node.js LTS (>= 22) from https://nodejs.org/ and re-run."
    }

    $PrevEap = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    & $WingetCmd.Source install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements --silent
    $ErrorActionPreference = $PrevEap

    Update-SessionPath
    $NodeInfo = Get-NodeInfo

    if (-not $NodeInfo.Exe -or $NodeInfo.Major -lt 22) {
        $PrevEap = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        & $WingetCmd.Source upgrade OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements --silent
        $ErrorActionPreference = $PrevEap

        Update-SessionPath
        $NodeInfo = Get-NodeInfo
    }

    if (-not $NodeInfo.Exe -or $NodeInfo.Major -lt 22) {
        Write-Error "Node.js >= 22 is still unavailable after winget install. Please install Node.js >= 22 manually from https://nodejs.org/ and re-run."
    }
}

$NodeExe = $NodeInfo.Exe
$NodeMajor = $NodeInfo.Major
Write-Host "[install-win] Using Node.js v$NodeMajor ($NodeExe)"

$PayloadExists = Test-Path $PayloadJs
$ThemesIsNewer = $false
if ($PayloadExists -and (Test-Path $ThemesJson)) {
    $PayloadTime = (Get-Item $PayloadJs).LastWriteTimeUtc
    $ThemesTime = (Get-Item $ThemesJson).LastWriteTimeUtc
    if ($ThemesTime -gt $PayloadTime.AddSeconds(2)) {
        $ThemesIsNewer = $true
    }
}

$PyExe = Find-WorkingPython

if ($ForceBuild -or -not $PayloadExists) {
    if (-not $PyExe) {
        Write-Error "Python 3 was not found to compile dist/theme_payload.js (ForceBuild=$ForceBuild, PayloadExists=$PayloadExists)."
    }
    Write-Host "[install-win] Compiling dist/theme_payload.js..."
    & $PyExe $BuildPy
    if ($LASTEXITCODE -ne 0) {
        Write-Error "build_payload.py failed with exit code $LASTEXITCODE."
    }
} elseif ($ThemesIsNewer -and $PyExe) {
    Write-Host "[install-win] themes/themes.json is newer than dist/theme_payload.js; recompiling with Python..."
    & $PyExe $BuildPy
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "[install-win] Rebuild failed (exit code $LASTEXITCODE); falling back to existing dist/theme_payload.js."
    }
} else {
    Write-Host "[install-win] Using pre-compiled dist/theme_payload.js (ready out-of-the-box)."
}

if (Test-Path $PidFile) {
    $OldPidText = (Get-Content $PidFile -ErrorAction SilentlyContinue | Select-Object -First 1)
    $OldPid = 0
    if ([int]::TryParse(($OldPidText -as [string]), [ref]$OldPid) -and $OldPid -gt 0) {
        $ExistingProc = Get-Process -Id $OldPid -ErrorAction SilentlyContinue
        if ($ExistingProc -and $ExistingProc.ProcessName -eq 'node') {
            Write-Host "[install-win] Stopping existing daemon (PID $OldPid)..."
            Stop-Process -Id $OldPid -Force -ErrorAction SilentlyContinue
            Start-Sleep -Milliseconds 350
        }
    }
    Remove-Item $PidFile -Force -ErrorAction SilentlyContinue
}

# Generate silent-start.vbs dynamically without hardcoding user or Node paths.
$EscapedNode = $NodeExe.Replace('"', '""')
$EscapedDaemon = $DaemonJs.Replace('"', '""')
$VbsContent = @"
Set WshShell = CreateObject("WScript.Shell")
WshShell.CurrentDirectory = "$($RepoRoot.Replace('"', '""'))"
WshShell.Run """$EscapedNode"" --max-old-space-size=24 --expose-gc ""$EscapedDaemon""", 0, False
"@
Set-Content -Path $VbsPath -Value $VbsContent -Encoding ASCII

$WshShell = New-Object -ComObject WScript.Shell

# Ensure Antigravity shortcuts include --remote-debugging-port=0 (required on Antigravity v2.33.0+)
$ShortcutSearchDirs = @(
    [Environment]::GetFolderPath('DesktopDirectory'),
    [Environment]::GetFolderPath('Programs'),
    [Environment]::GetFolderPath('Startup'),
    (Join-Path $env:APPDATA 'Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar')
) | Where-Object { $_ -and (Test-Path $_) }

foreach ($SearchDir in $ShortcutSearchDirs) {
    Get-ChildItem -Path $SearchDir -Recurse -Filter '*.lnk' -ErrorAction SilentlyContinue | ForEach-Object {
        try {
            $Sc = $WshShell.CreateShortcut($_.FullName)
            if ($Sc.TargetPath -and ($Sc.TargetPath -imatch '\\Antigravity\.exe$')) {
                if ($Sc.Arguments -notmatch '--remote-debugging-port') {
                    $Sc.Arguments = ("$($Sc.Arguments) --remote-debugging-port=0").Trim()
                    $Sc.Save()
                    Write-Host "[install-win] Patched CDP flag on shortcut: $($_.FullName)"
                }
            }
        } catch {
            # Ignore unreadable or protected shortcuts
        }
    }
}

if (-not $NoStartup) {
    $StartupDir = [Environment]::GetFolderPath('Startup')
    $ShortcutPath = Join-Path $StartupDir 'AntigravityCustomTheme.lnk'
    $Shortcut = $WshShell.CreateShortcut($ShortcutPath)
    $Shortcut.TargetPath = 'wscript.exe'
    $Shortcut.Arguments = """$VbsPath"""
    $Shortcut.WorkingDirectory = $RepoRoot
    $Shortcut.WindowStyle = 7
    $Shortcut.Description = 'Antigravity Custom Theme Daemon'
    $Shortcut.Save()
    Write-Host "[install-win] Startup shortcut created: $ShortcutPath"
}

Write-Host "[install-win] Launching daemon via wscript.exe..."
Start-Process -FilePath 'wscript.exe' -ArgumentList """$VbsPath""" -WorkingDirectory $RepoRoot

for ($i = 0; $i -lt 15; $i++) {
    Start-Sleep -Milliseconds 250
    if (Test-Path $PidFile) {
        $NewPidText = (Get-Content $PidFile -ErrorAction SilentlyContinue | Select-Object -First 1)
        $NewPid = 0
        if ([int]::TryParse(($NewPidText -as [string]), [ref]$NewPid) -and $NewPid -gt 0) {
            if (Get-Process -Id $NewPid -ErrorAction SilentlyContinue) {
                Write-Host "[install-win] Daemon running silently (PID $NewPid)."
                $PortFile = Join-Path $env:APPDATA 'Antigravity\DevToolsActivePort'
                if (-not (Test-Path $PortFile)) {
                    Write-Host "[install-win] Note: DevToolsActivePort not found yet. Quit Antigravity completely (System Tray -> Quit) and reopen it from Start Menu (if using a Taskbar pin, unpin and re-pin from Start Menu)."
                }
                exit 0
            }
        }
    }
}

Write-Warning "[install-win] Daemon did not write daemon.pid in time. Check $RepoRoot\daemon.log."
exit 1
