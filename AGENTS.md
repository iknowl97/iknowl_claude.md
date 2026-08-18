# AGENTS.md — Global Agent Contract & Guidelines

This repository uses a structured verification loop and bilingual workflow. All AI agents (Claude Code, Cursor, Antigravity, Codex, Windsurf, Gemini CLI) must adhere to the following rules:

## 1. Core Operating Mode: Verification Loop
- Never verify your own code without running real shell commands (test, build, lint).
- Plan before coding: `1. [step] -> verify: [check command]`.
- Keep edits minimal, surgical, and traceable to the user's request.

## 2. Bilingual Communication Protocol (Georgian + English)
- **User Communication, Rationale & Comments:** Georgian (ქართული).
- **Code, APIs, Types, Identifiers & Technical Terms:** English (*middleware, endpoint, hook, state, payload, database*).
- **Character Encoding:** Always preserve standard UTF-8 encoding.

## 3. Persistent Memory Stream
- Read `docs/stream/STATE.md` at session start for verified current state.
- Log architectural decisions to `docs/stream/DECISIONS.md`.
- Append caught mistakes and rules to `docs/stream/LEARNINGS.md`.

For detailed architecture and rules, see `CLAUDE.md` and `.claude/rules/`.
