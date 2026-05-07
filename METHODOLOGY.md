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

1. Read project-level shared files: `brain/MAP.md` (which contains the workstream registry) + `brain/PROJECT.md` (if needed)
2. **Don't guess which workstream this window belongs to** — report and ask:
   > "I see this is a multi-workstream project with [list workstreams]. Which one does this window work on?"
3. After the user explicitly says, **then** read the corresponding `STATUS_<workstream>.md` + `HANDOFF_<workstream>.md`
4. Then do the brief report from single-workstream step 3

#### Universal disciplines

- **If `cwd` switches to another project mid-session** — must re-read the new project's MAP + STATUS + HANDOFF, do not carry over memory from the previous project (Trap 11)
- **If the user says "switch this window to another workstream"** (within the same multi-workstream project) — must re-read `STATUS_<new>.md` + `HANDOFF_<new>.md`, do not carry over memory from the previous workstream (Trap 14)

### 1.4 New project kick-off (when user says "set up project brain")

**Step 1: Assess applicability** (see §5) — Is this project a fit?
- Fits: multi-module, long-lived, cross-session/cross-window, likely to grow complex
- Doesn't fit: one-off scripts, projects with < 3 docs, pure exploratory prototypes

**Step 2: Confirm with user before scaffolding** — don't just create files.
Say: "This looks like a fit for `project-brain`. Want me to scaffold?" Wait for explicit go-ahead.

**Step 2b: Confirm single or multi-workstream** (v2.1) —
- **Single-workstream** (default, fits most development-driven projects) → use `STATUS.md` + `HANDOFF.md`
- **Multi-workstream** (parallel independent streams within the project) → use `STATUS_<workstream>.md` + `HANDOFF_<workstream>.md`

For multi-workstream: have the user list all workstream names (use consistent style: all English or all Chinese — don't mix). The AI then creates the corresponding files and registers them in MAP.md §6.

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

### 3.5 Workstream split mode (v2.1, optional)

#### When to use

v2 default assumes "one project = one workstream main line" — fits development-driven projects. Some projects naturally have **multiple parallel independent workstreams**:

- A product team running development + operations + outreach as parallel streams
- Each stream has its own progress, blockers, window-switch handoff — **shouldn't be mixed into one STATUS**

When this fits, enable **workstream split mode**. v2.1 is an extension of v2, **not a replacement**.

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
6. Single commit: "**enable workstream split**" — git log records the structural upgrade clearly

#### Cross-workstream handoff (deferred to future versions)

Scenario: the **outreach** workstream decides to run a campaign → needs the **development** workstream to build a landing page. How does the message cross?

Possible solutions (none baked into v2.1 — accumulate experience first):
- Write to `DECISIONS.md` (shared layer; the dev window will see it on next startup)
- Write a blocker in your STATUS: "blocked: waiting on dev workstream to do X"
- Use a separate "external collaboration space" pattern

**v2.1 deliberately leaves this unsolved** — to avoid over-engineering before real-world friction tells us which solution fits.

---

## 4. Update mechanism

### 4.1 The principle

**The AI doesn't silently modify any file in `brain/`.**

When something should be updated, the AI **proposes** — "we just decided X, want to append to DECISIONS?" — and the user approves, modifies, or rejects.

**Sole exception**: when the user explicitly says "update STATUS / log this decision / write a HANDOFF," the AI does it directly without asking.

**Not based on staleness checks**: v2 deliberately removed `last_updated` fields. The protocol guarantees freshness — when the user signals window-switch, the AI updates first; when the AI completes major work, it proposes an update. Files are always current. No need to compare timestamps.

### 4.2 Update rules per file

| File | When AI proposes update | Trigger source | Must ask first? |
|---|---|---|---|
| **STATUS.md** | User signals end-of-session ("that's it for now / heading out / time to switch"); or AI completes a major change (proposes, doesn't act) | User / AI sense | Draft for user review, write only after OK |
| **HANDOFF.md** | User signals window-switch | User | Same. Procedure in §4.3 |
| **DECISIONS.md** | AI senses something **was just decided** (irreversibly) | AI sense | **Must ask via gentle inquiry** ("does this count as decided?") — see §4.5 |
| **MAP.md** | Module added/removed; new doc added; structure changed | AI sense | **Must ask** ("I see a new file in `topics/`, register in MAP §5?") |
| **MAP calibration scan** | User says "MAP calibration" or "tidy up project memory" | User | Run scan per MAP.md last section |
| **PROJECT.md** | Project definition has drifted (very rare) | Very rare | Must explicitly discuss before changing |
| **`topics/*` docs** | When user and AI deliberately write a topic doc | User | **Not in auto-update scope** — topic docs are written intentionally, not maintained passively |

### 4.3 HANDOFF write procedure (avoiding archival timing confusion)

When the user says "switch windows," the **currently-online AI** does two steps:

1. **Archive first**: if `brain/HANDOFF.md` already exists (left from previous switch), `git mv` it to `brain/handoffs/<its-last-modified-timestamp>.md`
2. **Then write the new one**: write a fresh `brain/HANDOFF.md` for the next session

This way `HANDOFF.md` always represents "**state at the most recent window-switch**," and the archive is the historical chain.

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

**The AI's "current workstream" assignment**: don't auto-guess. At session start, ask the user (per §1.3 multi-workstream branch). Once known, the entire session operates on that workstream's STATUS/HANDOFF. If the user says "switch this window to another workstream," re-read the new workstream's files and don't carry over memory (Trap 14).

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
- **Team collaboration**: this methodology is designed for **two-agent collaboration** (one human, one AI). Pure human teams may need adjustments (e.g., the single-overwrite STATUS model doesn't fit multiple humans editing concurrently)

### 5.4 Activation boundary

This methodology activates **in the "doing project work" context** — triggered by the user speaking explicitly (§1.1).

**Does not affect:**
- Casual conversation in the same window
- Non-project topics (life chat, brainstorming, cross-project discussion)
- The user's authority over when to switch windows (the AI doesn't auto-monitor context usage to nag — that's the user's call)
- Being inside a directory with `brain/` while not currently discussing the project — no update mechanism fires

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
