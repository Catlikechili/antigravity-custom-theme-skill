# Antigravity Custom Theme Skill - 1-Command Windows Bootstrap Installer
# Usage (PowerShell):
#   irm https://raw.githubusercontent.com/Catlikechili/antigravity-custom-theme-skill/main/scripts/bootstrap-win.ps1 | iex

& {
    $ErrorActionPreference = 'Stop'

    $RepoUrl = 'https://github.com/Catlikechili/antigravity-custom-theme-skill.git'
    $TargetDir = Join-Path $env:USERPROFILE '.gemini\config\skills\antigravity-custom-theme'
    $SkillsParent = Split-Path -Parent $TargetDir

    function Update-BootstrapPath {
        $MachinePath = [Environment]::GetEnvironmentVariable('Path', 'Machine')
        $UserPath = [Environment]::GetEnvironmentVariable('Path', 'User')
        $Combined = @($MachinePath, $UserPath, $env:PATH) | Where-Object { $_ }
        $PathParts = ($Combined -join ';') -split ';' | Where-Object { $_ -and $_.Trim() -ne '' }

        $KnownToolDirs = @(
            (Join-Path $env:ProgramFiles 'nodejs'),
            (Join-Path $env:LOCALAPPDATA 'Programs\nodejs'),
            (Join-Path $env:ProgramFiles 'Git\cmd'),
            (Join-Path $env:LOCALAPPDATA 'Programs\Git\cmd')
        )
        if (${env:ProgramFiles(x86)}) {
            $KnownToolDirs += (Join-Path ${env:ProgramFiles(x86)} 'nodejs')
            $KnownToolDirs += (Join-Path ${env:ProgramFiles(x86)} 'Git\cmd')
        }

        $FinalParts = New-Object System.Collections.Generic.List[string]
        foreach ($Dir in $KnownToolDirs) {
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

    function Get-BootstrapNodeMajor {
        $NodeCmd = Get-Command node -ErrorAction SilentlyContinue
        if (-not $NodeCmd) { return 0 }
        try {
            $PrevEap = $ErrorActionPreference
            $ErrorActionPreference = 'Continue'
            $Raw = (& $NodeCmd.Source -p "process.versions.node.split('.')[0]" 2>$null)
            $ErrorActionPreference = $PrevEap
            $Ver = 0
            if ($Raw -and [int]::TryParse(($Raw | Select-Object -First 1).ToString().Trim(), [ref]$Ver)) {
                return $Ver
            }
        } catch {
            # Ignore probe failure
        }
        return 0
    }

    Write-Host "================================================================" -ForegroundColor Cyan
    Write-Host "  Antigravity Custom Theme Skill - Windows 1-Command Installer  " -ForegroundColor Cyan
    Write-Host "================================================================" -ForegroundColor Cyan

    Update-BootstrapPath

    # 1. Check / Install Git
    $GitCmd = Get-Command git -ErrorAction SilentlyContinue
    if (-not $GitCmd) {
        Write-Host "[bootstrap] Git not found. Installing Git via winget..." -ForegroundColor Yellow
        $WingetCmd = Get-Command winget -ErrorAction SilentlyContinue
        if (-not $WingetCmd) {
            Write-Error "Git is missing and winget is unavailable. Please install Git from https://git-scm.com/download/win and re-run."
            return
        }
        $PrevEap = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        & $WingetCmd.Source install --id Git.Git --exact --accept-package-agreements --accept-source-agreements --silent
        $ErrorActionPreference = $PrevEap
        Update-BootstrapPath
        $GitCmd = Get-Command git -ErrorAction SilentlyContinue
        if (-not $GitCmd) {
            Write-Error "Git installation finished, but git.exe was not found in PATH. Reopen PowerShell and run the command again."
            return
        }
    }
    Write-Host "[bootstrap] Git ready: $($GitCmd.Source)" -ForegroundColor Green

    # 2. Check / Install Node.js >= 22
    $NodeMajor = Get-BootstrapNodeMajor
    if ($NodeMajor -lt 22) {
        Write-Host "[bootstrap] Node.js >= 22 required (detected major: $NodeMajor). Installing OpenJS.NodeJS.LTS via winget..." -ForegroundColor Yellow
        $WingetCmd = Get-Command winget -ErrorAction SilentlyContinue
        if (-not $WingetCmd) {
            Write-Error "Node.js >= 22 is missing and winget is unavailable. Please install Node.js LTS from https://nodejs.org/ and re-run."
            return
        }
        $PrevEap = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        & $WingetCmd.Source install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements --silent
        $ErrorActionPreference = $PrevEap
        Update-BootstrapPath
        $NodeMajor = Get-BootstrapNodeMajor
        if ($NodeMajor -lt 22) {
            $PrevEap = $ErrorActionPreference
            $ErrorActionPreference = 'Continue'
            & $WingetCmd.Source upgrade OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements --silent
            $ErrorActionPreference = $PrevEap
            Update-BootstrapPath
            $NodeMajor = Get-BootstrapNodeMajor
        }
        if ($NodeMajor -lt 22) {
            Write-Error "Node.js >= 22 could not be verified after winget install. Please install from https://nodejs.org/ and re-run."
            return
        }
    }
    Write-Host "[bootstrap] Node.js v$NodeMajor ready." -ForegroundColor Green

    # 3. Clone or Update Repository
    if (-not (Test-Path $SkillsParent)) {
        New-Item -ItemType Directory -Path $SkillsParent -Force | Out-Null
    }

    $GitDir = Join-Path $TargetDir '.git'
    if (Test-Path $GitDir) {
        Write-Host "[bootstrap] Existing repository found at $TargetDir. Pulling latest updates..." -ForegroundColor Cyan
        $PrevEap = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        $CurrentOrigin = (& $GitCmd.Source -C $TargetDir remote get-url origin 2>$null)
        if ($CurrentOrigin -and (($CurrentOrigin.Trim() -ieq $RepoUrl) -or ($CurrentOrigin.Trim() -ieq ($RepoUrl -replace '\.git$', '')))) {
            & $GitCmd.Source -C $TargetDir pull --ff-only
        } else {
            & $GitCmd.Source -C $TargetDir pull --ff-only $RepoUrl main
        }
        $PullExit = $LASTEXITCODE
        $ErrorActionPreference = $PrevEap
        if ($PullExit -ne 0) {
            Write-Warning "[bootstrap] git pull --ff-only skipped due to local modifications. Continuing with local checkout..."
        }
    } elseif (Test-Path $TargetDir) {
        $Items = Get-ChildItem -Path $TargetDir -Force -ErrorAction SilentlyContinue
        if (-not $Items) {
            Write-Host "[bootstrap] Cloning repository into $TargetDir..." -ForegroundColor Cyan
            & $GitCmd.Source clone $RepoUrl $TargetDir
            if ($LASTEXITCODE -ne 0) {
                Write-Error "git clone failed with exit code $LASTEXITCODE."
                return
            }
        } else {
            Write-Error "Directory $TargetDir already exists and is not a Git repository. Back it up or rename it before running bootstrap."
            return
        }
    } else {
        Write-Host "[bootstrap] Cloning repository into $TargetDir..." -ForegroundColor Cyan
        & $GitCmd.Source clone $RepoUrl $TargetDir
        if ($LASTEXITCODE -ne 0) {
            Write-Error "git clone failed with exit code $LASTEXITCODE."
            return
        }
    }

    # 4. Run install-win.ps1
    $InstallScript = Join-Path $TargetDir 'scripts\install-win.ps1'
    if (-not (Test-Path $InstallScript)) {
        Write-Error "Installer script not found at $InstallScript."
        return
    }

    Write-Host "[bootstrap] Running scripts/install-win.ps1..." -ForegroundColor Cyan
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $InstallScript
    if ($LASTEXITCODE -ne 0) {
        Write-Error "install-win.ps1 exited with code $LASTEXITCODE."
        return
    }

    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Green
    Write-Host "  Installation Complete! Antigravity Custom Theme is active.    " -ForegroundColor Green
    Write-Host "  -> Open Antigravity -> Click 'Custom theme' in left sidebar.  " -ForegroundColor Green
    Write-Host "  -> If Antigravity was already open without CDP port, right-   " -ForegroundColor Yellow
    Write-Host "     click System Tray -> Quit, then reopen from Start Menu.    " -ForegroundColor Yellow
    Write-Host "================================================================" -ForegroundColor Green
}
