#!/usr/bin/env bash
# ==============================================================================
# iknowl Git Pre-Commit Hook (POSIX Bash)
# Blocks committing secrets, private keys, and .env files
# ==============================================================================

set -e

# Block forbidden files
FORBIDDEN_FILES=$(git diff --cached --name-only | grep -E "(\.env|\.env\..*|\.pem$|\.key$|id_rsa|id_ed25519)" || true)
if [ -n "$FORBIDDEN_FILES" ]; then
    echo -e "\033[0;31m[BLOCKED] Cannot commit sensitive files:\033[0m"
    echo "$FORBIDDEN_FILES"
    exit 1
fi

# Block common secret patterns in staged diff
STAGED_DIFF=$(git diff --cached)
if echo "$STAGED_DIFF" | grep -E -q "(AKIA[0-9A-Z]{16}|ghp_[0-9a-zA-Z]{36}|github_pat_[0-9a-zA-Z_]{82}|sk-[a-zA-Z0-9]{32,}|BEGIN RSA PRIVATE KEY)"; then
    echo -e "\033[0;31m[BLOCKED] Potential hardcoded API key or private key detected in staged diff!\033[0m"
    exit 1
fi

exit 0
