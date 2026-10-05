# project-brain — Methodology

> Full methodology for the `project-brain` folder structure + collaboration protocol. For a quick overview see [README.md](./README.md).

---

## Table of contents

- [0. Vocabulary mapping (verbal ↔ folders)](#0-vocabulary-mapping-verbal--folders)
- [1. How to invoke this methodology](#1-how-to-invoke-this-methodology)
- [2. The problem this solves](#2-the-problem-this-solves)
- [3. Core design](#3-core-design)
- [4. Update mechanism](#4-update-mechanism)
- [5. Applicable scope](#5-applicable-scope)
- [6. Trap list (mistakes we've hit)](#6-trap-list-mistakes-weve-hit)
- [7. Related resources](#7-related-resources)

---

## 0. Vocabulary mapping (verbal ↔ folders)

When the user speaks naturally and the AI parses what file/folder is meant:

| What the user says | What it actually refers to |
|---|---|
| "the project brain" / "brain" | The whole `brain/` folder (continuity layer + topics + handoffs) |
| "topics" | The `brain/topics/` 4-category subdirectory |
| "update the project brain" | Run the **proposal-list workflow** (see §4.4) |
| "update the map / MAP" | Just `brain/MAP.md` |
| "update status / STATUS" | Just `brain/STATUS.md` (or `STATUS_<workstream>.md` if multi-workstream) |
| "log a decision / record a decision" | Append a new entry to `brain/DECISIONS.md` |
| "switch windows / write HANDOFF" | Write `brain/HANDOFF.md` + archive previous to `brain/handoffs/` |
| "who's on it now" / "the roster" | The roster in `brain/MAP.md` §6: workstream → current window (concurrent mode, §3.6.1) |
| "hand this to the X workstream" / "tell the X window" | Cross-workstream request: both STATUS ledgers + a live ping (§3.6.3) |
| "redefine the project" | `brain/PROJECT.md` (rare, discuss first) |
| "go to / write under topics" / "this is a systems doc" | `brain/topics/<category>/` |

---

## 1. How to invoke this methodology

### 1.1 Trigger: user speaks explicitly

The AI does **not** auto-detect "is this a project directory?" All triggers come from the user speaking explicitly:

| User says | Triggered action |
|---|---|
| "new project" / "set up project brain" / "scaffold this" | New-project kick-off (§1.4) |
| "load project brain" / "how do I pick up this project?" | Startup protocol (§1.3) |
| "clean up the structure" / "this project is a mess" / "migrate to v2" | Existing-project migration (§1.5) |
| "update the project brain" | Proposal-list workflow with judgment division (§4.4) |
| "switch windows" / "context's getting full" / "I'll head out" | Write STATUS + HANDOFF |
| "hand this to the X workstream" / "tell the X window" (concurrent multi-workstream projects) | Cross-workstream request (§3.6.3) |
| "MAP calibration" / "scan the MAP" | Run MAP self-calibration (see MAP.md last section) |

**Non-trigger context**: When the user is in a directory with `brain/` but is not actually discussing the project (e.g., casual chat), the methodology should NOT activate. Mechanisms run only when explicitly triggered.

### 1.2 The project-root `CLAUDE.md` is the real continuity contract

The AI doesn't auto-scan directories on wake. But Claude Code (and similar tools) **auto-load the project-root `CLAUDE.md`** — so the actual continuity guarantee lives in `templates/CLAUDE.md`. It directs new sessions to read `brain/MAP.md` + `brain/STATUS.md`.

This is the methodology's reliability anchor: **continuity rides on the AI tool's auto-load mechanism, not on the AI scanning for a folder.**

### 1.3 Startup protocol (when user says "load project brain" or new session opens)

**First decide: single-workstream or multi-workstream project?** (Look at the file naming under `brain/`)
- Only `STATUS.md` / `HANDOFF.md` → **single-workstream** (default)
- Multiple `STATUS_<workstream>.md` files → **multi-workstream** (v2.1 mode, see §3.5)

#### Single-workstream (default)

1. Read two files: `brain/MAP.md` + `brain/STATUS.md`
2. If `brain/HANDOFF.md` exists → read it (this is the previous session's still-warm thoughts that didn't make it into STATUS)
3. **Don't silently start working** — give a brief report: "I see this is [project name], currently stopped at [STATUS section 1], next step is [STATUS section 2]. Continue?"

#### Multi-workstream (split mode)

1. Read project-level shared files: `brain/MAP.md` (which contains the workstream registry, plus the roster if windows run concurrently) + `brain/PROJECT.md` (if needed)
2. **Identify which workstream this window serves — never guess.** Explicit signals only: the window is named for the workstream (the workstream's name plus a sequence number, e.g. `web-6`), or the user said which one when opening it (v2.8 refinement). Otherwise report and ask:
   > "I see this is a multi-workstream project with [list workstreams]. Which one does this window work on?"
3. **Then** read the corresponding `STATUS_<workstream>.md` + `HANDOFF_<workstream>.md`
4. **Concurrent mode** (v2.8 — MAP §6 has a "Who's on it now" roster): also skim the *other* workstreams' STATUS "Handed to other workstreams" lists for rows addressed to this workstream that are still `sent` — those are requests nobody on this workstream has accepted yet (§3.6.3)
5. Then do the brief report from single-workstream step 3 — name the workstream, and mention open requests (its own "From other workstreams" list plus any unaccepted `sent` rows from step 4)
6. **Concurrent mode, once the user confirms** the report and work begins on this workstream: claim its roster row — this window's name + date in that one cell, committed alone, announced (§3.6.1). A window opened for casual chat claims nothing (§5.4)

#### Universal disciplines

- **If `cwd` switches to another project mid-session** — must re-read the new project's MAP + STATUS + HANDOFF, do not carry over memory from the previous project (Trap 11)
- **If the user says "switch this window to another workstream"** (within the same multi-workstream project) — must re-read `STATUS_<new>.md` + `HANDOFF_<new>.md`, do not carry over memory from the previous workstream (Trap 14)
- **If Claude Code's auto memory surfaced a project-brain pointer at session start** (v2.7, §3.4) — treat it as a signpost only. Still run the read protocol above; never report project state from the pointer (Trap 17)

### 1.4 New project kick-off (when user says "set up project brain")

**Step 1: Assess applicability** (see §5) — Is this project a fit?
- Fits: multi-module, long-lived, cross-session/cross-window, likely to grow complex
- Doesn't fit: one-off scripts, projects with < 3 docs, pure exploratory prototypes

**Step 1b: Pick the scaffold level** (added v2.5 from real-project field use) — when a project has nested sub-projects (a monorepo with apps, a website with a sub-module, a multi-product workspace), pick which level gets the `brain/`:

- **Project root** (default): one `brain/` at the top-level repo root. Cross-cutting context — overall product definition, shared decisions, cross-module dependencies — lives here.
- **Sub-project**: a nested `brain/` under one specific sub-project. Use only when the sub-project really has fundamentally different context, contributors, or release cadence than the parent — and the parent doesn't need to track it.

**Default to project root** unless the sub-project clearly lives a separate life. A nested `brain/` is more maintenance than most sub-projects justify. When in doubt, start at project root; promote a sub-project to its own `brain/` only if the root one starts forking into hard-to-merge dual concerns.

A project with **both** a root `brain/` and sub-project `brain/`s is multi-level mode — explicitly out of scope for v2. If you genuinely need nested brains, treat them as independent scaffolds (one full set of files per `brain/`) and accept the cross-reference overhead.

**Step 2: Confirm with user before scaffolding** — don't just create files.
Say: "This looks like a fit for `project-brain`. Want me to scaffold?" Wait for explicit go-ahead.

**Step 2b: Confirm single or multi-workstream** (v2.1) —
- **Single-workstream** (default, fits most development-driven projects) → use `STATUS.md` + `HANDOFF.md`
- **Multi-workstream** (parallel independent streams within the project) → use `STATUS_<workstream>.md` + `HANDOFF_<workstream>.md`

For multi-workstream: have the user list all workstream names (use consistent style: all English or all Chinese — don't mix). The AI then creates the corresponding files and registers them in MAP.md §6.

If the workstreams will run in **concurrent windows** (several open at once in one checkout — v2.8): also fill the Owns column and the "Who's on it now" roster in MAP §6, and read §3.6 before the first windows open.

**Step 3: Scaffold (after confirmation)**

```bash
SKILL=/path/to/project-brain
cp -r "$SKILL/templates/brain"   <new-project-root>/brain
cp    "$SKILL/templates/CLAUDE.md"  <new-project-root>/CLAUDE.md
```

**Step 4: Fill `PROJECT.md` on day one** — while memory is fresh, write the one-line definition and "what we explicitly will NOT do." This file's value comes from "imprinting clarity at the moment definition exists." Once the project grows, the one-line definition becomes a wall of caveats.

**Step 5: Scan all `⚠️ TODO ⚠️` placeholders**

```bash
grep -rn "⚠️ TODO ⚠️" brain/
```

Walk through every placeholder with the user: which are "must fill day one" (PROJECT five-elements, MAP §1/§2, DECISIONS first entry), which are "fill once there's content" (topics index, uncommitted changes, etc.). **Empty fields should be intentional, not forgotten.**

**Step 6: Make "establishing project-brain" the first DECISIONS entry** — proves this file has been used since day one.

**Step 7: Write a usage observation** to your local notes — let the methodology grow with each use.

### 1.4b Existing-material decomposition (between green-field and full migration)

Added v2.5 from real-project field use. Real projects often don't fit either §1.4 (empty scaffold, fill from scratch) or §1.5 (sprawling unstructured docs, retrofit through structural relocation). Many sit in the middle: they already have **a few well-structured docs that contain the right content in the wrong shape** (e.g. one `PLAN.md`, one `ROADMAP.md`, an early `CLAUDE.md`).

Don't follow §1.4 as if green-field — but don't run §1.5 either, since there's no doc rot to undo.

**The path:**

1. **Scaffold the empty `brain/`** (§1.4 Step 3) — skeleton in place.
2. **Map existing docs to `brain/` files** rather than copy-and-trim. Walk through each existing doc section-by-section and ask which `brain/` file each section maps to. Examples:
   - `PLAN.md` §1 (project definition / scope) → `PROJECT.md`
   - `PLAN.md` §3 (architecture overview) → `topics/systems/ARCHITECTURE.md`
   - `PLAN.md` §5 (sandbox / dev setup) → `topics/operations/SANDBOX_SETUP.md`
   - `ROADMAP.md` (entirely) → `topics/planning/ROADMAP.md` (or split per phase)
3. **`DECISIONS.md` will land a large batch upfront**. Existing docs already encode many decisions, so the first DECISIONS update for these projects often produces 10+ entries at once. The reverse-chronological format absorbs this naturally — write each with proper "rejected alternatives" and a current date.
4. **Shrink the original docs to index pages**, don't delete them. Leave a short index in `PLAN.md` / `ROADMAP.md` pointing into the new `brain/` locations. This preserves external links and shows readers where content moved.
5. **`git init` if the project has no git yet**. Existing-material projects sometimes haven't started version control. The decompose-into-brain step creates a clear "before / after structural change" boundary — establish git before this work begins (`git init` + a snapshot commit of the original state) so the decomposition is traceable. The AI may proceed with `git init` without asking — it's a standard engineering default, not a project decision (see Trap 13).

**When this applies**: the project has 2–4 substantial structured docs but no `brain/`-like organization yet. If it has zero docs → §1.4 green-field. If it has 15+ scattered docs with rot → §1.5 full migration.

### 1.5 Existing-project migration (when user says "clean up structure" or "migrate to v2")

For a project that has accumulated scattered docs and you want to retrofit `project-brain`. Core sequence:

1. **Stage A: Structural relocation** — `git mv` scattered docs into `brain/topics/`. **Don't change content yet.** This preserves git rename history.
2. **Stage A: Erect the `brain/` skeleton** — empty templates committed. Makes the new structure "exist."
3. **Stage B: Content unpacking** — split monolithic docs into `brain/topics/` subdirectories + delete originals.
4. **Stage D: Fill the continuity layer** — populate PROJECT/MAP/STATUS with current information.
5. **Stage C: Backfill DECISIONS** — mine commit log / chat archives for key decisions, each entry must include "rejected alternatives."
6. **Stage E: Create project-root `CLAUDE.md`** — directs new sessions to brain/.

**Critical discipline**: Each stage is its own commit. Stage A's relocation and Stage B's content edits must NOT be in the same commit, or `git log --follow` will lose track.

---

## 2. The problem this solves

AI-assisted development has a counter-intuitive truth: **larger context windows don't help; better information structure does.**

A wider window doesn't mean it gets read; reading doesn't mean located; located doesn't mean prioritized. Without structure, every new session is a re-orientation tax — the AI either reads too much (wasting tokens) or misses the critical pieces.

What this methodology does:

> **Separate "meta-information" from "business content," "long-stable" from "frequently-changing," "read-once-and-keep" from "read-every-window."**

Without this separation, you get:

- One README mixing project pitch + current status + decision history + how-to-run → editing any one section forces re-reading the whole
- Sprawling docs where boundaries blur (one MEMORY_ARCHITECTURE.md containing design + ops + history + bugs)
- New sessions don't know what to read — read too much (waste tokens) or miss critical context
- Decisions buried in commit messages, chat logs, doc footnotes — never traceable when needed
- Cross-window handoff loses the "still-warm thoughts in the previous window" — the next session starts blind

---

## 3. Core design

### 3.1 One folder, two time-scales

`brain/` contains two kinds of content:

```
brain/
├── PROJECT.md       ← Continuity layer (read every session)
├── MAP.md
├── STATUS.md
├── DECISIONS.md
├── HANDOFF.md
├── handoffs/        ← Past handoffs (archive)
└── topics/          ← Topic layer (read on demand)
    ├── systems/
    ├── operations/
    ├── planning/
    └── feedback/
```

- **Continuity layer** (5 core files at `brain/` root): some part of these gets read every new session
- **Topic layer** (4 categories under `brain/topics/`): read on demand, not in the standard continuity path

### 3.2 The 5 core continuity files

| File | Time-character | Volatility | When to read |
|---|---|---|---|
| `PROJECT.md` | Project definition, near-immutable | ~0 | Scope ambiguous / first contact |
| `MAP.md` | Structural map, evolves slowly | Occasional | Every new session |
| `STATUS.md` | Instantaneous state, can be overwritten | Frequent | Every new session |
| `DECISIONS.md` | Decision log, append-only | Event-driven | Tracing why something is the way it is |
| `HANDOFF.md` | Cross-window bridge, generated at switch | Per-switch | **New session start** (if exists) |

**Why split by time-character?** Because *when* a file gets updated affects maintenance discipline more than *what* it contains. Mixing them forces low-frequency content to be re-edited alongside high-frequency content — the most common mode of doc rot.

**`HANDOFF.md` vs `STATUS.md`:**
- STATUS = steady-state ("currently working on X, next step Y, blocker Z")
- HANDOFF = transient at the moment of window-switch — **only contains things that can't be settled into STATUS**: hunches not yet articulated, weird debugging observations, half-tried approaches

If STATUS is freshly overwritten, HANDOFF can be very short (5 lines) or even nearly empty. **HANDOFF is not a backup of STATUS.**

HANDOFF is consume-and-discard — when the next switch comes, the previous one is archived to `handoffs/YYYY-MM-DD-HHMM.md` and `HANDOFF.md` is overwritten with the latest.

### 3.3 The 4 topic categories

| Subdirectory | Contains | Decision criterion |
|---|---|---|
| `systems/` | System design, architecture, technology choices | "Is this answering: how is it designed?" |
| `operations/` | Ops, processes, packaging, deployment | "How do I operate it / what do I do each release?" |
| `planning/` | Roadmap, pricing strategy, plans | "What are we going to build / how do we plan it?" |
| `feedback/` | Bug tracking, user feedback, triage | "What is reality / what are users telling us?" |

**The principle**: classification is **by problem-dimension**, not by business module. A single module (say, "payment system") will have its design in `systems/`, deploy logs in `operations/`, pricing in `planning/`, user feedback in `feedback/`. The same module's docs scatter across four directories — but when looking for something, you always know which directory.

**Why not by module?** Modules grow, shrink, get renamed, get merged, get split. The four problem dimensions are far more stable.

### 3.4 Continuity entry points (project instruction file / skill manifest)

A project-level instruction file is the **continuity protocol entry point** — what the AI tool auto-loads when a new session opens this project. As of v2.4, this can be:

- `CLAUDE.md` (Claude Code, auto-loaded from project root)
- The `project-brain` Claude Code plugin (installed via `/plugin install project-brain@sprout-labs`; provides the `skills/project-brain/SKILL.md` workflows on top of `CLAUDE.md`)
- `.cursorrules` (Cursor)
- `.github/copilot-instructions.md` (GitHub Copilot Chat)
- `AGENTS.md` (Codex CLI / Aider / Continue, the [agents.md](https://agents.md) convention)

All of them serve the same purpose: tell the new-session AI **"First read `brain/MAP.md` and `brain/STATUS.md`."**

Use the `scripts/scaffold.sh` script to copy whichever entry files match your tooling. The methodology itself is tool-agnostic — what matters is that *some* project-level instruction file is auto-loaded and points at `brain/`.

**Stacking order** (Claude Code's behavior):

```
~/.claude/CLAUDE.md             ← Global / cross-project AI rules
<some-parent>/CLAUDE.md          ← Subset of projects
<project-root>/CLAUDE.md         ← This project specifically (the template)
```

More specific overrides more general. The project-root `CLAUDE.md` writes only **what's specific to this project** — protocol entry, red lines, high-frequency entry points.

#### Optional: deterministic startup injection via Claude Code hooks (v2.6)

The instruction-file route above is *prompted* behavior — the AI is told "first read `brain/MAP.md` + `brain/STATUS.md`," and almost always complies, but nothing enforces it. Claude Code's `SessionStart` hooks can make the STATUS half *deterministic*: the hook injects the file's content into context at session start, mechanically, before the model makes any choice.

Merge the `hooks` key from [`templates/claude-code-hooks.settings.json`](./templates/claude-code-hooks.settings.json) into the project's `.claude/settings.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|compact",
        "hooks": [
          {
            "type": "command",
            "command": "if [ -f brain/STATUS.md ]; then echo '--- project-brain: brain/STATUS.md ---'; cat brain/STATUS.md; [ -f brain/HANDOFF.md ] && echo '--- brain/HANDOFF.md ---' && cat brain/HANDOFF.md; fi"
          }
        ]
      }
    ]
  }
}
```

Boundaries:

- **This is an optional adapter for one tool.** The methodology core stays tool-agnostic markdown; Cursor / Copilot / AGENTS.md users rely on the instruction-file route unchanged.
- **Inject STATUS (+ HANDOFF if present) only** — the small, read-every-window files. Don't inject MAP or PROJECT: they're for on-demand reading, and large auto-injections re-create the "read too much" problem this methodology exists to solve.
- **Multi-workstream projects**: a hook can't know which workstream the window is on — skip the hook or keep it to shared context; the ask-the-user step in §1.3 still applies.

#### Optional: Claude Code auto-memory pointer (v2.7)

Claude Code maintains its own **auto memory**: a per-repository directory under `~/.claude/projects/<project>/memory/`, holding one fact per file (frontmatter `type: user | feedback | project | reference`) plus a `MEMORY.md` index. The index's first 200 lines / 25 KB are loaded into context at every session start; topic files are read on demand. It lives outside the repo — not versioned, not visible to Cursor / Copilot / Codex — and per Anthropic's docs it is not a handoff mechanism: a fresh session gets CLAUDE.md + the memory index, never a summary of the last session.

That makes it a second continuity channel but a poor state store. v2.7 uses it for exactly one thing: a **pointer** — one `project`-type file, one index line — so the auto-loaded context already says "this repo keeps state in `brain/`, go there" before the AI has read anything.

What the pointer adds over the instruction-file route:

- **A second auto-loaded channel.** The instruction file says "read `brain/`"; the pointer says the same thing from Claude's own memory. Two independent prompts to the same place beat one.
- **A timestamp the static template can't carry.** The pointer records when the last HANDOFF was written (and for which workstream). On wake, the AI can say "there's a handoff from two hours ago" before opening a file.
- **Nothing else.** No state, no summary, no todo list. `brain/` stays the single truth (Trap 17).

Pointer file — `<memory-dir>/project-brain-pointer.md`:

```markdown
---
name: project-brain-pointer
description: This repo keeps its continuity state in brain/ (project-brain); where to resume from
metadata:
  type: project
---

This project uses project-brain. Continuity state lives in `brain/`, not here.
- When the user asks to resume / continue / check status: read `brain/MAP.md` + `brain/STATUS.md`, then `brain/HANDOFF.md` if present (METHODOLOGY §1.3). Multi-workstream: ask which workstream first.
- This note is a signpost, not state. Never report progress from it.
- Last HANDOFF written: <YYYY-MM-DD HH:MM> (workstream: <name or —>)
```

Index line in `MEMORY.md` — **replace in place, never append a new line per handoff**:

```markdown
- [project-brain pointer](project-brain-pointer.md) — continuity lives in brain/; last HANDOFF <YYYY-MM-DD HH:MM>
```

When to write / refresh it (Claude Code only — the AI knows its own memory directory from its system prompt; if no such directory is announced, skip silently):

- **Kick-off** (§1.4): create it once the scaffold lands.
- **Every HANDOFF write** (§4.3 step 3): rewrite the file and replace its index line. Same rhythm as archiving — mechanical, announced in the same reply, no approval needed (Tier 1, §4.1).
- **Never on casual work.** The pointer changes only when a HANDOFF does.

Boundaries:

- **Optional, single-tool adapter** — like the SessionStart hook above. The methodology core stays tool-agnostic markdown.
- **Prompted, not deterministic.** Unlike the hook, this relies on the AI following the procedure. The hook remains the deterministic option; the two stack.
- **Per-repository scope.** Auto memory is keyed to the repo, so a monorepo with nested sub-brains gets one pointer — write it for the parent brain only (same routing logic as Trap 16).
- **Activation boundary unchanged** (§5.4). Seeing the pointer does not license auto-activating any workflow; it only tells the AI where to go when the user asks.

### 3.5 Multi-workstream mode (v2.1, optional)

#### When to use

v2 default assumes "one project = one workstream main line" — fits development-driven projects. Some projects naturally have **multiple parallel independent workstreams**:

- A product team running development + operations + outreach as parallel streams
- Each stream has its own progress, blockers, window-switch handoff — **shouldn't be mixed into one STATUS**

When this fits, enable **multi-workstream mode**. v2.1 is an extension of v2, **not a replacement**.

#### File layout (multi-workstream)

```
brain/
├── PROJECT.md                       ← Shared (project-level)
├── MAP.md                           ← Shared (with workstream registry, §6)
├── DECISIONS.md                     ← Shared (decisions affect the whole project)
├── STATUS_dev.md                    ← Split (one per workstream)
├── STATUS_ops.md
├── HANDOFF_dev.md                   ← Split
├── HANDOFF_ops.md
├── handoffs/
│   ├── dev/                         ← Per-workstream archive directories
│   │   └── 2026-04-30-1430.md
│   └── ops/
└── topics/                          ← Shared (topic docs)
    ├── systems/
    ├── operations/
    ├── planning/
    └── feedback/
```

#### What splits, what stays shared

| File | Mode | Reason |
|---|---|---|
| `PROJECT.md` | **Shared** | Project definition is project-level, not workstream-level |
| `MAP.md` | **Shared** | Project map too is project-level; but lists all workstreams in §6 |
| `DECISIONS.md` | **Shared** | Decisions affect the whole project. Entries can tag `[affects: <workstream>]` |
| `topics/*` | **Shared** | Topic docs (design / ops / planning / feedback) split by problem dimension, not by workstream |
| `STATUS_<ws>.md` | **Split** | Each workstream's instantaneous state is independent |
| `HANDOFF_<ws>.md` | **Split** | Each workstream's window-switch handoff is independent |
| `handoffs/<ws>/` | **Split** | Historical handoffs archived per-workstream |

#### Naming convention

- **Flat suffix** (no nesting): `STATUS_<workstream>.md`, `HANDOFF_<workstream>.md`
- Workstream names chosen by the user — any language, but **be consistent** (all English or all the user's preferred language; don't mix file names in one language and directory names in another)
- **Don't rename workstreams once committed** — renaming breaks git history continuity for that workstream

#### Enabling / upgrading

**Enable at new-project kick-off** (recommended): see §1.4 step 2b.

**Upgrade single → multi mid-project**:

1. `git mv brain/STATUS.md brain/STATUS_<original>.md`
2. `git mv brain/HANDOFF.md brain/HANDOFF_<original>.md`
3. `mkdir brain/handoffs/<original>` + move existing handoffs in there
4. Create `STATUS_<new>.md` + `HANDOFF_<new>.md` for the new workstream
5. Register all workstreams in MAP.md §6
6. Single commit: "**enable multi-workstream mode**" — git log records the structural upgrade clearly

#### Cross-workstream handoff

Scenario: the **outreach** workstream decides to run a campaign → needs the **development** workstream to build a landing page. How does the message cross?

v2.1 deliberately left this unsolved — to avoid over-engineering before real-world friction told us which solution fits. **v2.8 resolved it** from a project that hit the friction daily, with its workstreams running in concurrent windows: two STATUS ledgers plus a live ping. See §3.6.3.

### 3.6 Concurrent workstreams — several windows live at once (v2.8, optional)

#### When it applies

§3.5 splits STATUS / HANDOFF per workstream but quietly assumes the windows take turns. Some multi-workstream projects run them **at the same time**: a web window, an app window and an outreach window all open, all in the same checkout, all reading and writing the same `brain/`. Four frictions show up that turn-taking never surfaces:

1. **Workstreams outlive windows** — yet everything that names a window goes stale at the next switch.
2. **Workstreams need each other** — outreach needs a page changed; the app needs to know a deploy just happened.
3. **One working tree, one staging area, several committers.**
4. **Workstreams get added, and eventually retired, mid-project.**

v2.8 codifies how one real project answered each: three concurrent workstreams, one human, a dozen-plus windows rotated through in a week. Like v2.1, it is **validated on one project** — these are the rules that project actually ran, written down after the friction, not designed ahead of it. Field reports welcome.

**Worktrees vs one checkout.** If the workstreams can be isolated on branches (each in its own git worktree, merged through tests), do that — isolation beats discipline. This section is for when they can't be: the streams touch shared code, deploy to the same target, or would conflict in `brain/` daily. (The source project rejected worktrees for exactly those reasons and logged it in DECISIONS.)

#### 3.6.1 Workstreams are durable, windows are disposable

A workstream ("web", "outreach") lives for months. The window serving it is replaced every time its context fills up. So the two get separate names, and exactly one place maps one to the other — the **roster** in `MAP.md` §6:

| Workstream | Current window | Since |
|---|---|---|
| web | web-6 | 2026-10-05 |
| app | app-6 | 2026-10-05 |
| outreach | outreach-1 | 2026-10-04 |

"Current window" is whatever name the other windows reach it by — a session title, a tab name, the address your tool's session-to-session messaging uses.

- **Identify, then claim.** On wake, a window first works out which workstream it serves — from explicit signals only (it is named for the workstream, e.g. `web-6`, or the user said so when opening it); otherwise it asks (§1.3). Once the user confirms the wake report and work on that workstream begins, it writes its own name into the workstream's roster row — that one cell and the date, nothing else — committed alone and announced (a Tier 1 mechanical MAP registration, §4.1). Ad-hoc windows never claim, even if their name happens to contain a workstream's name (an `app-review` window is not the app workstream).
- **Refer to workstreams, not windows.** STATUS, HANDOFF and DECISIONS say "the app workstream," never "app-6." A window name may appear as provenance ("found by outreach-1 on 10-05"), never as an address ("tell app-6 before deploying"). The roster is the one place a window name is current (Trap 18).
- **Reaching another workstream:** look it up in the roster. If that window is gone, look for a live window named after the workstream (your tool's session list, if it has one). If there is none, write the request into your own STATUS (§3.6.3) — the next window on that workstream picks it up when it skims the other workstreams' "Handed to…" lists on wake (§1.3 step 4).
- **Ad-hoc windows** — one-off tasks that don't own a workstream — stay off the roster and get no STATUS of their own. Anything they decide that matters goes into DECISIONS like any other window's.

#### 3.6.2 Ownership — who changes what

The registry in `MAP.md` §6 gains an **Owns** column: the directories / areas each workstream changes. "Can I edit this?" becomes a lookup.

- A workstream that shouldn't touch an area (outreach doesn't edit application code) writes up what it needs and **hands it to the owner** (§3.6.3) instead of editing.
- An area two workstreams genuinely share (a server both clients call) gets one rule: **say so before you edit it** — file and intent — and wait if the other window is mid-change. Cross-cutting work gets an agreed interface; each side builds its half; test together.
- **Interface contracts.** When one workstream depends on another's surface — CSS class names, URL paths, an API response shape — write the dependency down where the owner will see it: the "Interface dependencies & who to tell" list in MAP §6 (and the DECISIONS entry that created it, if there is one): "app depends on X, Y, Z — tell app before changing them." Undocumented dependencies get broken by the side that never knew they existed.

#### 3.6.3 Cross-workstream requests (resolves the v2.1 deferral)

v2.1 left "how does one workstream ask another for something" unsolved, pending real friction. The friction came, and the answer that held up was **two ledgers plus a live ping**:

- **The requester's STATUS** keeps a "Handed to other workstreams" list: what was asked, of which workstream, and where it stands (sent → accepted → done).
- **The owner's STATUS** keeps a "From other workstreams" list: what, from which workstream, what "done" means, and **who to tell when it ships**. The owner writes this entry itself when it accepts — the requester never edits another workstream's STATUS (§4.7 already scopes STATUS writes to the current workstream).
- **Ledgers survive STATUS overwrites.** STATUS is overwritten freely (§3.2), but open ledger rows are carried forward on every overwrite; a row drops out only once it's done (anything worth keeping about it goes to DECISIONS or MAP first).
- **Live delivery** is whatever channel the tool offers — session-to-session messages, or the user carrying it across. The message delivers; the ledgers remember. A request that exists only in a chat message dies with the window that received it. If the owner has no live window, the `sent` row waits: the next window on that workstream finds it on wake (§1.3 step 4).
- **Close the loop.** When it ships, the owner tells the requester, and the requester ticks its own list. Shared-resource events — a deploy, a release, a migration — are announced to every affected workstream **before and after**. Who to tell for which event is a standing fact, not a session state, so it lives in MAP §6 ("Interface dependencies & who to tell"), not in STATUS.
- Decisions that bind more than one workstream still go into the shared DECISIONS, tagged `[affects: <ws>, <ws>]` (§3.5).

#### 3.6.4 One checkout, several windows — git discipline

Without worktrees, every window shares one working tree **and one staging area**. A careless commit sweeps up another window's half-finished work; a careless file write erases it.

1. **The staging area is shared.** Before every commit, run `git diff --cached --stat`. Never `git commit -a`, `git add -A` or `git add .` — stage your files by name (Trap 19). If the staged set already holds something that isn't yours, another window is mid-commit: don't commit over it and don't unstage it — wait, or ask that window.
2. **Commit only your own changes.** When a file you changed also holds another window's uncommitted edits, stage only your part. A human can use `git add -p`; an AI without an interactive terminal can build the staged version itself — start from `git show HEAD:<file>`, apply only its own edit, store it with `git hash-object -w`, and stage it with `git update-index --cacheinfo 100644,<sha>,<path>` (add `--add` for a new file); or write its hunks as a patch and `git apply --cached`. **First check `git diff --cached -- <file>` is empty**: rebuilding the index entry from `HEAD` silently drops anything another window already staged in that file — Trap 19 in reverse. Then test exactly what will be committed, in isolation: `mkdir <tmpdir> && git checkout-index -a --prefix=<tmpdir>/`, add whatever untracked dependencies the tests need, and run them there.
3. **Shared `brain/` files are edited in place, never rewritten** (Trap 20). MAP / DECISIONS / PROJECT: re-read right before editing, then change or append your one spot with a targeted edit. Writing the whole file back from a copy read an hour ago erases whatever the other windows wrote since.
4. **Write only your own STATUS / HANDOFF.** Read the other workstreams' files; never write them. (Same rule as §4.7, but now it prevents collisions, not just confusion.)
5. **Name what isn't yours.** In STATUS "Uncommitted changes," list the other windows' uncommitted edits you've noticed as *not this workstream's — don't touch*, so your successor doesn't sweep them up either.
6. **Deploy from a commit, not the working tree** — the tree holds everyone's unfinished work.
7. **Prefix commit messages with the workstream** (`web: …`, `docs(brain): STATUS_app …`) so `git log --grep` can reconstruct one workstream's history.

#### 3.6.5 Workstream lifecycle

- **Adding the Nth workstream mid-project**: a DECISIONS entry (why a new workstream rather than folding the work into an existing one — that's the rejected alternative); a registry row with its Owns column; a roster row; `STATUS_<new>.md` + `HANDOFF_<new>.md` + `handoffs/<new>/`; and the instruction file's wake section updated to list it. One commit: "add workstream: <new>".
- **Retiring a workstream**: archive its STATUS / HANDOFF into `handoffs/<ws>/`, drop its roster row, mark its registry row `retired <date>`, take it out of the instruction file's wake section, and log a DECISIONS entry. Keep the history; don't reuse the name (§3.5's no-rename rule).
- **Ad-hoc windows don't turn into workstreams by accident.** If the same kind of one-off window keeps getting reopened, that's the signal to add a workstream — deliberately, through the steps above.

#### Boundaries

- **One human, several AI windows.** Not a multi-human team protocol (§5.3).
- **No locks.** Collisions are prevented by ownership, heads-ups and edit-in-place — not by lock files or a coordinator. If you need locks, you need worktrees.
- **Tool-agnostic.** Session-to-session messaging speeds up delivery where a tool has it; nothing here depends on it.
- **Activation boundary unchanged** (§5.4). Seeing a roster doesn't license any workflow; the user still triggers them.

---

## 4. Update mechanism

### 4.1 The principle — tiered trust (since v2.6)

**The AI never *silently* modifies a file in `brain/` — but not every file needs permission before writing.** Files differ in the cost of a wrong write; the approval ritual should match that cost. Git (mandatory anyway, §5.1) makes the cheap tier reversible in one command.

| Tier | Files | Protocol |
|---|---|---|
| **Tier 1 — write, then announce** | `STATUS`, `HANDOFF`, mechanical `MAP` registrations | After completing the work that changed the state, the AI writes directly and **reports what it wrote in the same reply** ("STATUS overwritten: now at X, next Y"). The user reviews via `git diff` / `git log` when they care to; reverting is one command. |
| **Tier 2 — ask, then write** | `DECISIONS`, `PROJECT`, structural `MAP` redesigns | These encode shared commitments ("this is decided" / "this is what the project is"). A wrong write corrupts understanding, not just a file. Gentle inquiry (§4.5) and explicit discussion remain mandatory. |

**Why the change** (v2.0–v2.5 required ask-before-write for everything): the old rule spent the user's attention as the safety mechanism on every routine STATUS overwrite. With git as the review surface, a Tier-1 mistake costs one `git revert` — user attention is the scarcer resource. What stays non-negotiable at every tier is *announcement*: a write the user never hears about is still forbidden.

**Sole exception** (unchanged): when the user explicitly says "update STATUS / log this decision / write a HANDOFF," the AI does it directly without asking — explicit instruction overrides both tiers.

**Not based on staleness checks**: v2 deliberately removed `last_updated` fields. The protocol guarantees freshness — when the user signals window-switch, the AI updates first; when the AI completes major work, it proposes an update. Files are always current. No need to compare timestamps.

### 4.2 Update rules per file

| File | When the AI updates | Trigger source | Tier / protocol |
|---|---|---|---|
| **STATUS.md** | User signals end-of-session ("that's it for now / heading out / time to switch"); or AI completes a major change | User / AI sense | **Tier 1**: write directly, announce in the same reply; user reviews via git |
| **HANDOFF.md** | User signals window-switch | User | **Tier 1**: write directly, announce. Procedure in §4.3 |
| **DECISIONS.md** | AI senses something **was just decided** (irreversibly) | AI sense | **Tier 2**: gentle inquiry first ("does this count as decided?") — see §4.5 |
| **MAP.md** | New doc added / doc removed → §5 registration | AI sense | **Tier 1** for mechanical registrations (write + announce); **Tier 2** for structural redesign of the map itself |
| **MAP calibration scan** | User says "MAP calibration" or "tidy up project memory" | User | Run scan per MAP.md last section; `scripts/doctor.sh` automates the mechanical half |
| **PROJECT.md** | Project definition has drifted (very rare) | Very rare | **Tier 2**: must explicitly discuss before changing |
| **`topics/*` docs** | When user and AI deliberately write a topic doc | User | **Not in auto-update scope** — topic docs are written intentionally, not maintained passively |

### 4.3 HANDOFF write procedure (avoiding archival timing confusion)

When the user says "switch windows," the **currently-online AI** does three steps:

1. **Archive first**: if `brain/HANDOFF.md` already exists (left from previous switch), `git mv` it to `brain/handoffs/<its-last-modified-timestamp>.md`
2. **Then write the new one**: write a fresh `brain/HANDOFF.md` for the next session
3. **Refresh the auto-memory pointer** (Claude Code only, v2.7, §3.4): rewrite `project-brain-pointer.md` with the new HANDOFF timestamp (and workstream, if multi-workstream) and replace its single index line in `MEMORY.md`. Skip silently in tools without auto memory.

This way `HANDOFF.md` always represents "**state at the most recent window-switch**," and the archive is the historical chain.

Multi-workstream: the same three steps on `HANDOFF_<ws>.md` → `handoffs/<ws>/`. In concurrent mode (§3.6) the archive name may carry the outgoing window's name as provenance (`handoffs/web/2026-10-05-1430-web-5.md`), and the outgoing window leaves its roster row alone — the next window claims it on wake.

### 4.4 The "update the project brain" workflow (judgment division)

**When the user says "update the project brain," they mean:**

> "I think it's time to record something — but **what specifically to record is for you to judge**. I don't know how each file works internally."

**Not**: "I already know which files to update; do as I say."

#### Judgment division

| Who has | What judgment |
|---|---|
| User | "**Should we record now?**" (instinct: feels like we did a lot / time to settle) |
| **AI** | "**What specifically to record / how to write each entry**" (specialized understanding of how each file works) |
| User | "**Is the AI's judgment correct?**" (approve / reject / correct) |

#### What the AI does

Based on what happened in the session, **proactively judge** which files should update and what to write. Hand the user a **list with reasons**:

> Things I'm proposing to update from this session:
> - **STATUS** overwrite: currently at [X], next step [Y]
>   *Reason: you said "that's it for now," state changed*
> - **DECISIONS** to confirm if 1 entry: about [brief description of decided thing]
>   *Reason: that section felt like it landed — does this count as decided? If yes, append (with "rejected alternatives"); if still discussing, skip*
> - **MAP** §5 register: new file `brain/topics/systems/[X].md`
>   *Reason: doc we just wrote*
> - **HANDOFF** not needed — you didn't say switch windows
> - **PROJECT.md** not needed — definition unchanged
>
> Does this match what you'd want?

The user might respond:
- "OK, do all of them"
- "DECISIONS is wrong, that's still being discussed" — judgment correction
- "Skip today" — defer

#### Critical disciplines

- **The AI must propose a judgment with reasons** — not leave it blank waiting for user to choose
- **Don't ask "which ones do you want to update?"** — that pushes specialized judgment back to the user, breaking the division
- **Also list things you're NOT updating, with reasons** — gives the user the full judgment surface
- **Real entry counts** (don't pad to look thorough) — see Trap 12
- **Per-item review applies even to Tier-1 files here** — "update the project brain" is the user requesting a deliberate checkpoint, so the judgment surface is the point. Tiered trust (§4.1) governs routine work moments, not this workflow

### 4.5 DECISIONS judgment: gentle inquiry, not hard-keyword detection

#### The real problem

The user rarely uses hard decision words like "decided / settled" when actually deciding. Common forms:

- "yeah" / "OK" / "alright" / "fine"
- Just starts executing ("OK so let's first do...")
- Silent acceptance of the AI's proposed approach

If the AI uses keyword detection, it **misses far more than it catches** (natural decisions slip past) or **mistakes discussion for decision** (false positives).

#### Method: gentle inquiry, hand uncertainty back to the user

When the AI senses "that section felt like a decision," it **doesn't assert "we decided X" — it asks open-endedly**:

> "About [brief description], does that count as decided? Want to append to DECISIONS?"

The user dispatches with a quick "yeah / no / let's keep talking" — **the question of whether it's actually decided stays in the user's hands**.

#### Integration point

This question usually rolls into the §4.4 "update the project brain" list — asked at end-of-session, not as mid-conversation interruption.

Mid-conversation interruption is reserved for decisions that feel **especially important / need immediate solidification** (e.g., a non-reversible architectural commitment).

#### Things to still avoid

- **Don't dress up "still discussing" as "we decided X"** just to get a DECISIONS entry on the board
- **Don't ask "does this count as decided?" every few minutes** — annoying. Only at perceived "section ends" (topic wrap-up moments)

#### Retroactive logging

When the user later says "log a decision for that thing earlier," the AI just writes it without asking — that's retroactive logging, not new-decision detection.

### 4.6 Noise insurance

If the user says "no update proposals today, please," the AI doesn't propose anything for that session and waits for the user's signal next time.

### 4.7 Multi-workstream update behavior (v2.1)

If the project is multi-workstream (§3.5), all rules in §4.1-4.6 **still apply**, but **scoped to the current window's workstream**:

| Rule | Single-workstream | Multi-workstream |
|---|---|---|
| AI doesn't silently modify | same | same |
| Proactively propose, user approves | same | same |
| Judgment division | same | same (user "should we?", AI "what specifically?") |
| **STATUS update target** | `STATUS.md` | **`STATUS_<current-workstream>.md`** |
| **HANDOFF write target** | `HANDOFF.md` | **`HANDOFF_<current-workstream>.md`** |
| **HANDOFF archive directory** | `handoffs/` | **`handoffs/<current-workstream>/`** |
| MAP update | same | same (shared) |
| DECISIONS append | same | same (shared); entries can tag `[affects: <workstream>]` |
| PROJECT change | same | same (shared) |
| **Roster row** (concurrent, v2.8) | — | claim your own workstream's row once the user confirms the wake report (Tier 1, announce); never edit another workstream's row |
| **Shared files with concurrent windows** (v2.8) | — | MAP / DECISIONS / PROJECT edited in place — re-read, change your one spot, never rewrite the whole file (Trap 20) |
| **Cross-workstream requests** (v2.8) | — | recorded in your own STATUS only — "Handed to…" when sending, "From…" when accepting (§3.6.3) |

**The AI's "current workstream" assignment**: don't auto-guess. At session start, identify it from explicit signals or ask the user (per §1.3 multi-workstream branch). Once known, the entire session operates on that workstream's STATUS/HANDOFF. If the user says "switch this window to another workstream," re-read the new workstream's files and don't carry over memory (Trap 14).

**When the user says "update the project brain"** (multi-workstream): the §4.4 list workflow still runs, but **the list is scoped to the current workstream**.

---

## 5. Applicable scope

### 5.1 Fits this methodology

**Prerequisite (mandatory)**: project uses git. Several mechanisms (HANDOFF archival, MAP calibration, blame traceability, the `git mv` discipline in migration) assume git history. **Without git, this methodology delivers half its value at best — see Trap 13.**

**Typical fits:**
- **Complex projects** (multi-module, multi-subsystem)
- **Long-lived** (cross-month, cross-year)
- **Multi-window / multi-AI collaboration** (the AI rotates across many sessions)
- **Has users / real feedback** (needs the `feedback/` category)
- **Important decisions** (needs traceable DECISIONS)

### 5.2 Doesn't fit

- **One-off scripts** / **weekend demos**: a single README is enough; `brain/` is over-engineering
- **Pure exploratory prototypes** (haven't decided what to build): structure constrains thinking. Let it grow first, structure once it hurts
- **Pure content projects** (blog, notebook): different tooling category (Notion / Ulysses), not a code-project metadata structure

### 5.3 Gray zones

- **"Maybe-this-becomes-a-real-project"**: lean toward simpler first. Pass the "still want to work on it after a week" test before scaffolding `brain/`
- **Team collaboration**: this methodology is designed for **one human working with AI** — one window at a time by default, or several concurrent AI windows under §3.6 (v2.8). Pure human teams may need adjustments (e.g., the single-overwrite STATUS model doesn't fit multiple humans editing concurrently)

### 5.4 Activation boundary

This methodology activates **in the "doing project work" context** — triggered by the user speaking explicitly (§1.1).

**Does not affect:**
- Casual conversation in the same window
- Non-project topics (life chat, brainstorming, cross-project discussion)
- The user's authority over when to switch windows (the AI doesn't auto-monitor context usage to nag — that's the user's call)
- Being inside a directory with `brain/` while not currently discussing the project — no update mechanism fires
- Opening a window in a concurrent multi-workstream project — the roster claim (§3.6.1) waits until the user confirms the window is working on that workstream; a window opened for casual chat claims nothing

---

## 6. Trap list (mistakes we've hit)

These are concrete failure modes encountered during evolution. Each comes with a discipline.

### 6.1 Conceptual traps

**Trap 1: Conflating "using on current project" with "validating the methodology"**
Using the methodology on an existing project gives day-to-day value (less doc-rot pain). But it doesn't validate the methodology — only a *new* project does. Don't conflate the two.

**Trap 2: Over-retreating after correction**
If you're told "using on current project isn't validation," don't retreat to "then don't use it on current project at all." Concept clarity and action choice are two separate steps.

**Trap 3: Asking the user for their gut before stating yours**
"Tell me your instinct first, then I'll proceed" hands the judgment back to the user. The AI should state its own inclination first, independent of the user's; the user can then evaluate independently.

### 6.2 Technical traps

**Trap 4: Worktree based on stale `main`**
When creating a worktree for restructure work, ensure `main` is current first (`git fetch` and check `origin/feature/*` vs `origin/main`). A worktree based on a stale main can silently disagree with reality.

**Trap 5: Mixing `git mv` and content edits in one commit**
Migration's Stage A (relocation) and Stage B (content edits) MUST be separate commits. Otherwise `git log --follow <new-path>` loses the rename history; blame breaks.

**Trap 6: Premature generalization of templates**
While developing the methodology in your own project, first-person language and project-specific examples are *correct context*, not bugs. Premature generalization loses the concrete judgment detail. Generalize when actually sharing externally — not before.

### 6.3 Maintenance traps

**Trap 7: DECISIONS without "rejected alternatives" degrades into a worse CHANGELOG**
DECISIONS' unique value is **the paths not taken**. Without that, it's a worse version of CHANGELOG (which already records "what was done"). Hard discipline: every DECISIONS entry must list rejected alternatives. If you can't, ask yourself if you actually *made a decision* — or just executed something.

**Trap 8: STATUS exceeding 80 lines**
STATUS is instantaneous. Once over 80 lines, it's encroaching on MAP's territory (structural changes) or DECISIONS' (rationale). Settle the long content into the right file, then overwrite STATUS.

**Trap 9: MAP rot**
MAP §5 (topic doc index) drifts most easily — new doc added but not registered, old doc deleted but still listed. Discipline: run a calibration scan (see MAP.md last section) when the user says "MAP calibration" or after a major structural change.

### 6.4 v2 / v2.1 newer traps (theoretical, awaiting more empirical validation)

**Trap 10: Writing HANDOFF as a STATUS backup**
HANDOFF's unique value is **the can't-yet-be-articulated stuff** — the "I have a hunch but can't say why" content. If STATUS is freshly overwritten, HANDOFF should be very short or near-empty. **Don't pad HANDOFF to look complete** — that's wasted effort.

**Trap 11: Memory pollution on cross-project switch**
When `cwd` switches from project A to project B in the same session, the AI tends to mistakenly carry A's blockers / status onto B. Discipline: when `cwd` changes, re-read the new project's MAP/STATUS/HANDOFF; suspend the previous project's mental model.

**Trap 12: Update proposal lists becoming noise**
When the user says "update the project brain," if the proposed list has > 3 items, double-check whether you've conflated "things that should be proposed" with "things that could be skipped." Only propose things that should be proposed.

**Trap 13: Non-git projects break several mechanisms**
v2 assumes git. Without it:
- HANDOFF's `git mv` archival → use plain `mv` (loses file rename history)
- MAP self-calibration "every 10 commits" trigger → switch to time-based (every week)
- DECISIONS traceability via commit log → loses fidelity
- Traps 4 / 5 (worktree / git mv) become meaningless

**Discipline**: if the project doesn't use git long-term, **judge it as out-of-scope for this methodology**. Either run `git init` or don't adopt project-brain. Half-adoption silently breaks mechanisms — more dangerous than non-adoption.

**Trap 14 (v2.1): Memory pollution on same-window workstream switch**
In multi-workstream projects, the user might tell the same window to switch workstream ("now switch this window to outreach"). Risk: the AI still has the previous workstream's progress, blockers, just-decided things in mind — easy to mis-attach them to the new workstream.

**Discipline**:
- When `cwd` is unchanged but workstream changes, MUST re-read `STATUS_<new>.md` + `HANDOFF_<new>.md`
- Previous workstream's "still-warm thoughts" must either get settled into its STATUS/HANDOFF (write them down) or be explicitly let go (don't carry them over)
- After switching, brief report: "switched to [new workstream], read the files, currently at [...]" — let the user confirm the AI actually switched cleanly

This is essentially Trap 11 (cross-project switch pollution) at a finer granularity — the same discipline applies.

### 6.5 v2.6 traps (mechanized in `doctor.sh`)

Unlike the traps above — documented as cautions, then left to discipline — these two ship enforced. `scripts/doctor.sh` checks 7 and 8 catch them mechanically, on the v2.6 principle that a mechanically-checkable rule should never be left to anyone's discipline. They're defined here so the rule lives in the methodology, not only in the script that enforces it.

**Trap 15: Stale cross-references**
Relative links between `brain/` docs rot silently — a file moves, a directory gets renamed, a heading is reworded — and nothing surfaces the break until someone clicks. Concrete forms caught on the first real-project runs: wrong `../` depths after a file moved, `~/`-prefixed paths no markdown renderer expands, absolute-path links that break on another machine or a fresh clone, and `#anchor` links pointing at a heading that no longer exists.

**Discipline**: keep relative links resolvable on disk; prefer an explicit `<a id="..."></a>` for a section anchor over relying on the renderer's heading slug; never hardcode absolute or `~/` paths. `doctor.sh` check 7 mechanizes this — relative links must resolve (with `%20` decoding; fenced code blocks and HTML comments skipped), ASCII `#anchors` must exist at the target, absolute-path links are flagged.

**Trap 16: Cross-brain sibling references**
Only relevant to the nested sub-brain setup §1.4 Step 1b flags as out-of-scope-but-sometimes-unavoidable. When a project ends up with more than one `brain/`, a doc in one sub-brain links straight into a *sibling* sub-brain's `brain/`. That couples two scaffolds meant to stay independent: the shared fact now lives in two places, and renaming or moving one silently breaks the other.

**Discipline**: route shared facts up to the **parent** brain and have each sub-brain reference the parent — never a sibling. Upward references (into an ancestor brain) and downward references (into a descendant brain) stay allowed; only sibling-to-sibling data references are the trap. `doctor.sh` check 8 mechanizes this for projects with nested brains.

### 6.6 v2.7 traps

**Trap 17: Auto memory as a shadow state store**
Claude Code's auto memory (§3.4) is auto-loaded, Claude-writable, and invisible in the repo — every property that tempts an AI to jot "current state" there instead of in `brain/`. The moment it does, the project has two states: one versioned and shared with every tool, one in `~/.claude` that only Claude on this machine sees, that no `git log` records, and that goes stale the first time a window switches without touching it. The same drift shows up in the index: appending a new `MEMORY.md` line per handoff instead of replacing the one line grows the auto-loaded block until it hits the 200-line cap, after which later entries silently stop loading.

**Discipline**: auto memory holds one pointer (§3.4) and nothing else about the project — no progress, no todos, no decisions. Refresh it by rewriting, never by appending. On wake, treat it as a signpost and run the read protocol; report state only from `brain/`. `doctor.sh` cannot check this (the directory is outside the repo), so it stays a discipline trap — the first new one since v2.6 mechanized the rest, and flagged as such deliberately.

### 6.7 v2.8 traps (concurrent workstreams)

These come from the concurrent-windows project behind §3.6. Traps 18 and 19 were hit there; Trap 20 is **preventive** — the shared-file rule that project ran on, written down before anyone gets bitten. Trap 18 is partly mechanized (`doctor.sh` check 10); Traps 19 and 20 live in transient git state and in-context file copies, which no script can see — they stay discipline traps.

**Trap 18: Window names as workstream identity**
In concurrent mode it's natural to write "tell app-6 before deploying" into a STATUS — app-6 is who's on the app workstream right now. At the next switch app-6 closes, and every file that named it now addresses a window that no longer exists; the newcomer on that workstream never hears a thing. Found in the source project when a single handoff turned out to hard-code two other workstreams' window names.

**Discipline**: window names live in exactly one place — the roster in MAP §6 — and each new window claims its own row on wake. Everywhere else, name the workstream. A window name may appear as provenance ("found by app-6"), never as an address. `doctor.sh` check 10 lists roster window names that appear in active STATUS / HANDOFF files; it can't tell provenance from address, so it reports them as info for a human glance.

**Trap 19: Sweeping another window's work into your commit**
One checkout, one staging area, several windows. `git add -A`, `git commit -a`, or staging a whole shared file packs another window's half-finished edits — or hunks it had already staged for its own commit — into yours. Nothing errors. The other window later finds its work committed under someone else's message, possibly already deployed. Hit for real in the source project (the outreach window carried off hunks another window had staged), which is how its "look at `git diff --cached` first" rule got written.

**Discipline**: §3.6.4 steps 1–2 — stage by name, check the staged set before every commit, stage only your own part of a shared file, and test the staged tree in isolation.

**Trap 20 (preventive): Rewriting a shared brain file from a stale copy**
An AI holding MAP or DECISIONS in context "updates" it by writing the whole file back. Every edit another window made since the read — committed or not — silently disappears. With one window at a time a stale copy is harmless; with three windows writing the same MAP it's data loss that no diff reviewer is looking for.

**Discipline**: shared files (MAP / DECISIONS / PROJECT) are edited in place — re-read right before, change or append your one spot with a targeted edit, never write the full file back. DECISIONS was already append-only; MAP and PROJECT, which do get edited, are edited in place — never written back wholesale.

---

## 7. Related resources

- **[README.md](./README.md)** — project front-page (English) / **[README.zh-CN.md](./README.zh-CN.md)** (中文)
- **[CHANGELOG.md](./CHANGELOG.md)** — version history
- **[templates/](./templates/)** — drop-in templates

### Methodologies that influenced this

This work stands on shoulders of community efforts. Notable inspirations:

- **Prompt Shelf 2026 memory persistence guide** — three-file architecture (CLAUDE.md / MEMORY.md / CONTEXT.md). [thepromptshelf.dev](https://thepromptshelf.dev/blog/claude-code-memory-persistence-guide-2026/)
- **softaworks/agent-toolkit session-handoff skill** — handoff archival, validation, chaining. [github.com/softaworks/agent-toolkit](https://github.com/softaworks/agent-toolkit/blob/main/skills/session-handoff/README.md)
- **Anthropic's official skills repo** — the project-skill discipline as a structured artifact. [github.com/anthropics/skills](https://github.com/anthropics/skills)
- **The 4-Step Protocol** — context injection / sequencing / verification gating ideas. [Medium article](https://medium.com/@ilyas.ibrahim/the-4-step-protocol-that-fixes-claude-codes-context-amnesia-c3937385561c)

What we kept that they didn't have, and what we borrowed from them, is documented in the v2 evolution story (see [README.md](./README.md#why-this-exists--the-evolution-story)).

---

**Maintained by**: [Ethan](https://ethanflow.com) ([Sprout Labs](https://ethanflow.com)), working with a Jarvis-style AI collaboration workflow. PRs welcome.
