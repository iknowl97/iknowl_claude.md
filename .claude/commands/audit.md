---
description: Run security and secrets audit across codebase and dependencies
---

## Action Plan for /audit
1. Run `security-auditor` subagent across the project.
2. Scan codebase for hardcoded secrets, private keys, `.env` exposure, and injection vectors (SQL, shell, XSS).
3. Execute package manager audit command if available (`pnpm audit`, `npm audit`, `cargo audit`, `pip-audit`).
4. Check middleware guards, authentication routes, and CORS configuration.
5. Report findings in Georgian (ქართულად) categorized by severity (CRITICAL, HIGH, MEDIUM, LOW) with concrete mitigation steps.
