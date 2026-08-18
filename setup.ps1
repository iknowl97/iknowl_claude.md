<#
.SYNOPSIS
    iknowl Claude Pack Installer & OS Selector for Windows (PowerShell)
.DESCRIPTION
    Installs and configures iknowl Claude Starter Pack into the target repository.
    Supports Smart Merge for existing CLAUDE.md and platform-specific hook setup.
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$TargetDir = (Get-Location).Path,
    [ValidateSet("universal", "windows", "linux", "auto")]
    [string]$Mode = "auto"
)

$SourceDir = $PSScriptRoot
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "`n========================================================" -ForegroundColor Cyan
Write-Host "  iknowl Claude Starter Pack Installer (2026)" -ForegroundColor Green
Write-Host "========================================================`n" -ForegroundColor Cyan

Write-Host "Target Directory: $TargetDir" -ForegroundColor Yellow

if (-not (Test-Path $TargetDir)) {
    Write-Host "[!] Target directory does not exist. Creating it..." -ForegroundColor DarkYellow
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

# 1. Check existing CLAUDE.md and handle merge strategy
$TargetClaude = Join-Path $TargetDir "CLAUDE.md"
$StreamDir = Join-Path $TargetDir "docs\stream"

if (-not (Test-Path $StreamDir)) {
    New-Item -ItemType Directory -Path $StreamDir -Force | Out-Null
}

if (Test-Path $TargetClaude -and (Resolve-Path $TargetClaude).Path -ne (Resolve-Path (Join-Path $SourceDir "CLAUDE.md")).Path) {
    Write-Host "`n[!] Detected existing CLAUDE.md in target project!" -ForegroundColor Yellow
    Write-Host "  [1] Smart Merge (Prepend Bootstrap Directive & Backup to docs/stream/CLAUDE.md.bak)" -ForegroundColor Cyan
    Write-Host "  [2] Backup & Replace (Replace with full iknowl template, save old as CLAUDE.md.orig)" -ForegroundColor Cyan
    Write-Host "  [3] Keep untouched (Only add reference layer at the bottom)" -ForegroundColor Cyan
    
    $choice = Read-Host "`nSelect an option [1-3] (Default: 1)"
    if ([string]::IsNullOrWhiteSpace($choice)) { $choice = "1" }

    $backupPath = Join-Path $StreamDir "CLAUDE.md.bak"
    Copy-Item -Path $TargetClaude -Destination $backupPath -Force
    Write-Host "[+] Backed up original CLAUDE.md to docs/stream/CLAUDE.md.bak" -ForegroundColor Green

    switch ($choice) {
        "2" {
            Copy-Item -Path (Join-Path $SourceDir "CLAUDE.md") -Destination $TargetClaude -Force
            Write-Host "[+] Replaced CLAUDE.md with iknowl standard template" -ForegroundColor Green
        }
        "3" {
            $refBlock = "`n<!-- iknowl Engine Layer -->`nOperating Mode: Verification Loop enabled. Slash commands: /plan, /verify, /distill, /decide.`nPersistent Memory: Read docs/stream/STATE.md at session start. Rules in .claude/rules/.`n"
            Add-Content -Path $TargetClaude -Value $refBlock -Encoding UTF8
            Write-Host "[+] Appended iknowl reference layer to existing CLAUDE.md" -ForegroundColor Green
        }
        Default {
            # Smart Merge: Prepend Bootstrap Directive to existing CLAUDE.md
            $existingContent = Get-Content -Path $TargetClaude -Raw -Encoding UTF8
            $bootstrapDirective = @"
<!-- ========================================================================== -->
<!-- IKNOWL PACK BOOTSTRAP TRIGGER (Self-Organizing Directive)                  -->
<!-- IF THIS BLOCK EXISTS: On your first turn or /bootstrap:                   -->
<!-- 1. BACKUP: Verify docs/stream/CLAUDE.md.bak exists.                       -->
<!-- 2. AUTO-DETECT: Detect OS/Platform, package manager & commands via shell.  -->
<!-- 3. REORGANIZE: Format this file into the lean <100 line iknowl standard.  -->
<!-- 4. OVERFLOW: Move rules > 40 lines to .claude/rules/project-rules.md.      -->
<!-- 5. INITIALIZE: Fill docs/stream/STATE.md and update Project section.       -->
<!-- 6. CLEANUP: Delete this header block once done.                             -->
<!-- ========================================================================== -->

"@
            Set-Content -Path $TargetClaude -Value ($bootstrapDirective + $existingContent) -Encoding UTF8
            Write-Host "[+] Prepended Self-Organizing Bootstrap Directive to existing CLAUDE.md" -ForegroundColor Green
        }
    }
} elseif (-not (Test-Path $TargetClaude)) {
    Copy-Item -Path (Join-Path $SourceDir "CLAUDE.md") -Destination $TargetClaude -Force
    Write-Host "[+] Copied iknowl CLAUDE.md" -ForegroundColor Green
}

# 2. Copy .claude directory and docs/stream
Write-Host "`n[*] Copying .claude configuration, subagents, commands, and rules..." -ForegroundColor Cyan
Copy-Item -Path (Join-Path $SourceDir ".claude") -Destination $TargetDir -Recurse -Force
Copy-Item -Path (Join-Path $SourceDir "AGENTS.md") -Destination $TargetDir -Force
Copy-Item -Path (Join-Path $SourceDir "docs") -Destination $TargetDir -Recurse -Force

# 3. Configure OS Hook
$SettingsPath = Join-Path $TargetDir ".claude\settings.json"
if ($Mode -eq "auto") {
    $hasNode = (Get-Command node -ErrorAction SilentlyContinue) -ne $null
    if ($hasNode) {
        $hookCmd = "node .claude/hooks/block-secrets.js"
        $platformDesc = "Universal (Node.js)"
    } else {
        $hookCmd = "powershell -ExecutionPolicy Bypass -File .claude/hooks/block-secrets.ps1"
        $platformDesc = "Windows Native (PowerShell)"
    }
} elseif ($Mode -eq "windows") {
    $hookCmd = "powershell -ExecutionPolicy Bypass -File .claude/hooks/block-secrets.ps1"
    $platformDesc = "Windows Native (PowerShell)"
} elseif ($Mode -eq "linux") {
    $hookCmd = "bash .claude/hooks/block-secrets.sh"
    $platformDesc = "Linux/macOS Native (Bash)"
} else {
    $hookCmd = "node .claude/hooks/block-secrets.js"
    $platformDesc = "Universal (Node.js)"
}

$settingsJson = @"
{
  "`$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "deny": [
      ".env",
      ".env.*",
      "*.pem",
      "*.key",
      "id_rsa",
      "id_ed25519"
    ]
  },
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit",
        "command": "$hookCmd"
      }
    ]
  }
}
"@
Set-Content -Path $SettingsPath -Value $settingsJson -Encoding UTF8
Write-Host "[+] Configured .claude/settings.json for $platformDesc" -ForegroundColor Green

Write-Host "`n========================================================" -ForegroundColor Green
Write-Host "  iknowl Claude Pack successfully installed!" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor Green
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Start Claude Code in target directory: claude" -ForegroundColor White
Write-Host "2. Run /bootstrap to auto-detect tech stack and verify commands." -ForegroundColor White
Write-Host "3. Start coding with /plan and /verify!`n" -ForegroundColor White
