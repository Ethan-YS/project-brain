# [Project Name] — Copilot Chat Instructions

This file is auto-loaded by GitHub Copilot Chat when working in this repo.
It tells Copilot how to pick up the project's persistent context.

## On session start

Decide single- or multi-workstream (look at file naming under `brain/`):
- Only `STATUS.md` / `HANDOFF.md` → single-workstream
- Multiple `STATUS_<workstream>.md` → multi-workstream (v2.1)

### Single-workstream

Read these in order:
1. `brain/MAP.md` — project map (modules, doc index, run instructions)
2. `brain/STATUS.md` — current state (where we stopped, next step, blockers)
3. `brain/HANDOFF.md` if it exists — previous session's still-warm thoughts

Then report briefly: project recognized + current progress + last blocker.

### Multi-workstream

First read shared files: `brain/MAP.md` + `brain/PROJECT.md`.
Don't guess this window's workstream — use explicit signals only (the window is named for a workstream, e.g. `web-6`, or the user said so); otherwise ask the user which one.
Then read the corresponding `STATUS_<workstream>.md` + `HANDOFF_<workstream>.md`.
Concurrent windows (v2.8 — MAP §6 has a "Who's on it now" roster): also check other workstreams' STATUS for requests to yours still marked `sent`. Once the user confirms and work begins, write this window's name + date into your workstream's roster row and say so.

## Update behavior

Never silently modify a file in `brain/` (tiered trust, METHODOLOGY §4.1):
- `STATUS` / `HANDOFF` / mechanical `MAP` registrations → write after the work lands, then tell the user what you wrote
- `DECISIONS` / `PROJECT` / structural `MAP` changes → propose to the user (with reasoning), wait for approval, then write

Specific triggers:
- User says "update the project brain" → propose a list with reasons (what to update + why); user picks
- A decision feels just made → ask "does this count as decided?" — don't assert
- User signals end-of-session ("that's it / heading out") → draft `brain/STATUS.md` for review
- User signals window-switch → write `brain/HANDOFF.md`, archive the previous one to `brain/handoffs/YYYY-MM-DD-HHMM.md`

Multi-workstream (v2.1): scope STATUS / HANDOFF / handoffs to the current workstream. PROJECT / MAP / DECISIONS / topics are shared.

Concurrent windows in one checkout (v2.8, METHODOLOGY §3.6): name workstreams, not window names; write only your own STATUS / HANDOFF; edit shared files in place; stage by name and check `git diff --cached --stat` before committing; hand changes in another workstream's area to its owner.

## Project red lines

⚠️ TODO ⚠️ — fill in red lines, or confirm "no explicit red lines for this project"

## Reference

Full methodology: https://github.com/Ethan-YS/project-brain/blob/main/METHODOLOGY.md
