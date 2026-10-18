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
3. `brain/HANDOFF.md` if exists — last shift's report (first thing to do, waits, still-warm thoughts)

Brief report: project recognized + current progress + last blocker.

### Multi-workstream (v2.1)

First read shared files: `brain/MAP.md` + `brain/PROJECT.md`.
Identify which workstream this session works on — explicit signals only (the session is named for a workstream, e.g. `web-6`, or the user said so); otherwise ask. Don't guess.
Then read the corresponding `STATUS_<workstream>.md` + `HANDOFF_<workstream>.md`.
Concurrent sessions (v2.8 — MAP §6 has a "Who's on it now" roster): also check other workstreams' STATUS for requests to yours still marked `sent`. Once the user confirms and work begins, write this session's name + date into your workstream's roster row (that cell only, committed alone).

## Update protocol

`brain/` is written for the next session, not for the user (METHODOLOGY §4.1, v2.9.1): `STATUS` / `HANDOFF` / `MAP` registrations / `RUNBOOK` appends — write when the work lands, don't ask, don't report; the commit message is the record. Ask only one thing, and only when you can't tell: is this decided? `DECISIONS` / `PROJECT` follow the answer.

**Judgment division** (core principle):
- The user decides "should we record now" (high-level pacing)
- The agent decides "specifically what to record" (file-specific judgment)
- The user approves or rejects the agent's proposal

When the user says "update the project brain":
1. Identify what happened in the session
2. Propose a list with reasons (what to update + why each)
3. Wait for user's approval per item
4. Write the approved updates

When the user signals window-switch / hand off / shift change:
1. Move what's still valid out of the existing `brain/HANDOFF.md` (waits → STATUS, procedures and traps → `brain/topics/operations/RUNBOOK.md`)
2. Archive it to `brain/handoffs/<timestamp>.md`
3. Write a new `brain/HANDOFF.md` as a shift report (the template's six sections; delete empty ones). Don't restate what STATUS / RUNBOOK already hold

When a decision feels made: ask "does this count as decided?" — don't assert "we decided X."

## Multi-workstream (v2.1)

If this project uses multi-workstream mode, scope STATUS / HANDOFF / handoffs to the current workstream:
- `STATUS_<current>.md` / `HANDOFF_<current>.md` / `handoffs/<current>/`

PROJECT.md / MAP.md / DECISIONS.md / topics/ stay shared across workstreams.

If the user switches workstream mid-session: re-read the new one's files; don't carry over memory.

Concurrent sessions in one checkout (v2.8, METHODOLOGY §3.6):
- Name other workstreams, never their current session/window names (those live only in the MAP §6 roster)
- Write only your own STATUS / HANDOFF; edit shared files (MAP / DECISIONS / PROJECT) in place, never rewrite them whole
- Stage files by name; run `git diff --cached --stat` before every commit; never `git add -A` / `commit -a`
- Need a change in an area another workstream owns? Record it in your STATUS ("Handed to other workstreams") and tell that workstream; the owner records it in theirs when it accepts

## Build / test / dev commands

⚠️ TODO ⚠️ — fill in main commands (run, build, test, lint, etc.)

## Project red lines (read before writing code)

⚠️ TODO ⚠️ — fill in red lines, or confirm "no explicit red lines for this project"

## Reference

Full methodology: https://github.com/Ethan-YS/project-brain/blob/main/METHODOLOGY.md
