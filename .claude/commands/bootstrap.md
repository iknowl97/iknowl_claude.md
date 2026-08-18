---
description: Bootstrap and auto-detect project tech stack, package manager, and test/build commands
---

## Action Plan for /bootstrap
1. **OS & Platform Detection:** Identify operating system (Windows, Linux, macOS) and terminal shell (PowerShell `pwsh`, Bash, Zsh). Enforce rules from `.claude/rules/platform.md`.
2. **CLAUDE.md Smart Migration:**
   - If an existing legacy `CLAUDE.md` is detected, back it up to `docs/stream/CLAUDE.md.bak`.
   - Preserve all existing project rules and domain knowledge in `## Project Specifics`.
   - If custom rules exceed 40 lines, move overflow to `.claude/rules/project-rules.md`.
   - Remove the bootstrap trigger comment block from `CLAUDE.md`.
3. **Manifest & Stack Detection:** Scan project root for manifest files (`package.json`, `Cargo.toml`, `pyproject.toml`, `go.mod`, `pom.xml`, `composer.json`, `Makefile`, etc.).
4. **Package Manager & Commands:** Determine package manager (`pnpm`, `bun`, `npm`, `cargo`, `uv`, `poetry`, `go`) and verify executable test, build, lint, and dev commands via real shell runs.
5. **State Initialization:** Populate `docs/stream/STATE.md` with verified facts and update `CLAUDE.md` project section.
6. **Report:** Output findings to the user in Georgian (ქართულად) with English technical details.
