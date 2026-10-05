# [Project Name] — Project Context

> This is the **project-level** `CLAUDE.md`, layered above your global / parent `CLAUDE.md` files.
> Write only what's specific to **this project** — don't duplicate global rules here.

---

## First 30 seconds of a new session

**First, decide single- or multi-workstream** (look at file naming under `brain/`):
- Only `STATUS.md` / `HANDOFF.md` → take the **single-workstream** branch
- Multiple `STATUS_<workstream>.md` files → take the **multi-workstream** branch (v2.1)

### Single-workstream (default)

**Must read** (both under `brain/`):

1. `brain/MAP.md` — project map. Answers "what does this project look like, where are docs?"
2. `brain/STATUS.md` — current state. Answers "where are we, what's next?"

**If `brain/HANDOFF.md` exists** — read it. It's the previous session's still-warm-not-yet-written-down content.

After reading, give a brief report: project recognized + current progress + last blocker. **Don't silently start working** — confirm understanding first.

### Multi-workstream (v2.1)

**First read project-level shared files**: `brain/MAP.md` (with workstream registry, §6) + `brain/PROJECT.md` (if needed).

**Identify which workstream this window serves — don't guess.** Explicit signals only: this window is named for a workstream (its name plus a number, e.g. `web-6`), or the user said which one when opening it. Otherwise report and ask:

> "I see this is a multi-workstream project with [list workstreams]. Which one does this window work on?"

**Then read** `brain/STATUS_<workstream>.md` + `brain/HANDOFF_<workstream>.md`, then do the same brief report (include anything waiting under "From other workstreams").

**Concurrent windows** (v2.8 — MAP §6 has a "Who's on it now" roster): also skim the other workstreams' STATUS "Handed to other workstreams" for rows addressed to yours that are still `sent`, and mention them in the report. Once the user confirms and work begins, write this window's name + date into your workstream's roster row — that cell only, committed alone, announced. Refer to other workstreams by workstream name, never by window name (Trap 18).

**If the user switches this window's workstream mid-session** — must re-read the new workstream's STATUS + HANDOFF, **don't carry over memory from the previous workstream** (Trap 14).

## When to read other continuity-layer files

- **Scope ambiguous / someone asks "can this project do X feature?"** → read `brain/PROJECT.md` (check if it's blocked by "what we explicitly don't do")
- **Want to understand "why is it shaped this way / why is this convoluted?"** → read `brain/DECISIONS.md`
- **Want to know where a specific topic doc lives** → go back to `brain/MAP.md` §5 doc index

## When to read `brain/topics/` content

`brain/MAP.md` §5 marks "when to read" for each topic doc. Read by trigger condition; don't read all every session.

⚠️ TODO ⚠️ — high-frequency entry points (e.g., "memory logic → topics/systems/MEMORY.md")

## Project red lines (read before writing code)

⚠️ TODO ⚠️ — fill in red lines, or confirm "no explicit red lines for this project"

## Update responsibility

**Core principle — tiered trust** (METHODOLOGY §4.1): the AI never *silently* modifies a file in `brain/`. `STATUS` / `HANDOFF` / mechanical `MAP` registrations (including a roster claim): write after the work lands, then announce what was written in the same reply. `DECISIONS` / `PROJECT` / structural `MAP` changes: propose first, user approves.

**Judgment division** (important):
- The user decides "**should we record now**"
- The AI decides "**what specifically to record / what to write in each entry**" (the user doesn't know how each file works internally — don't push this judgment back)
- The user has approval/rejection authority over the AI's judgments

Specific rhythm:

- User says "**update the project brain**" → run "judge + list" workflow: based on what happened in the session, proactively judge which files should update and what to write, give a **list with reasons** for the user to review (see METHODOLOGY §4.4)
- AI senses "that section felt like a decision" → **gentle inquiry**: "does this count as decided? Want to append to DECISIONS?" — don't assert (see METHODOLOGY §4.5)
- Module added / removed → propose to update `brain/MAP.md` §2
- New doc added / deprecated → propose to update `brain/MAP.md` §5
- User signals end-of-session ("that's it / heading out / time to switch") → proactively draft `brain/STATUS.md` for review (soft cap 80 lines)
- User says window-switch → write `brain/HANDOFF.md`, archive previous to `brain/handoffs/YYYY-MM-DD-HHMM.md`; in Claude Code, also refresh the auto-memory pointer (METHODOLOGY §3.4, v2.7)
- User explicitly says "update STATUS / log a decision" → just do it, don't ask

**Multi-workstream** (v2.1): scope all the above STATUS / HANDOFF / handoffs to the current window's workstream — `STATUS_<current>.md` / `HANDOFF_<current>.md` / `handoffs/<current>/`. PROJECT / MAP / DECISIONS / topics are shared, not per-workstream. See METHODOLOGY §3.5 + §4.7.

**Concurrent windows** (v2.8, several windows in one checkout): write only your own workstream's STATUS / HANDOFF; edit shared files (MAP / DECISIONS / PROJECT) in place — re-read, change your one spot, never rewrite the whole file; stage files by name and run `git diff --cached --stat` before every commit; don't edit an area another workstream owns (MAP §6) — hand it over: your STATUS records it under "Handed to other workstreams," theirs under "From other workstreams" when they accept, plus a live ping if your tool can message other sessions. See METHODOLOGY §3.6.

Full mechanism: see `METHODOLOGY.md` §4.

MAP self-calibration rules: in `brain/MAP.md` last section.
