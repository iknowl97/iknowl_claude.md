# ==============================================================================
# iknowl Git Pre-Commit Hook (PowerShell)
# Blocks committing secrets, private keys, and .env files
# ==============================================================================

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$forbiddenPattern = '\.env|\.env\..*|\.pem$|\.key$|id_rsa|id_ed25519'
$stagedFiles = git diff --cached --name-only

$blockedFiles = $stagedFiles | Where-Object { $_ -match $forbiddenPattern }
if ($blockedFiles) {
    Write-Host "[BLOCKED] Cannot commit sensitive files:" -ForegroundColor Red
    $blockedFiles | ForEach-Object { Write-Host "  - $_" -ForegroundColor Red }
    exit 1
}

$stagedDiff = git diff --cached
$secretPattern = 'AKIA[0-9A-Z]{16}|ghp_[0-9a-zA-Z]{36}|github_pat_[0-9a-zA-Z_]{82}|sk-[a-zA-Z0-9]{32,}|BEGIN RSA PRIVATE KEY'

if ($stagedDiff -match $secretPattern) {
    Write-Host "[BLOCKED] Potential hardcoded API key or private key detected in staged diff!" -ForegroundColor Red
    exit 1
}

exit 0
