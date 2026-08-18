#!/usr/bin/env node
/**
 * Cross-Platform PreToolUse Hook: Block Secrets in Code/File Edits
 * Reads tool-call JSON from standard input.
 * Exits with code 2 to BLOCK the action if secret patterns are detected.
 */

const fs = require('fs');

let input = '';
process.stdin.setEncoding('utf8');

process.stdin.on('data', chunk => {
  input += chunk;
});

process.stdin.on('end', () => {
  try {
    if (!input.trim()) {
      process.exit(0);
    }

    const payload = JSON.parse(input);
    const toolInput = payload.tool_input || {};
    const content = toolInput.content || toolInput.new_str || toolInput.replacement || '';
    const filePath = toolInput.path || toolInput.target_file || toolInput.file_path || '';

    // Block sensitive file paths directly
    if (/\.(env|pem|key|pfx|p12)$/i.test(filePath) || /id_(rsa|ed25519)/i.test(filePath)) {
      console.error(`Blocked: Direct modification of sensitive file "${filePath}" is prohibited.`);
      process.exit(2);
    }

    // Secret pattern regexes
    const secretPatterns = [
      /(api[_-]?key|auth[_-]?token|secret[_-]?key|access[_-]?token|private[_-]?key)\s*[:=]\s*['"`][a-zA-Z0-9_\-.~+]{8,}['"`]/i,
      /ghp_[a-zA-Z0-9]{36}/,
      /sk-[a-zA-Z0-9]{32,}/,
      /-----BEGIN\s+(RSA|OPENSSH|EC|DSA|PRIVATE)\s+KEY-----/,
      /bearer\s+ey[a-zA-Z0-9_\-]{20,}\.ey[a-zA-Z0-9_\-]{20,}/i
    ];

    for (const pattern of secretPatterns) {
      if (pattern.test(content)) {
        console.error('Blocked: Potential API secret or private key detected in tool input.');
        console.error('Action: Store credentials in environment variables or a secure secret vault.');
        process.exit(2);
      }
    }

    process.exit(0);
  } catch (err) {
    // If payload is unparseable or unexpected, allow execution without breaking agent loop
    process.exit(0);
  }
});
