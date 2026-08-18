---
description: Trigger dual independent verifiers to check implementation against spec and break edge cases
---

## Action Plan for /verify
1. Run `verifier-spec` subagent to check each acceptance criterion with real shell commands.
2. Run `verifier-adversarial` subagent to attack edge cases, missing error boundaries, and unhandled branches.
3. Verify character encoding (UTF-8) and check for orphan code/imports.
4. If either verifier fails: route findings to `fixer` agent, update `docs/stream/LEARNINGS.md`, and loop until both pass.
5. Once both pass: append change summary to `docs/stream/CHANGES/` and update `docs/stream/STATE.md`.
