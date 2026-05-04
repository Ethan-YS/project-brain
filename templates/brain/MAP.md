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
> See METHODOLOGY §3.5.

| Workstream | STATUS file | HANDOFF file | Archive directory | Active windows / notes |
|---|---|---|---|---|
| ⚠️ TODO ⚠️ | `STATUS_⚠️.md` | `HANDOFF_⚠️.md` | `handoffs/⚠️/` | ⚠️ TODO ⚠️ |

**Adding a new workstream**:
1. User decides the workstream name (keep style consistent with existing names — all English or all the chosen language)
2. AI creates `STATUS_<new>.md` + `HANDOFF_<new>.md` (from templates) + `handoffs/<new>/.gitkeep`
3. Register in this section
4. Single commit: "**add workstream: <new>**"

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
