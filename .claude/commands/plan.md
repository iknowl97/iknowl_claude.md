---
description: Create a surgical, binary-verifiable plan before touching code
---

## Action Plan for /plan
1. Check `docs/stream/STATE.md` to ground plan in current project state.
2. If goal is complex or touches auth/migrations/payments, perform Bayesian risk check per `.claude/rules/bayes.md`.
3. Break down goal into small, atomic specs (one coder context each).
4. For each step: specify `1. [step] -> verify: [exact check command]`.
5. Output plan in Georgian (ქართულად) for explanations, with English code identifiers and acceptance criteria.
6. Await confirmation if high risk; otherwise begin execution via implementer loop.
