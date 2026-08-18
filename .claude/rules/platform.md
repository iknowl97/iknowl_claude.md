# Platform & OS Execution Rules (Cross-Platform Guidelines)

AI agents must execute commands and format file operations according to the host operating system.

---

## 1. Windows (PowerShell / `pwsh`)

### Command & Syntax Rules:
- **Never chain commands with `cd ... && ...` or `cd ... ; ...`**: Always use the native working directory parameter or pass absolute/relative paths directly.
- **PowerShell syntax over cmd.exe**: Use PowerShell cmdlets (`Get-ChildItem`, `Select-String`, `Test-Path`, `Remove-Item`) or cross-platform CLI tools (`git`, `node`, `cargo`, `pnpm`).
- **Environment variables**: Use `$env:VARIABLE_NAME` syntax (not `%VARIABLE_NAME%` or `$VARIABLE_NAME`).
- **Quoting and Escaping**: Double quote JSON strings or use single quotes for literal blocks. In PowerShell, double quotes inside double quotes must be escaped with backticks (`` `" ``) or single quotes.
- **Character Encoding**: Ensure UTF-8 console output when handling non-ASCII text (`[Console]::OutputEncoding = [System.Text.Encoding]::UTF8`).
- **Path Separators**: Both `/` and `\` work in PowerShell, but standard tools (`git`, `node`, `pnpm`) prefer forward slashes `/`.

### Anti-patterns on Windows:
- ❌ Do NOT run `export VAR=val` (use `$env:VAR = "val"`).
- ❌ Do NOT run `source .env` or `source venv/bin/activate` (use `.\venv\Scripts\Activate.ps1`).
- ❌ Do NOT run `grep` / `sed` / `awk` assuming GNU Linux binaries exist unless verified in environment.

---

## 2. Linux & macOS (POSIX Bash / Zsh)

### Command & Syntax Rules:
- **Standard POSIX Utilities**: Use `grep`, `sed`, `awk`, `find`, `curl`, `jq` with standard flags.
- **File Permissions**: Ensure scripts in `.claude/hooks/` have executable permissions (`chmod +x .claude/hooks/*.sh`).
- **Environment Variables**: Use `export VAR="val"` and `$VAR`.
- **Line Endings**: Use `LF` (`\n`) for all text/shell files (avoid `CRLF`).
- **Case Sensitivity**: Remember that file systems on Linux are strictly case-sensitive (`App.tsx` != `app.tsx`).

---

## 3. Universal / Cross-Platform Best Practices

- **Node.js Scripts for Automation**: When building hooks or scripts, prefer Node.js (`.js`) or Python (`.py`) when available, as they run identically on Windows, macOS, and Linux.
- **No Interactive Blocking Commands**: Never execute interactive commands without non-interactive flags (e.g. use `npm init -y`, `npx -y`, `git --no-pager`).
- **Verification**: Always execute real shell commands and inspect the exit code before claiming a task is done.
