---
name: project-brain
description: |
  Use this skill when an AI coding session needs persistent context across sessions, window switches, or context compaction.
  Triggers:
  (1) The user wants to set up project-level memory ("set up project brain", "scaffold project context", "init project brain", "建项目脑").
  (2) The user opens a directory containing a brain/ folder — read the existing project brain to resume work.
  (3) The user signals window switch / context compaction — write a HANDOFF before they leave so the next session can resume.
  (4) The user says "update the project brain" — propose a list of what to record and let them approve.
  This skill provides a folder structure (brain/), a copy-able template, and a four-workflow protocol (startup / kick-off / update / handoff). Methodology details in METHODOLOGY.md alongside this file.
allowed-tools: ["Read", "Write", "Edit", "Bash", "Glob", "Grep"]
---

# project-brain

A folder structure + collaboration protocol for persistent project context across AI sessions. Use it to scaffold a `brain/` folder in the user's project, resume work from an existing one, or update entries when work happens.

## When to invoke this skill

| User signal | Workflow |
|---|---|
| "set up project brain" / "scaffold project" / "建项目脑" / "init project context" | **Kick-off** — see §1 |
| User is in a directory containing `brain/` and asks the AI to "load" / "resume" / "what's the status" | **Startup** — see §2 |
| User says "switch windows" / "context's getting full" / "I'll head out" / "压缩了" | **Handoff** — see §3 |
| User says "update the project brain" / "let's record this" / "更新项目脑" | **Update** — see §4 |

## Core principles (always honored)

- **Don't auto-modify any file in `brain/`.** Always propose; user approves.
- **Judgment Division**: the user decides "should we record now"; the AI decides "what specifically to record"; the user reviews. Don't push specialized judgments back to the user ("which files do you want me to update?").
- **DECISIONS gentle inquiry**: when something feels decided, ask "does this count as decided?" — don't assert "we decided X."
- **Multi-workstream**: if `brain/` has multiple `STATUS_<workstream>.md` files, don't guess this window's workstream — ask the user.

## §1 New project kick-off

When the user wants to scaffold:

1. **Confirm applicability**: multi-module / long-lived / cross-session work? If a one-off script — say "this might be over-engineering for this project" and let the user override.
2. **Confirm single or multi-workstream**: most projects are single-workstream (default). If the project has parallel independent workstreams (dev + ops + outreach kind of project), ask the user to list workstream names.
3. **Run scaffold**: `bash <skill-path>/scripts/scaffold.sh <user-project-root>` (defaults to all four AI adapters: Claude, Cursor, Copilot, AGENTS.md).
4. **Walk the user through `brain/PROJECT.md`** on day one — fill the one-line definition + "what we explicitly DON'T do." Don't let this drift into the future.
5. **Scan placeholders**: `grep -rn "⚠️ TODO ⚠️" <user-project>/brain/` — go through with the user. Empty fields should be intentional.
6. **First DECISIONS entry**: append "establishing project-brain" with rejected alternatives, so this file is used from day one.

## §2 Startup (entering a project that already has `brain/`)

**Single-workstream** (only `STATUS.md`):
1. Read `brain/MAP.md`
2. Read `brain/STATUS.md`
3. If `brain/HANDOFF.md` exists, read it
4. Brief report: project recognized + current progress + last blocker

**Multi-workstream** (multiple `STATUS_<workstream>.md`):
1. Read shared files: `brain/MAP.md` + `brain/PROJECT.md`
2. **Don't guess** — ask: "I see this is a multi-workstream project with [list workstreams]. Which one does this window work on?"
3. After the user answers, read corresponding `brain/STATUS_<workstream>.md` + `brain/HANDOFF_<workstream>.md`
4. Brief report

**Universal discipline**: if `cwd` switches to another project mid-session, re-read the new project's files; if the user switches workstreams in the same window, re-read the new workstream's files. Don't carry over memory.

## §3 Handoff (user signaling window switch)

When the user says they're switching windows / context is getting full / heading out:

1. **Archive the existing HANDOFF first** (if one exists):
   ```bash
   git mv brain/HANDOFF.md brain/handoffs/$(date +%Y-%m-%d-%H%M).md
   ```
   (For multi-workstream: `brain/HANDOFF_<current>.md` → `brain/handoffs/<current>/...`.)
2. **Write a fresh `brain/HANDOFF.md`** capturing:
   - Why the window-switch (context limit / break / refocus)
   - Current state at this exact moment
   - Where the next session should pick up
   - **Things still in head not yet written down** — the unique value of HANDOFF (hunches, half-tried approaches, weird debugging observations)
3. Keep it short. If STATUS was just overwritten, HANDOFF can be near-empty.

## §4 Update workflow

When the user says "update the project brain":

1. Look back at what happened in this session
2. **Propose a list with reasons** — for each candidate file, say what to write and why:
   ```
   - STATUS overwrite: now at [X], next [Y]. Reason: you said "that's it"
   - DECISIONS: about to append? Reason: that section felt like it landed — does this count as decided?
   - MAP §5 register: new file at brain/topics/systems/[X].md. Reason: doc we just wrote
   - HANDOFF: not needed — you didn't say switch windows
   ```
3. **Wait for user's approval per item** — they may say "OK, all of them" / "skip DECISIONS, that's still discussion" / "today, just STATUS"
4. Write only the approved updates

**Never reverse this**: don't ask the user "which files do you want to update?" That hands the wrong layer of judgment to the wrong person.

## Reference

- **Full methodology** (the why, all 14 traps, evolution story): `METHODOLOGY.md` (alongside this file)
- **Templates**: `templates/` (what `scaffold.sh` copies)
- **Public repo**: https://github.com/Ethan-YS/project-brain
