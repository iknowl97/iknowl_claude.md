#!/usr/bin/env bash
# ==============================================================================
# iknowl Claude Pack Installer & OS Selector for Linux & macOS
# ==============================================================================

set -e

TARGET_DIR="${1:-$(pwd)}"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "\033[0;36m========================================================\033[0m"
echo -e "\033[0;32m  iknowl Claude Starter Pack Installer (Linux/macOS)     \033[0m"
echo -e "\033[0;36m========================================================\033[0m"
echo -e "Target Directory: \033[1;33m$TARGET_DIR\033[0m"

mkdir -p "$TARGET_DIR/docs/stream"

TARGET_CLAUDE="$TARGET_DIR/CLAUDE.md"
STREAM_DIR="$TARGET_DIR/docs/stream"

# 1. Handle existing CLAUDE.md
if [ -f "$TARGET_CLAUDE" ] && [ "$(cd "$(dirname "$TARGET_CLAUDE")" && pwd)/$(basename "$TARGET_CLAUDE")" != "$SOURCE_DIR/CLAUDE.md" ]; then
    echo -e "\n\033[1;33m[!] Detected existing CLAUDE.md in target project!\033[0m"
    echo "  [1] Smart Merge (Prepend Bootstrap Directive & Backup to docs/stream/CLAUDE.md.bak)"
    echo "  [2] Backup & Replace (Replace with full iknowl template, save old as CLAUDE.md.orig)"
    echo "  [3] Keep untouched (Only add reference layer at the bottom)"
    
    read -r -p "Select an option [1-3] (Default: 1): " choice
    choice="${choice:-1}"
    
    cp "$TARGET_CLAUDE" "$STREAM_DIR/CLAUDE.md.bak"
    echo -e "\033[0;32m[+] Backed up original CLAUDE.md to docs/stream/CLAUDE.md.bak\033[0m"
    
    case "$choice" in
        2)
            cp "$SOURCE_DIR/CLAUDE.md" "$TARGET_CLAUDE"
            echo -e "\033[0;32m[+] Replaced CLAUDE.md with iknowl standard template\033[0m"
            ;;
        3)
            echo -e "\n<!-- iknowl Engine Layer -->\nOperating Mode: Verification Loop enabled. Slash commands: /plan, /verify, /distill, /decide.\nPersistent Memory: Read docs/stream/STATE.md at session start. Rules in .claude/rules/.\n" >> "$TARGET_CLAUDE"
            echo -e "\033[0;32m[+] Appended iknowl reference layer to existing CLAUDE.md\033[0m"
            ;;
        *)
            # Smart Merge: Prepend Bootstrap Directive
            TMP_FILE=$(mktemp)
            cat << 'EOF' > "$TMP_FILE"
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

EOF
            cat "$TARGET_CLAUDE" >> "$TMP_FILE"
            mv "$TMP_FILE" "$TARGET_CLAUDE"
            echo -e "\033[0;32m[+] Prepended Self-Organizing Bootstrap Directive to existing CLAUDE.md\033[0m"
            ;;
    esac
elif [ ! -f "$TARGET_CLAUDE" ]; then
    cp "$SOURCE_DIR/CLAUDE.md" "$TARGET_CLAUDE"
    echo -e "\033[0;32m[+] Copied iknowl CLAUDE.md\033[0m"
fi

# 2. Copy .claude and docs
echo -e "\n\033[0;36m[*] Copying .claude configuration, subagents, commands, and rules...\033[0m"
cp -r "$SOURCE_DIR/.claude" "$TARGET_DIR/"
cp "$SOURCE_DIR/AGENTS.md" "$TARGET_DIR/"
cp -r "$SOURCE_DIR/docs" "$TARGET_DIR/"

# 3. Set execution permissions for shell hooks
chmod +x "$TARGET_DIR/.claude/hooks/"*.sh 2>/dev/null || true

# 4. Check Node.js and configure settings.json
SETTINGS_FILE="$TARGET_DIR/.claude/settings.json"
if command -v node >/dev/null 2>&1; then
    HOOK_CMD="node .claude/hooks/block-secrets.js"
    PLATFORM_DESC="Universal (Node.js)"
else
    HOOK_CMD="bash .claude/hooks/block-secrets.sh"
    PLATFORM_DESC="Linux/macOS Native (Bash)"
fi

cat << EOF > "$SETTINGS_FILE"
{
  "\$schema": "https://json.schemastore.org/claude-code-settings.json",
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
        "command": "$HOOK_CMD"
      }
    ]
  }
}
EOF

echo -e "\033[0;32m[+] Configured .claude/settings.json for $PLATFORM_DESC\033[0m"

echo -e "\n\033[0;32m========================================================\033[0m"
echo -e "\033[0;32m  iknowl Claude Pack successfully installed!            \033[0m"
echo -e "\033[0;32m========================================================\033[0m"
echo -e "Next Steps:"
echo -e "1. Run Claude Code in project root: \033[1mclaude\033[0m"
echo -e "2. Run \033[1m/bootstrap\033[0m to auto-detect tech stack and verify commands."
echo -e "3. Start development with \033[1m/plan\033[0m and \033[1m/verify\033[0m!\n"
