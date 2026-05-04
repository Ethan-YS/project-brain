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
Don't guess this window's workstream — ask the user which one.
Then read the corresponding `STATUS_<workstream>.md` + `HANDOFF_<workstream>.md`.

## Update behavior

Don't silently modify any file in `brain/`. When something should be updated:
1. Propose to the user (with reasoning)
2. Wait for approval
3. Then write

Specific triggers:
- User says "update the project brain" → propose a list with reasons (what to update + why); user picks
- A decision feels just made → ask "does this count as decided?" — don't assert
- User signals end-of-session ("that's it / heading out") → draft `brain/STATUS.md` for review
- User signals window-switch → write `brain/HANDOFF.md`, archive the previous one to `brain/handoffs/YYYY-MM-DD-HHMM.md`

Multi-workstream (v2.1): scope STATUS / HANDOFF / handoffs to the current workstream. PROJECT / MAP / DECISIONS / topics are shared.

## Project red lines

⚠️ TODO ⚠️ — fill in red lines, or confirm "no explicit red lines for this project"

## Reference

Full methodology: https://github.com/Ethan-YS/project-brain/blob/main/METHODOLOGY.md
