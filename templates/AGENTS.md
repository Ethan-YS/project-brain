# [Project Name] — AGENTS.md

> This file follows the [AGENTS.md convention](https://agents.md) — a project-level guide
> for AI coding agents (Codex CLI, Aider, Continue, etc.) that respect this convention.

## On session start

Decide single- or multi-workstream (look at file naming under `brain/`):
- Only `STATUS.md` / `HANDOFF.md` → single-workstream branch
- Multiple `STATUS_<workstream>.md` → multi-workstream branch (v2.1)

### Single-workstream

Read these in order:
1. `brain/MAP.md` — project map
2. `brain/STATUS.md` — current state
3. `brain/HANDOFF.md` if exists — previous session's still-warm thoughts

Brief report: project recognized + current progress + last blocker.

### Multi-workstream (v2.1)

First read shared files: `brain/MAP.md` + `brain/PROJECT.md`.
Then ask the user which workstream this session works on. Don't guess.
Read the corresponding `STATUS_<workstream>.md` + `HANDOFF_<workstream>.md` after the user answers.

## Update protocol

Don't silently modify any file in `brain/`.

**Judgment division** (core principle):
- The user decides "should we record now" (high-level pacing)
- The agent decides "specifically what to record" (file-specific judgment)
- The user approves or rejects the agent's proposal

When the user says "update the project brain":
1. Identify what happened in the session
2. Propose a list with reasons (what to update + why each)
3. Wait for user's approval per item
4. Write the approved updates

When the user signals window-switch:
1. Archive existing `brain/HANDOFF.md` to `brain/handoffs/<timestamp>.md`
2. Write a new `brain/HANDOFF.md` capturing still-warm-not-yet-written thoughts

When a decision feels made: ask "does this count as decided?" — don't assert "we decided X."

## Multi-workstream (v2.1)

If this project uses workstream split mode, scope STATUS / HANDOFF / handoffs to the current workstream:
- `STATUS_<current>.md` / `HANDOFF_<current>.md` / `handoffs/<current>/`

PROJECT.md / MAP.md / DECISIONS.md / topics/ stay shared across workstreams.

If the user switches workstream mid-session: re-read the new one's files; don't carry over memory.

## Build / test / dev commands

⚠️ TODO ⚠️ — fill in main commands (run, build, test, lint, etc.)

## Project red lines (read before writing code)

⚠️ TODO ⚠️ — fill in red lines, or confirm "no explicit red lines for this project"

## Reference

Full methodology: https://github.com/Ethan-YS/project-brain/blob/main/METHODOLOGY.md
