# MAP — Project Map

> **What this file answers**: "What does the project look like? Where do I find specific information?"
>
> **Character**: evolves with project structure. Module-level granularity only — no specific function/file details.
> Detail belongs in topic docs under `brain/topics/`.
>
> **Who reads this**: **first thing every new session reads**.

---

## 1. Quick start

> Fastest path for a new session to get the project running. Minimum commands only — no detailed explanations.
> Full ops detail in `brain/topics/operations/`.

**Run the project**:
```bash
⚠️ TODO ⚠️ (main run command)
```

**Key entry points / ports**:
- ⚠️ TODO ⚠️

**Health check / status verification**:
```bash
⚠️ TODO ⚠️
```

## 2. Module list

> What modules exist, what each does, current state. Module-level only — don't drill into files.

| Module | Responsibility | State | Main location |
|---|---|---|---|
| ⚠️ TODO ⚠️ | ⚠️ TODO ⚠️ | stable / in development / deprecated | (path) |

## 3. Module dependencies

> Brief description of key dependency directions and data flows. Text or ASCII diagram is fine — doesn't need to be precise, just understandable.

⚠️ TODO ⚠️

## 4. Continuity layer 5 core files (`brain/` direct children)

> New sessions read MAP and STATUS first; HANDOFF if it exists; the rest on demand.

| File | Answers | When to read |
|---|---|---|
| `PROJECT.md` | Origin, non-goals | First contact, scope ambiguous |
| `MAP.md` | Module structure, doc index | Every session |
| `STATUS.md` | Current state, next step | Every session |
| `HANDOFF.md` | Previous session's window-switch handoff | Every session (if exists) |
| `DECISIONS.md` | Historical decisions | When tracing a design's rationale |

`handoffs/` — historical HANDOFF archive directory.

## 5. Topic docs (`brain/topics/`)

> Grouped by category. The "**when to read**" column is the key — tells future readers the trigger condition; don't read all every session.
> No "last updated" column — protocol guarantees freshness; if you really need to check, use `git log -1 --format=%ad <path>`.

### systems/ (system design topics)
| File | What it is | When to read |
|---|---|---|
| ⚠️ TODO ⚠️ | ⚠️ TODO ⚠️ | ⚠️ TODO ⚠️ |

### operations/ (ops / process)
| File | What it is | When to read |
|---|---|---|
| ⚠️ TODO ⚠️ | ⚠️ TODO ⚠️ | ⚠️ TODO ⚠️ |

### planning/ (plans / roadmap)
| File | What it is | When to read |
|---|---|---|
| ⚠️ TODO ⚠️ | ⚠️ TODO ⚠️ | ⚠️ TODO ⚠️ |

### feedback/ (feedback / tracking)
| File | What it is | When to read |
|---|---|---|
| ⚠️ TODO ⚠️ | ⚠️ TODO ⚠️ | ⚠️ TODO ⚠️ |

---

## 6. Workstream registry (v2.1, multi-workstream projects only)

> **Fill this section only for multi-workstream projects** — single-workstream projects can leave it empty or remove the section.
> Workstreams share PROJECT / MAP / DECISIONS / topics; STATUS / HANDOFF / handoffs split per workstream.
> See METHODOLOGY §3.5 (and §3.6 if several windows run at once).

| Workstream | Owns (dirs / areas it changes) | STATUS file | HANDOFF file | Archive directory |
|---|---|---|---|---|
| ⚠️ TODO ⚠️ | ⚠️ TODO ⚠️ | `STATUS_⚠️.md` | `HANDOFF_⚠️.md` | `handoffs/⚠️/` |

A workstream doesn't edit an area another one owns — it hands the change over (METHODOLOGY §3.6.3).

**Adding a new workstream**:
1. User decides the workstream name (keep style consistent with existing names — all English or all the chosen language)
2. AI creates `STATUS_<new>.md` + `HANDOFF_<new>.md` (from templates) + `handoffs/<new>/.gitkeep`
3. Register in this section (registry row; roster row too if windows run concurrently)
4. List it in the project instruction file's wake section (`CLAUDE.md` / `AGENTS.md` …)
5. DECISIONS entry: why a new workstream rather than folding the work into an existing one
6. Single commit: "**add workstream: <new>**"

**Retiring a workstream**: archive its STATUS / HANDOFF into `handoffs/<ws>/`, mark its registry row `retired <date>`, drop its roster row, take it out of the instruction file's wake section, log it in DECISIONS. Never reuse the name.

### Who's on it now (v2.8, concurrent windows only)

> Fill only if several windows run at the same time. Workstreams are durable, windows are disposable — this table is the **only** place a window name is current. See METHODOLOGY §3.6.

| Workstream | Current window (the name other windows reach it by) | Since |
|---|---|---|
| ⚠️ TODO ⚠️ | ⚠️ TODO ⚠️ | ⚠️ TODO ⚠️ |

- **New window, once the user confirms the wake report**: write your window name + date into your workstream's row — that cell only, committed alone, announced. Ad-hoc windows never claim a row.
- **On wake, also skim the other workstreams' STATUS** "Handed to other workstreams" for rows addressed to yours that are still `sent` — requests waiting for someone to accept them.
- **Reaching another workstream**: this table first; window gone → look for a live window named after the workstream; none → put it in your own STATUS under "Handed to other workstreams" — its next window picks it up on wake.
- **STATUS / HANDOFF / DECISIONS name the workstream, never the window.** Provenance ("found by web-5") is fine; addresses ("tell web-5") are not.
- **Ad-hoc windows** (one-off tasks that own no workstream) stay off this table.

**Interface dependencies & who to tell** (standing facts — change these, or ship these, and tell the listed workstream first):
- ⚠️ TODO ⚠️ (e.g., "app depends on web's `.topbar` class and `/g/<id>` URLs" · "any deploy → tell app before and after")

**Concurrent rules** (one checkout, several windows — METHODOLOGY §3.6.4):
- The staging area is shared: `git diff --cached --stat` before every commit; stage files by name, never `-A` / `-a` / `.`
- Commit only your own changes; when a shared file also holds another window's uncommitted edits, stage only your part
- Shared brain files (MAP / DECISIONS / PROJECT): re-read, then edit your one spot — never rewrite the whole file
- Editing an area another workstream owns or shares → tell it first (file + intent)
- Deploy from a commit, not the working tree; tell affected workstreams before and after

---

## 7. MAP self-calibration

> MAP's biggest enemy is staleness. This file needs an active maintenance mechanism.

**Triggers for update**:
- Module added / removed / state change → update §2 (module list)
- Module **major restructure** (refactor, new subsystem) → update §2, §3
- New doc added / removed / heavily revised → update §5
- Run command changes → update §1 (quick start)

**MAP calibration scan** (doesn't run automatically; triggered by user or proposed by AI):
- Scan `brain/topics/`: find files that exist but aren't registered in MAP §5 → report "unregistered files"
- Scan MAP entries: find entries that point to non-existent files → report "stale entries"
- Find MAP entries whose description clearly disagrees with the actual file content → report "drifted entries"
- **Trigger occasions**:
  - User says "MAP calibration / tidy up project memory"
  - After a major module change (AI proactively proposes calibration)
