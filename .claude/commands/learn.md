---
description: Manually or automatically record a caught mistake or durable rule into LEARNINGS.md
---

## Action Plan for /learn
1. Prompt user or analyze recent failure context for:
   - What was the error/bug?
   - What is the permanent rule to prevent recurrence?
   - Which Bayesian prior was updated?
2. Format entry as:
   ```markdown
   - L-<next_id> [YYYY-MM-DD] <Bug description>
     Rule: <Durable rule>
     Prior updated: <P(failure | symptom) update>
   ```
3. Append entry to `docs/stream/LEARNINGS.md`.
4. If this error occurred 2+ times, run `/distill` logic to promote to `.claude/rules/forbidden.md`.
5. Confirm addition in Georgian (ქართულად).
