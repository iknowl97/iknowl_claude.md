---
description: Self-Evaluation and Meta-Learning: distill repeating mistakes from LEARNINGS.md into permanent rules
---

## Action Plan for /distill
1. Read all entries in `docs/stream/LEARNINGS.md`.
2. Categorize and count recurring failure modes (e.g. concurrency bugs, forgotten await, unhandled nulls, bad regex, secret leaks, encoding glitches).
3. For any pattern that occurred 2 or more times:
   - Formulate a concise, bulletproof "Never do X" rule.
   - Append it to `.claude/rules/forbidden.md` under `## Promoted from LEARNINGS`.
4. If a rule is universally critical across the entire codebase, propose adding a 1-line hard constraint to `CLAUDE.md`.
5. If a rule can be deterministically verified, propose adding an automated hook in `.claude/hooks/`.
6. Archive processed items in `LEARNINGS.md` to keep the file lightweight.
7. Present a summary of learned rules in Georgian (ქართულად) with English technical terms.
