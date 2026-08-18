---
description: Run Bayesian decision and risk analysis before architecture or critical path changes
---

## Action Plan for /decide
1. Identify competing approaches (at least 2 options: Approach A vs Approach B).
2. Set prior odds based on `docs/stream/LEARNINGS.md` and repository history.
3. Compute likelihood ratios (LR) for available evidence (prototypes, official docs, reversibility, risk factors per `.claude/rules/bayes.md`).
4. Calculate posterior probabilities and Expected Value (EV).
5. Propose the highest EV path (or safest reversible path on ties).
6. Log assessment to `docs/stream/DECISIONS.md`.
