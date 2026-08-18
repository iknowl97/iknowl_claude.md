# PowerShell PreToolUse Hook: Block Secrets in Code/File Edits
# Reads tool-call JSON from standard input; exits 2 to BLOCK.

$inputContent = [Console]::In.ReadToEnd()
if ([string]::IsNullOrWhiteSpace($inputContent)) {
    exit 0
}

try {
    $payload = $inputContent | ConvertFrom-Json
    $toolInput = $payload.tool_input
    $content = ""
    if ($toolInput) {
        if ($toolInput.content) { $content = $toolInput.content }
        elseif ($toolInput.new_str) { $content = $toolInput.new_str }
        elseif ($toolInput.replacement) { $content = $toolInput.replacement }
    }

    if ($content -match '(?i)(api[_-]?key|auth[_-]?token|secret[_-]?key|private[_-]?key)\s*[:=]\s*[''"`][a-zA-Z0-9_\-.~+]{8,}[''"`]') {
        [Console]::Error.WriteLine("Blocked: Potential secret detected in write input.")
        exit 2
    }

    if ($content -match 'sk-[a-zA-Z0-9]{32,}|ghp_[a-zA-Z0-9]{36}|-----BEGIN [A-Z ]+ PRIVATE KEY-----') {
        [Console]::Error.WriteLine("Blocked: Secret token or private key detected.")
        exit 2
    }
}
catch {
    exit 0
}

exit 0
