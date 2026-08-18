---
description: Trigger Code Reviewer subagent to review uncommitted changes or branch diff
---

## Action Plan for /review
1. Run `git status` and `git diff` (or `git diff HEAD~1`) to inspect changes.
2. Spawn `code-reviewer` subagent to audit simplicity, surgical precision, edge cases, and architectural compliance against `.claude/rules/karpathy.md`.
3. Check for orphan variables, unhandled async promises, and memory leaks.
4. Output structured code review in Georgian (ქართულად) with English technical terms.
5. If blockers are found, provide surgical fix recommendations.
